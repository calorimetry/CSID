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

function [dxdt, y] = TwoStateMasterModel ...
  (t, x, u,...        % time, state and input vectors
  ca0, ca1, ca2,...   % 1st, 2nd & 3rd order non-linear parameters for ca
  cb0, cb1, cb2,...   % 1st, 2nd & 3rd order non-linear parameters for cb
  kas0, kas1, kas2,...% 1st, 2nd & 3rd order non-linear parameters for kab
  kab0, kab1, kab2,...% 1st, 2nd & 3rd order non-linear parameters for kab
  kbs0, kbs1, kbs2,...% 1st, 2nd & 3rd order non-linear parameters for kbs
  varargin)

dxdt = TwoStateMasterDynamics ...
  (t, x, u,...        % time, state and input vectors
  ca0, ca1, ca2,...   % 1st, 2nd & 3rd order non-linear parameters for ca
  cb0, cb1, cb2,...   % 1st, 2nd & 3rd order non-linear parameters for cb
  kas0, kas1, kas2,...% 1st, 2nd & 3rd order non-linear parameters for kab
  kab0, kab1, kab2,...% 1st, 2nd & 3rd order non-linear parameters for kab
  kbs0, kbs1, kbs2);  % 1st, 2nd & 3rd order non-linear parameters for kbs
y = x;                % the outputs are the temperature states
