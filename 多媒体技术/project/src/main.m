clc;
clear;
HuffmanCompression = 1;
RLCcompression = 2;
JPEG = 3;
EXIT = 4;
while true
    [command, image, imagePath, savedimagePath] = getBasicInfo();

    jpg_ = strfind(imagePath,'.jpg');
    jpeg_ = strfind(imagePath,'.jpeg');

    if ((isempty(jpg_) == 0) || (isempty(jpeg_) == 0))
        imwrite(image,'tmp.jpg');
        image = imread('tmp.jpg');
        imwrite(image,'tmp.jpg');
        image = imread('tmp.jpg');
    end

    if command == HuffmanCompression
        fprintf("HuffmanCompression\n");       
        % Huffman coding based lossless compression
        if size(image, 3) == 3 % colour
            [image_channel_encoded_R, symbol_code_struct_R] = huffman_encode_myself(image(:,:,1));
            [image_channel_encoded_G, symbol_code_struct_G] = huffman_encode_myself(image(:,:,2));
            [image_channel_encoded_B, symbol_code_struct_B] = huffman_encode_myself(image(:,:,3));
            save("huff-encoded.mat", ...
                'image_channel_encoded_R', 'symbol_code_struct_R', ...
                'image_channel_encoded_G', 'symbol_code_struct_G', ...
                'image_channel_encoded_B', 'symbol_code_struct_B');
            fprintf("encode finish\n");
            image_channel_decoded_R = huffman_decode_myself(image_channel_encoded_R, symbol_code_struct_R);
            image_channel_decoded_G = huffman_decode_myself(image_channel_encoded_G, symbol_code_struct_G);
            image_channel_decoded_B = huffman_decode_myself(image_channel_encoded_B, symbol_code_struct_B);
            fprintf("decode finish\n");
            subplot(1,2,1), imshow(uint8(image)), title("source image");
            image_return = uint8(cat(3, image_channel_decoded_R, image_channel_decoded_G, image_channel_decoded_B));
            subplot(1,2,2), imshow(image_return), title("reconstructed image");
            imwrite(image_return, savedimagePath);
            [ratio, sourceimageSize, savedimageSize] = calculateRatio(imagePath, savedimagePath);
            fprintf("ratio = %.2f\n", ratio);
        else
            gray_image = image;
            [image_channel_encoded, symbol_code_struct] = huffman_encode_myself(image);
            save("huff-encoded.mat",...
                'image_channel_encoded', 'symbol_code_struct');
            fprintf("encode finish\n");
                image_channel_decoded = huffman_decode_myself(image_channel_encoded, symbol_code_struct);
            fprintf("decode finish\n");           
            subplot(1,2,1), imshow(uint8(gray_image)), title("source image");
            image_return = uint8(image_channel_decoded);
            subplot(1,2,2), imshow(image_return), title("reconstructed image");
            imwrite(image_return, savedimagePath);
            [ratio, sourceimageSize, savedimageSize] = calculateRatio(imagePath, savedimagePath);
            fprintf("ratio = %.2f\n", ratio);
        end
    elseif command == RLCcompression
        fprintf("RLCcompression\n");
        imageDimension = size(image);
        subplot(1,2,1),imshow(image),title("source image");
        if numel(imageDimension) == 2 
            fprintf("grayscale image\n");
            encoded_image_grayscale = RLC_encode(image);
            fprintf("encode finish\n");
            save("rlc-encoded.mat","encoded_image_grayscale");
            decoded_image_grayscale = RLC_decode(encoded_image_grayscale, size(image));
            fprintf("decode finish\n");
            image_return = uint8(decoded_image_grayscale);
            subplot(1,2,2), imshow(image_return), title("reconstructed image");
            imwrite(image_return, savedimagePath);
            [ratio, sourceimageSize, savedimageSize] = calculateRatio(imagePath, savedimagePath);
            fprintf("ratio = %.2f\n", ratio);
        elseif numel(imageDimension) == 3
            fprintf("colour image\n");
            red_channel = image(:,:,1);
            green_channel = image(:,:,2);
            blue_channel = image(:,:,3);
            encoded_red_channel = RLC_encode(red_channel);
            encoded_green_channel = RLC_encode(green_channel);
            encoded_blue_channel = RLC_encode(blue_channel);
            fprintf("encode finish\n");
            save("rlc-encoded.mat","encoded_red_channel","encoded_blue_channel","encoded_green_channel");
            decoded_red_channel = RLC_decode(encoded_red_channel, size(red_channel));
            decoded_green_channel = RLC_decode(encoded_green_channel, size(green_channel));
            decoded_blue_channel = RLC_decode(encoded_blue_channel, size(blue_channel));
            fprintf("decode finish\n");
            image_return = uint8(cat(3, decoded_red_channel, decoded_green_channel, decoded_blue_channel));
            subplot(1,2,2), imshow(image_return), title("reconstructed image");
            imwrite(image_return, savedimagePath);
            [ratio, sourceimageSize, savedimageSize] = calculateRatio(imagePath, savedimagePath);
            fprintf("ratio = %.2f\n", ratio);
        end
    elseif command == JPEG
        fprintf("JPEG\n");
        [origin_height,origin_width,~] = size(image);
        subplot(1,2,1),imshow(image),title("source image");
        [resized_image, rate] = resizeImage(image);
        image_YCbCr = RGB2YCBCR(resized_image);     
        [image_channel_Y,image_channel_Cb,image_channel_Cr] = sampling(image_YCbCr);
        length = 8;
        [DCT_Y_channel,DCT_Cb_channel,DCT_Cr_channel] = ...
                DCT_transform(image_channel_Y,image_channel_Cb,image_channel_Cr,length);
        [Quantified_Y_channel,Quantified_Cb_channel,Quantified_Cr_channel] = Quantify(DCT_Y_channel,DCT_Cb_channel,DCT_Cr_channel,8);
        zigzagged_Y_channel = zigzag8x8(Quantified_Y_channel);
        zigzagged_Cb_channel = zigzag8x8(Quantified_Cb_channel);
        zigzagged_Cr_channel = zigzag8x8(Quantified_Cr_channel);
        DC_Y_channel = DPCM_encode(zigzagged_Y_channel);
        DC_Cb_channel = DPCM_encode(zigzagged_Cb_channel);
        DC_Cr_channel = DPCM_encode(zigzagged_Cr_channel);
        AC_Y_channel = RLCencode(zigzagged_Y_channel);
        AC_Cb_channel = RLCencode(zigzagged_Cb_channel);
        AC_Cr_channel = RLCencode(zigzagged_Cr_channel);
        [DC_Y_channel_encoded, DC_Y_dictionary_encoded] = huffman_encode_lib(DC_Y_channel);
        [DC_Cb_channel_encoded, DC_Cb_dictionary_encoded] = huffman_encode_lib(DC_Cb_channel);
        [DC_Cr_channel_encoded, DC_Cr_dictionary_encoded] = huffman_encode_lib(DC_Cr_channel);
        [AC_Y_channel_encoded, AC_Y_dictionary_encoded] = huffman_encode_lib(AC_Y_channel);
        [AC_Cb_channel_encoded, AC_Cb_dictionary_encoded] = huffman_encode_lib(AC_Cb_channel);
        [AC_Cr_channel_encoded, AC_Cr_dictionary_encoded] = huffman_encode_lib(AC_Cr_channel);
        origin_width = uint16(origin_width);
        origin_height = uint16(origin_height);
        fprintf("encode finish\n");
        save("jpeg-encoded.mat",...
            "DC_Y_channel_encoded", "DC_Y_dictionary_encoded",...
            "DC_Cb_channel_encoded", "DC_Cb_dictionary_encoded",...
            "DC_Cr_channel_encoded", "DC_Cr_dictionary_encoded",...
            "AC_Y_channel_encoded", "AC_Y_dictionary_encoded",...
            "AC_Cb_channel_encoded", "AC_Cb_dictionary_encoded",...
            "AC_Cr_channel_encoded", "AC_Cr_dictionary_encoded");
        origin_width = double(origin_width);
        origin_height = double(origin_height);
        resize_width = ceil(origin_width/rate) * rate;
        resize_height = ceil(origin_height/rate) * rate;
        DC_Y_channel_decoded = huffman_decode_lib(DC_Y_channel_encoded, DC_Y_dictionary_encoded);
        DC_Cb_channel_decoded = huffman_decode_lib(DC_Cb_channel_encoded, DC_Cb_dictionary_encoded);
        DC_Cr_channel_decoded = huffman_decode_lib(DC_Cr_channel_encoded, DC_Cr_dictionary_encoded);
        AC_Y_channel_decoded = huffman_decode_lib(AC_Y_channel_encoded, AC_Y_dictionary_encoded);
        AC_Cb_channel_decoded = huffman_decode_lib(AC_Cb_channel_encoded, AC_Cb_dictionary_encoded);
        AC_Cr_channel_decoded = huffman_decode_lib(AC_Cr_channel_encoded, AC_Cr_dictionary_encoded);
        iDC_Y = DPCM_decode(DC_Y_channel_decoded);
        iDC_Cb = DPCM_decode(DC_Cb_channel_decoded);
        iDC_Cr = DPCM_decode(DC_Cr_channel_decoded);
        [~,column_number] = size(iDC_Y);
        iAC_Y = RLCdecode(AC_Y_channel_decoded,column_number);
        iAC_Cb = RLCdecode(AC_Cb_channel_decoded,column_number/4);
        iAC_Cr = RLCdecode(AC_Cr_channel_decoded,column_number/4);
        izigzagged_Y = [iDC_Y;iAC_Y];
        izigzagged_Cb = [iDC_Cb;iAC_Cb];
        izigzagged_Cr = [iDC_Cr;iAC_Cr];
        qdctY = izigzag8x8(izigzagged_Y,resize_width);
        qdctCb = izigzag8x8(izigzagged_Cb,resize_width/2);
        qdctCr = izigzag8x8(izigzagged_Cr,resize_width/2);
        [iDCT_Y_channel,iDCT_Cb_channel,iDCT_Cr_channel] = iQuantify(qdctY,qdctCb,qdctCr);
        [image_return_Y_channel,image_return_Cb_channel,image_return_Cr_channel] = iDCT_transform(iDCT_Y_channel,iDCT_Cb_channel,iDCT_Cr_channel,length);
        image_return_YCbCr = regenerateYCBCRimage(image_return_Y_channel,image_return_Cb_channel,image_return_Cr_channel);
        fprintf("decode finish\n");

        image_return_RGB = YCBCR2RGB(image_return_YCbCr);
        image_return = uint8(image_return_RGB(1:origin_height,1:origin_width,:));
        subplot(1,2,2),imshow(image_return),title("reconstructed image");
        imwrite(image_return, savedimagePath);
        [ratio, sourceimageSize, savedimageSize] = calculateRatio(imagePath, savedimagePath);
        fprintf("ratio = %.2f\n", ratio);
    elseif command == EXIT
        break;
    else
        fprintf("command = %d ERROR\n",command);
    end
end
fprintf("program finish\n");
