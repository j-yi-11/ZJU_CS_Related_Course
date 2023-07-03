function [processedimg] = imgscale(originalimg,scale)
%   originalimg  原来图像    processedimg  处理过图像
%   scale  缩放系数
[r,c] = size(originalimg);
nr= round(r*scale);             %根据放大倍数乘原行数的结果，取其四舍五入的值作为新的行
nc= round(c*scale);             %根据放大倍数乘原列数的结果，取其四舍五入的值作为新的列
processedimg = zeros(nr,nc);           %用新的行列生成目标图像矩阵
SB = zeros(r+1,c+1);        %新建一个矩阵SB，大小在B的基础上行列都加1
%%%%%处理SB边界%%%%%
SB(2:r+1,2:c+1)=originalimg;
SB(2:r+1,1)=originalimg(:,1);
SB(1,2:c+1)=originalimg(1,:);
SB(1,1)=originalimg(1,1);
%%%%%处理SB边界%%%%%
for Ai=1:nr
    for Aj=1:nc
        Bi=(Ai-1)/scale;       %求出Ai对应的Bi坐标，Ai是由Bi先缩放S倍，再在竖直方向正向平移1得到
        Bj=(Aj-1)/scale;       %求出Aj对应的Bj坐标，Aj是由Bj先缩放S倍，再在水平方向正向平移1得到
        i=fix(Bi);         %向零方向取整，求出坐标Bi的整数部分
        j=fix(Bj);         %向零方向取整，求出坐标Bj的整数部分
        u=Bi-i;            %求出坐标Bi的小数部分
        v=Bj-j;            %求出坐标Bj的小数部分
        i=i+1;             %这是在矩阵SB上计算的，不是在矩阵B上计算的，竖直方向上有平移量，加1对应B上的i值
        j=j+1;             %这是在矩阵SB上计算的，不是在矩阵B上计算的，水平方向上有平移量，加1对应B上的j值
        processedimg(Ai,Aj)=(1-u)*(1-v)*SB(i,j)+u*v*SB(i+1,j+1)+u*(1-v)*SB(i+1,j)+(1-u)*v*SB(i,j+1);%双线性插值法计算A(Ai,Aj)
    end
end
end


