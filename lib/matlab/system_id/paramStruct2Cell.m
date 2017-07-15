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

function param = paramStruct2Cell(parameters)
% paramStruct2Cell -- this code is used to resovle the differences in how
% parameters are orgamized for greyest and nlgreyest models. If the
% parameters are in a structure array, they are reorganized into a cell
% array as expected for a greyest model. 

nparam = length(parameters);
if iscell(parameters) % parameters are in a cell object as used by greyest models
  param = parameters;
else % parameters are a structure array and need to be turned into a cell array
  param = cell(nparam,2);
  for kp = 1:nparam
    param{kp,1} = parameters(kp).Name;
    param{kp,2} = parameters(kp).Value;
  end
end
end
