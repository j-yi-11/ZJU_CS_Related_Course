function [resized_image, rate] = resizeImage(original_image)
    [m,n,~] = size(original_image);
    rate = 16;
    new_m = ceil(m/rate) * rate;
    new_n = ceil(n/rate) * rate;
    for i=m+1:new_m
        original_image(i,:,:)=original_image(m,:,:);
    end
    for i=n+1:new_n
        original_image(:,i,:)=original_image(:,n,:);
    end
    resized_image = original_image;
end
