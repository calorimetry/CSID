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

function dydx = derivCentered( X, Y )
% derivCentered -- compute centered derivative of two vectors of equal
% length
%
% dydx = derivCentered( X, Y )
%
% Inputs
% X - row or column vector containing the independent variable
% Y - row or column vector containing the dependent varaible
%
% Outputs
% dydx - column vector containing the centered derivative

nx = length(X);

if nx ~= length(Y)
    error ('arrays must be equal length');
end

% ensure that the vector shape is columnar
X = X(:);
Y = Y(:);

dydx = [ (Y(2) - Y(1)) / (X(2) - X(1)); ...
         (Y(3:nx) - Y(1:nx - 2)) ./ (X(3:nx) - X(1:nx - 2)); ...
         (Y(nx) - Y(nx - 1))/(X(nx) - X(nx - 1)) ];

