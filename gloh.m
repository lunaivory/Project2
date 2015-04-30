function [histdir, histmag] = gloh( img, points )

    % x and y derivative masks (Prewitt operator)
    dx = double([-1 0 1; -1 0 1; -1 0 1]);
    dy = dx';

    if(ndims(img) == 3)
        grayscale = im2double(rgb2gray(img));
    else
        grayscale = im2double(img);
    end

    Ix = conv2(grayscale, dx, 'same');
    Iy = conv2(grayscale, dy, 'same');

    % Find magnitude and orientation of gradient images
    I_mag = sqrt(Ix.^2 + Iy.^2);
    I_theta = atan2(Iy, Ix);
    I_theta(isnan(I_theta)) = 0; % remove NaN's
    I_theta(find(I_theta == pi)) = -pi; % range [-pi, pi)

    histdir = hist(I_theta,8);
    histmag = hist(I_mag,8);
    
end

