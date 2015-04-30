function descriptors = msop_descriptor( img, points )

    % Convert to grayscale if needed
    if(ndims(img) == 3)
        grayscale = im2double(rgb2gray(img));
    else
        grayscale = im2double(img);
    end
    
    patch_size = 20;
    descriptor_size = (4*patch_size*patch_size) / 25;
    descriptors = double(zeros(size(points,1), descriptor_size));
    for i=1:size(points, 1)
        x = points(i, 1);
        y = points(i, 2);
        
        % extract the patch around keypoint
        image_patch = grayscale((y-patch_size+1):(y+patch_size), ...
            (x-patch_size+1):(x+patch_size));
        
        % down size the patch
        down = imresize(image_patch, 0.2);
        
        % normalize intensity values
        oldMin = double(min(min(down(:,:))));
        oldMax = double(max(max(down(:,:))));
        down = double(down - oldMin) ./ (oldMax - oldMin);
        
        % reshape matrix into vector
        down = reshape(down, [1, descriptor_size]);
        
        % save the result
        descriptors(i, :) = down;
    end
end

