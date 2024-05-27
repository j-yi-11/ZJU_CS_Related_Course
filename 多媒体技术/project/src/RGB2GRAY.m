function image_gray = RGB2GRAY(image_rgb)
    image_gray = uint8(0.2989 * image_rgb(:,:,1) + 0.5870 * image_rgb(:,:,2) + 0.1140 * image_rgb(:,:,3))
end