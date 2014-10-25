function input = clamp(input, limits)

  input(input<limits(1)) = limits(1);
  input(input>limits(2)) = limits(2);
    
end