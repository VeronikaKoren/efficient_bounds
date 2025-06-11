
clear
close all
clc

savefig=1;

test=3; % pick 1,2 or 3 of parameters below
nparam_all={'network_size','M','tau_s','sigma_s'};
nparam_plt={'Network size (N^E)','Number of stimuli M','Time const. stim. \tau_s [ms]','variance stimulus \sigma_s'}; % 

addpath([cd,'/result/'])
savefile='/Users/vkoren/limit_spiking/figure/parameters/decreasing_loss/';

loadname=['performance_',nparam_all{test}];
load(loadname);

%% defualt parameters

loadname='optimal_params';
load(loadname,'M','N')
tau_s=10;
sigma_s=2;

defaults=[N,M,tau_s,sigma_s];

figname=['prop_spikes_',nparam_all{test}];

%%
prop={prop_good_loss;prop_good_error};
namep={'decreasing loss','decreasing error'};

red=[0.9,0.1,0.0];
blue=[0.0,0.3,0.8];
col={red,blue};

npop={'Excitatory','Inhibitory'};
pos_vec=[0,0,10,7.5];

yt=[0.6,0.8,1];
lsy={'-','--'};
lw=2.3;
fs=15;

%%

H=figure('name',figname);

hold on
for k=1:2
    plot(parvec,prop{1}(:,k),'color',col{k},'LineStyle',lsy{k},'linewidth',lw)
end
hold off

line([defaults(test) defaults(test)],[0.5,1.0],'Color','k','LineStyle',':','LineWidth',lw)
if test==1
    for k=1:2
        text(0.65,0.9-(k-1)*0.15,npop{k},'units','normalized','color',col{k},'fontsize',fs)
    end
end

set(gca,'YTick',yt)
set(gca,'YTickLabel',yt,'fontsize',fs)

xt=get(gca,'XTick');
if numel(xt)==4
    set(gca,'XTick',xt([1,2,3]),'fontsize',fs)
else 
    set(gca,'XTick',xt([1,3,5]),'fontsize',fs)
end
if test==1
    set(gca,'XTick',[min(parvec),xt(2)+100,xt(3)+200])
else
    set(gca,'XTick',[min(parvec),xt(3),xt(5)])
end
axis([0,max(parvec),0.45,1.05])

op=get(gca,'OuterPosition');
set(gca,'OuterPosition',[op(1)+0.03 op(2)+0.03 op(3)-0.05 op(4)-0.02])

xlabel(nparam_plt{test})
if test==1
    ylabel('Prop. efficient spikes')
end

set(H, 'Units','centimeters', 'Position', pos_vec)
set(H,'PaperPositionMode','Auto','PaperUnits', 'centimeters','PaperSize',[pos_vec(3), pos_vec(4)]) % for saving in the right size

if savefig==1
    print(H,[savefile,figname],'-dpng','-r300');
end

%%
if test==2
    [~,idx]=max(prop_good_loss(:,1));
    display(parvec(idx),'optimal according to E neurons')
    [~,idx]=max(prop_good_loss(:,2));
    display(parvec(idx),'optimal according to I neurons')
end
