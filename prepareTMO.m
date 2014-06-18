function [brightness, key] = prepareTMO()
  global config;

  lengthOfSequence = config.IO.sequenceInOutPoints(2) - config.IO.sequenceInOutPoints(1);
  
  % Allokation der Statistik
  brightness = zeros(lengthOfSequence, 3);
  key = zeros(lengthOfSequence, 3);

  for currentFrame = 1:lengthOfSequence + 1

    % Einlesen der HDR-Daten
    HDR = read(sprintf(config.IO.inputPath, config.IO.sequenceInOutPoints(1)+currentFrame-1));

    for channel = 1:3
      HDR_Y = removeSpecials(HDR(:,:,channel));
      
      % Quantilefilter
      [minLum, maxLum] = percentile(HDR_Y, [config.Tempora.quantileLower config.Tempora.quantileUpper]);
      
      % Statistik
      HDR_Y_Percentile = clamp(HDR_Y, [minLum maxLum]);
      maxLum = log(maxLum);
      minLum = log(minLum);
      worldLum = squeeze(mean(mean(log(HDR_Y_Percentile))));
      
      key(currentFrame, channel) = (maxLum - worldLum) ./ (maxLum - minLum);
      brightness(currentFrame, channel) = exp((maxLum + minLum) ./ (maxLum - minLum));
    end
    
    fprintf('Prepared %d\n', currentFrame);
  end
  
  key = fliplr(key);
  brightness = fliplr(brightness);

end