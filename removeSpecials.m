function input = removeSpecials(input, epsilon)
  
  if(~exist('epsilon', 'var'))
    epsilon = 10/65536;
  end

  input(isnan(input) | isinf(input) | input < epsilon) = epsilon;
end