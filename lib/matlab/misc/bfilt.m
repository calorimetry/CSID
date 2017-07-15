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

function y=bfilt(x)

% Blaise Filter for row vector x

l=length(x);


m(1,:)=[2*x(1)-x(3) 2*x(1)-x(2) x(1:l-2)];
m(2,:)=[2*x(1)-x(2) x(1:l-1)];
m(3,:)=x;
m(4,:)=[x(2:l) 2*x(l)-x(l-1)];
m(5,:)=[x(3:l) 2*x(l)-x(l-1) 2*x(l)-x(l-2)];

b=[0 .25 .5 .25 0];
y=b*sort(m);

