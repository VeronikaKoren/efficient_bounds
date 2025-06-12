% computes the proportion of loss-correcting spikes as a function of
% weighting of the error with the cost g

close all
clear
%clc

% add path
addpath([cd,'/function/'])
saveres=0;

%% parameters

loadname='optimal_params';
load(loadname)

sigma_s=2;                              % sigma of the OU stimulus
tau_s=10;                               % time constant OU stimulus

nsec=1;                                 % duration of the trial in seconds 
dt=0.01;                                % time step in ms  

%% simulate network activity

[w,J] = w_fun(M,N,p_vec(3),p_vec(4));               % selectivity and connectivity
[s,x]=signal_fun(tau_s,sigma_s,tau_vec(1),M,nsec,dt); % compute the stimulus and the target signal
spikes=cell(2,1);

[spikes{1},spikes{2},xhat_e,xhat_i,re,ri] = net_fun_complete(dt,s,w,J,tau_vec,p_vec); % integrate network activity and compute estimates

%% proportion of spikes decreasing the loss
 
spiketime= cellfun(@(x)  find(sum(x))-1, spikes,'un',0);
n=cellfun(@numel, spiketime);

parvec=0.0:0.03:1;
ng=length(parvec);
n_good_loss=zeros(ng,2);

for ii=1:ng
    
    g=parvec(ii);

    [error,cost] = performance_fun(x,xhat_e,xhat_i,re,ri,g);
    
    loss=(g*error) + ((1-g).*cost);
    
    for k=1:2
        y1=loss(k,:);
        n_good_loss(ii,k)=sum((y1(spiketime{k})-y1(spiketime{k}+1))>0);
    end

end

% prop spikes descreasing the loss
prop_good_loss=n_good_loss./n';

%% plot

if saveres==1
    savefile=[cd,'/result/'];
    savename='performance_g';
    save([savefile,savename],'parvec','prop_good_loss','nsec')
    disp('saved result')
    clear
end

