
close all
clear
clc


saveres=1;
% here add the path
addpath([cd,'/function/'])

%% parameters

loadname='optimal_params';
load(loadname)

nsec=1;                                 % duration of the trial in seconds 
dt=0.01;                                 % time step in ms  

sigma_s=2;                              % sigma of the O-U stimulus
tau_s=10;                               % time constant O-U stimulus

%% simulate network activity

[w,J] = w_fun(M,N,p_vec(3),p_vec(4));               % selectivity and connectivity
[s,x]=signal_fun(tau_s,sigma_s,tau_vec(1),M,nsec,dt); % compute the stimulus and the target signal

[fe,fi,xhat_e,xhat_i,re,ri] =net_fun_complete(dt,s,w,J,tau_vec,p_vec); % integrate network activity and compute estimates

fe=int8(fe);

if saveres==1
    savefile=[cd,'/result/'];
    savename='spiking_Exc';
    save([savefile,savename],'fe','nsec')
    disp('saved result')
    clear
end



