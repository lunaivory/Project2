clear; clc;

sigma = 2;
radius = 2;
threshold = 1000;

[imgs, grayscales] = load_imgs();

img1 = grayscales{1};
img2 = grayscales{2};

points = cell(1,size(imgs,2));

disp('Detecting Harris corners')
% Detect harris corners
for i=1:size(imgs,2)
    points{i} = harris_corner(grayscales{i}, sigma, radius, threshold);
end
% [harris, r, c] = harris_corner(img1, sigma, radius, threshold);
% [harris2, r2, c2] = harris_corner(img2, sigma, radius, threshold);
%
% p1 = [c'; r']';
% p2 = [c2'; r2']';

% get sift descriptors

disp('Calculating SIFT descriptors')
descriptors = cell(1,size(imgs, 2));
for i=1:size(imgs,2)
    descriptors{i} = sift_descriptor(grayscales{i}, points{i});
end

disp('Matching features')
matches = cell(1,size(imgs, 2)-1);
for i=1:size(imgs,2)-1
    matches{i} = feature_match(descriptors{i}, descriptors{i+1});
end
% [desc1, theta1, mag1] = sift_descriptor(img1, p1);
% [desc2, theta2, mag2] = sift_descriptor(img2, p2);

% imagesc(img2), axis off, colormap(gray), hold on;
% plot(c2, r2, 'ys');

%
% Create a new image showing the two images side by side.
% img = [grayscales{1} grayscales{2}];

% match features
% match = feature_match(desc1, desc2);
% Show a figure with lines joining the accepted matches.

for i=1:size(imgs,2)-1
    img = [grayscales{i} grayscales{i+1}];
    figure(i);
    imagesc(img);
    colormap('gray');
    hold on;
    cols1 = size(imgs{i},2);
    for j=1:size(matches{i},1)
        x1 = points{i}(j,1);
        y1 = points{i}(j,2);
        if(matches{i}(j) > 0)
            x2 = points{i+1}(matches{i}(j),1) + cols1;
            y2 = points{i+1}(matches{i}(j),2);
            plot(x1,y1, 'go');
            plot(x2,y2, 'c+');
            line([x1 x2], [y1 y2], 'Color', 'r');
        elseif(j < size(points{i+1}, 1))
            x2 = points{i+1}(j,1) + cols1;
            y2 = points{i+1}(j,2);
            plot(x1,y1, 'ys');
            plot(x2,y2, 'ms');
        else
            plot(x1,y1, 'ys');
        end
    end
    hold off;
end


%%%%%

% dist1 = sqrt(sum(sift1.^2));
% dist = dist2(sift, sift2);
% matches = knnsearch(sift1, sift2, 'Distance', 'euclidean', 'K', 2);

% [features1, valid_points1] = extractFeatures(img1, keypoints1);
% [features2, valid_points2] = extractFeatures(img2, keypoints2);
%
% indexPairs = matchFeatures(features1, features2);
%
% matchedPoints1 = valid_points1(indexPairs(:, 1), :);
% matchedPoints2 = valid_points2(indexPairs(:, 2), :);
%
% figure; showMatchedFeatures(img1, img2, matchedPoints1, matchedPoints2);

%
% image1 = [img1 img2];
% figure(3), imagesc(image1), colormap(gray), hold on;
% plot(c, r, 'rs');
% plot(c2+size(img1,2), r2, 'rs');
% matched1 = [];
% matched2 = [];
% for i=50:100
%     x1 = keypoints1(match(i,1), 1);
%     y1 = keypoints1(match(i,1), 2);
%     x2 = keypoints2(match(i,2), 1);
%     y2 = keypoints2(match(i,2), 2);
%     matched1 = [matched1; x1 y1];
%     matched2 = [matched2; x2 y2];
%     plot([x1; x2+size(img1,2)],[y1; y2],'y');
% end
% figure(5);
% imagesc(img2), colormap(gray), hold on;
% plot(matched2(:,1), matched2(:,2), 'o');
% matchCompact = ransac(match, keypoints1, keypoints2);
% trans = translation(matchCompact, keypoints1, keypoints2);

% B = img2 + trans;
% [best1, best2] = ransac(matched1, 2, 50, 15, 50);
% figure(2);
% showMatchedFeatures(img1, img2, matched1, matched2);
% imagesc(img2), axis off, colormap(gray), hold on;
% % plot(c2, r2, 'ys');
% [min1, min_index] = min(distances(1,:))
%
% distances(1, min_index) = inf;
%
% [min2, min_index2] = min(distances(1,:))
%
% min1/min2
% Mdl = createns(p1,'NSMethod','kdtree','Distance','euclidean');

% IdxNN = knnsearch(Mdl,p2,'K',2);

% figure(2); clf; imagesc(img1); hold on;
% % show features detected in image 1
% plot(c,r,'+g');
% % % show displacements
% line([c; c2],[r; r2],'color','y')
%
% u = [];
% v = [];
% for i=1:size(c,1)
% theta = ori1(c(i),r(i));
% m = mag1(c(i), r(i)); % magnitude (length) of arrow to plot
% x = c(i); y = r(i);
% u = [u; m * cos(theta)]; % convert polar (theta,r) to cartesian
% v = [v; m * sin(theta)];
% hold on
% end
%
% quiver(c,r,u,v, 'r');

% u = [];
% v = [];
% for i=1:size(c2,1)
% theta = theta2(r2(i),c2(i));
% m = mag2(r2(i), c2(i)); % magnitude (length) of arrow to plot
% x = c2(i); y = r2(i);
% u = [u; m * cos(theta)]; % convert polar (theta,r) to cartesian
% v = [v; m * sin(theta)];
% hold on
% end
%
% quiver(c2,r2,u,v, 'r');

%
% plot the results
% figure(1);
% subplot(1,2,1);
% imagesc(img1), axis off, colormap(gray), hold on;
% plot(c, r, 'ys');
% subplot(1,2,2);
% imagesc(img2), axis off, colormap(gray), hold on;
% plot(c2, r2, 'ys');
%