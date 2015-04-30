function match = feature_match(desc1, desc2)
%FEATURE_MATCH Match features between feature descriptors
%   Detailed explanation goes here
    match = zeros(size(desc1,1), 1);

    for i=1:size(desc1,1)
        dists = double(zeros(size(desc2,1),1));
        for j=1:size(desc2,1)
            tmp = sum((desc1(i,:) - desc2(j,:)).^2);
            dists(j) = tmp;
        end
        [min1, min_index] = min(dists);
        dists(min_index) = NaN;
        min2 = min(dists);
        % From lecture slides:
        % If ratio between closest and second closest distance < 0.8
        % it is considered a match
        if (min1/min2) < 0.8
            match(i) = min_index;
        end
    end

end

