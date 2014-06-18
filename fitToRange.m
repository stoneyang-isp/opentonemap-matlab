function input = fitToRange(input, usePercentile, clamp)

  if(~exist('usePercentile', 'var'))
    usePercentile = false;
  end
  if(~exist('clamp', 'var'))
    clamp = false;
  end

  if(usePercentile == true)
    [minInput, maxInput] = percentile(input, [0.001 0.999]);
  else
    maxInput = max(input(:));
    minInput = min(input(:));
  end

  if(maxInput ~= minInput)
    input = (input - minInput) / (maxInput - minInput);
  end
  
  if(clamp)
    input(input<1) = 1;
    input(input>0) = 0;
  end

end