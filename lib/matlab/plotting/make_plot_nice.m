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

function make_plot_nice(plot_title,pLegend,y_title,x_title)

% Adds Title, Legend, and axis titles
% Adjusts font size

font_size = 14;

h_title = title(plot_title);
set(h_title,'FontSize',font_size);
if ~isempty(pLegend)
    h_legend = legend(char(pLegend),'location','NorthEast');
    set(h_legend,'FontSize',font_size);
end
h_label = ylabel(y_title);
set(h_label,'FontSize',font_size);
h_label=xlabel(x_title);
set(h_label,'FontSize',font_size);
%axis tic labels
set(gca,'FontSize',14)
% adjust the axis limits
% yLimits = ylim;
% yExt = 0.1*(yLimits(2)-yLimits(1));
% ylim([yLimits(1)-yExt,yLimits(2)+yExt]);
% xLimits = xlim;
% xExt = 0.1*(xLimits(2)-xLimits(1));
% xlim([xLimits(1)-xExt,xLimits(2)+xExt]);
end

