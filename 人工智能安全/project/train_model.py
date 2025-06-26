import os
import time
import torch
from torch import optim
import numpy as np
import torchvision
import argparse
from torch.utils.data import DataLoader
from tqdm import tqdm
from dataset import *
from models import Mymodel
def main(args):
    if args.datasets_name == "MNIST":
        train_datasets, val_datasets = get_mnist()
    elif args.datasets_name == "STL10":
        train_datasets, val_datasets = get_stl10()
    elif args.datasets_name == "CIFAR10":
        train_datasets, val_datasets = get_cifar10()
    elif args.datasets_name == "CIFAR100":
        train_datasets, val_datasets = get_cifar100()
    elif args.datasets_name == "ImageNet":
        train_datasets, val_datasets = get_imagenet()
    else:
        print("not support dataset, use CIFAR10 instead")
        train_datasets, val_datasets = get_cifar10()
    print(f"len(train_datasets)={len(train_datasets)}, len(val_datasets) = {len(val_datasets)}")

    train_dataloader=DataLoader(train_datasets,args.batch_size,shuffle=True)
    val_dataloader=DataLoader(val_datasets,args.batch_size,shuffle=True)
    assert torch.cuda.is_available()
    print("get model======>")
    model=Mymodel(args.model_name)
    # print(model)
    model=model.cuda()
    optimizer = optim.SGD(model.parameters(), lr=0.1,
                      momentum=0.9, weight_decay=5e-4)
    scheduler = torch.optim.lr_scheduler.CosineAnnealingLR(optimizer, T_max=args.batch_size)
    criterion = torch.nn.CrossEntropyLoss()
    # this model is train
    print("train======>")
    log_dir = args.model_name + "-" + args.datasets_name + "-"
    train(model,train_dataloader,val_dataloader,log_dir,args.epoch,optimizer,scheduler,criterion,best_val=0)


def train(model,train_dataloader,val_dataloader,log_dir,epoch,optimizer,scheduler,criterion,best_val=0):
    save_log_dir = "./"+log_dir+"originalModel/train_model_log.txt"
    print("current dir is ",os.getcwd())
    # if save_log_dir file is not exist, create it
    if not os.path.exists(os.getcwd()+"/"+log_dir+"originalModel"):
        os.makedirs(os.getcwd()+"/"+log_dir+"originalModel")
    file = open(os.getcwd()+"/"+log_dir+"originalModel/train_model_log.txt", "a+")
    file.close()
    # if confi
    best_acc=0
    # open a log file named train_model_log.txt
    with open(save_log_dir, "a+") as f:
        # write time to the log file
        f.write(str(time.strftime('%Y-%m-%d %H:%M:%S', time.localtime(time.time()))))
        # write the model to the log file
        f.write(str(model))
        f.close()

    train_loss=[]
    train_acc=[]
    val_loss=[]
    val_acc=[]
    for epoch_i in range(1,epoch+1):
        T_loss_L=[]
        T_acc_L=[]
        model.train()
        with tqdm() as tbar:
            for batch_idx,(x,y) in enumerate(train_dataloader):
                tbar.set_description(f"Epoch: {epoch_i} | train {batch_idx}/{len(train_dataloader)}")
                x=x.cuda()
                y=y.cuda()
                optimizer.zero_grad()
                output_y=model(x)
                loss=criterion(output_y,y)
                loss.backward()
                optimizer.step()
                T_loss_L.append(loss.item())
                predict_y=torch.argmax(output_y,dim=1)
                t_acc = (y == predict_y).float().mean().item()
                T_acc_L.append(t_acc)
                tbar.set_postfix(loss=f"{np.mean(T_loss_L):.2f}",acc=f"{100.*np.mean(T_acc_L):.2f}")
                tbar.update(1)
        train_loss.append(np.mean(T_loss_L))
        train_acc.append(100.*np.mean(T_acc_L))
        with open(save_log_dir, "a+") as f:
            f.write(f"\nEpoch: {epoch_i} | train_loss: {np.mean(T_loss_L):.2f} | train_acc: {100.*np.mean(T_acc_L):.2f}")
            f.close()
        model.eval()
        V_loss_L=[]
        V_acc_L=[]
        with tqdm() as tbar:
            for batch_idx,(x,y) in enumerate(val_dataloader):
                tbar.set_description(f"Epoch: {epoch_i} | val {batch_idx}/{len(val_dataloader)}")
                x=x.cuda()
                y=y.cuda()
                output_y=model(x)
                loss=criterion(output_y,y)
                V_loss_L.append(loss.item())
                predict_y=torch.argmax(output_y,dim=1)
                v_acc = (y == predict_y).float().mean().item()
                V_acc_L.append(v_acc)
                tbar.set_postfix(loss=f"{np.mean(T_loss_L):.2f}",acc=f"{100.*np.mean(T_acc_L):.2f}")
                tbar.update(1)
        scheduler.step()
        val_loss.append(np.mean(V_loss_L))
        val_acc.append(100.*np.mean(V_acc_L))
        with open(save_log_dir, "a+") as f:
            f.write(f"\nEpoch: {epoch_i} | val_loss: {np.mean(V_loss_L):.2f} | val_acc: {100.*np.mean(V_acc_L):.2f}")
            f.close()
        if best_acc<np.mean(V_acc_L):
            best_acc=np.mean(V_acc_L)
            state = {
                    'model': model.state_dict(),
                    'epoch': epoch_i,
                    "acc":best_acc
                }
            torch.save(state,os.path.join(os.getcwd()+"/"+log_dir+"originalModel","best.pth"))#args.save_path
            print(f"find best acc {best_acc*100:.2f}% at {epoch_i}")
            with open(save_log_dir, "a+") as f:
                f.write(f"\nfind best acc {best_acc*100:.2f}% at {epoch_i}")
                f.close()


if __name__=="__main__":
    parser = argparse.ArgumentParser(description='train_victim_model')
    #str
    parser.add_argument('--datasets_name', type=str,default="CIFAR10",help='choose the datasets')
    parser.add_argument("--model_name",type=str,default="VGG_16",help="model name")
    parser.add_argument("--save_path",type=str,default="exp/weight",help="determine where to save the model")
    #int
    parser.add_argument('--batch_size',type=int,default=100,help="get the batch size")
    parser.add_argument('--epoch',type=int,default=150,help="training epoch")
    parser.add_argument('--seed', type=int,default=3210103803,help="random seed")
    #float
    parser.add_argument('--lr', default=0.001, type=float, help='learning rate')
    args = parser.parse_args()
    print(args)
    import random
    def setup_seed(seed):
        torch.manual_seed(seed)
        torch.cuda.manual_seed_all(seed)
        np.random.seed(seed)
        random.seed(seed)
        torch.backends.cudnn.deterministic = True
    # 设置随机数种子
    setup_seed(args.seed)
    if not os.path.exists(args.save_path):
        os.makedirs(args.save_path)
    main(args)