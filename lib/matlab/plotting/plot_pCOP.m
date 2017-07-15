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

function run_data = plot_pCOP(run_data)
% plot_pCOP -- plot of the power COP for modelled
% and inferred datasets
%
% run_data = plot_pCOP(run_data)
% Plots the measured input power, inferred power (out + stored) and power COP
% of the fitted model/data contained in the run_data input struct
%
% Arguments
%
% run_data : [structure] A structure containing experiment data, a fitted
%                        system identification model and other relevant
%                        variables
%
% Return Values
%
% run_data : [structure] The same as the input structure
%
figure('Name', 'power COPs');
clf;
hours = run_data.Hours.data;

nplots = 2;
fields = {'modelled', 'inferred'};
if isfield(run_data.fit, 'input_power_threshold')
  power_min = run_data.fit.input_power_threshold;
else
  power_min = 1; % minimum power for ploting power COP
end
if isfield(run_data.fit, 'input_power_COP_threshold')
  power_COP_min = run_data.fit.input_power_COP_threshold;
else
  power_COP_min = 10; % minimum power for reporting power COP statistics
end

for nplot = 1:nplots
  field = fields{nplot};
  fh(nplot) = subplot(nplots, 1, nplot);

  yyaxis left
  pleft = plot(hours, run_data.Power.in.all, '-b', ...
    hours, run_data.Power.out.all.(field) + ...
    run_data.Power.stored.all.(field), ':g');
  set(gca, 'FontSize', 14)
  pleft(1).LineWidth = 2;
  pleft(2).LineWidth = 2;
  xlabel('Time (hours)', 'FontSize', 20);
  ylabel('Power (Watts)', 'FontSize', 20);

  yyaxis right
  power_cop = run_data.Power.COP.all.(field);
  power_cop(run_data.Power.in.all < power_min) = nan;
  pright = plot(hours, power_cop, 'r');
  pright(1).LineWidth = 1;
  ylabel('\it \fontname{Times} COP_{power}', 'FontSize', 20);
  ylim([.5 1.5])

  title([field, ' power and power COP'], 'FontSize', 20)
  pLegend{1} = '\it \fontname{Times} P_{in}';
  pLegend{2} = '\it \fontname{Times} P_{out} + P_{stored}';
  pLegend{3} = '\it \fontname{Times} COP_{power}';
  legend(pLegend, 'Location', 'northeast', 'FontSize', 20)
  legend('boxoff')

  valid_data = all([run_data.Power.in.all > power_COP_min, ...
                    ~isnan(run_data.Power.COP.all.(field))], 2);
  power_COP_avg = mean ...
    (run_data.Power.COP.all.(field)(valid_data));
  power_COP_std = std ...
    (run_data.Power.COP.all.(field)(valid_data));

  pmin_str = num2str(power_COP_min, '%.3f');
  COP_str  = num2str(power_COP_avg, '%.4f');
  COP_std_str  = num2str(power_COP_std, '%.4f');
  str = ['For P_{in} > ' pmin_str ' Watts' char(10) 'Power COP = ' COP_str ' ± ' COP_std_str];
  annotation('textbox', [0.15, 0.1 + (2-nplot) * 0.48, 0.75, 0.1], ...
    'String', str, 'FitBoxToText','on', 'HorizontalAlignment', 'center',...
    'FontSize', 18, 'FontWeight', 'normal', 'Color', 'k', 'LineStyle', 'none');

end

linkaxes(fh, 'x')
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 0.4 0.9]);


