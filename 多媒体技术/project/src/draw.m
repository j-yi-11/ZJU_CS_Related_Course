image_name = '4.jpeg';
I = imread(image_name);
[~,~,channel] = size(I);
if channel == 3
    subplot(1,3,1),imhist(I(:,:,1)),title("red");
    subplot(1,3,2),imhist(I(:,:,2)),title("green");
    subplot(1,3,3),imhist(I(:,:,3)),title("blue");
else
    figure(),imhist(I),title(image_name);
end