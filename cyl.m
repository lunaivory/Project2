function IMG = cyl(I,f)
    mx = (size(I, 1)) / 2;
    my = (size(I, 2)) / 2;
    rx = mx;
    ry = my;
    X(rx*2+1, ry*2+1) = 0; Y(rx*2+1, ry*2+1) = 0;
    for x = -rx: rx
        for y = -ry: ry
            xinv = tan(x/f)*f;
            yinv = y * sqrt(xinv^2 + f^2) / f;
            X(x+rx+1, y+ry+1) = xinv;
            Y(x+rx+1, y+ry+1) = yinv;
        end
    end    
    X = X + mx; Y = Y + my;
    for x = 1: (rx*2+1)
        for y = 1 : (ry*2+1)
           xx = floor(X(x,y));
           yy = floor(Y(x,y));
           if (xx<1 || yy<1 || xx>=size(I,1) || yy>=size(I,2))
              continue;
           end
           a = X(x,y) - xx;
           b = Y(x,y) - yy;
           xx1 = xx + 1*(xx<size(I,1));
           yy1 = yy + 1*(yy<size(I,2));
            w00 = (1-a) * (1-b);
            w10 = a * (1-b);
            w01 = (1-a) * b;
            w11 = a * b;
            %IMG(x,y,:) = I(xx, yy,:);
            if xx <= 0 || yy <= 0 || xx1 > size(I,1) || yy1 > size(I,2)
                fprintf('%f %f %d %d %d %d\n',X(x,y), Y(x,y), xx, yy, xx1, yy1);
            end
            IMG(x,y,:) = w00 * I(xx, yy, :) + w10 * I(xx1, yy, :) +...
                         w01 * I(xx, yy1, :) + w11 * I(xx1, yy1, :);
        end
    end
    % subplot(1,2,1), imshow(I);
    % subplot(1,2,2), imshow(IMG);
end