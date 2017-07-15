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

function runData = RepositionFigure( runData )
%

position = [1 1390 560 420];
if isfield(runData,'figures')
    if isfield(runData.figures,'position')
        position = runData.figures.position;
    end
end
set(gcf,'Position',position);
runData.figures.position = newPosition( position );
end

function np = newPosition( position )
%
barHeight = 70;
a = get(0,'MonitorPositions');
scrnwdth = a(3);
scrnhght = a(4);

%
width = position(3);
height = position(4);
xpvt = scrnwdth - 2*width;
x = position(1);
y = position(2);
if x > xpvt
    nx = 1;
    ny = y-height-barHeight;
else
    nx = x+width;
    ny = y;
end
if ny+height/2 < 0
    ny = scrnhght - barHeight - height;
end
np = [nx,ny,width,height];

end
