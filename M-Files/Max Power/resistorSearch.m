function [rSorted, idx] = resistorSearch( resistors )
%RESISTORSEARCH Summary of this function goes here
%   Detailed explanation goes here

rArray = zeros(31,5);
rArray(16:31,1) = 1/resistors(5);
rArray([8:15 24:31],2) = 1/resistors(4);
rArray([4:7 12:15 20:23 28:31],3) = 1/resistors(3);
rArray([2 3 6 7 10 11 14 15 18 19 22 23 26 27 30 31],4) = 1/resistors(2);
rArray(1:2:31,5) = 1/resistors(1);
R = sum(rArray,2).^-1;

[rSorted, idx] = sort(R,'descend');
% fprintf('%d,',idx);
% fprintf('\n');