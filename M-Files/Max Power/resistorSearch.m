function [rSorted, idx] = resistorSearch(initial, adder)
%RESISTORSEARCH Summary of this function goes here
%   Detailed explanation goes here

R1 = initial;
R2 = R1+adder;
R3 = R2+adder;
R4 = R3+adder;
R5 = R4+adder;

rArray = zeros(31,5);
rArray(16:31,1) = 1/R5;
rArray([8:15 24:31],2) = 1/R4;
rArray([4:7 12:15 20:23 28:31],3) = 1/R3;
rArray([2 3 6 7 10 11 14 15 18 19 22 23 26 27 30 31],4) = 1/R2;
rArray(1:2:31,5) = 1/R1;
R = sum(rArray,2).^-1;

[rSorted, idx] = sort(R,'descend');
fprintf('%d,',idx(7:31));
fprintf('\n');