function imout = test(im, focal_length)
I = imread('cameraman.tif');
imshow(I);
    dir2cyl = @(r) [-atan2(r(:, 2), r(:, 1)), ...
                r(:, 3) ./ sqrt(sum(r(:, 1 : 2).^2))];
cyl2dir = @(xy) [cos(-xy(:, 1)), ...
                 sin(-xy(:, 1)), ...
                 xy(:, 2)];
             hom2euk = @(x) x(:, 1 : 2) ./ x(:, [3 3]);
euk2hom = @(x) [x, ones(size(x, 1), 1)];
forward = @(U, T) dir2cyl((T.tdata.R * T.tdata.K^-1 * euk2hom(U)')');
inverse = @(X, T) hom2euk((T.tdata.K * T.tdata.R' * cyl2dir(X)')');
rot = @(p, a) circshift(blkdiag([cos(p) -sin(p); sin(p) cos(p)], 1), [a a]);
R = rot(pi / 2, 1) * rot(0.5 * randn, 3) * rot(0.5 * randn, 2) * rot(0.5 * randn, 1);
c = 100;
K = [-c, 0, size(I, 2) / 2;
      0, c, size(I, 1) / 2;
      0, 0, 1];
  tform = maketform('custom', 2, 2, forward, inverse, struct('K', K, 'R', R));
  xdata = [-pi, pi];
ydata = [-1, 1];
scale = 1 / 100;
J = imtransform(I, tform, 'XData', xdata, 'YData', ydata, 'XYScale', scale);
imshow(J, 'XData', xdata, 'YData', ydata);
axis on;
set(gca, 'YDir', 'normal');
end