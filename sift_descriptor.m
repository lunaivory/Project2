function sift_descriptors = sift_descriptor( img, keypoints)
%% Given an image and feature points, return the keypoints SIFT descriptors
%% Borrowed and modified from a combination of
%% (c) Lana Lazebnik
%% and
%% (c) Thomas F. El-Maraghi

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

    % SIFT parameters
    enlarge_factor = 1.5;
    num_bins = 4;
    num_angles = 8;
    num_samples = num_bins * num_bins;
    alpha = 9;  % smoothing of orientation histogram

    angle_step = 2 * pi / num_angles;
    angles = 0:angle_step:2*pi;
    angles(num_angles + 1) = []; % bin centers

    [height, width] = size(grayscale);
    num_points = size(keypoints, 1);

    sift_descriptors = zeros(num_points, num_samples * num_angles);

    % default grid of samples
    step = 2/num_bins:2/num_bins:2;
    step = step - (1 / num_bins + 1);
    [x_grid, y_grid] = meshgrid(step, step);
    x_grid = reshape(x_grid, [1 num_samples]);
    y_grid = reshape(y_grid, [1 num_samples]);

    % orientation images
    I_orient = zeros(height, width, num_angles);

    for i=1:num_angles
        angl = cos(I_theta - angles(i)).^alpha;
        angl = angl .* (angl > 0);

        % magnitude weight
        I_orient(:,:,i) = angl .* I_mag;
    end

    % iterate over all keypoints
    for i=1:num_points
        x = keypoints(i,1);
        y = keypoints(i,2);
        radius = 6 * enlarge_factor;

        % find bin centers
        x_t_grid = x_grid * radius + x;
        y_t_grid = y_grid * radius + y;
        grid_res = y_t_grid(2) - y_t_grid(1);

        % find window
        x_low = floor(max(x - radius - (grid_res / 2), 1));
        x_high = ceil(min(x - radius - (grid_res / 2), width));

        y_low = floor(max(y - radius - (grid_res / 2), 1));
        y_high = ceil(min(y - radius - (grid_res / 2), height));

        [px_grid, py_grid] = meshgrid(x_low:x_high, y_low:y_high);
        num_pixels = numel(px_grid);
        px_grid = reshape(px_grid, [num_pixels 1]);
        py_grid = reshape(py_grid, [num_pixels 1]);

        px_dist = abs(repmat(px_grid, [1 num_samples]) - repmat(x_t_grid, [num_pixels 1]));
        py_dist = abs(repmat(py_grid, [1 num_samples]) - repmat(y_t_grid, [num_pixels 1]));

        % find weight of each pixel
        x_weights = px_dist / grid_res;
        x_weights = (1- x_weights) .* (x_weights <= 1);
        y_weights = py_dist / grid_res;
        y_weights = (1- y_weights) .* (y_weights <= 1);
        weights = x_weights .* y_weights;

        % make the sift descriptor
        sift = zeros(num_angles, num_samples);
        for j=1:num_angles
            tmp = reshape(I_orient(y_low:y_high, x_low:x_high, j), [num_pixels 1]);
            tmp = repmat(tmp, [1 num_samples]);
            sift(j,:) = sum(tmp .* weights);
        end
        sift_descriptors(i,:) = reshape(sift, [1 num_samples * num_angles]);

%         figure(2);
%         subplot(1,2,1);
%         imagesc(grayscale(y_low:y_high,x_low:x_high) .* reshape(sum(weights,2), [y_high-y_low+1,x_high-x_low+1]));
%         subplot(1,2,2);
%         imagesc(sift);
%         pause(1);

    end

    %%
    %% normalize the SIFT descriptors more or less as described in Lowe (2004)
    %%
    tmp = sqrt(sum(sift_descriptors.^2, 2));
    norm_ind = find(tmp > 1);

    sift_normalized = sift_descriptors(norm_ind,:);
    sift_normalized = sift_normalized ./ repmat(tmp(norm_ind,:), [1 size(sift_descriptors,2)]);

    % suppress large gradients
    sift_normalized(find(sift_normalized > 0.2)) = 0.2;

    % finally, renormalize to unit length
    tmp = sqrt(sum(sift_normalized.^2, 2));
    sift_normalized = sift_normalized ./ repmat(tmp, [1 size(sift_descriptors,2)]);

    sift_descriptors(norm_ind,:) = sift_normalized;
end

