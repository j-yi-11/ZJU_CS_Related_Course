clear;close all;clc; 
img=double(rgb2gray(imread('peppers.png')));    
[originalrow, originalcolumn]=size(img);
output = zeros(originalrow,originalcolumn);
row = power( 2 ,uint64 ( log2 ( originalrow ) + 1 ) ) ;
column = power( 2 , uint64 ( log2 (originalcolumn) + 1 ) ) ;
max = row;
if max < column
    max = column;
end
    img = [ img , double( zeros( originalrow , max - originalcolumn ) ) ] ;   
    img = [ img ; double( zeros( max - originalrow , max ) ) ] ;   
img = img./255;
len = double(max);
A = double(zeros(len,len));
B = double(zeros(len,len));
for i = 1 : len
    A(1,i) = 1.0 / len ;
    B(1,i) = 1.0;
end
for i = 0 : (log2(len)-1)
    count = (power(2,i));%  确定一个数值要几行
    alength = (len / count); %   确定一行有几个非零数值
     for j = 1 : count  
        for index = 1 : alength
            if index <= alength/2
                A( 2^i+j, index + alength*(j-1) ) = 1.0 / alength ;
                B( 2^i+j, index + alength*(j-1) ) = 1.0 ;
            end
            if index > alength/2
                A( 2^i+j, index + alength*(j-1) ) = -1.0 / alength ;
                B( 2^i+j, index + alength*(j-1) ) = -1.0 ;
            end
        end
     end
end
B = B';
img = A * img ;
%  后期调整，保留！
% threshold = 40.0/255.0 ;
% img( abs(img) < threshold ) = 0 ;
I1 = img(:);
I1 = int16(I1.*255) ;%
kk = unique(I1);
P = double(zeros(1,length(kk)));
for i = 1 : length(kk)   
     P( i ) = length( find(I1 == kk(i,1) ) )/double(max)/double(max);%每一个灰度出现比率
end
%%% 哈夫曼编码    https://blog.csdn.net/ahafg/article/details/48750295?spm=1001.2101.3001.6650.6&utm_medium=distribute.pc_relevant.none-task-blog-2%7Edefault%7EBlogCommendFromBaidu%7Edefault-6-48750295-blog-124281148.pc_relevant_multi_platform_whitelistv1&depth_1-utm_source=distribute.pc_relevant.none-task-blog-2%7Edefault%7EBlogCommendFromBaidu%7Edefault-6-48750295-blog-124281148.pc_relevant_multi_platform_whitelistv1&utm_relevant_index=12
dict = huffmandict(kk,P); %哈夫曼取字典函数
hcode = huffmanenco(I1,dict);        %哈夫曼编码
dhsig = huffmandeco(hcode,dict);        %哈夫曼译码        
ide = col2im(dhsig,[double(max),double(max)],[double(max),double(max)],'distinct'); %把向量重新转换成图像块；
ide = (double(ide)./255);  %  解哈夫曼码得到的Haar小波图像
ide = B*ide;
yita = length(hcode) / ( double(max) * double(max) * 8 );
 %%%测试--------------------------------------------------------------------------   
    for i = 1 : originalrow
        for j = 1 : originalcolumn
            output(i,j) = ide(i,j);
        end
    end
    imshow(output);
    
%%%压缩率 == sizeof(hcode)/sizeof(img) == 1420967 / (1024*1024*8) == 16.74%  threshold = 2/255
%%% threshold == 5/255      压缩比== 1248736 / (1024*1024*8) ==  14.89%
    
    


