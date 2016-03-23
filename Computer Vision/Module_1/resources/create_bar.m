function grid = create_bar(h, w, theta, s, img_size)
grid = zeros(img_size,img_size);

grid(img_size/2-ceil(h/2)+1:img_size/2+ceil(h/2)-1,img_size/2-ceil(w/2)+s:img_size/2+ceil(w/2)-1+s) = 1;% grid(s:(s+h-1),s:(s+w-1)) = ones(h,w);
grid = imrotate(grid, theta, 'nearest', 'crop');
end