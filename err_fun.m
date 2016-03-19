%clear all; close all;
function [total_err] = err_fun(params,T_frames)
%alp = 450; bet = 850; lam = 110; mu = 200;
%params = [alp,bet,lam,mu];
%T_frames = [25,90,185,290];
a=1; b = 308;

fname = csvread('waterfront_new.csv');

%% Compute piecewise segment Qi for four frames
%T_frames = a:1:b ;

Q = nubs(params,T_frames);

%% Compute error for curve of four frames

tot_err = 0; % Minimize this

for i=1:4
    
    cur_frame = T_frames(i);
    all_data = fname(cur_frame,fname(cur_frame,:) ~= 0);
    
    err = sum((Q(i) - all_data).^2); 
    tot_err = tot_err + err;
    
end

total_err = tot_err;

end