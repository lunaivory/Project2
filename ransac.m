function M = ransac(X1, X2, IMG1, IMG2)
  k = 35;
  c = 0;
  d = 4;
  n = 4;
  sz = size(X1, 1);

  for i = 1:k
    A = zeros(n, 2);
    B = zeros(n, 2);
    for j = 1:n
      itr = ceil(rand*sz);
      A(j, :) = X1(itr, :);
      B(j, :) = X2(itr, :);
    end
    X = B\A;
    nX1 = X1*X;
    D2 = (nX1-X2).*(nX1-X2);
    D = D2(:,1) + D2(:,2);
    tmp = sum(D < d);
    if tmp > c
      disp(D);
      c = tmp;
      M = X;
      Dr = D < d;
    end
  end
  fprintf('%d over %d\n', c, sz);
  PlotRansac(X1, X2, Dr, IMG1, IMG2);
end

function PlotRansac(X1, X2, D, IMG1, IMG2)
  img = [IMG1, IMG2];
  imagesc(img);
  colormap('gray');
  hold on;
  cols = size(IMG1, 2);
  for i=1:size(D)
    x1 = X1(i, 1); y1 = X1(i, 2);
    x2 = X2(i, 1) + cols; y2 = X2(i, 2);
    if D(i)==0
      %fprintf('No MATCH %d %d %d %d\n', x1, y1, x2, y2);
      plot(x1, y1, 'r.');
      plot(x2, y2, 'r.');
      %line([x1 x2], [y1 y2], 'Color', 'w');
    else
      plot(x1, y1, 'go');
      plot(x2, y2, 'go');
      line([x1 x2], [y1 y2], 'Color', 'g');
    end
  end
  hold off;
end