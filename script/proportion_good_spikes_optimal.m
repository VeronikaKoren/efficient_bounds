% computes the proportion of error-correcting spikes and proportion of
% spikes decreasing the loss for the default set of parameters

close all
clear
clc

addpath([cd,'/function/'])

%% parameters

loadname='optimal_params';
load(loadname,'M','N','p_vec','tau_vec')

sigma_s=2;                              % sigma of the OU stimulus
tau_s=10;                               % time constant OU stimulus

nsec=10;                                 % duration of the trial in seconds 
dt=0.01;                                % time step in ms  

%gL=0.5;
mu=p_vec(1);

%% simulate network activity and get spike times

[w,J] = w_fun(M,N,p_vec(3),p_vec(4));               % selectivity and connectivity
[s,x]=signal_fun(tau_s,sigma_s,tau_vec(1),M,nsec,dt); % compute the stimulus and the target signal

spikes=cell(2,1);

[spikes{1},spikes{2},xhat_e,xhat_i,re,ri] = net_fun_complete(dt,s,w,J,tau_vec,p_vec); % integrate network activity and compute estimates
spiketime= cellfun(@(x)  find(sum(x))-1, spikes,'un',0);
n=cellfun(@numel, spiketime);

%% proportion of spikes decreasing the loss
 
[error,cost,loss] = performance_fun(x,xhat_e,xhat_i,re,ri,mu);

n_good_loss=zeros(2,1);
n_good_error=zeros(2,1);
for k=1:2
    y1=loss(k,:);
    n_good_loss(k)=sum((y1(spiketime{k})-y1(spiketime{k}+1))>0);

    y2=error(k,:);
    n_good_error(k)=sum((y2(spiketime{k})-y2(spiketime{k}+1))>0);
end

prop_good_loss=n_good_loss./n;
prop_good_error=n_good_error./n;

%%

display(prop_good_loss','proportion of spikes decresing the loss in E and I population')
display(prop_good_error','proportion of spikes decreasin the error in E and I population')
