from __future__ import print_function
import os

import numpy as np
from torch.nn.utils import prune
from torchvision.utils import save_image
import matplotlib.pyplot as plt
import torch
import torch.nn as nn
import torch.nn.functional as F
import torch.optim as optim
from PIL import Image
from torch.optim.lr_scheduler import StepLR
from torchvision import datasets, models
from torchvision import transforms


class Net(nn.Module):
    def __init__(self):
        super(Net, self).__init__()
        self.conv1 = nn.Conv2d(3, 32, 3, 1)
        self.conv2 = nn.Conv2d(32, 64, 3, 1)
        self.dropout1 = nn.Dropout(0.25)
        self.dropout2 = nn.Dropout(0.5)
        self.fc1 = nn.Linear(9216, 128)
        self.fc2 = nn.Linear(128, 10)

    def forward(self, x):
        x = self.conv1(x)
        x = F.relu(x)
        x = self.conv2(x)
        x = F.relu(x)
        x = F.max_pool2d(x, 2)
        x = self.dropout1(x)
        x = torch.flatten(x, 1)
        x = self.fc1(x)
        x = F.relu(x)
        x = self.dropout2(x)
        x = self.fc2(x)
        output = F.log_softmax(x, dim=1)
        return output


class MobileNet(nn.Module):
    def __init__(self):
        super(MobileNet, self).__init__()
        net = models.mobilenet_v3_small(pretrained=False)
        self.trunk = nn.Sequential(*(list(net.children())[:-2]))
        self.avg_pool = nn.AdaptiveAvgPool2d(output_size=1)
        self.fc = nn.Sequential(
            nn.Linear(576, 10, bias=True),
            nn.LogSoftmax(dim=1)
        )

    def forward(self, x):
        x = self.trunk(x)
        x = self.avg_pool(x)
        x = torch.flatten(x, 1)
        x = self.fc(x)
        return x


def plot_training_results(train_losses, test_losses, test_accuracy):
    epochs = len(train_losses)
    plt.style.use('seaborn')
    plt.figure(figsize=(12, 4))
    plt.subplot(1, 2, 1)
    plt.plot(range(1, epochs + 1), train_losses, label='Train Loss')
    plt.plot(range(1, epochs + 1), test_losses[:epochs], label='Test Loss')  # Use test_losses[:epochs]
    plt.xlabel('Epoch')
    plt.ylabel('Loss')
    plt.title('Training and Test Loss')
    plt.legend()
    plt.subplot(1, 2, 2)
    plt.plot(range(1, epochs + 1), test_accuracy, label='Test Accuracy')
    plt.xlabel('Epoch')
    plt.ylabel('Accuracy')
    plt.title('Test Accuracy')
    plt.tight_layout()
    plt.show()


def train(model, device, train_loader, optimizer, epoch, train_loss_list):
    model.train()
    train_loss = 0
    batch_number = 0
    for batch_idx, (data, target) in enumerate(train_loader):
        data, target = data.to(device), target.to(device)
        optimizer.zero_grad()
        # added
        data = data + torch.randn_like(data) * 0.1  # 使用数据增强，如旋转、平移、缩放、翻转等
        perturbed_data = fgsm_attack(model, data, target, epsilon=0.1)  # 新增对抗样本，以增强模型的鲁棒性
        output = model(perturbed_data)
        parameters_to_prune = ((model.conv1, 'weight'), (model.conv2, 'weight'),
                               (model.fc1, 'weight'), (model.fc2, 'weight'))  # 权重裁剪
        prune.global_unstructured(
            parameters_to_prune,
            pruning_method=prune.L1Unstructured,
            amount=0.1,
        )
        # output = model(data)
        loss = F.nll_loss(output, target)
        loss.backward()
        optimizer.step()
        train_loss += loss.item()
        batch_number += 1
        train_loss_list.append(train_loss / batch_number)
        if batch_idx % 100 == 0:
            print('Train Epoch: {} [{}/{} ({:.0f}%)]\tLoss: {:.6f}'.format(
                epoch, batch_idx * len(data), len(train_loader.dataset),
                       100. * batch_idx / len(train_loader), loss.item()))


def test(model, device, test_loader, test_loss_list, test_accuracy_list):
    model.eval()
    test_loss = 0
    correct = 0
    with torch.no_grad():
        for data, target in test_loader:
            data, target = data.to(device), target.to(device)
            output = model(data)
            test_loss += F.nll_loss(output, target, reduction='sum').item()  # sum up batch loss
            pred = output.argmax(dim=1, keepdim=True)  # get the index of the max log-probability
            correct += pred.eq(target.view_as(pred)).sum().item()

    test_loss /= len(test_loader.dataset)
    test_loss_list.append(test_loss)
    test_accuracy_list.append(correct / len(test_loader.dataset))
    print('\nTest set: Average loss: {:.4f}, Accuracy: {}/{} ({:.0f}%)\n'.format(
        test_loss, correct, len(test_loader.dataset),
        100. * correct / len(test_loader.dataset)))


def cnn_eval(tensor):
    model = Net()
    model.load_state_dict(torch.load("mnist_cnn.pt"))
    model.eval()
    print(torch.argmax(model(tensor)))


def mobile_eval(tensor):
    model = MobileNet()
    model.load_state_dict(torch.load("mnist_mobile.pt"))
    model.eval()
    print(torch.argmax(model(tensor)))


def l_infinity_pgd(model, tensor, gt, epsilon=40. / 255, target=None, iteration=500, show=True):
    delta = torch.zeros_like(tensor, requires_grad=True)
    # add random noise to delta and set epsilon to 0.005 to see the effect of noise
    delta.data = (delta.data + torch.randn_like(delta.data) * 0.005).clamp(-epsilon, epsilon)
    opt = optim.SGD([delta], lr=0.1)
    # print(target)
    for t in range(iteration):
        pred = model(norm(tensor + delta))
        if target is None:
            loss = -nn.CrossEntropyLoss()(pred, torch.LongTensor([gt]))
        else:
            loss = - 0.5 * nn.CrossEntropyLoss()(pred, torch.LongTensor([4])) + nn.CrossEntropyLoss()(pred,
                                                                                                      torch.LongTensor(
                                                                                                          [target]))
        if t % 50 == 0:
            print(t, loss.item())
        opt.zero_grad()
        loss.backward()
        opt.step()
        delta.data.clamp_(-epsilon, epsilon)

    print("True class probability:", nn.Softmax(dim=1)(pred))
    cnn_eval(norm(tensor + delta))

    if show:
        f, ax = plt.subplots(1, 2, figsize=(10, 5))
        ax[0].imshow((delta)[0].detach().numpy().transpose(1, 2, 0))
        ax[1].imshow((tensor + delta)[0].detach().numpy().transpose(1, 2, 0))

    return tensor + delta


def create_adv_dataset():
    transform = transforms.Compose([
        transforms.ToTensor()
    ])
    dataset1 = datasets.ImageFolder('mnist/training', transform=transform)
    train_loader = torch.utils.data.DataLoader(dataset1, batch_size=1, shuffle=True, num_workers=8)

    attack_target = 0
    # 每个数字生成100个对抗样本
    for batch_idx, (data, target) in enumerate(train_loader):
        attack_target = batch_idx // 100
        if target == attack_target:
            continue
        if attack_target > 9:
            break
        model = Net()
        model.load_state_dict(torch.load("mnist_cnn.pt"))
        model.eval()
        adv_img = l_infinity_pgd(model, data, target, 35. / 255, attack_target, 50, False)
        image_dir_1 = os.path.join('mnist/adv_ori_label', str(target.item()))
        image_dir_2 = os.path.join('mnist/adv_adv_label', str(attack_target))
        if not os.path.exists(image_dir_1):
            os.makedirs(image_dir_1)
        if not os.path.exists(image_dir_2):
            os.makedirs(image_dir_2)

        save_image(adv_img, os.path.join(image_dir_1, str(batch_idx) + '.jpg'))
        save_image(adv_img, os.path.join(image_dir_2, str(batch_idx) + '.jpg'))


# 对抗攻击函数
def fgsm_attack(model, data, target, epsilon):
    data_raw = data.clone().detach().requires_grad_(True)
    output = model(data_raw)
    loss = F.nll_loss(output, target)
    model.zero_grad()
    loss.backward()
    perturbed_data = data_raw + epsilon * torch.sign(data_raw.grad)
    perturbed_data = torch.clamp(perturbed_data, 0, 1)
    return perturbed_data


def main():
    # Training settings

    no_cuda = False
    seed = 1111
    batch_size = 128
    test_batch_size = 1000
    lr = 0.01
    save_model = True
    epochs = 2
    train_loss_list = []
    test_loss_list = []
    test_accuracy_list = []
    use_cuda = not no_cuda and torch.cuda.is_available()

    torch.manual_seed(seed)

    device = torch.device("cuda" if use_cuda else "cpu")

    train_kwargs = {'batch_size': batch_size, 'shuffle': True}
    test_kwargs = {'batch_size': test_batch_size, 'shuffle': True}
    if use_cuda:
        cuda_kwargs = {'num_workers': 1,
                       'pin_memory': True,
                       'shuffle': False}
        train_kwargs.update(cuda_kwargs)
        test_kwargs.update(cuda_kwargs)

    transform = transforms.Compose([
        transforms.ToTensor(),
        transforms.Normalize((0.1307,), (0.3081,))
    ])
    dataset1 = datasets.ImageFolder('mnist/training', transform=transform)
    dataset2 = datasets.ImageFolder('mnist/testing', transform=transform)
    train_loader = torch.utils.data.DataLoader(dataset1, **train_kwargs, num_workers=8)
    test_loader = torch.utils.data.DataLoader(dataset2, **test_kwargs)

    model = Net().to(device)
    # model = MobileNet().to(device)

    optimizer = optim.SGD(model.parameters(), momentum=0.9, lr=lr)

    scheduler = StepLR(optimizer, step_size=3, gamma=0.1)
    for epoch in range(1, epochs + 1):
        train(model, device, train_loader, optimizer, epoch, train_loss_list)
        test(model, device, test_loader, test_loss_list, test_accuracy_list)
        scheduler.step()
    # plot_training_results(train_loss_list, test_loss_list, test_accuracy_list)
    if save_model:
        torch.save(model.state_dict(), "mnist_cnn.pt")
        # torch.save(model.state_dict(), "mnist_mobile.pt")

    return model


if __name__ == '__main__':
    train_loss_list = []
    test_loss_list = []
    test_accuracy_list = []
    model = main()
    # model = MobileNet()
    # model.load_state_dict(torch.load("mnist_mobile.pt"))
    # model.eval()
    four_img = Image.open("mnist/pic/4.jpg")
    four_img = four_img.convert('RGB')
    transform = transforms.Compose([
        transforms.ToTensor()
    ])

    norm = transforms.Compose([
        transforms.Normalize((0.1307,), (0.3081,))
    ])

    four_tensor = transform(four_img)[None, :, :, :]

    # plot image (note that numpy using HWC whereas Pytorch user CHW, so we need to convert)
    plt.imshow(four_tensor[0].numpy().transpose(1, 2, 0))
    mobile_eval(norm(four_tensor))
    cnn_eval(norm(four_tensor))
    gt = 4
    delta = torch.zeros_like(four_tensor, requires_grad=True)
    opt = optim.SGD([delta], lr=10)
    epsilon = 0.2
    for t in range(20):
        pred = model(norm(four_tensor + delta))
        loss = -nn.CrossEntropyLoss()(pred, torch.LongTensor([gt]))
        opt.zero_grad()
        loss.backward()
        opt.step()
        delta.data.clamp_(-epsilon, epsilon)
    print(loss)
    print(cnn_eval(norm(four_tensor + delta)))
    plt.imshow(norm(four_tensor + delta)[0].detach().numpy().transpose(1, 2, 0))
    model.eval()
    x = l_infinity_pgd(model, four_tensor, 4, target=8)
    rem_img = Image.open("mnist/pic/tienan.jpeg")
    rem_img = rem_img.convert('RGB')
    transform = transforms.Compose([
        transforms.Resize((28, 28)),
        transforms.ToTensor()
    ])
    norm = transforms.Compose([
        transforms.Normalize((0.1307,), (0.3081,))
    ])
    rem_tensor = transform(rem_img)[None, :, :, :]
    cnn_eval(norm(rem_tensor))
    plt.imshow(rem_tensor[0].numpy().transpose(1, 2, 0))

    # 注意修改gt为输出值
    pred = 7
    l_infinity_pgd(model, rem_tensor, pred, 20. / 255, 6, 150)
    create_adv_dataset()

    test_transform = transforms.Compose([
        # transforms.GaussianBlur(3, sigma=(0.1, 1.0)),
        transforms.ToTensor(),
        transforms.Normalize((0.1307,), (0.3081,))
    ])

    dataset1 = datasets.ImageFolder('mnist/testing', transform=test_transform)
    dataset2 = datasets.ImageFolder('mnist/adv_ori_label', transform=test_transform)
    test_loader1 = torch.utils.data.DataLoader(dataset1, shuffle=False, batch_size=100)
    test_loader2 = torch.utils.data.DataLoader(dataset2, shuffle=False, batch_size=100)

    model = Net()
    model.load_state_dict(torch.load("mnist_cnn.pt"))
    model.eval()

    test(model, 'cpu', test_loader1, test_loss_list, test_accuracy_list)
    test_loss_list.clear()
    test_accuracy_list.clear()
    test(model, 'cpu', test_loader2, test_loss_list, test_accuracy_list)
    test_loss_list.clear()
    test_accuracy_list.clear()

    model = MobileNet()
    model.load_state_dict(torch.load("mnist_mobile.pt"))
    model.eval()

    test(model, 'cpu', test_loader1, test_loss_list, test_accuracy_list)
    test_loss_list.clear()
    test_accuracy_list.clear()
    test(model, 'cpu', test_loader2, test_loss_list, test_accuracy_list)
    test_loss_list.clear()
    test_accuracy_list.clear()
