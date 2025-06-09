
close all
clear
%clc

figname='spike_triggered';
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

[w,J] = w_fun(M,N,p_vec(3),p_vec(4));               % decoding weights and connectivity matrices

[s,x]=signal_fun(tau_s,sigma_s,tau_vec(1),M,nsec,dt); % compute the stimulus and the target signal

[fe,fi,xhat_e,xhat_i,re,ri] =net_fun_complete(dt,s,w,J,tau_vec,p_vec); % integrate biophysical model

%% get eror cost and loss over time

gL=0.7; % weighting of the error with the cost; 0<gL<1
[error,cost,loss] = performance_fun(x,xhat_e,xhat_i,re,ri,gL);

%% compute spike-triggered error, cost and loss

[~,sptime,~]= find(fe);

prespike = 10;
posspike = 10;
sterrore = zeros(length(sptime),prespike+posspike+1);
stmetce = zeros(length(sptime),prespike+posspike+1);
stlosse = zeros(length(sptime),prespike+posspike+1);
for i=1:length(sptime)
    if (sptime(i)-prespike>0) && (sptime(i)+prespike<size(fe,2))
        sterrore(i,:) = error(1,sptime(i)+(-prespike:posspike));
        stmetce(i,:) = cost(1,sptime(i)+(-prespike:posspike));
        stlosse(i,:) = loss(1,sptime(i)+(-prespike:posspike));
    end
end

% spikes_locationi = find(fi);
[~,sptime,~]= find(fi);
sterrori = zeros(length(sptime),prespike+posspike+1);
stmetci = zeros(length(sptime),prespike+posspike+1);
stlossi = zeros(length(sptime),prespike+posspike+1);

for i=1:length(sptime)
    if (sptime(i)-prespike>0) && (sptime(i)+prespike<size(fi,2))
        sterrori(i,:) = error(2,sptime(i)+(-prespike:posspike));
        stmetci(i,:) = cost(2,sptime(i)+(-prespike:posspike));
        stlossi(i,:) = loss(2,sptime(i)+(-prespike:posspike));
    end
end

sterrore = mean(sterrore,1);
sterrori = mean(sterrori,1);

mstmetce = mean(stmetce,1);
mstmetci = mean(stmetci,1);

stlosse = mean(stlosse,1);
stlossi = mean(stlossi,1);

%%

fs=10;
ms=8;
lw=1.7;
lwa=1;
tl=0.01;


red=[0.85,0.32,0.1];
blue=[0,0.48,0.74];
gray=[0.5,0.5,0.5];
col={red,blue};
fs=10;
lw=1.7;

namepop={'E neurons','I neurons'};
pos_vec = [0, 0, 16, 6];
%% plot spike-triggered error, cost and loss

H=figure('name',figname);

tiledlayout(1,3, "TileSpacing","tight","Padding","loose")
nexttile
plot((-prespike:posspike)*dt, sterrore,'color',red, 'linewidth',lw-0.5); hold on;
plot((-prespike:posspike)*dt, sterrori, '-.','color',blue,'linewidth',lw+0.5)

set(gca,'Fontsize',fs)
xlabel('Time [ms]')
title('Squared error')

nexttile
plot((-prespike:posspike)*dt, mstmetce,'color',red, 'linewidth',lw-0.5); hold on;
plot((-prespike:posspike)*dt, mstmetci, '-.','color',blue,'linewidth',lw+0.5)

set(gca,'Fontsize',fs)
xlabel('Time [ms]')
title('Metabolic cost')
legend('\color[rgb]{0.85,0.32,0.1} E neurons','\color[rgb]{0,0.48,0.74} I neurons','Location','best')


nexttile
plot((-prespike:posspike)*dt, stlosse ,'color',red, 'linewidth',lw-0.5); hold on;
plot((-prespike:posspike)*dt, stlossi , '-.','color',blue,'linewidth',lw+0.5)

set(gca,'Fontsize',fs)
xlabel('Time [ms]')
title('Loss')

set(H, 'Units','centimeters', 'Position', pos_vec)
set(H,'PaperPositionMode','Auto','PaperUnits', 'centimeters','PaperSize',[pos_vec(3), pos_vec(4)]) % for saving in the right size
% exportgraphics(H,'sp_triggered.svg')
if savefig(1)==1
    print(H,[savefile,figname],'-dpng','-r300');
end

%%