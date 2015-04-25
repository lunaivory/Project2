function [IMG, FX, FY] = cylindricalize(I, fX, fY, f)
    
    T = maketform('custom', 2, 2, [], @inverse_func, [size(I) f]);
    IMG = imtransform(I, T);
    FX = fX;
    FY = fY;
    imshow(IMG);
end

function U = inverse_func(X, T)
    mx = T.tdata(1) / 2;
    my = T.tdata(2) / 2;
    f = T.tdata(3);
    mX = X(:, 1) - mx;
    mY = X(:, 2) - my;
    Xo = mx + (f .* tan(mX / f));
    Yo = my + sqrt((Xo - mx).^2 + f^2) .* mY / f;
    %Xo = (X(:, 1)~= 0).*(f ./ tan(X(:, 1)));
    %Yo = sqrt((Xo).^2 + f^2) .* X(:, 2);
    %Xo = mx + ((X(:, 1) - mx)~= 0).*(f ./ tan(X(:, 1) - mx));
    %Yo = my + sqrt((Xo - mx).^2 + f^2) .* (X(:, 2) - my);
    disp(Xo);
    %disp(Yo);
    %Xo = atan(f/X(:, 1));
    %Yo = X(:, 2)/sqrt((X(:, 1)).^2 + f^2);
    U = [Xo Yo];
end