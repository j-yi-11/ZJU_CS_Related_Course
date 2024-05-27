import matplotlib.pyplot as plt

# VGG19 结果
vgg19_epochs = list(range(20))
vgg19_acc = [1.765700, 21.654100, 50.860000, 58.650000, 59.860000, 62.380000, 63.030000, 65.860000, 67.120000, 70.260000, 73.100000, 74.020000, 74.940000, 75.740000, 76.530000, 76.810000, 77.490000, 78.780000, 79.650000, 80.423400]
vgg19_loss = [8.852506, 6.744485, 2.306429, 1.416307, 1.352630, 1.273888, 1.208638, 1.148059, 1.100747, 1.078379, 1.070688, 1.043252, 1.000245, 0.978362, 0.969312, 0.942767, 0.920656, 0.908758, 0.896536, 0.876426]

# RESNET18 结果
resnet18_epochs = list(range(20))
resnet18_acc = [3.03, 25.98, 45.78, 52.24, 53.86, 56.38, 59.03, 59.86, 61.12, 62.26, 63.1, 64.02, 64.94, 65.74, 66.53, 66.81, 67.49, 67.78, 69.00, 69.34]
resnet18_loss = [6.036298, 4.147485, 2.608310, 1.779415, 1.470352, 1.299458, 1.206439, 1.163896, 1.124431, 1.088991, 1.070688, 1.041138, 1.008474, 0.995757, 0.969312, 0.954244, 0.935662, 0.927172, 0.899673, 0.889161]

# 绘制 VGG19 和 ResNet18 的准确性结果
plt.figure(figsize=(15, 6))
plt.subplot(1, 2, 1)
plt.plot(vgg19_epochs, vgg19_acc, marker='o', linestyle='-', color='b', label='VGG19')
plt.plot(resnet18_epochs, resnet18_acc, marker='o', linestyle='-', color='r', label='ResNet18')
plt.title('VGG19 vs ResNet18 accuracy')
plt.xlabel('Epochs')
plt.ylabel('accuracy')
plt.legend()

# 绘制 VGG19 和 ResNet18 的损失结果
plt.subplot(1, 2, 2)
plt.plot(vgg19_epochs, vgg19_loss, marker='o', linestyle='-', color='b', label='VGG19')
plt.plot(resnet18_epochs, resnet18_loss, marker='o', linestyle='-', color='r', label='ResNet18')
plt.title('VGG19 vs ResNet18 loss')
plt.xlabel('Epochs')
plt.ylabel('loss')
plt.legend()

plt.tight_layout()
plt.show()
plt.savefig('vgg19-resnet18.png')