clear;close all;clc;
%  直接哈夫曼编码
img=double(rgb2gray(imread('peppers.png')));%原图
[m,n]=size(img);
I1 = img(:);
% I1 = int16(I1) ;%.*255
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
yita = length(hcode) / ( m * n * 8 ) ;    %  yita 压缩比
imshow( ide );
%%%压缩比 yita == sizeof(hcode)/sizeof(img) ==  1381017*1  / (384*512*8) == 87.80%