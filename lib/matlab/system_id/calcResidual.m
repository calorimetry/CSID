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

function data = calcResidual(data, range)
% calcResudual -- calculate the residual as inferred minus modelled
node_flows  = {'out', 'stored'};

for kfl = 1:length(node_flows)
  flow = node_flows{kfl};
  node_fields = fieldnames(data.(flow));
  for knf = 1:length(node_fields)
    node = node_fields{knf};
    data.(flow).(node).residual = nan(size(data.in.all));
    data.(flow).(node).residual(range) = ...
      data.(flow).(node).inferred(range) - data.(flow).(node).modelled(range);
  end
end
