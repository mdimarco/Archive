function grid = create_bar(h, w, theta, s, img_size)
grid = zeros(img_size,img_size);
grid(img_size/2-ceil(h/2)+1+s:img_size/2+ceil(h/2)-1+s,img_size/2-ceil(w/2):img_size/2+ceil(w/2)-1) = 1;
grid = imrotate(grid, theta, 'nearest', 'crop');
end