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

function fillParameters (model)
% fillParameters -- given a system ID model, add the parameters as named
% variables in the calling function's workspace
  switch class(model)
    case 'idnlgrey'
      for kp = 1:length(model.Parameters)
        assignin('caller', model.Parameters(kp).Name, ...
                           model.Parameters(kp).Value)
      end
    case 'idgrey'
      for kp = 1:length(model.Structure.Parameters)
        assignin('caller', model.Structure.Parameters(kp).Name, ...
                           model.Structure.Parameters(kp).Value)
      end

    otherwise
      error('unknown model type')
  end
end
