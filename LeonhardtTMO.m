function LDR = LeonhardtTMO(brightness, key)
  global config;
  
  small_eps = 0.5;
  
  contrast = zeros(size(key));
  for channel = 1:3
    brightness(:,channel) = smoothParameter(brightness(:,channel));
    contrast(:,channel) = (1 - config.LeonhardtTMO.Contrast) + config.LeonhardtTMO.Contrast*smoothParameter(key(:,channel));
  end
  
  for currentFrameNo = config.IO.tonemapInOutPoints(1):config.IO.tonemapInOutPoints(2)

    relatedDataFrameNo = currentFrameNo - config.IO.sequenceInOutPoints(1) + 1;
    
    HDR = read(sprintf(config.IO.inputPath, currentFrameNo));
    HDR = removeSpecials(HDR);
    
    if(config.LeonhardtTMO.useDetailDrawback == true)
      hdr_coarse = log(HDR + small_eps);
      
      if(config.LeonhardtTMO.useWLSFilter == true)
        hdr_coarse = reshape(WLSFilter(hdr_coarse, config.LeonhardtTMO.lambda, config.LeonhardtTMO.alpha), size(HDR));
      else
        hdr_coarse = RF(hdr_coarse, config.LeonhardtTMO.sigma, config.LeonhardtTMO.rho);
      end
      
      hdr_coarse = (HDR * (1 - config.LeonhardtTMO.DetailDrawback) + (exp(hdr_coarse) - small_eps) * config.LeonhardtTMO.DetailDrawback);
      HDR = HDR.*exp((HDR - hdr_coarse) * config.LeonhardtTMO.DetailHighlight);
    else
      hdr_coarse = HDR;
    end
    
    transfered = zeros(size(HDR));
    
    for channel = 1:3
      brightness_map = brightness(relatedDataFrameNo, channel) + mean(HDR, 3);
      Ia = (hdr_coarse(:,:,channel) + brightness_map).*(brightness_map.*sinh(hdr_coarse(:,:,channel)./brightness_map));
      transfered(:,:,channel) = exp(-config.LeonhardtTMO.BrightnessOffset)*removeSpecials(Ia).^(contrast(relatedDataFrameNo, channel));
    end
    
    LDR = HDR.^config.LeonhardtTMO.Gamma ./ (hdr_coarse.^config.LeonhardtTMO.Gamma + transfered);
    LDR = LDR.^(1/config.LeonhardtTMO.Gamma);
    
    fprintf('Tonemapped %d\n', currentFrameNo);
    
    if(config.ShadowsNHighlights.useShadowsNHighlights)
      LDR = ShadowsNHighlights(removeSpecials(LDR));
    end
    
%     exrwrite(LDR, sprintf(config.IO.outputPath, currentFrameNo));  
  end
end