% computes the proportion of error-correcting spikes and proportion of
% spikes decreasing the loss as a function of the metaboli cost mu or noise intensity sigma

close all
clear
clc

saveres=0;

test=1; % pick 1, or 2 from parameters in nparam_all
nparam_all={'mu','sigma'};
display(['measuring performance as a function of ',nparam_all{test}])

%% parameters

addpath([cd,'/function/'])
loadname='optimal_params';
load(loadname,'M','N','p_vec','tau_vec')

sigma_s=2;                              % sigma of the OU stimulus
tau_s=10;                               % time constant OU stimulus

nsec=50;                                 % duration of the trial in seconds 
dt=0.01;                                % time step in ms  
g=0.7;

%% simulate network activity as a function of parameter par

parvec_all={0:1:50;0:0.5:16};
parvec=parvec_all{test};

%%
np=length(parvec);
prop_good_loss=zeros(np,2);
prop_good_error=zeros(np,2);

for ii=1:np

    display(np-ii+1,'remaining')
    p_vec(test)=parvec(ii);

    [w,J] = w_fun(M,N,p_vec(3),p_vec(4));               % decoding weights and connectivity
    [s,x]=signal_fun(tau_s,sigma_s,tau_vec(1),M,nsec,dt); % stimulus and target signal

    spikes=cell(2,1);
    [spikes{1},spikes{2},xhat_e,xhat_i,re,ri] = net_fun_complete(dt,s,w,J,tau_vec,p_vec); % integrate network activity and compute estimates

    % proportion of spikes decreasing the loss and the error
    spiketime= cellfun(@(x)  find(sum(x))-1, spikes,'un',0);
    n=cellfun(@numel, spiketime);

    [error,~,loss] = performance_fun(x,xhat_e,xhat_i,re,ri,g);
    
    n_good_loss=zeros(2,1);
    n_good_error=zeros(2,1);
    for k=1:2
        
        y1=loss(k,:);
        n_good_loss(k)=sum((y1(spiketime{k})-y1(spiketime{k}+1))>0);
        
        y2=error(k,:);
        n_good_error(k)=sum((y2(spiketime{k})-y2(spiketime{k}+1))>0);
    end

    prop_good_loss(ii,:)=n_good_loss./n;
    prop_good_error(ii,:)=n_good_error./n;

end

%% save result

if saveres==1
    savefile=[cd,'/result/'];
    savename=['performance_',nparam_all{test}];
    save([savefile,savename],'parvec','prop_good_error','prop_good_loss','nsec','g')
    disp('saved result')
    clear
end

