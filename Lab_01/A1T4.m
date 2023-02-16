clc
load image
img = demapper(signal);

newimage = compressed_decoder(img,image_size);
imshow(newimage/255);