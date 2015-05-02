function M = ransac(X1, X2, IMG1, IMG2)
  k = 88800;
  c = 0;
  d = 1;
  sz = size(X1, 1);
  n = 6;
  X11 = ones(sz, 3);
  X11(:,1:2) = X1(:,1:2);
  
  for i = 1:k
    A = zeros(n, 3);
    B = zeros(n, 2);
    for j = 1:n
      itr = ceil(rand*sz);
      A(j, :) = [X1(itr, :),1];
      B(j, :) = X2(itr, :);
    end
    X = A\B;
%     disp(X);
    nX1 = X11*X;
    D2 = (nX1-X2).*(nX1-X2);
    D = D2(:,1) + D2(:,2);
    cal = 0;
%     for kk = 1:size(D)
%        fprintf('%d %d\n', nX1(kk,1)-X2(kk,1), nX1(kk,2)-X2(kk,2));
%        fprintf('%d : %d < %d ? %d',kk, D(kk), d, D(kk) < d);
%        cal = cal + 1;
%     end
    tmp = sum(D < d);
    %fprintf('%d vs %d', cal, tmp);
%     disp(tmp);
    if tmp > c
      c = tmp;
      M = X;
      Dr = D < d;
    end
  end
   fprintf('%d over %d\n', c, sz);
   figure(1);
   PlotRansac(X1, X2, Dr, IMG1, IMG2);
   pause();
end

function PlotRansac(X1, X2, D, IMG1, IMG2)
  img = [IMG1, IMG2];
  imagesc(img);
  colormap('gray');
  axis off;
  hold on;
  cols = size(IMG1, 2);
  for i=1:size(D)
    x1 = X1(i, 1); y1 = X1(i, 2);
    x2 = X2(i, 1) + cols; y2 = X2(i, 2);
    if D(i)==0
      %fprintf('No MATCH %d %d %d %d\n', x1, y1, x2, y2);
      plot(x1, y1, 'r.');
      plot(x2, y2, 'r.');
      if (mod(i,10) == 0)
        line([x1 x2], [y1 y2], 'Color', 'w');
      end
    else
      %fprintf('MATCH %d %d %d %d\n', x1, y1, x2, y2);
      plot(x1, y1, 'go');
      plot(x2, y2, 'go');
      line([x1 x2], [y1 y2], 'Color', 'g');
    end
  end
  hold off;
end