clc;clear;close all;
im = imread('gray.jpg');
temp = im;
[r,c]=size(im);
yasuo = zeros(r,c);
im = double(im);
yasuo = im;
for i = 1 : r
    for j = 1+1 : c
        yasuo(i,j) = im(i,j) - im(i,j-1);
    end
end
xlswrite('yasuo.xlsx',yasuo);
%压缩以及保存实现完毕

jieya = xlsread('yasuo.xlsx');
[r,c]=size(jieya);
result = jieya;
for i = 1 : r
    for j = 1+1 : c
        result(i,j) = jieya(i,j) + result(i,j-1);
    end
end
result = uint8(result);
imwrite(uint8(result),'returned.jpg');
figure;imshow(result);