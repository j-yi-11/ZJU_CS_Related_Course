function image_YCbCr = regenerateYCBCRimage(image_Y_channel,image_CB_channel,image_Cr_channel)
    [row_Y,column_Y] = size(image_Y_channel);
    [row_Cb,column_Cb] = size(image_CB_channel);
    y = uint8(image_Y_channel);
    cb = zeros(row_Y,column_Y);
    cr = zeros(row_Y,column_Y);
    for i=1:row_Cb
        for j=1:column_Cb
            [cb(2*i,2*j),cb(2*i-1,2*j),cb(2*i,2*j-1),cb(2*i-1,2*j-1)] = deal(image_CB_channel(i,j));
            [cr(2*i,2*j),cr(2*i-1,2*j),cr(2*i,2*j-1),cr(2*i-1,2*j-1)] = deal(image_Cr_channel(i,j));
        end
    end
    cb = uint8(cb);
    cr = uint8(cr);
    image_YCbCr = cat(3,y,cb,cr);
end