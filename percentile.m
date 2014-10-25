function [lowerPerc, upperPerc] = percentile(input, limits)
  
  s1 = numel(input);
  input = sort(input(:));
  percs = input(max(round(s1*limits),1));

  lowerPerc = percs(1);
  upperPerc = percs(2);
  
end