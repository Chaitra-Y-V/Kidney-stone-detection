clc
clear all
close all
warning off

[filename, pathname] = uigetfile('*.*', 'Pick a MATLAB code file');
filename=strcat(pathname,filename);
input_image=imread(filename);
imshow(input_image);

%converting from rgbtogray%
gray_input_image=rgb2gray(input_image);
imshow(gray_input_image);
title('input image');

%getting pixel information%
impixelinfo;

%binarizing the image%
%binarized_image=imbinarize(gray_input_image,20/255);
binarized_image=gray_input_image>20;
figure;
imshow(binarized_image);
title('after binarizing');

%filling holes%
holes_filled_image=imfill(binarized_image,'holes');
figure;
imshow(holes_filled_image);
title('filling holes');

%performing bwareaopen%
BW_image=bwareaopen(holes_filled_image,1000);
figure;
imshow(BW_image);
title('required ROI of image');

%multiplying created mask on input image%
PreprocessedImage=uint8(double(input_image).*repmat(BW_image,[1,1,3]));
% figure;
% imshow(PreprocessedImage);
PreprocessedImage=imadjust(PreprocessedImage,[0.3 0.7],[])+50;
figure;
imshow(PreprocessedImage);
title('preprocessed image after contrast stretching');

%converting to gray%
gray_pp_image=rgb2gray(PreprocessedImage)
% figure;
% imshow(gray_pp_image);
% title('preprocessed image');

%applying median filter%
image_after_medfilter=medfilt2(gray_pp_image,[5,5]);
figure;
imshow(image_after_medfilter);
title('application of median filter');

%binarizing filtered image%
binarized_filtimage=image_after_medfilter>250;
figure;
imshow(binarized_filtimage);
title('binarized image');

%calculating no of rows and columns%
[r c m]=size(binarized_filtimage);
x1=r/2;
y1=c/3;
%defining the mask%
row=[x1 x1+200 x1+200 x1];
col=[y1 y1 y1+40 y1+40];
%using roipoly%
polygon=roipoly(binarized_filtimage,row,col);
figure;
imshow(polygon);
title('polygon');

%multiplying the mask%
after_mul_mask=binarized_filtimage.*double(polygon);
% figure;
% imshow(after_mul_mask);
% title('image after mask');

image_after_mask=bwareaopen(after_mul_mask,4);
figure;
imshow(image_after_mask);
title('image after mask');
 
[matrix, number]=bwlabel(image_after_mask);
if(number>=1)
    disp('stone is detected');
    imshow(input_image);
    title('input image');
    imshow(image_after_mask);
    title('stone is detected');
else
    disp('stone is not detected');
    subplot(2,2,1);
    imshow(input_image);
    title('input image');
    subplot(2,2,2);
    imshow(image_after_mask);
    title('stone is not detected');
end
