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

function padded_data = nanpad (data, full_range_size, subrange)
% padded_data = nanpad (data, full_range_size, subrange)
% pad the numeric fields of a structure with nans if they fall outside
% the subrange of fullrange. All of the numeric fields are assumed to be
% the size of subrange

% this code is useful for padding model results when the model is fit to a
% subset of the full dataset

  if isnumeric(data)
    padded_data = nan(full_range_size);
    padded_data(subrange) = data;
  else
    fields = fieldnames(data);
    for kf = 1:length(fields)
      field = fields{kf};
      padded_data.(field) = nanpad(data.(field), full_range_size, subrange);
    end
  end

end
