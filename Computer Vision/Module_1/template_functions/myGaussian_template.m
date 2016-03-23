  function output = myGaussian(width, height, sigma)
    output = ones(width,height);
  
    subX = ceil(width/2);
    subY = ceil(height/2);
    
    for i = 1:height
        y = i - subY;
        for j = 1:width
            x = j - subX;
            output(i,j) = (1/(2*pi*sigma^2))*exp(-((y)^2/(2*sigma^2) + (x)^2/(2*sigma^2))); 
        end
    end
    output = output / sqrt(sum(sum(output.^2)));
    
    return
  end
  