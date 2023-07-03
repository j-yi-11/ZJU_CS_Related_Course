clear;
clc;
close all;
inputfilepath = input('输入待监测图片的文件夹路径：');
imagename = input('输入待监测图片的文件名(必须用英文单引号引起来)：');
%     imagename = '仰.qita.黄庭坚_02.gif';
num = input('请输入要检测出的图片数量');
file2 = strcat( inputfilepath , '\' , '2' );
filegray = strcat( inputfilepath , '\' , 'gray' );
filesrc = strcat( inputfilepath , '\' , 'calligraphy' );
total = 3777;  %   文件总数量
type = 6 ;  %   特征向量维数
fileinfo = struct('id','name','character','cosine');
%%遍历图片并且二值化
d1 = dir( filesrc );
l1 = length(d1);
count = 0 ;
for i = 3 : l1   %  3 --> 32   l1
    s1 = strcat(filesrc,'\',d1(i).name) ;
    cd(s1);
    d2 = dir( s1 );
    l2 = length(d2);
    for j = 3 : l2    %  3  -->  8  l2
        s2 = strcat( s1 , '\' , d2(j).name ) ;
        cd(s2);
        d3 = dir( s2 );
        l3 = length(d3);
        for k = 3 : l3    %  l3 
            s3 = strcat( s2 , '\' , d3(k).name ,'.gif');
            count = count + 1 ;
            %二值化  +  尺寸一致化 -- 370*370
            im = imread( d3(k).name );
            thresh = graythresh( im );
            im = im2bw( im , thresh );
            im = imresize(im,[370,370]);
            filepath = pwd ;
            cd( file2 );
            fileinfo(count).id = count ;
            fileinfo(count).name = strcat( d1(i).name,'.',d2(j).name,'.',d3(k).name );
            fileinfo(count).character = ones(type,1);
            fileinfo(count).cosine = 1;
            imwrite( im , strcat( d1(i).name,'.',d2(j).name,'.',d3(k).name ) );
            cd(filepath);
        end
    end
end




%  遍历图片并且灰度化
d1 = dir( filesrc );
l1 = length(d1);
count = 0 ;
for i = 3 : l1   %  3 --> 32   l1
    s1 = strcat(filesrc,'\',d1(i).name) ;
    cd(s1);
    d2 = dir( s1 );
    l2 = length(d2);
    for j = 3 : l2    %  3  -->  8  l2
        s2 = strcat( s1 , '\' , d2(j).name ) ;
        cd(s2);
        d3 = dir( s2 );
        l3 = length(d3);
        for k = 3 : l3    %  l3 
            s3 = strcat( s2 , '\' , d3(k).name ,'.gif');
            count = count + 1 ;
            %灰度化  +  尺寸一致化 -- 370*370
            im = imread( d3(k).name );
            im = im2gray(im);
            im = imresize(im,[370,370]);
            filepath = pwd ;
            cd( filegray );
            fileinfo(count).id = count ;
            fileinfo(count).name = strcat( d1(i).name,'.',d2(j).name,'.',d3(k).name );
            fileinfo(count).character = ones(type,1);
            fileinfo(count).cosine = 1;
            imwrite( im , strcat( d1(i).name,'.',d2(j).name,'.',d3(k).name ) );
            cd(filepath);
        end
    end
end
disp('预处理完毕');    %留下
cd( filegray );
img = imread(imagename);
for i = 1 : total
    fileinfo(i).character(1) = 1;
    ii = imread(fileinfo(i).name);
    fileinfo(i).character(1) = corr2(img,ii);
end
disp('特征值1处理完毕');



%  3个算子+corr2
total = 3777;
cd( filegray );
img = imread(imagename);
p1=edge(img,'roberts');
p2=edge(img,'prewitt');
p3=edge(img,'sobel');
dd = zeros(total,3);   %  后续  5  --  3777
for i = 1 : total
    im = imread(fileinfo(i).name);
    pp1=edge(im,'roberts');
    pp2=edge(im,'prewitt');
    pp3=edge(im,'sobel');
    dd(i,1) = corr2(p1,pp1);
    dd(i,2) = corr2(p2,pp2);
    dd(i,3) = corr2(p3,pp3);
    t = dd(i,:);
    t = t / norm(t); %  向量单位化
    dd(i,:) = t ;
    fileinfo(i).character(2) = ( dd(i,1) + dd(i,2) + dd(i,3) )/3;
    if isnan( fileinfo(i).character(2) )
         fileinfo(i).character(2) = 0 ;
    end
end
disp('特征值2处理完毕');

% 3X3黑点统计图;
cd( filegray );
total = 3777;
cc = zeros(total,9);
for k = 1 : total
    im = imread( fileinfo(k).name );
    for i = 1 : 3
        for j = 1 : 3
            xstart = uint8(1+370/3*(i-1));
            ystart = uint8(1+370/3*(j-1));
            cc(k,3*(i-1)+j) = length( find ( im ( xstart : xstart+uint8(370/3) , ...
                ystart : xstart+uint8(370/3) )  ~= 0) ) ;
        end
    end
    temp = cc(k,:);
    temp = temp/norm(temp);   %  3x3黑点统计图向量单位化
    cc(k,:) = temp;
    fileinfo(k).character(3) =  temp(5) * 0.8 + ( sum(temp) - temp(5) ) / 10 ;  %权重可改
    if isnan( fileinfo(k).character(3) )
         fileinfo(k).character(3) = 0 ;
    end
end
disp('特征值3处理完毕');
        
% 笔画数量
cd( file2 );
bh = zeros(total,4);
for ii = 1 : total
    bw = imread(fileinfo(ii).name);
    for i = 2 : 369
        for j = 2 : 369
            if bw(i,j) == 1
                if  bw(i,j+1) == 1     %横         %起点   2转折   3转折sum < 4 && sum ~= 0
                    bh(ii,1) = bh(ii,1) + 1;
                end
                if bw(i+1,j) == 1      %竖         %  4转折
                    bh(ii,2) = bh(ii,2) + 1;
                end
                if  bw(i-1,j+1) == 1     %撇         %起点   2转折   3转折sum < 4 && sum ~= 0
                    bh(ii,3) = bh(ii,3) + 1;
                end
                if bw(i+1,j+1) == 1      %捺         %  4转折
                    bh(ii,4) = bh(ii,4) + 1;
                end
            end
        end
    end
    t = bh(ii,:);
    t = t / norm(t); %  向量单位化
    bh(ii,:) = t ;
    fileinfo(ii).character(5) = 100*( 10*( t(1) * 0.3 + t(2) * 0.3 + t(3) * 0.2 + t(4) * 0.2 ) - 5 );
    if isnan( fileinfo(i).character(5) )
         fileinfo(i).character(5) = 0 ;
    end
end
disp('特征值4处理完毕');   

%  转折点，起点数量
cd( file2 );
pt = zeros(3777,4);   
for ii = 1 : 3777
    bw = imread(fileinfo(ii).name);
    for i = 2 : 369
        for j = 2 : 369
            sigma = bw(i-1,j) + bw(i,j-1) + bw(i-1,j+1)...
                + bw(i,j+1) + bw(i+1,j) + bw(i-1,j-1)...
                + bw(i+1,j+1)  + bw(i+1,j-1);
            if bw(i,j) == 1     %  %起点   2转折   3转折  4转折
                if  sigma == 0     
                    pt(ii,:) = zeros(1,4);
                end
                if sigma > 0 && sigma < 4     
                    pt(ii,sigma) = pt(ii,sigma) + 1;
                end
                if  sigma >= 4     %         
                    pt(ii,4) = pt(ii,4) + 1;
                end
            end
        end
    end
    t = pt(ii,:);
    t = t / norm(t); %  向量单位化
    pt(ii,:) = t ;
    fileinfo(ii).character(4) = t(1)*0.4 + t(2)*0.2  + t(3)*0.2  + t(4)*0.2 ; %权重可改  sum(t) / 4 
    if isnan( fileinfo(ii).character(4) )
        fileinfo(ii).character(4) = 0 ;
    end
end
disp('特征值5处理完毕');

%二值图边缘检测+边界父子关系的corr2
cd( file2 );
for ii = 1 : total
    img = imread(fileinfo(ii).name);
    [~,~,n,~] = bwboundaries( img );
%     B = reshape(B,[ ]);
    fileinfo(ii).character(6) = n/30;
    if isnan( fileinfo(ii).character(6) )
        fileinfo(ii).character(6) = 0 ;
    end    
end
disp('特征值6处理完毕');
cd( filegray );
ind = 1 ;
total = 3777;
for ii = 1 : total
    if strcmp( fileinfo(ii).name , imagename ) == 1
        ind = ii;
    end
end
for ii = 1 : total
    aa = fileinfo(ii).character;
    bb = fileinfo(ind).character;
    fileinfo(ii).cosine = dot(aa,bb)/norm(aa)/norm(bb);
end

%   sort  降序
ff = fileinfo;
for ii = 1 : total
    maxindex = ii;
    for jj = ii+1 :total
        if ff(maxindex).cosine < ff(jj).cosine
            maxindex = jj ;
        end
    end
    tt = ff(ii);
    ff(ii) = ff(maxindex);
    ff(maxindex) = tt;
end
cd( file2 );

line = uint8(sqrt(num))+1;
for j = 1 : num
    subplot( 4 , 5 , j );
    ig = imread( ff( j ) .name );
    imshow( ig .* 255 );
    fprintf(' id = %d , name = %s \n',ff( j ).id , ff( j ).name );
end