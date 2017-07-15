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

function dydx = derivBackward( X, Y )
% derivBackward -- compute backward derivative of two vectors of equal
% length
%
% dydx = derivBackward( X, Y )
%
% Inputs
% X - row or column vector containing the independent variable
% Y - row or column vector containing the dependent varaible
%
% Outputs
% dydx - column vector containing the backward derivative

nx = length(X);

if nx ~= length(Y)
    error ('arrays must be equal length');
end

% ensure that the vector shape is columnar
X = X(:);
Y = Y(:);

dydx = [ (Y(2:nx) - Y(1:nx-1)) ./ (X(2:nx) - X(1:nx-1)); 0 ];

