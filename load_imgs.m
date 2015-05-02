function [imgs, grayscales] = load_imgs( )
    for i = 1:7
        filename = sprintf('./photo/%d.jpg', i);
        imgs{i} = cyl(imread(filename), 1800);
        grayscales{i} = rgb2gray(imgs{i});
    end  
end

