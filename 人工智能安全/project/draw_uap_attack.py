import matplotlib.pyplot as plt
import numpy as np


def visualize_adv_ori():
    ori_files = ["./GoogleNet-CIFAR10-UAP_ATTACK/benign.png",
                "./GoogleNet-CIFAR100-UAP_ATTACK/benign.png",
                "./GoogleNet-STL10-UAP_ATTACK/benign.png",
                 "./GoogleNet-ImageNet-UAP_ATTACK/benign.png"
                ]
    adv_files = ["./GoogleNet-CIFAR10-UAP_ATTACK/adversarial.png",
                "./GoogleNet-CIFAR100-UAP_ATTACK/adversarial.png",
                "./GoogleNet-STL10-UAP_ATTACK/adversarial.png",
                "./GoogleNet-ImageNet-UAP_ATTACK/adversarial.png"
                ]
    # load original and adversarial png files from path and visualize them in a figure
    fig = plt.figure()
    fig.suptitle("GoogleNet ori and adv images")
    ax1 = fig.add_subplot(2, 4, 1)
    ax2 = fig.add_subplot(2, 4, 2)
    ax3 = fig.add_subplot(2, 4, 3)
    ax4 = fig.add_subplot(2, 4, 4)
    ax5 = fig.add_subplot(2, 4, 5)
    ax6 = fig.add_subplot(2, 4, 6)
    ax7 = fig.add_subplot(2, 4, 7)
    ax8 = fig.add_subplot(2, 4, 8)
    ax1.set_title("CIFAR10")
    ax2.set_title("CIFAR100")
    ax3.set_title("STL10")
    ax4.set_title("ImageNet")
    ax1.imshow(plt.imread(ori_files[0]))
    ax2.imshow(plt.imread(ori_files[1]))
    ax3.imshow(plt.imread(ori_files[2]))
    ax4.imshow(plt.imread(ori_files[3]))
    ax5.imshow(plt.imread(adv_files[0]))
    ax6.imshow(plt.imread(adv_files[1]))
    ax7.imshow(plt.imread(adv_files[2]))
    ax8.imshow(plt.imread(adv_files[3]))
    fig.savefig("GoogleNet-uap_attack_model_adv_ori.png")



def visualize_uap():
    uap_files = ["./GoogleNet-CIFAR10-UAP_ATTACK/uap_single*10.png",
                 "./GoogleNet-CIFAR100-UAP_ATTACK/uap_single*10.png",
                 "./GoogleNet-STL10-UAP_ATTACK/uap_single*10.png",
                 "./GoogleNet-ImageNet-UAP_ATTACK/uap_single*10.png",
                 ]
    # load png files from path and visualize them in a figure
    fig = plt.figure()
    fig.suptitle("GoogleNet UAP*10 image")
    ax1 = fig.add_subplot(2, 2, 1)
    ax2 = fig.add_subplot(2, 2, 2)
    ax3 = fig.add_subplot(2, 2, 3)
    ax4 = fig.add_subplot(2, 2, 4)
    ax1.set_title("CIFAR10")
    ax2.set_title("CIFAR100")
    ax3.set_title("STL10")
    ax4.set_title("ImageNet")
    ax1.imshow(plt.imread(uap_files[0]))
    ax2.imshow(plt.imread(uap_files[1]))
    ax3.imshow(plt.imread(uap_files[2]))
    ax4.imshow(plt.imread(uap_files[3]))
    fig.savefig("GoogleNet-uap_attack_model_uap.png")
def draw():
    log_files = ["./GoogleNet-CIFAR10-UAP_ATTACK/attack_log.txt",
                "./GoogleNet-CIFAR100-UAP_ATTACK/attack_log.txt",
                "./GoogleNet-STL10-UAP_ATTACK/attack_log.txt",
                 "./GoogleNet-ImageNet-UAP_ATTACK/attack_log.txt",
                ]
    fig_loss = plt.figure()
    fig_acc = plt.figure()
    ax1 = fig_loss.add_subplot(2, 2, 1)
    ax2 = fig_loss.add_subplot(2, 2, 2)
    ax3 = fig_loss.add_subplot(2, 2, 3)
    ax4 = fig_loss.add_subplot(2, 2, 4)
    ax5 = fig_acc.add_subplot(2, 2, 1)
    ax6 = fig_acc.add_subplot(2, 2, 2)
    ax7 = fig_acc.add_subplot(2, 2, 3)
    ax8 = fig_acc.add_subplot(2, 2, 4)
    fig_loss.suptitle("UAP Attack GoogleNet Train Loss")
    fig_acc.suptitle("UAP Attack GoogleNet Train Acc")
    ax1.set_title("CIFAR10")
    ax2.set_title("CIFAR100")
    ax3.set_title("STL10")
    ax4.set_title("ImageNet")
    ax5.set_title("CIFAR10")
    ax6.set_title("CIFAR100")
    ax7.set_title("STL10")
    ax8.set_title("ImageNet")
    # ax1.set_xlabel("Epoch")
    # ax2.set_xlabel("Epoch")
    # ax3.set_xlabel("Epoch")
    # ax4.set_xlabel("Epoch")
    # ax5.set_xlabel("Epoch")
    # ax6.set_xlabel("Epoch")
    # ax7.set_xlabel("Epoch")
    # ax8.set_xlabel("Epoch")
    train_loss = []
    train_acc = []
    val_loss = []
    val_acc = []
    cnt = 0
    for log_file in log_files:
        cnt += 1
        train_loss.clear()
        train_acc.clear()
        val_loss.clear()
        val_acc.clear()
        with open(log_file, "r") as f:
            lines = f.readlines()
            for line in lines:
                if "train_loss" in line:
                    train_loss.append(float(line.split(" ")[4]))
                    train_acc.append(float(line.split(" ")[7]))
                if "val_loss" in line:
                    print(line)
                    val_loss.append(float(line.split(" ")[4]))
                    val_acc.append(float(line.split(" ")[7].split("%")[0]))
        if cnt == 1:
            ax1.plot(range(1, len(train_loss)+1), train_loss, label="train_loss")
            ax1.plot(range(1, len(val_loss)+1), val_loss, label="val_loss")
            ax5.plot(range(1, len(train_acc)+1), train_acc, label="train_acc")
            ax5.plot(range(1, len(val_acc)+1), val_acc, label="val_acc")
            ax1.legend()
            ax5.legend()
        elif cnt == 2:
            ax2.plot(range(1, len(train_loss)+1), train_loss, label="train_loss")
            ax2.plot(range(1, len(val_loss)+1), val_loss, label="val_loss")
            ax6.plot(range(1, len(train_acc)+1), train_acc, label="train_acc")
            ax6.plot(range(1, len(val_acc)+1), val_acc, label="val_acc")
            ax2.legend()
            ax6.legend()
        elif cnt == 3:
            ax3.plot(range(1, len(train_loss)+1), train_loss, label="train_loss")
            ax3.plot(range(1, len(val_loss)+1), val_loss, label="val_loss")
            ax7.plot(range(1, len(train_acc)+1), train_acc, label="train_acc")
            ax7.plot(range(1, len(val_acc)+1), val_acc, label="val_acc")
            ax3.legend()
            ax7.legend()
        elif cnt == 4:
            ax4.plot(range(1, len(train_loss)+1), train_loss, label="train_loss")
            ax4.plot(range(1, len(val_loss)+1), val_loss, label="val_loss")
            ax8.plot(range(1, len(train_acc)+1), train_acc, label="train_acc")
            ax8.plot(range(1, len(val_acc)+1), val_acc, label="val_acc")
            ax4.legend()
            ax8.legend()
    fig_loss.savefig("GoogleNet-uap_attack_model_train_loss.png")
    fig_acc.savefig("GoogleNet-uap_attack_model_train_acc.png")




if __name__ == "__main__":
    draw()
    visualize_uap()
    print("draw uap attack model")
    visualize_adv_ori()
    print("draw adv ori model")