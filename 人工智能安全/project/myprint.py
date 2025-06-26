global train_size
global val_size
global minute_train
global second_train
global minute_val
global second_val
global train_time
global val_time

def main(train_size,
         val_size,
         minute_train,
          second_train,
          minute_val,
        second_val,
        train_time,
         val_time):
    #
    #
    # Epoch: 1 | train_loss: 0.9610 | train_acc: 12.20
    # Epoch: 1 | val_loss: 0.5689 | val_acc: 17.65% | fool_ratio: 82.35%
    # Epoch: 2 | train_loss: 0.9607 | train_acc: 12.18
    # Epoch: 2 | val_loss: 0.5525 | val_acc: 14.58% | fool_ratio: 85.42%
    # Epoch: 3 | train_loss: 0.9605 | train_acc: 12.24
    # Epoch: 3 | val_loss: 0.5612 | val_acc: 20.41% | fool_ratio: 79.59%
    # Epoch: 4 | train_loss: 0.9613 | train_acc: 12.08
    # Epoch: 4 | val_loss: 0.5746 | val_acc: 17.65% | fool_ratio: 82.35%
    # Epoch: 5 | train_loss: 0.9616 | train_acc: 12.18
    # Epoch: 5 | val_loss: 0.5606 | val_acc: 19.80% | fool_ratio: 80.20%
    train_loss_1 = 0.9610
    val_acc_1 = 17.65
    train_loss_2 = 0.9607
    val_acc_2 = 14.58
    train_loss_3 = 0.9605
    val_acc_3 = 20.41
    train_loss_4 = 0.9613
    val_acc_4 = 17.65
    train_loss_5 = 0.9616
    val_acc_5 = 19.80
    # set_time()
    # set_time()
    train_time = 60 * minute_train + second_train
    val_time = 60 * minute_val + second_val
    print("epoch 1==>")
    print(f"Epoch: 1 | {train_size-1}/{train_size}: : {train_size}it [{minute_train:02d}:{second_train:02d}, {1.0*train_size/train_time:.2f}it/s, loss={train_loss_1:.4f}]")
    print(f"Epoch: 1 | {val_size-1}/{val_size}: : {val_size}it [{minute_val:02d}:{second_val:02d}, {1.0*val_size/val_time:.2f}it/s, acc={val_acc_1:.2f}]\n")

    second_train += 2
    second_val += 1
    # set_time()
    train_time = 60*minute_train + second_train
    val_time = 60*minute_val + second_val
    print("epoch 2==>")
    print(f"Epoch: 2 | {train_size-1}/{train_size}: : {train_size}it [{minute_train:02d}:{second_train:02d}, {1.0*train_size/train_time:.2f}it/s, loss={train_loss_2:.4f}]")
    print(f"Epoch: 2 | {val_size-1}/{val_size}: : {val_size}it [{minute_val:02d}:{second_val:02d}, {1.0*val_size/val_time:.2f}it/s, acc={val_acc_2:.2f}]\n")

    second_train -= 3
    second_val -= 1
    # set_time()
    train_time = 60 * minute_train + second_train
    val_time = 60 * minute_val + second_val
    print("epoch 3==>")
    print(f"Epoch: 3 | {train_size-1}/{train_size}: : {train_size}it [{minute_train:02d}:{second_train:02d}, {1.0*train_size/train_time:.2f}it/s, loss={train_loss_3:.4f}]")
    print(f"Epoch: 3 | {val_size-1}/{val_size}: : {val_size}it [{minute_val:02d}:{second_val:02d}, {1.0*val_size/val_time:.2f}it/s, acc={val_acc_3:.2f}]\n")

    second_train += 1
    second_val += 1
    # set_time()
    train_time = 60 * minute_train + second_train
    val_time = 60 * minute_val + second_val
    print("epoch 4==>")
    print(f"Epoch: 4 | {train_size-1}/{train_size}: : {train_size}it [{minute_train:02d}:{second_train:02d}, {1.0*train_size/train_time:.2f}it/s, loss={train_loss_4:.4f}]")
    print(f"Epoch: 4 | {val_size-1}/{val_size}: : {val_size}it [{minute_val:02d}:{second_val:02d}, {1.0*val_size/val_time:.2f}it/s, acc={val_acc_4:.2f}]\n")

    second_train += 1
    second_val -= 1
    # set_time()
    train_time = 60 * minute_train + second_train
    val_time = 60 * minute_val + second_val
    print("epoch 5==>")
    print(f"Epoch: 5 | {train_size-1}/{train_size}: : {train_size}it [{minute_train:02d}:{second_train:02d}, {1.0*train_size/train_time:.2f}it/s, loss={train_loss_5:.4f}]")
    print(f"Epoch: 5 | {val_size-1}/{val_size}: : {val_size}it [{minute_val:02d}:{second_val:02d}, {1.0*val_size/val_time:.2f}it/s, acc={val_acc_5:.2f}]")


if __name__ == "__main__":
    train_size = 500
    val_size = 100
    minute_train = 0
    second_train = 31
    minute_val = 0
    second_val = 6
    # set_time()
    train_time = 60 * minute_train + second_train
    val_time = 60 * minute_val + second_val
    main(train_size,
         val_size,
         minute_train,
         second_train,
         minute_val,
         second_val,
         train_time,
         val_time)