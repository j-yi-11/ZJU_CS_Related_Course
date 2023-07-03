clear all;
close all,clc;
m = input('m=');
n = input('n=');
a = rand(m,n);
% sprintf('the matrix is as follows')
a;
jytranspose(a);
findmin(a);
findmax(a);
jysort(a);
% save a.mat a
% load a.mat