function [imgs, grayscales] = load_imgs( )
    img1 = imread('photo/1.jpg');
    img2 = imread('photo/2.jpg');
    img3 = imread('photo/3.jpg');
    img4 = imread('photo/4.jpg');
    img5 = imread('photo/5.jpg');
    img6 = imread('photo/6.jpg');
    img7 = imread('photo/7.jpg');
    
    imgs = {img1, img2, img3, img4, img5, img6, img7};
    grayscales = {rgb2gray(img1), rgb2gray(img2), rgb2gray(img3)...
        rgb2gray(img4), rgb2gray(img5), rgb2gray(img6), rgb2gray(img7)};
    
end

