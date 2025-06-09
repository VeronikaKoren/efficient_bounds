
close all
clear
%clc

figname='spikes_loss_zoom';
savefig=0;
savefile=pwd;

% here add path
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

%% get error, cost and loss

gL=0.7; % weighting of the error with the cost; 0<gL<1
[error,cost,loss] = performance_fun(x,xhat_e,xhat_i,re,ri,gL);

%%

fs=10;
ms=8;
lw=1.7;
lwa=1;
tl=0.01;

pos_vec=[0,0,16,12];

zoomint=1:800;
errorzoom = error(1,zoomint);
losszoom = loss(1,zoomint);
costzoom = cost(1,zoomint);
spiketime=find(sum(fe(:,zoomint)));

plt_spikes_loss_zoom2(spiketime, errorzoom, costzoom, losszoom,dt,figname, savefig,savefile,pos_vec)


