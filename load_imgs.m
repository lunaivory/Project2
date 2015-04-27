function [imgs, grayscales] = load_imgs( )
    img1 = imread('imgs/1.jpg');
    img2 = imread('imgs/2.jpg');
    img3 = imread('imgs/3.jpg');
    img4 = imread('imgs/4.jpg');
    img5 = imread('imgs/5.jpg');
    img6 = imread('imgs/6.jpg');
    img7 = imread('imgs/7.jpg');
    
    imgs = {img1, img2, img3, img4, img5, img6, img7};
    grayscales = {rgb2gray(img1), rgb2gray(img2), rgb2gray(img3)...
        rgb2gray(img4), rgb2gray(img5), rgb2gray(img6), rgb2gray(img7)};
    
end

