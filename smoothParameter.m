function output = smoothParameter( input )
  global config;
  output = WLSFilter(input, config.Tempora.lambda, config.Tempora.alpha);
end