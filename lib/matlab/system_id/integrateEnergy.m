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

function energy = integrateEnergy(power, t, range, mask)
% integrateEnergy --integrates the power versus time t over the range with
% filter applied to remove known bad data points
%
% energy = integrateEnergy(power, t, range, filter)
%
% Arguments
% power:  nx1 double array, time series of power (Watts)
% t:      nx1 double array of time (seconds)
% range:  array indicies of time series portion to be integrated
% mask:   nx1 array, 1 if point is valid, 0 if point omitted
%
% Return Values
% energy: nx1 double array with cumulative integrated energy (Joules)
%
npts = length(power);
pre  = (1:range(1))';
post = (range(end):npts)';
p_filt = power(range) .* mask(range);
energy = nan(npts,1);
energy(range) = cumtrapz(t, p_filt);
energy(pre) = 0.0;
energy(post) = energy(range(end));

end

