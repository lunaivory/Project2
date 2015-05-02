function S = stitchLinearBlend(imgs, Tform)
    n = size(imgs, 2);

    imgSize = size(imgs{1});

    % Initialize panorama size
    
    for i=1:n
        [xlim(i,:), ylim(i,:)] = outputLimits(Tform{i}, [1, imgSize(2)], [1, imgSize(1)]);
    end
    maxX = ceil(max(max(xlim(:,:)))); minX = ceil(min(min(xlim(:,:))));
    maxY = ceil(max(max(ylim(:,:)))); minY = ceil(min(min(ylim(:,:))));
    width = ceil(maxX - minX);
    height = ceil(maxY - minY);

    S = zeros([height width 3], 'like', imgs{1});

    coordinate = imref2d([height width], [minX maxX], [minY maxY]);
    
    % Start blending and stitching

    xLast{n} = 0;
    for i = 1:n
        W = imwarp(imgs{i}, Tform{i}, 'OutputView', coordinate);
        imgSize = size(W(:,:,1));
        
        xFirst = getXFirst(imgSize, W);

        [p0, p1] = getPoissonBound(xLast, xFirst, i);

        for y = 1:imgSize(1)
            for x = 1:imgSize(2)

                if (x < p0)
                    continue;
                elseif (x > p1)
                    if(sum(W(y,x,:)) > 0)
                        S(y,x,:) = W(y,x,:);
                    end
                else
                    
                end
                
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

function xFirst = getXFirst(imgSize, W)

    xFirst = 0;
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
end

function [bound0, bound1] = getPoissonBound(xLast, xFirst, itr)

    if (itr == 1) 
        bound0 = 0;
        bound1 = 0;
    else
        bound0 = (xLast{itr-1} - xFirst)/4 + xFirst;
        bound1 = (xLast{itr-1} - xFirst)*3/4 + xFirst;
    end
end