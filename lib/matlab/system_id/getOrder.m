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

function [ order ] = getOrder( varLabels )
% getOrder -- Produce a row vector containing the order of model based on
% its variable labels
% It is necessary to pass the model order to nonlinear system
% identification codes
%
% order = [ nOutputs, nInputs, nStates]

order = [length(varLabels.OutputName),...
         length(varLabels.InputName),...
         length(varLabels.StateName)];
end

