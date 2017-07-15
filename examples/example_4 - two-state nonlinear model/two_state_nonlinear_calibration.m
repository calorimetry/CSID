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

%% Initial housekeeping
clear;
close all;
restoredefaultpath

splitpath = strsplit(mfilename('fullpath'), filesep);
containing_dir = strjoin(splitpath(1:end - 1), filesep);
lib_dir = strjoin(splitpath(1:end - 3), filesep);
addpath(genpath(lib_dir));
%% Analysis paramter
run_data.model.action = 'fit';  % fit: Calibration; predict: Prediction 

run_data.model.type = 'two state master model zero Kelvin ground';
%        M O D E L    T Y P E S
% 'one state master model linear'
% 'one state master model'
% 'two state master model linear'
% 'two state master model'

experiment_name = 'example_dataset_calibration.csv';
calibration_file = '';

run_data.downsample_factor = 2;
max_iteration = 50;
%% Dataset specific information

matfile = strcat(containing_dir, filesep, ...
  strrep(experiment_name, '.csv', '.mat'));
parameter_file = matfile;

% define data import
map.headers = {'Time (Seconds)', 'Power (W)', ...
  'Temperature_Center(deg. C)', ...
  'Temperature__Middle(deg. C)', ...
  'Temperature_Surface(deg. C)'};
map.names   = {'Time', 'input_power', 'center_temp', 'middle_temp', 'room_temp' };
map.units   = {'Sec', 'Watts', 'Celsius', 'Celsius', 'Celsius'};

%% load the data object into memory
fprintf('loading data...\n');
% filespec = strcat(strjoin(splitpath(1:end-1), filesep),filesep, experiment_name);
fileID = fopen(experiment_name);
file_data = textscan(fileID, '%s', 'Delimiter', '\n');
nlines = length(file_data{1});
data_headers = textscan(file_data{1}{1}, '%s', 'Delimiter', ',');

%% process header information
nfields = length(map.names);
for k_map = 1:nfields
  index(k_map) = find(not(cellfun('isempty', strfind(data_headers{1}, ...
  map.headers{k_map}))));
  if isempty(index(k_map))
    fprintf('%s\n',data_headers{1}{:})
    error('data field %s not found.\n', map.headers{k_map})
  end
end

%% process date number and measurement information
nan_count = 0;
for k = 2:nlines
  line_data = textscan(file_data{1}{k}, '%s', 'Delimiter', ',');
  if length(line_data{1})>1 % stop converting if data ends
%     raw_data.Time.data(k - 1,1) = line_data{1}{1};
    for k_map = 1:nfields
      raw_data.(map.names{k_map}).data(k - 1, 1) = ...
        str2double(line_data{1}{index(k_map)});
      if any(isnan(raw_data.(map.names{k_map}).data(k - 1, 1)))
        nan_count = nan_count + 1;
        warning('Nan Values in raw data vector %s at line %d.\n', ...
          map.headers{k_map}, k);
      end
    end
  else
    break
  end
end
fprintf('Total NaNs encountered while loading dataset: %d\n', nan_count);

%% Determine down sampling
if isfield(run_data, 'downsample_factor')
  dsf = run_data.downsample_factor;
else
  dsf = length(raw_data.Time.data)/2000;
end

%% determine sampling interval
sample_interval_in_seconds = dsf * mean(diff(raw_data.Time.data)); % average time step
npoints = fix(length(raw_data.Time.data) / dsf);
run_data.basetime.data = raw_data.Time.data(1) + ...
  sample_interval_in_seconds * (0 : npoints - 1)';
run_data.basetime.units = 'Seconds';
% base time in hours
run_data.Hours.data    = 1 / 3600 * sample_interval_in_seconds * (0:npoints - 1)';
run_data.Hours.units   = 'Hours';
run_data.delta_time.value    = sample_interval_in_seconds;
run_data.delta_time.units    = 'Seconds';

%% Interpolate the datasets to the uniform time grid
for kfield = 1:nfields
  field = map.names{kfield};
  run_data.(field).data = ...
      interp1(raw_data.Time.data, raw_data.(field).data, run_data.basetime.data,...
              'pchip', 'extrap');
  % set units
  run_data.(field).units = map.units{kfield};
end

%% Plot raw temperature and power data
% temperature and power
run_data.nStart = find(run_data.Hours.data >= 0, 1);
run_data.nStop  = length(run_data.Hours.data);

fields = {'Hours', 'input_power', 'center_temp', 'middle_temp', 'room_temp'};
plotRunData( run_data, fields, {'x', 'y1', 'y2', 'y2', 'y2'});

run_data.fit.max_iter = max_iteration;
run_data.fit.start  = run_data.nStart;
run_data.fit.stop   = run_data.nStop;
run_data.fit.x0 = [run_data.center_temp.data(run_data.fit.start);...
  run_data.middle_temp.data(run_data.fit.start)];
run_data.fit.fix_x0 = true;

%% Run analysis
switch run_data.model.action
  case 'predict' % predict response from a calibration run's parameters
    if exist(calibration_file, 'file') == 2
      S = load(calibration_file);
      if strcmp(run_data.model.type, S.run_data.model.type)
        param = S.run_data.model.model.Parameters;
        clear S
        parameters = [param(:).Value];
        run_data = CalibrateUserCalorimeter(run_data, parameters);
      else
        error('Prediction using model type %s requires calibration of the same type.\n',...
          run_data.model.type);
      end
    else
      fprintf('No model parameters found.\n');
    end
  case 'fit' % produce calibration parameters from the current run
    if exist('parameter_file', 'var') == 1 % use preexisting starting parameters
      if exist(parameter_file, 'file') == 2
        S = load(parameter_file);
        param = S.run_data.model.model.Parameters;
        clear S
        parameters = [param(:).Value];
        run_data = CalibrateUserCalorimeter(run_data, parameters);
      else
        run_data = CalibrateUserCalorimeter(run_data);
      end
    else
      run_data = CalibrateUserCalorimeter(run_data);
    end
    save(matfile, 'run_data')
end
fprintf('Finished.\n');
