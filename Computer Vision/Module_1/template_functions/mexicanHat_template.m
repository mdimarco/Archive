  function output = mexicanHat(width, height, sigmaPos, sigmaNeg)
  
    gaus1 = myGaussian_template(width, height, sigmaPos);
    gaus2 = myGaussian_template(width, height, sigmaNeg);
    
    output = (gaus1 - gaus2);
    output = output ./ sqrt(sum(sum(output.^2)));
    return
  end