"""
Boundary Attack++
"""
import argparse
import random
import warnings
import numpy as np
import torch
import os
import time
import sys
from tqdm import tqdm
from torch.utils.data import DataLoader
from models import Mymodel
from dataset import *
from torchvision import utils as vutils
xx = None
def UAP_ATTACK_WHITE(model,train_data=None,val_data=None,optimizer = None,uap=None,args = None):
    debug = True
    save_path = args.model_name + "-" + args.dataset + "-UAP_ATTACK/"
    if not os.path.exists(os.getcwd()+"/"+save_path):
        os.makedirs(os.getcwd()+"/"+save_path)
    file = open(os.getcwd()+"/"+save_path+"attack_log.txt", "a+")
    file.close()
    with open(os.getcwd()+"/"+save_path+"attack_log.txt", "a+") as f:
        f.write(str(time.strftime('%Y-%m-%d %H:%M:%S', time.localtime(time.time()))))
        f.write(str(model))
        f.close()
    print("[UAP_ATTACK_WHITE]: uap.size = ",uap.size())
    print("[UAP_ATTACK_WHITE]: train_data.type = ",type(train_data))
    print("[UAP_ATTACK_WHITE]: val_data.type = ",type(val_data))
    for batch_idx,(x,y) in enumerate(train_data):
        print("[UAP_ATTACK_WHITE]: x.size = ",x.size()) # torch.Size([100, 3, 224, 224])
        print("[UAP_ATTACK_WHITE]: x[0].size = ",x[0].size()) # torch.Size([3, 224, 224])
        # print("y[0] = ",y[0])
        break
    global xx
    train_loss = []
    train_acc = []
    val_loss = []
    val_acc = []
    val_fool_ratio = []
    for epoch_i in range(1,args.epoch+1):
        print("\nepoch %d==>"%(epoch_i))
        # todo: begin add
        model.train()
        T_acc_L = []
        T_loss_L = []
        # todo: end add
        with tqdm() as tbar:
            for batch_idx,(x,y) in enumerate(train_data):
                tbar.set_description(f"Epoch: {epoch_i} | train {batch_idx}/{len(train_data)}")
                uap.requires_grad = True # torch.Size([1, 3, 32, 32])
                x=x.cuda() # torch.Size([100, 3, 32, 32]) torch.Size([100, 3, 224, 224])
                if epoch_i == 1 and batch_idx == 0:
                    print("train x.size = ",x.size())
                y=y.cuda()
                # 计算benign sample的置信度向量
                logits_ori = model(x) # torch.Size([100, 1000])
                predict_label = torch.argmax(logits_ori, dim=1) #torch.Size([100])
                # 计算adversarial sample的置信度向量
                logits_uap = model(x+uap)
                predict_uap = torch.argmax(logits_uap, dim=1)
                # 计算损失函数 L(k(x), k(x + ν))
                optimizer.zero_grad()
                loss = torch.nn.functional.cosine_similarity(predict_label.float(),predict_uap.float(),dim=0) #torch.Size([])
                loss_avg = loss.mean()
                loss_avg.requires_grad = True
                loss_avg.backward()
                # 计算梯度
                optimizer.step()
                T_loss_L.append(loss_avg.item())
                optimizer.zero_grad()
                t_acc = (predict_label != predict_uap).float().mean().item()
                T_acc_L.append(t_acc)
                # torch.clamp 裁剪扰动大小
                clip_tensor = torch.full_like(uap.data,args.clip_value)
                uap.data = torch.clamp(uap.data, clip_tensor, (np.maximum(uap.data.cpu(), -args.clip_value)).to("cuda"))
                # v <= min(eps, max(v,−eps)) : v clipping
                # v is uap.data
                tbar.set_postfix(loss=f"{loss_avg.cpu().item():.4f}")
                tbar.update(1)
        train_loss.append(np.mean(T_loss_L))
        train_acc.append(100.*np.mean(T_acc_L))
        exit(0)
        with open(save_path+"attack_log.txt", "a+") as f:
            f.write(f"\nEpoch: {epoch_i} | train_loss: {np.mean(T_loss_L):.4f} | train_acc: {100.*np.mean(T_acc_L):.2f}")
            f.close()
        uap.requires_grad = False
        V_acc_L = []
        V_loss_L = []
        # todo: begin add
        model.eval()
        # todo: end add
        with torch.no_grad():
            with tqdm() as tbar:
                for batch_idx,(x,y) in enumerate(val_data):
                    tbar.set_description(f"Epoch: {epoch_i} | val {batch_idx}/{len(val_data)}")
                    x=x.cuda() # torch.Size([100, 3, 32, 32]) torch.Size([100, 3, 224, 224])
                    xx = x
                    y=y.cuda()
                    logits_ori = model(x)
                    predict_label = torch.argmax(logits_ori,dim=1)

                    x = x[predict_label==y]
                    logits_ori = logits_ori[predict_label==y]
                    predict_label = predict_label[predict_label==y]

                    logits_uap = model(x+uap)
                    predict_uap = torch.argmax(logits_uap,dim=1)
                    loss = torch.nn.functional.cosine_similarity(predict_label.float(),predict_uap.float(),dim=0)
                    V_loss_L.append(loss.mean().item())
                    v_acc = (predict_label != predict_uap).cpu().numpy().tolist()
                    
                    V_acc_L += v_acc

                    tbar.set_postfix(acc=f"{100.*np.mean(V_acc_L):.2f}%",fool_ratio=f"{100*(1-np.mean(V_acc_L)):.2f}%")
                    tbar.update(1)
        val_loss.append(np.mean(V_loss_L))
        val_acc.append(100.*np.mean(V_acc_L))
        val_fool_ratio.append(100*(1-np.mean(V_acc_L)))
        with open(save_path+"attack_log.txt", "a+") as f:
            f.write(f"\nEpoch: {epoch_i} | val_loss: {np.mean(V_loss_L):.4f} | val_acc: {100.*np.mean(V_acc_L):.2f}% | fool_ratio: {100*(1-np.mean(V_acc_L)):.2f}%")
            f.close()
        os.makedirs(save_path,exist_ok=True)
        print("save uap.size = ",uap.size())
        print("save x.size = ",x.size())
        print("save xx.size = ",xx.size())
        # save uap.size =  torch.Size([1, 3, 224, 224])
        # save x.size =  torch.Size([0, 3, 224, 224])
        save_image_tensor(uap,os.path.join(save_path,"uap_single.png"))
        print("uap single save done")
        save_image_tensor(uap*10,os.path.join(save_path,"uap_single*10.png"))
        print("uap single*10 save done")
        save_image_tensor(xx,os.path.join(save_path,"benign.png"))
        print("benign save done")
        save_image_tensor(uap+xx,os.path.join(save_path,"adversarial.png"))
        print("adversarial save done")
        torch.save({"perturbation_hist":uap,},os.path.join(save_path,"uap.pth"))
        print("uap.pth save done")

def save_image_tensor(input_tensor: torch.Tensor, filename):
    """
    将tensor保存为图片
    :param input_tensor: 要保存的tensor
    :param filename: 保存的文件名
    """
    print("[save_image_tensor]: input_tensor.size = ",input_tensor.size())
    if len(input_tensor.shape) == 4 and input_tensor.shape[0] != 0:
        input_tensor_copy = input_tensor.clone().detach()
        print("[save_image_tensor]: input_tensor_copy.size = ",input_tensor_copy.size())
        input_tensor_cpu = input_tensor_copy.to(torch.device('cpu'))
        print("[save_image_tensor]: input_tensor_cpu.size = ",input_tensor_cpu.size())
        vutils.save_image(input_tensor_cpu, filename)
    elif len(input_tensor.shape) == 3:
        # torch.size([3, 224, 224]) -> torch.size([1, 3, 224, 224])
        temp_numpy = input_tensor.clone().detach().squeeze(0).numpy()
        print("[save_image_tensor]: temp_numpy.shape = ",temp_numpy.shape)
        final_numpy = temp_numpy[np.newaxis, :, :, :].copy()
        print("[save_image_tensor]: final_numpy.shape = ",final_numpy.shape)
        final_tensor = torch.from_numpy(final_numpy)
        print("[save_image_tensor]: final_tensor.size = ",final_tensor.size())
        final_tensor_copy = final_tensor.clone().detach()
        print("[save_image_tensor]: final_tensor_copy.size = ",final_tensor_copy.size())
        final_tensor_cpu = final_tensor_copy.to(torch.device('cpu'))
        print("[save_image_tensor]: final_tensor_cpu.size = ",final_tensor_cpu.size())
        vutils.save_image(final_tensor_cpu, filename)
def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--dataset', type=str,
        choices=["CIFAR10", "CIFAR100", "ImageNet","STL10"],
        default="CIFAR10")
    parser.add_argument('--dataset_trained', type=str,
                        choices=["CIFAR10", "CIFAR100", "ImageNet", "STL10"],
                        default="CIFAR10")
    parser.add_argument('--model_name', type=str,
        choices=['ResNet_18', 'DenseNet_121',"EfficientNet_B2","GoogleNet","VGG_16","MobileNet_V2","ResNet_50","Wide_ResNet50_2","Squeezenet1_0","Shufflenet_v2_x2_0","MNASNet1_0","Alexnet"],
        default='ResNet_18')
    parser.add_argument('--cuda', type=str,
        choices=["0","1"],
        default="0")
    parser.add_argument('--image_size', type=int,
        default=32)
    parser.add_argument('--epoch', type=int,
        default=5)
    parser.add_argument('--clip_value', type=float,choices=[0.04],
        default=0.04)
    parser.add_argument('--lr', type=float,
        default=0.1)
    parser.add_argument('--batch_size', type=int,
        default=100)
    parser.add_argument('--seed', type=int,
        default=3210103803)
    args = parser.parse_args()
    print(args)
    os.environ['CUDA_VISIBLE_DEVICES']=args.cuda

    def setup_seed(seed):
        torch.manual_seed(seed)
        torch.cuda.manual_seed_all(seed)
        np.random.seed(seed)
        random.seed(seed)
        torch.backends.cudnn.deterministic = True
    setup_seed(args.seed)
    sys.path.append(".")
    model=Mymodel(args.model_name)
    save_dict=torch.load(args.model_name + "-" + args.dataset_trained + "-originalModel/best.pth")
    print(f"[main]: find best acc {save_dict['acc']*100:.2f}% at {save_dict['epoch']}")
    model.load_state_dict(save_dict["model"])
    model.eval()
    model=model.cuda()
    image_size = args.image_size
    uap = (torch.rand(1,3,image_size,image_size).cuda()*2-1)*args.clip_value
    save_image_tensor(uap, "uap-"+args.model_name + "-" + args.dataset +"-original.png")
    flag = 0
    if args.dataset=="MNIST":
        train_datasets,val_datasets=get_mnist()
    elif args.dataset=="STL10":
        train_datasets,val_datasets=get_stl10()
    elif args.dataset=="CIFAR10":
        train_datasets,val_datasets=get_cifar10()
    elif args.dataset=="CIFAR100":
        train_datasets,val_datasets=get_cifar100()
    elif args.dataset=="ImageNet":
        train_datasets,val_datasets=get_imagenet()
    else:
        print("[main]: not support dataset, use CIFAR10 instead")
        train_datasets,val_datasets=get_cifar10()
    print(f"[main]: len(train_datasets)={len(train_datasets)}, len(val_datasets) = {len(val_datasets)}")
    train_data = DataLoader(train_datasets,args.batch_size,shuffle=True)
    val_data = DataLoader(val_datasets,args.batch_size,shuffle=False)
    optimizer = torch.optim.Adam([uap], lr=args.lr,weight_decay=1e-5)
    UAP_ATTACK_WHITE(model,train_data,val_data,optimizer,uap,args=args)
    print("[main]: done")
    exit(0)

if __name__=="__main__":
    warnings.filterwarnings("ignore")
    main()


        
    
    