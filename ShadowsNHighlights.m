function OUT = ShadowsNHighlights(IN)
  global config;

  sourceMean = repmat(mean(IN, 3), [1 1 3]);
  blurredPixel = mean(log(IN), 3);
  
  if(config.ShadowsNHighlights.useWLSFilter == true)
    blurredPixel = WLSFilter(blurredPixel, config.ShadowsNHighlights.lambda, config.ShadowsNHighlights.alpha);
  else
    blurredPixel = RF(blurredPixel, config.ShadowsNHighlights.sigma, config.ShadowsNHighlights.rho);
  end  
  
  blurredPixel = repmat(exp(blurredPixel), [1 1 3]);
  blurredMean = repmat(mean(blurredPixel, 3), [1 1 3]);

  num33 = sourceMean + (blurredMean - sourceMean) * config.ShadowsNHighlights.LocalContrastIntensity;
  num35 = repmat(mean(blurredPixel ./ blurredMean, 3), [1 1 3]);

  if (config.ShadowsNHighlights.Shadows > 0)
    num37 = 1;
  else
    num37 = 0;
  end
  
  val21 = (50 ./ (num33 * 255 + 10) - 0.3 * (1 + (1 - config.ShadowsNHighlights.ShadowTonalRange) * 2));
  val21(val21 < 0) = 0;

  num39 = min(((config.ShadowsNHighlights.Compression * 10 + 1)/3), val21);
  num41 = num37 * (1.0 + num39 .* num35 * config.ShadowsNHighlights.Shadows) + 2 * (1 - num37);

  x = IN + sourceMean .* (num41 - 1);
  x = ((x + (IN .* num41 - x)) .* num37 + (IN + (IN - sourceMean) .* num39 .* num35 .* (num41 - 1)) .* (1 - num37)) ./ IN;

  num57 = 1 - sourceMean;
  val22 = (50 ./ (255 - num33 * 255 + 10) - 0.3 * (1 + (1 - config.ShadowsNHighlights.HighlightTonalRange) * 2));
  val22(val22 < 0) = 0;

  num59 = min((config.ShadowsNHighlights.Compression * 10 + 1)/3, val22);
  num61 = num57 .* (1.0 + num59 .* num35 .* config.ShadowsNHighlights.Highlights) - num57;

  num62 = sourceMean - (sourceMean - IN .* x) .* num59 .* num35;
  num62 = 1.0 - (num61 + sourceMean - num62)./num62;

  OUT = IN .* x .* num62;
  
end