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

function [leftAxis, rightAxis, leftLine, rightLine] = NiceYYPlot(plotData)
% NiceYYPlot --Creates double Y plot
% Note: this code uses plotyy, which Mathworks has deprecated. Going
% forward we should switch over to useing yyaxis
font_size = 14;

% pack x axis to match number of multiple y datasets
[hAx, leftLine, rightLine] = ...
  plotyy(plotData.x1{1}, plotData.y1{1}, plotData.x2{1}, plotData.y2{1});
leftAxis  = hAx(1);
rightAxis = hAx(2);

if isfield(plotData, 'LineStyle1')
  set(leftLine, 'LineStyle', plotData.LineStyle1);
else
  set(leftLine, 'LineStyle', '-');
end

% Thicken lines for readability
set(leftLine, 'LineWidth', 2);
set(rightLine, 'LineWidth', 2);

if isfield(plotData, 'LineStyle2')
  for kline = 1:length(rightLine)
    if iscell(plotData.LineStyle2)
      linestyle = plotData.LineStyle2{kline};
    elseif ischar(plotData.LineStyle2)
      linestyle = plotData.LineStyle2;
    else
      linestyle = '-';
    end
    set(rightLine(kline), 'LineStyle', linestyle);
  end
else
  set(rightLine, 'LineStyle', '-');
end

if isfield(plotData, 'Marker2')
  for kline = 1:length(rightLine)
    set(rightLine(kline), 'Marker', plotData.Marker2{kline});
  end
else
  set(rightLine, 'Marker', 'none');
end

% axis ticks
if isfield(plotData, 'y1tics')
  set(leftAxis, 'YTick', plotData.y1tics);
end
if isfield(plotData, 'y2tics')
  set(rightAxis, 'YTick', plotData.y2tics);
end
set(hAx(1), 'FontSize', font_size);
set(hAx(2), 'FontSize', font_size);

% minor ticks
set(rightAxis, 'XMinorTick', 'on')
set(rightAxis, 'YMinorTick', 'on')
set( leftAxis, 'YMinorTick', 'on')

% Figure Title
h_title = title(plotData.title);
set(h_title, 'FontSize', font_size);

% axis titles
ylabel(hAx(1), plotData.y1_title)    % left y-axis
ylabel(hAx(2), plotData.y2_title)    % right y-axis
h_label=xlabel(plotData.x_title);
set(h_label, 'FontSize', font_size);

% adjust axes
% x axis
[ xmax, xmin, xExt ] = extOfCell( {plotData.x1{:}, plotData.x2{:}} );
xlim(hAx(1), [xmin - 0.1 * xExt, xmax + 0.1 * xExt]);
xlim(hAx(2), [xmin - 0.1 * xExt, xmax + 0.1 * xExt]);
% left y axis
[ ymax, ymin, yExt ] = extOfCell( plotData.y1 );
if abs(ymax - ymin) > 0
  ylim(hAx(1), [ymin - 0.1 * yExt, ymax + 0.1 * yExt]);
end
if isfield(plotData, 'y1tics')
  set(hAx(1), 'YTick', plotData.y1tics)
end
% right y axis
if isfield(plotData, 'y2tics')
  [ ymax, ymin, yExt ] = extOfCell({plotData.y2tics});
else
  [ ymax, ymin, yExt ] = extOfCell(plotData.y2);
end
% zoom y axis
if ~isfield(plotData, 'y2_zoom')
  plotData.y2_zoom = 1;
end
ymax = ymax/plotData.y2_zoom;
ymin = ymin/plotData.y2_zoom;
yExt = yExt/plotData.y2_zoom;

% stretch y2 axis to clear y1 data
if ~isfield(plotData, 'y2stretch')
  plotData.y2stretch = 0;
end
if ymax>ymin
  ylim(hAx(2), [ymin - 0.1 * yExt, ymax + (plotData.y2stretch + 0.1) * yExt]);
end
if isfield(plotData, 'y2tics')
  set(hAx(2), 'YTick', plotData.y2tics)
end
grid off

% remove unwanted tics
set(gca, 'box', 'off')

% legend
if isfield(plotData, 'legends')
  pLegend = plotData.legends;
else
  pLegend = {};
end
try
  legend_loc=plotData.legend_loc;
catch
  legend_loc = 'NorthEast';
end
if ~isempty(pLegend)
  h_legend = legend(char(pLegend), 'location', legend_loc);
  set(h_legend, 'FontSize', font_size);
end

end

