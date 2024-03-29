global config;

%% Source-Konfiguration
config.IO = struct(...
  'sequenceInOutPoints', [820 820], ...
  'tonemapInOutPoints', [820 820], ...
  'inputPath', '/Volumes/Daten/EXR/fire/%05d.exr',...
  'outputPath', '/Volumes/Daten/Render_temp/%05d.exr' ...
);

%% Parameter-Konfigurierung
config.LeonhardtTMO = struct( ...
  'ExposureOffset', -8.5     ,...
  'BrightnessOffset',  0     ,...
  'Contrast', 1              ,... 
  'Gamma', 2.7               ,...
  'useDetailDrawback', true  ,...
  'useWLSFilter', false      ,...
  'DetailDrawback', 0.67     ,...
  'DetailHighlight', 0       ,...
	'alpha', 2                 ,...
	'lambda', 0.25             ,...
  'sigma', 100               ,...
  'rho', 0.5                  ...
);

% Macht das gleiche wie Tiefen / Lichter in PS, benutzt aber einen
% kantenerhaltenden Tiefpassfilter um Halos zu vermeiden.
config.ShadowsNHighlights = struct( ...
  'useShadowsNHighlights', false, ...
  'useWLSFilter', false      ,...
  'Compression', 1           ,...
  'Highlights', 1            ,... 
  'HighlightTonalRange', 0   ,...
  'Shadows', 0               ,...
  'ShadowTonalRange', 0      ,...
  'LocalContrastIntensity', 1,...
  'alpha', 1                 ,...
  'lambda', 0.1              ,...
  'sigma', 60                ,...
  'rho', 1                    ...
);

% Parameter f�r die temporale Gl�ttung
config.Tempora = struct(      ...
  'alpha', 3                 ,...
  'lambda', 2                ,...
  'quantileLower', 0.05      ,...
  'quantileUpper', 0.999      ...
);
%%
[brightness, key] = prepareTMO();

LDR = LeonhardtTMO(brightness, key);

%%
imshow(LDR);