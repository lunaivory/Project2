function S = stitch(imgs, Tform)
    n = size(imgs, 2);
    %%% Align Tform & initial panorama%%%
    mid = round(n/2);
    % invT = invert(Tform{mid-1});
    imgSize = size(imgs{1});
    for i=1:n
        %Tform{i}.T = invT.T * Tform{i}.T;
        [xlim(i,:), ylim(i,:)] = outputLimits(Tform{i}, [1, imgSize(2)], [1, imgSize(1)]);
    end
    maxX = ceil(max(max(xlim(:,:)))); minX = ceil(min(min(xlim(:,:))));
    maxY = ceil(max(max(ylim(:,:)))); minY = ceil(min(min(ylim(:,:))));
    width = ceil(maxX - minX);
    height = ceil(maxY - minY);

    S = zeros([height width 3], 'like', imgs{1});

    coordinate = imref2d([height width], [minX maxX], [minY maxY]);
    xLast{n} = 0;
    for i = 1:n
        W = imwarp(imgs{i}, Tform{i}, 'OutputView', coordinate);
        imgSize = size(W(:,:,1));
        xFirst = 0;
        midy = ceil(imgSize(1)/2);
        for x = 1: imgSize(2)
            for y = 1:imgSize(1)
               if (sum(W(y,x,:) > 0))
                   xFirst = x;
                   break;
               end
            end
            if(xFirst > 0)
                break;
            end
        end
        
        for y = 1:imgSize(1)
            for x = 1:imgSize(2)
                if (sum(W(y,x,:)) > 0)
                    
                    xLast{i} = max([xLast{i}, x]);
                    
                    if (sum(S(y,x,:)) > 0)
                        portion = (x - xFirst) / abs(xLast{i-1} - xFirst);
                        %fprintf('%d %d %d %f\n', xFirst, xLast{i-1}, x, portion);
                        S(y,x,:) = (1 - portion) * S(y,x,:) + portion * W(y,x,:);
                    else
                        S(y,x,:) = W(y,x,:);
                    end
                end
            end
        end
    end
    figure(2);
    imshow(S);
end




