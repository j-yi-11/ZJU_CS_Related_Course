clc;
clear;
src = '5.png';
src_image = imread(src);
imshow(src_image);
imwrite(src_image, 'temp.png');
dst_image = imread('temp.png');
anss = dst_image - src_image;