function [] = RGB2BIN(~)
%RGB2BIN 此处显示有关此函数的摘要
%   此处显示详细说明
I = imread('grayimg.png');
thresh = graythresh(I);   %自动确定二值化阈值
[r,c] = size(I);
A = zeros(r,c);
one = 0 ; zero = 0 ;
for i = 1 : r
    for j = 1 : c
        if I(i,j) > thresh * 255 
            A(i,j) = 1;
            one = one + 1 ;
        else
            A(i,j) = 0;
            zero = zero + 1 ;
        end
    end
end
bipicture = 'biimg.jpg';
imwrite(A,bipicture);
end

