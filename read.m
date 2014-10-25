function output = read(input)
  global config

  [~,~,ext] = fileparts(input);
  
  switch ext
    case '.exr'
      output = double(exrread(input));
    otherwise
      output = im2double(imread(input));
  end
  
  output = exp(config.LeonhardtTMO.ExposureOffset) * output;
end