import matplotlib.pyplot as plt
import numpy as np
# load data from:
# ./DenseNet_121-CIFAR10-originalModel/train_model_log.txt
# ./ResNet_18-CIFAR10-originalModel/train_model_log.txt
# ./GoogleNet-CIFAR10-originalModel/train_model_log.txt

def draw_test():
    log_file = "./train_model_log.txt"
    # create a figure
    fig_loss = plt.figure()
    # create another figure for acc
    fig_acc = plt.figure()
    # subplot is 1*1
    ax1 = fig_loss.add_subplot(1, 1, 1)
    ax2 = fig_acc.add_subplot(1, 1, 1)
    # set the title of the figure
    fig_loss.suptitle("Original Model Train Loss on CIFAR10")
    fig_acc.suptitle("Original Model Train Acc on CIFAR10")
    # set the title of each subplot
    ax1.set_title("ResNet_18")
    ax2.set_title("ResNet_18")
    # set the label of x-axis
    ax1.set_xlabel("Epoch")
    ax2.set_xlabel("Epoch")
    # set the label of y-axis: loss
    ax1.set_ylabel("Loss")
    ax2.set_ylabel("Acc")
    # in log file, data format is:
    # 2024-06-08 20:38:36Mymodel(...
    # ...
    # )
    # Epoch: 1 | train_loss: 3.13 | train_acc: 19.76
    # Epoch: 1 | val_loss: 1.91 | val_acc: 29.23
    # find best acc 29.23% at 1
    # Epoch: 2 | train_loss: 1.87 | train_acc: 29.59
    # Epoch: 2 | val_loss: 1.79 | val_acc: 32.09
    # find best acc 32.09% at 2
    # ...
    # total 150 epochs
    train_loss = []
    train_acc = []
    val_loss = []
    val_acc = []
    best_acc = []
    best_acc_at = []
    with open(log_file, "r") as f:
        lines = f.readlines()
        for line in lines:
            if "find best acc" in line:
                # print(int(line.split(" ")[5]))
                best_acc.append(float(line.split(" ")[3].split("%")[0])/100.0)
                best_acc_at.append(int(line.split(" ")[5]))
            if "train_loss" in line:
                # print(line.split(" ")[7])
                train_loss.append(float(line.split(" ")[4]))
                train_acc.append(float(line.split(" ")[7]))
            if "val_loss" in line:
                val_loss.append(float(line.split(" ")[4]))
                val_acc.append(float(line.split(" ")[7]))
        # plot the data
        ax1.plot(range(1, len(train_loss)+1), train_loss, label="train_loss")
        ax1.plot(range(1, len(val_loss)+1), val_loss, label="val_loss")
        # # draw acc also
        ax2.plot(range(1, len(train_acc)+1), train_acc, label="train_acc")
        ax2.plot(range(1, len(val_acc)+1), val_acc, label="val_acc")
        # plot the last best acc and emphisize it
        ax2.scatter(best_acc_at[-1], best_acc[-1]*100.0, color="green", label="best_acc")
        ax1.legend()
        ax2.legend()
        # save the figure
        fig_loss.savefig("1000-original_model_train_loss.png")
        fig_acc.savefig("1000-original_model_train_acc.png")

def draw_original_model_train():
    # find all the log files and load data
    log_files = ["./DenseNet_121-CIFAR10-originalModel/train_model_log.txt",
                    "./ResNet_18-CIFAR10-originalModel/train_model_log.txt",
                    "./GoogleNet-CIFAR10-originalModel/train_model_log.txt"]
    # create a figure
    fig_loss = plt.figure()
    # create another figure for acc
    fig_acc = plt.figure()
    # subplot is 1*3
    ax1 = fig_loss.add_subplot(1, 3, 1)
    ax2 = fig_loss.add_subplot(1, 3, 2)
    ax3 = fig_loss.add_subplot(1, 3, 3)
    ax4 = fig_acc.add_subplot(1, 3, 1)
    ax5 = fig_acc.add_subplot(1, 3, 2)
    ax6 = fig_acc.add_subplot(1, 3, 3)
    # set the title of the figure
    fig_loss.suptitle("Original Model Train Loss on CIFAR10")
    fig_acc.suptitle("Original Model Train Acc on CIFAR10")
    # set the title of each subplot
    ax1.set_title("DenseNet_121")
    ax2.set_title("ResNet_18")
    ax3.set_title("GoogleNet")
    ax4.set_title("DenseNet_121")
    ax5.set_title("ResNet_18")
    ax6.set_title("GoogleNet")
    # set the label of x-axis
    ax1.set_xlabel("Epoch")
    ax2.set_xlabel("Epoch")
    ax3.set_xlabel("Epoch")
    ax4.set_xlabel("Epoch")
    ax5.set_xlabel("Epoch")
    ax6.set_xlabel("Epoch")
    # set the label of y-axis: loss
    ax1.set_ylabel("Loss")
    ax2.set_ylabel("Loss")
    ax3.set_ylabel("Loss")
    ax4.set_ylabel("Acc")
    ax5.set_ylabel("Acc")
    ax6.set_ylabel("Acc")
    # in log file, data format is:
    # 2024-06-08 20:38:36Mymodel(...
    # ...
    # )
    # Epoch: 1 | train_loss: 3.13 | train_acc: 19.76
    # Epoch: 1 | val_loss: 1.91 | val_acc: 29.23
    # find best acc 29.23% at 1
    # Epoch: 2 | train_loss: 1.87 | train_acc: 29.59
    # Epoch: 2 | val_loss: 1.79 | val_acc: 32.09
    # find best acc 32.09% at 2
    # ...
    # total 150 epochs
    train_loss = []
    train_acc = []
    val_loss = []
    val_acc = []
    best_acc = []
    best_acc_at = []
    cnt = 0
    for log_file in log_files:
        train_loss.clear()
        train_acc.clear()
        val_loss.clear()
        val_acc.clear()
        best_acc.clear()
        best_acc_at.clear()
        with open(log_file, "r") as f:
            lines = f.readlines()
            for line in lines:
                if "find best acc" in line:
                    # print(int(line.split(" ")[5]))
                    best_acc.append(float(line.split(" ")[3].split("%")[0])/100.0)
                    best_acc_at.append(int(line.split(" ")[5]))
                if "train_loss" in line:
                    # print(line.split(" ")[7])
                    train_loss.append(float(line.split(" ")[4]))
                    train_acc.append(float(line.split(" ")[7]))
                if "val_loss" in line:
                    val_loss.append(float(line.split(" ")[4]))
                    val_acc.append(float(line.split(" ")[7]))
        cnt += 1
        # plot the data
        if cnt == 1:
            ax1.plot(range(1, len(train_loss)+1), train_loss, label="train_loss")
            ax1.plot(range(1, len(val_loss)+1), val_loss, label="val_loss")
            # # draw acc also
            ax4.plot(range(1, len(train_acc)+1), train_acc, label="train_acc")
            ax4.plot(range(1, len(val_acc)+1), val_acc, label="val_acc")
            # plot the last best acc and emphisize it
            ax4.scatter(best_acc_at[-1], best_acc[-1]*100.0, color="green", label="best_acc")
            print(best_acc_at[-1], best_acc[-1])
            ax1.legend()
            ax4.legend()
        elif cnt == 2:
            ax2.plot(range(1, len(train_loss)+1), train_loss, label="train_loss")
            ax2.plot(range(1, len(val_loss)+1), val_loss, label="val_loss")
            ax5.plot(range(1, len(train_acc)+1), train_acc, label="train_acc")
            ax5.plot(range(1, len(val_acc)+1), val_acc, label="val_acc")
            ax5.scatter(best_acc_at[-1], best_acc[-1]*100.0, color="green", label="best_acc")
            print(best_acc_at[-1], best_acc[-1])
            ax2.legend()
            ax5.legend()
        elif cnt == 3:
            ax3.plot(range(1, len(train_loss)+1), train_loss, label="train_loss")
            ax3.plot(range(1, len(val_loss)+1), val_loss, label="val_loss")
            ax6.plot(range(1, len(train_acc)+1), train_acc, label="train_acc")
            ax6.plot(range(1, len(val_acc)+1), val_acc, label="val_acc")
            ax6.scatter(best_acc_at[-1], best_acc[-1]*100.0, color="green", label="best_acc")
            print(best_acc_at[-1], best_acc[-1])
            ax3.legend()
            ax6.legend()
        # save the figure
        fig_loss.savefig("original_model_train_loss.png")
        fig_acc.savefig("original_model_train_acc.png")

    # fig.savefig("original_model_train_loss.png")



if __name__ == "__main__":
    # draw_original_model_train()
    draw_test()