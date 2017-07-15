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

function [nstart, nstop] = inRange(nstart, nstop, vector)
% inRange -- adjusts nstart and nstop to ensure that the range nstart:nstop is
% in range of the vector [nstart, nstop] = inRange(nstart, nstop, vector)

if isempty(nstart)
  nstart = 1;
end
if isempty(nstop)
  nstop = length(vector);
end
nstop  = min(length(vector), nstop);
nstop  = max(2, nstop);
nstart = max(1, nstart);
nstart = min(length(vector) - 1, nstart);
end
