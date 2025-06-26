import torch,torchvision
from torchvision import transforms
class Mymodel(torch.nn.Module):
    def __init__(self,model_name):
        super().__init__()
        if model_name=="ResNet_18":
            self.model=torchvision.models.resnet18(pretrained=True)
        elif model_name=="VGG_16":
            self.model=torchvision.models.vgg16(pretrained=True)
        elif model_name=="Alexnet":
            self.model=torchvision.models.alexnet(pretrained=True)
        elif model_name=="Squeezenet1_0":
            self.model=torchvision.models.squeezenet1_0(pretrained=True)
        elif model_name=="GoogleNet":
            self.model=torchvision.models.googlenet(pretrained=True)
        elif model_name=="DenseNet_121":
            self.model=torchvision.models.densenet121(pretrained=True)
        else:
            print("model_name not supported, use resnet18 instead")
            self.model=torchvision.models.resnet18(pretrained=True)
        # self.model=torchvision.models.resnet18(pretrained=True) # weights = torchvision.models.Inception_V3_Weights.IMAGENET1K_V1
        self.transforms=transforms.Compose([
            transforms.Normalize((123.675/255, 116.28/255, 103.53/255), (58.395/255, 57.12/255, 57.375/255)),
        ])
        self.model_name=model_name

    def forward(self, x):
        x=self.transforms(x)
        x=self.model(x)
        return x
    
    def predict_label(self,x):
        x=self.forward(x)
        x=torch.argmax(x,dim=1)
        return x