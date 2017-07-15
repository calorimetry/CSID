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

function run_data = plotPowerResiduals(run_data)
% plotPowerResiduals -- plot of power residuals
%
% run_data = plotPowerResiduals(run_data)
% Plots power residuals taken by subtracting the modelled power from the
% inferred power for both outgoing and stored fluxes, in total and by node
%
% Arguments
%
% run_data: a structure which must contain field 'power' having subfields
% corresponding to nodes the last of which is the sum of all nodes. Each
% node subfield has a subfield 'residual' containing the difference between
% measured and modelled power
%
% Return Values
%
% run_data

figure('Name', 'Residuals');
clf;
hours = run_data.Hours.data;

% set plotting behavior - default is to show both power out and stored
nplots = 2;
fields = {'out', 'stored'};
if isfield(run_data, 'figures')
  if isfield(run_data.figures, 'residuals')
    if isfield(run_data.figures.residuals, 'stored')
      if isfield(run_data.figures.residuals.stored, 'show')
        if ~run_data.figures.residuals.stored.show
          nplots = 1;
          fields = {'out'};
        end
      end
    end
  end
end
fh = nan(nplots,1);
% plot power residuals
for nplot = 1:nplots
  field = fields{nplot};
  fh(nplot) = subplot(nplots, 1, nplot);

  % yyaxis left
  node_names = fieldnames(run_data.Power.(field));
  npts = length(run_data.Power.(field).(node_names{1}).residual);
  nnodes = length(node_names);
  resid_data = nan(npts, nnodes);
  pLegend = cell(nnodes, 1);
  for kn = 1:nnodes
    resid_data(:, kn) = run_data.Power.(field).(node_names{kn}).residual;
    pLegend{kn} = node_names{kn};
  end
  plot(hours, resid_data, 'LineWidth', 2);
  set(gca, 'FontSize', 14)
  xlabel('Time (hours)', 'FontSize', 20);
  ylabel('Power Residual (Watts)', 'FontSize', 20);
  
  if strcmp(field, 'out')
    power_type = 'conducted ';
  elseif strcmp(field, 'stored')
    power_type = 'stored ';
  else
    power_type = '';
  end
  title([power_type, 'residual power'], 'FontSize', 20)
  legend(pLegend, 'Location', 'northeast', 'FontSize', 20)
  legend('boxoff')
  
  % text boxes
  ypos = 0.115 + (nplots - nplot) * 0.47;
  delta = 0.05 / nplots;
  % maximum residual
  maxstr = num2str(max(max(abs(resid_data))), '%.3f');
  str = ['Largest power residual ' maxstr ' Watts.'];
  annotation('textbox', [0.15, ypos + delta, 0.75, 0.1], ...
    'String', str, 'FitBoxToText','on', 'HorizontalAlignment', 'center',...
    'FontSize', 18, 'FontWeight', 'normal', 'Color', 'k', ...
    'LineStyle', 'none', 'VerticalAlignment', 'bottom');
  % average residual
  resid_clean_alldata = resid_data(~isnan(resid_data(:, end)), end);
  avgstr = num2str(max(max(mean(resid_clean_alldata))), '%.3f');
  stdstr = num2str(max(max(std (resid_clean_alldata))), '%.3f');
  str = ['Average power residual ' avgstr ' ± ' stdstr ' Watts.'];
  annotation('textbox', [0.15, ypos, 0.75, 0.1], ...
    'String', str, 'FitBoxToText','on', 'HorizontalAlignment', 'center',...
    'FontSize', 18, 'FontWeight', 'normal', 'Color', 'k', ...
    'LineStyle', 'none', 'VerticalAlignment', 'bottom');
end
linkaxes(fh, 'x')

% scale the size of the figure
p = get(gcf, 'position');
p(4) = p(4) * nplots;
set(gcf, 'position', p)

end
