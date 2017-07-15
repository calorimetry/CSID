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

function [ mx, mn, ext ] = extOfCell( cell )
% Find the max and min of arrays in a cell array

mx = nan;
mn = nan;
for k=1:length(cell)
    x = cell{k};
    mxx = max(max(x));
    mnx = min(min(x));
    mx = max(mx,mxx);
    mn = min(mn,mnx);
end
ext = mx - mn;
end

