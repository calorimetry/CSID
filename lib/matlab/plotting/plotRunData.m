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

function run_data = plotRunData(run_data, fields, field_axes, varargin)
% plotRunData -- make single or double Y plots of fields in the run_data struct
%
% run_data = plotRunData(run_data, fields, sides, varargin)
%
% Arguments
% run_data:   A struct containing the sample times, and data fields including
%             their units
% fields:     A cell array of strings containing the names fields within run
%             data that are to be plotted
% field_axes: An cell array specifying which axis goes to each field;
%             valid entries include: 'X', 'Y', 'Y1', 'Y2' (case insensitive)
%
% Return Values
% run_data:   A struct containing the sample times, and data fields that have
%             been interpolated to all coincide with the sample times
%
% If the x axis of all the subplots is the same, then the axes will be
% linked.
%
% Example - make a double-Y plot of power and temperature vs. time and an
% additional separate plot of temperature vs. time
%
%  ax = {'x', 'y1', 'Y2', 'x', 'Y'}
%  fields = {'Time', 'Power', 'Temperature', 'Time', 'Temperature'}
%  plotRunData( run_data, fields, ax, 'LegendPosition', 'SouthEast')

%% figure title
if isfield(run_data, 'filename')
  figure('Name', strrep(run_data.filename, '_', '-'));
else
  figure();
end
clf;

%% Define the range of data being plotted
try
  plot_range = run_data.nStart:run_data.nStop;
catch
  plot_range = 1:length(run_data.Time.data);
end

%% Determine the number of plots (count x axes) and field indices
assert(strcmpi(field_axes{1}(1), 'x'), 'First Axis must be x axis')
isnewplot = cellfun(@(x) strcmpi(x(1), 'x'), field_axes);
x_indices = find(isnewplot);
beg_y_indices = x_indices + 1;
end_y_indices = find(circshift(isnewplot, -1, 2));
nplots = sum(isnewplot);
%% Replace underscores with dashes in field names for plotting purposes
dash_fields = strrep(fields,'_','-');

%% loop over plots
fh = nan(nplots, 1);
for kplot = 1:nplots;
  fh(kplot) = subplot(nplots, 1, kplot);
  clear plotData;
  x_index = x_indices(kplot);
  end_y_index = end_y_indices(kplot);
  beg_y_index = beg_y_indices(kplot);
  % create plot title
  if end_y_index > beg_y_index
    last_y_field = [' and ', dash_fields{end_y_index}];
  else
    last_y_field = dash_fields{end_y_index};
  end
  plotData.title = [strjoin(dash_fields(beg_y_index:end_y_index-1), ', '),...
                    last_y_field, ' vs ', fields{x_index}];

  % identify the x axis label and data
  plotData.x_title = axisLabel(run_data,fields{x_index});
  xdata = run_data.(fields{x_index}).data(plot_range);

  % loop over y fields
  plotData.y1_title = '';
  plotData.y2_title = '';
  plotData.x1{1} = [];
  plotData.x2{1} = [];
  plotData.y1{1} = [];
  plotData.y2{1} = [];
  pLegend = {};
  for ky_index = beg_y_index:end_y_index
    % build the data arrays and y axis titles
    ydata = run_data.(fields{ky_index}).data(plot_range);
    if any(strcmpi(field_axes(ky_index), {'y', 'y1'}))
      plotData.y1_title = [plotData.y1_title,...
                           axisLabel(run_data, fields{ky_index}), ' '];
      plotData.x1{1} = [plotData.x1{1}, xdata];
      plotData.y1{1} = [plotData.y1{1}, ydata];
    elseif strcmpi(field_axes(ky_index), 'y2')
      plotData.y2_title = [plotData.y2_title,...
                           axisLabel(run_data, fields{ky_index}), ' '];
      plotData.x2{1} = [plotData.x2{1}, xdata];
      plotData.y2{1} = [plotData.y2{1}, ydata];
    end
    pLegend = [pLegend, dash_fields{ky_index}];
  end
  plotData.legends = pLegend;
  % make plot
  if isempty(plotData.x2{1}) % if there is no right Y axes use NicerPlot
    plotData.x = num2cell(plotData.x1{1}, 1);
    plotData = rmfield(plotData, 'x1');
    plotData.y = num2cell(plotData.y1{1}, 1);
    plotData = rmfield(plotData, 'y1');
    plotData.y_title = plotData.y1_title;
    plotData = rmfield(plotData, 'y1_title');
    NicerPlot(plotData);
  else
    [leftAxis, rightAxis, leftLine, rightLine] = NiceYYPlot(plotData);
  end
end
%% link axes if they are all the same
if length(unique(fields(x_indices))) == 1
  linkaxes(fh, 'x')
end
%% reposition figure
% run_data = RepositionFigure(run_data);
end

function label = axisLabel(run_data, field)
  label = '';
  if isfield(run_data, field)
    label = strrep(field, '_', '-');
    if isfield(run_data.(field), 'units')
      label = strcat(label,' (', run_data.(field).units, ')');
    end
  end
end
