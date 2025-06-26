import torch
import torchvision
from torchvision import transforms,datasets
from torch.utils.data import DataLoader


def get_mnist():
    train_datasets=datasets.MNIST(root="mnist_data",train=True,download=True ,transform=transforms.ToTensor())
    val_datasets=datasets.MNIST(root="mnist_data",train=False,download=True ,transform=transforms.ToTensor())

    return train_datasets,val_datasets
def get_cifar10():
    transform1=transforms.Compose([
        transforms.RandomCrop(32,4),
        transforms.RandomHorizontalFlip(0.5),
        transforms.ToTensor(),
    ])
    transform2=transforms.Compose([
        transforms.ToTensor(),
    ])
    train_datasets=datasets.CIFAR10(root="cifar_data",train=True,download=True ,transform=transform1)
    val_datasets=datasets.CIFAR10(root="cifar_data",train=False,download=True ,transform=transform2)
    
    return train_datasets,val_datasets
    
def get_cifar100():
    transform1=transforms.Compose([
        transforms.RandomCrop(32,4),
        transforms.RandomHorizontalFlip(0.5),
        transforms.ToTensor(),
    ])
    transform2=transforms.Compose([
        transforms.ToTensor(),
    ])
    train_datasets=datasets.CIFAR100(root="cifar_data",train=True,download=True ,transform=transform1)
    val_datasets=datasets.CIFAR100(root="cifar_data",train=False,download=True ,transform=transform2)
    
    return train_datasets,val_datasets

def get_stl10():
    transform1=transforms.Compose([
        transforms.RandomCrop(96,4),
        transforms.RandomHorizontalFlip(0.5),
        transforms.ToTensor(),
    ])
    transform2=transforms.Compose([
        transforms.ToTensor(),
    ])
    train_datasets=datasets.STL10(root="stl10_data",split="train",download=True ,transform=transform1)
    val_datasets=datasets.STL10(root="stl10_data",split="test",download=True ,transform=transform2)

    return train_datasets,val_datasets

def get_imagenet():
    # data_transform = {
    #     "train": transforms.Compose([transforms.RandomResizedCrop(224),
    #                                  transforms.RandomHorizontalFlip(),
    #                                  transforms.ColorJitter(brightness=0.4, contrast=0.4, hue=0.4),
    #                                  transforms.ToTensor(),
    #                                  transforms.Normalize([0.485, 0.456, 0.406], [0.229, 0.224, 0.225])]),
    #
    #     "val": transforms.Compose([transforms.Resize(256),
    #                                transforms.CenterCrop(224),
    #                                transforms.ToTensor(),
    #                                transforms.Normalize([0.485, 0.456, 0.406], [0.229, 0.224, 0.225])])}
    #
    transform1=transforms.Compose([
        transforms.RandomResizedCrop(224),
        transforms.RandomHorizontalFlip(),
        transforms.ColorJitter(brightness=0.4, contrast=0.4, hue=0.4),
        transforms.ToTensor(),
        transforms.Normalize([0.485, 0.456, 0.406], [0.229, 0.224, 0.225])
    ])
    transform2=transforms.Compose([
        transforms.Resize(256),
        transforms.CenterCrop(224),
        transforms.ToTensor(),
        transforms.Normalize([0.485, 0.456, 0.406], [0.229, 0.224, 0.225])
    ])
    train_dataset_path="imagenet_data/train"
    valid_dataset_path="imagenet_data/val"
    train_datasets = datasets.ImageFolder(train_dataset_path,transform=transform1)
    val_datasets = datasets.ImageFolder(valid_dataset_path,transform=transform2)
    print("[get_imagenet] train_datasets.type:",type(train_datasets))
    print("[get_imagenet] val_datasets.type:",type(val_datasets))
    return train_datasets,val_datasets


def get_transforms(name):
    if name=="CIFAR10":
        transform=transforms.Compose([
        transforms.Normalize((125.307/255, 122.961/255, 113.8575/255), (51.5865/255, 50.847/255, 51.255/255)),
        ])
        
    elif name=="CIFAR100":
        transform=transforms.Compose([
        transforms.Normalize((129.304/255, 124.070/255, 112.434/255), (68.170/255, 65.392/255, 70.418/255)),
        ])
    elif name=="ImageNet":
        transform=transforms.Compose([
        transforms.Normalize((123.675/255, 116.28/255, 103.53/255), (58.395/255, 57.12/255, 57.375/255)),
        
    ])
    return transform









