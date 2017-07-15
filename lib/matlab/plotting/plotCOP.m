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

function run_data = plotCOP(run_data)
% plotCOP -- plot of input power, output+stored power and COP for modelled
% and inferred datasets
%
% run_data = plotCOP(run_data)
% Plots the measured input power, inferred power (out + stored) and energy COP
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
figure('Name', 'Energy COPs');
clf;
hours = run_data.Hours.data;

nplots = 2;
fields = {'modelled', 'inferred'};

% Use plotyy or yyaxis as appropriate to the version of matlab calling plotCOP
Matlab2016VersionString = '9.0';
if(verLessThan('matlab', Matlab2016VersionString)) % for Matlab releases < 2016
  % use plotyy because yyaxis is not available
  for nplot = 1:nplots
    field = fields{nplot};
    fh(nplot) = subplot(nplots, 1, nplot);

    % make the plot
    [hax,hleft,hright] = ...
      plotyy([hours,hours], [run_data.Power.in.all,...
      run_data.Power.out.all.(field) + ...
      run_data.Power.stored.all.(field)],...
      hours, run_data.Energy.COP.all.(field));

    % format the plot
    set(hax(1), 'FontSize', 14)
    set(hax(2), 'FontSize', 14)
    hleft(1).LineWidth = 2;
    hleft(2).LineWidth = 2;
    hright(1).LineWidth = 2;

    xlabel('Time (hours)', 'FontSize', 20);
    ylabel(hax(1),'Power (Watts)', 'FontSize', 20);
    ylabel(hax(2),'\it \fontname{Times} COP_{energy}', 'FontSize', 20);
    ylim(hax(2),[.5 1.5])

    title([field, ' power and energy COP'], 'FontSize', 20)
    pLegend{1} = '\it \fontname{Times} P_{in}';
    pLegend{2} = '\it \fontname{Times} P_{out} + P_{stored}';
    pLegend{3} = '\it \fontname{Times} COP_{energy}';
    legend(pLegend, 'Location', 'northeast', 'FontSize', 20)
    legend('boxoff')

    numCOPs = ...
      run_data.Energy.COP.all.(field)(~isnan(run_data.Energy.COP.all.(field)));
    endstr = num2str(numCOPs(end), '%.4f');
    str = ['Ending energy COP ' endstr ];
    annotation('textbox', [0.15, 0.05 + (2-nplot) * 0.48, 0.75, 0.1], ...
      'String', str, 'FitBoxToText','on', 'HorizontalAlignment', 'center',...
      'FontSize', 18, 'FontWeight', 'normal', 'Color', 'k', 'LineStyle', 'none');
  end

  linkaxes(fh, 'x')
  set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 0.4 0.9]);
  
else % otherwise the Matlab version is new so use yyaxis
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
    pright = plot(hours, run_data.Energy.COP.all.(field), 'r');
    pright(1).LineWidth = 1;
    ylabel('\it \fontname{Times} COP_{energy}', 'FontSize', 20);
    ylim([.5 1.5])

    title([field, ' power and energy COP'], 'FontSize', 20)
    pLegend{1} = '\it \fontname{Times} P_{in}';
    pLegend{2} = '\it \fontname{Times} P_{out} + P_{stored}';
    pLegend{3} = '\it \fontname{Times} COP_{energy}';
    legend(pLegend, 'Location', 'northeast', 'FontSize', 20)
    legend('boxoff')
    numCOPs = ...
      run_data.Energy.COP.all.(field)(~isnan(run_data.Energy.COP.all.(field)));
    endstr = num2str(numCOPs(end), '%.4f');
    str = ['Ending energy COP ' endstr ];
    annotation('textbox', [0.15, 0.05 + (2-nplot) * 0.48, 0.75, 0.1], ...
      'String', str, 'FitBoxToText','on', 'HorizontalAlignment', 'center',...
      'FontSize', 18, 'FontWeight', 'normal', 'Color', 'k', 'LineStyle', 'none');

  end

  linkaxes(fh, 'x')
  set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 0.4 0.9]);

end
