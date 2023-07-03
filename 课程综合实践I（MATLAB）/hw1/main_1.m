clear ;close all;clc;
originalimg = imread('img.jpg');%读取RGB格式的图像
[rows , cols , colors] = size(originalimg);%得到原来图像的矩阵的参数  
MidGrayPic = zeros(rows , cols);%用得到的参数创建一个全零的矩阵，这个矩阵用来存储用下面的方法产生的灰度图像  
MidGrayPic = uint8(MidGrayPic);%将创建的全零矩阵转化为uint8格式，因为用上面的语句创建之后图像是double型的  
RGB2GRAY();
count = zeros(1,256);  
I = imread('grayimg.png');
for value = 0 : 255
    [r,~]=find(I==value);
    count(value+1) = length(r);
end
%显示原来的RGB图像  
figure(1);  
imshow(originalimg);  
  
%显示转化之后的灰度图像  
figure(2);  
imshow(MidGrayPic);

%转换为灰度图并且显示统计结果
figure(3);
x = 0 : 1 : 255;
y = count(x+1);
bar(x,y)

% I = imread('grayimg.png');
% thresh = graythresh(I);   %自动确定二值化阈值
% [r,c] = size(I);
% A = zeros(r,c);
% one = 0 ; zero = 0 ;
% for i = 1 : r
%     for j = 1 : c
%         if I(i,j) > thresh * 255 
%             A(i,j) = 1;
%             one = one + 1 ;
%         else
%             A(i,j) = 0;
%             zero = zero + 1 ;
%         end
%     end
% end
% bipicture = 'biimg.jpg';
% imwrite(A,bipicture);

figure(4);
imshow(A)

figure(5)
x = 0 : 1 : 1;
y = [zero,one];
bar(x,y)