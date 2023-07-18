clear;close all;clc;
%  差分编码后哈夫曼编码
img=double(rgb2gray(imread('peppers.png')));%原图
[m,n]=size(img);
%  差分编码
im = img;
[r,c]=size(im);
yasuo = zeros(r,c);
im = double(im);
yasuo = im;
for i = 1 : r
    for j = 1+1 : c
        yasuo(i,j) = im(i,j) - im(i,j-1);
    end
end
%差分矩阵压缩以及保存实现完毕
max = yasuo(1,1); min = yasuo(1,1);
for i = 1 : r
    for j = 1 : c
        if yasuo(i,j) > max
            max = yasuo(i,j);
        end
        if yasuo(i,j) < min
            min = yasuo(i,j);
        end        
    end
end
for i = 1 : r
    for j = 1 : c
         yasuo(i,j) = int16(255*(yasuo(i,j) - min)/(max-min));     
    end
end
%   映射到0,1
I1 = yasuo(:);
I1 = int16(I1) ;%.*255
kk = unique(I1);
P = double(zeros(1,length(kk)));%
for i = 1 : length(kk)     % 255
     P( i ) = length( find(I1 == kk(i,1) ) )/double(m)/double(n);%每一个灰度出现比率
end     
dict = huffmandict(kk,P); %哈夫曼取字典函数
hcode = huffmanenco(I1,dict);        %哈夫曼编码
dhsig = huffmandeco(hcode,dict);        %哈夫曼译码        
ide = col2im(dhsig,[double(m),double(n)],[double(m),double(n)],'distinct'); %把向量重新转换成图像块；
ide = double(ide)./255;  
%完成哈夫曼编码
for i = 1 : r
    for j = 1 : c
         yasuo(i,j) = int16( ( min + ide(i,j) * (max-min) ) ); 
    end
end
%根据差分矩阵复原原图并且显示
jieya = yasuo ;
[r,c]=size(jieya);
result = jieya;
for i = 1 : r
    for j = 1+1 : c
        result(i,j) = jieya(i,j) + result(i,j-1);
    end
end
yita = length(hcode) / ( m * n * 8 ) ;
figure;imshow(result./255);
%%%  压缩比 == sizeof(hcode)/sizeof(img) == 742706 / (384*512*8) == 47.22%