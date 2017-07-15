%{
Copyright 2017 Google Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

This is not an official Google product.
%}

function NicerPlot(plotData)

% NicerPlot -- A general, single Y plotting function, used mainly for
% ensuring readability through larger font sizes and thicker lines.
%
% Input
% plotData a structure containing data and plotting instructions
%
font_size = 14;

try
  colors = plotData.line_colors;
catch
  colors = {'b' 'g' 'r' 'm' 'c' 'k' };
end

try
  markers = plotData.markers;
catch
  markers = {''};
end

try
  line_styles = plotData.line_styles;
catch
  line_styles = {'-'};
end

try
  error_bars = plotData.error_bars;
catch
  error_bars = false;
end

num_colors = length(colors);
num_markers = length(markers);
num_line_styles = length(line_styles);
num_plots = length(plotData.y);
multi_x = length(plotData.x) == num_plots;

for k=1:num_plots
  line_spec = [...
    line_styles{mod(k - 1, num_line_styles) + 1} ...
    markers{mod(k - 1, num_markers) + 1}];
  if multi_x
    x=plotData.x{k};
  else
    x=plotData.x{1};
  end
  if error_bars
    errorbar(real(x), real(plotData.y{k}), plotData.dy{k}, line_spec, ...
      'Color', colors{mod(k - 1, num_colors) + 1}, ...
      'LineWidth', 2.0);
  else
    plot(real(x), real(plotData.y{k}), line_spec, ...
      'Color', colors{mod(k - 1, num_colors) + 1}, ...
      'LineWidth', 2.0);
  end
  hold on
end

try
  plot_title = plotData.title;
catch
  plot_title = '';
end

% Legends
if isfield(plotData, 'legends')
  pLegend = plotData.legends;
else
  pLegend = {};
end

try
  legend_loc = plotData.legend_loc;
catch
  legend_loc = 'NorthEast';
end

if ~isempty(pLegend)
  h_legend = legend(char(pLegend), 'location', legend_loc);
  set(h_legend, 'FontSize', font_size);
end

x_title=plotData.x_title;
y_title=plotData.y_title;

h_title = title(plot_title);
set(h_title, 'FontSize', font_size);

h_label = ylabel(y_title);
set(h_label, 'FontSize', font_size);
h_label=xlabel(x_title);
set(h_label, 'FontSize', font_size);

%axis tic labels
set(gca, 'FontSize', font_size)
% minor ticks
set(gca, 'XMinorTick', 'on')
set(gca, 'YMinorTick', 'on')

try
  snug_x = plotData.snug_x;
catch
  snug_x = 0;
end
try
  snug_y = plotData.snug_y;
catch
  snug_y = 0;
end


if snug_x
  [ xmax, xmin, xExt ] = extOfCell( plotData.x );
  xlim([xmin - 0.1 * xExt, xmax + 0.1 * xExt]);
end

if snug_y
  [ ymax, ymin, yExt ] = extOfCell( plotData.y );
  ylim([ymin - 0.1 * yExt, ymax + 0.1 * yExt]);
end

hold off
