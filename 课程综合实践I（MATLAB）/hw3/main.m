clc;clear;close all;
im = imread('img.jpg');
s = input('请输入缩放系数:');

%如果im是彩色图,需要
if numel(size(im)) == 3
I(:,:,1) = imgscale(im(:,:,1),s);
I(:,:,2) = imgscale(im(:,:,2),s);
I(:,:,3) = imgscale(im(:,:,3),s);
%如果im是灰度图,只要
else
I = imgscale(im,s);
end
figure(1);
imshow(im);
figure(2);
imshow(uint8(I));

