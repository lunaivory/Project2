clear; clc;
set(0,'DefaultFigureMenu','none');
format compact;

sigma = 2;
radius = 2;
threshold = 1000;

disp('Loading Images')
[imgs, grayscales] = load_imgs();

img1 = grayscales{1};
img2 = grayscales{2};

points = cell(1,size(imgs,2));

disp('Detecting Harris corners')
% Detect harris corners
for i=1:size(imgs,2)
    points{i} = harris_corner(grayscales{i}, sigma, radius, threshold);
end

% get mops descriptors

disp('Calculating MOPS descriptors')
descriptors = cell(1,size(imgs, 2));
for i=1:size(imgs,2)
    descriptors{i} = mops_descriptor(grayscales{i}, points{i});
end

disp('Matching features')
matches = cell(1,size(imgs, 2)-1);
for i=1:size(imgs,2)-1
    matches{i} = feature_match(descriptors{i}, descriptors{i+1});
end

% Show a figure with lines joining the accepted matches.

%%%% Display Feature Matched %%%% 
% for i=1:size(imgs,2)-1
%     img = [grayscales{i} grayscales{i+1}];
%     figure(i);
%     imagesc(img);
%     colormap('gray');
%     hold on;
%     cols1 = size(imgs{i},2);
%     for j=1:10
%         x1 = points{i}(j,1);
%         y1 = points{i}(j,2);
%         if(matches{i}(j) > 0)
%             x2 = points{i+1}(matches{i}(j),1) + cols1 + 50;
%             y2 = points{i+1}(matches{i}(j),2);
%             plot(x1,y1, 'go');
%             plot(x2,y2, 'c+');
%             line([x1 x2], [y1 y2], 'Color', 'r');
%         elseif(j < size(points{i+1}, 1))
%             x2 = points{i+1}(j,1) + cols1;
%             y2 = points{i+1}(j,2);
%             plot(x1,y1, 'ys');
%             plot(x2,y2, 'ms');
%         else
%             plot(x1,y1, 'ys');
%         end
%     end
%     hold off;
% end
%%%%%%%%%%%%%%%%%%%%%%%%%

disp('Matching Images')
Tform = cell(1, size(imgs,2));
mid = ceil(size(imgs,2)/2);
Tform{mid} = affine2d(eye(3));
for i = mid:size(imgs,2)-1
    [X1,X2] = siftMatched(matches{i}, points{i}, points{i+1});
    Tform{i+1} = affine2d(ransac(X2, X1, grayscales{i+1}, grayscales{i}));
    if (i > mid)
        Tform{i+1}.T = Tform{i}.T * Tform{i+1}.T;
    end
end
for i = mid:-1:2
    [X2,X1] = siftMatched(matches{i-1}, points{i-1}, points{i});
    Tform{i-1} = affine2d(ransac(X2, X1, grayscales{i-1}, grayscales{i}));
    if (i < mid)
        Tform{i-1}.T = Tform{i}.T * Tform{i-1}.T;
    end
end
% Tform = cell(1, size(imgs, 2));
% Tform{1} = affine2d(eye(3));
% for i=1:size(imgs, 2) - 1
%     [X1, X2] = siftMatched(matches{i}, points{i}, points{i+1});
%     Tform{i+1} = affine2d(ransac(X2, X1, grayscales{i+1}, grayscales{i}));
%     if (i>1)
%         Tform{i+1}.T = Tform{i}.T * Tform{i+1}.T;
%     end
% end

disp('Stitching Images');
S = stitch(imgs, Tform);
%%%%%

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