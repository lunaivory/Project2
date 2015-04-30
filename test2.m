clear all; clc;

I1 = rgb2gray(imread('photo/2.jpg'));
I2 = rgb2gray(imread('photo/3.jpg'));

points1 = harris_corner(I1, 2, 2, 1000);
points2 = harris_corner(I2, 2, 2, 1000);

% x = size(I1, 1)/2;
% y = size(I1, 2)/2;
% 
% patchsize = 20;

% imagesc(I1), colormap(gray), hold on;
% patch = I1((y-patchsize)+1:(y+patchsize), (x-patchsize)+1:(x+patchsize));
% figure(1);
% imagesc(patch), colormap(gray), hold on;
% figure(2);
% down = imresize(patch, 0.2);
% imagesc(down), colormap(gray), hold on;
% 
% oldMin = double(min(min(down(:,:))));
% oldMax = double(max(max(down(:,:))));
% 
% down = double(down - oldMin) ./ (oldMax - oldMin);
% figure(3);
% imagesc(down), colormap(gray), hold on;
% 
% std2(down)
% 
% res = reshape(down, [1,size(down,1)*size(down,2)]);
% plot(x,y, 'rs');

% [g1histdir, g1histmag] = gloh(I1, points1);
% [g2histdir, g2histmag] = gloh(I2, points2);

% hist(g1histdir, 8);

desc1 = msop_descriptor(I1, points1);
desc2 = msop_descriptor(I2, points2);

matches = feature_match(desc1, desc2);

img = [I1 I2];
figure(1);
imagesc(img);
colormap('gray');
hold on;
cols1 = size(I1,2);
for j=1:size(matches,1)
    x1 = points1(j,1);
    y1 = points1(j,2);
    if(matches(j) > 0)
        x2 = points2(matches(j),1) + cols1;
        y2 = points2(matches(j),2);
        plot(x1,y1, 'go');
        plot(x2,y2, 'c+');
        line([x1 x2], [y1 y2], 'Color', 'r');
    elseif(j < size(points2, 1))
        x2 = points2(j,1) + cols1;
        y2 = points2(j,2);
        plot(x1,y1, 'ys');
        plot(x2,y2, 'ms');
    else
        plot(x1,y1, 'ys');
    end
end