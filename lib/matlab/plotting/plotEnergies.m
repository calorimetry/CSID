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

function run_data = plotEnergies(run_data)
% plotEnergies --plot of input, modeled and inferred energies

figure('Name', 'Energies');
clf;

% title
nplots = 1;
nplot = 1;
fh(nplot) = subplot(nplots, 1, nplot);
if isfield(run_data, 'filename')
  plotData.title = strrep(run_data.filename, '_', '-');
else
  plotData.title = '';
end

% define axis titles
plotData.x_title = 'Time (hours)';
plotData.y1_title = 'Energy In and Out (Joules)';
plotData.y2_title = 'Residual Energy (Joules)';

% left y
fit_range = run_data.fit.start:run_data.fit.stop;
hours = run_data.Hours.data(fit_range);
plotData.x1{1} = [hours, hours, hours];
plotData.y1{1} = [run_data.Energy.in.all(fit_range), ...
                  run_data.Energy.out.all.modelled(fit_range), ...
                  run_data.Energy.out.all.inferred(fit_range)];
pLegend{1} = 'Energy In';
pLegend{2} = 'Energy Out Modelled';
pLegend{3} = 'Energy Out Inferred';

% right y
plotData.x2{1} = hours;
plotData.y2{1} = run_data.Energy.out.all.residual(fit_range);
pLegend{4} = 'Residual Energy';

% make plot
[leftAxis, rightAxis, leftLine, rightLine] = NiceYYPlot(plotData);
legend(pLegend, 'Location', 'southeast')
linkaxes(fh, 'x')
run_data = RepositionFigure(run_data);
end
