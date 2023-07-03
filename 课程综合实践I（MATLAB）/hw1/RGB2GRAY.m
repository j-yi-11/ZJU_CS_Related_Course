function [] = RGB2GRAY(~)
%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明
originalimg = imread('img.jpg');%读取RGB格式的图像  
[rows , cols , colors] = size(originalimg);%得到原来图像的矩阵的参数  
MidGrayPic = zeros(rows , cols);%用得到的参数创建一个全零的矩阵，这个矩阵用来存储用下面的方法产生的灰度图像  
MidGrayPic = uint8(MidGrayPic);%将创建的全零矩阵转化为uint8格式，因为用上面的语句创建之后图像是double型的  
for i = 1:rows  
    for j = 1:cols 
        sum = 0 ; 
        for k = 1 : colors
            sum = sum + originalimg(i,j,k) / 3;
        end
        MidGrayPic(i,j) = sum;
    end  
end  
imwrite(MidGrayPic , 'grayimg.png' ); 
end

