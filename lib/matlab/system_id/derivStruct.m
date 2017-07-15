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

function derivs = derivStruct(the_struct, x)
% derivStruct - recursive differentiation of the numeric fields of the_struct

  if isnumeric(the_struct)
    % derivs = derivCentered(x, the_struct);
    % derivs = derivForward(x, the_struct);
    derivs = derivBackward(x, the_struct); % 1/18/2017 DKF this give best E conservation
  else
    fields = fieldnames(the_struct);
    for kf = 1:length(fields)
      field = fields{kf};
      derivs.(field) = derivStruct(the_struct.(field), x);
    end
  end
end
