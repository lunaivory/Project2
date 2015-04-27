% input:
%   - img: image to be processed
%   - sigma: standard deviation of smoothing Gaussian. use ~ 1-3
%   - thresh: the threshold. use value ~ 1000
%   - radius: radius of the region considered in the non-maximal
%   suppression. use ~ 1-3.

function points = harris_corner( img, sigma, radius, thresh )
%HARRISON Harrison corner detection
% initialize variables
    if (~exist('sigma', 'var'))
        sigma = 2;
    end
    if (~exist('radius', 'var'))
        radius = 2;
    end
    if (~exist('thresh', 'var'))
        thresh = 1000;
    end
    
    % x and y derivative masks (Prewitt operator)
    dx = [-1 0 1; -1 0 1; -1 0 1];
    dy = dx';
    
%     Sobel (more weight)
%     dx = [-1 0 1; -2 0 2; -1 0 1];
%     dy = dx';
    
    % Gaussian Filter of size (+/- 3 sigma) and min size 1x1.
    g = fspecial('gaussian', max(1, fix(6*sigma)), sigma);
    
    if(ndims(img) == 3)
        grayscale = rgb2gray(img);
    else
        grayscale = img;
    end

    % 1. compute derivatives of image
    Ix = conv2(double(grayscale), double(dx), 'same');
    Iy = conv2(double(grayscale), double(dy), 'same');

    % 2. smooth image derivatives
    Ix2 = conv2(double(Ix.^2), g, 'same');
    Iy2 = conv2(double(Iy.^2), g, 'same');
    Ixy = conv2(double(Ix.*Iy), g, 'same');
    
    % 3. harris corner measure
    harris = (Ix2.*Iy2 - Ixy.^2) ./ (Ix2 + Iy2);
%     k = 0.04;
%     harris = (Ix2.*Iy2 - Ixy.^2) - k*(Ix2 + Iy2).^2;

    % don't want corners close to image border
    harris([1:15, end-16:end], :) = 0;
    harris(:,[1:15,end-16:end]) = 0;

    % 4. grayscale morphological dilate
    size = 2*radius + 1;
    mx = ordfilt2(harris, size^2, ones(size));

    % 5. find maxima
    harris = (harris == mx) & (harris > thresh);
    
    % 6. find row and column coordinates
    [rows, cols] = find(harris);
    
    points = [cols'; rows']';
   
end

