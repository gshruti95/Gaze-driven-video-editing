function [] = croppath(bestpath)
close all;
list = dir('../waterfront/*.jpg');

for i=1:numel(list)
    
    
    f_name = strcat('../waterfront/', list(i).name);

    im = imread(f_name);
    %figure, imshow(im);

    f_im =imcrop(im,[bestpath(i)-360 0 719 720]);
    %figure, imshow(f_im);
    imwrite(f_im,strcat('../l1_waterfront/out_',sprintf('%03d',i),'.jpg'));
end

%figure, imshow(f_im);

end