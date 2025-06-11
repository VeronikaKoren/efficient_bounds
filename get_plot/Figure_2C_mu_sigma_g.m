
clear
close all
clc

savefig=1;

test=2; % pick 1,2 or 3  
nparam_all={'mu','sigma','g'};
nparam_plt={'Metabolic constant \mu [mV]','Noise strength \sigma [mV]','Weighting error vs. cost g'};

addpath([cd,'/result/'])
savefile='/Users/vkoren/limit_spiking/figure/parameters/decreasing_loss/';

loadname=['performance_',nparam_all{test}];
load(loadname);

loadname='optimal_params';
load(loadname,'p_vec')

defaults=[p_vec(1:2)',0.7];

figname=['prop_spikes_',nparam_all{test}];

%%
prop={prop_good_loss};
namep={'decreasing loss'};

red=[0.9,0.1,0.0];
blue=[0.0,0.3,0.8];
col={red,blue};

lw=2.3;
fs=15;
pos_vec=[0,0,10,7.5];
yt=[0.6,0.8,1];
lsy={'-','--'};
npop={'Excitatory','Inhibitory'};

%%

H=figure('name',figname);

hold on
for k=1:2
    plot(parvec,prop{1}(:,k),'color',col{k},'LineStyle',lsy{k},'linewidth',lw)
end
hold off

if test==1
    for k=1:2
        text(0.65,0.7-(k-1)*0.15,npop{k},'units','normalized','color',col{k},'fontsize',fs)
    end
end
line([defaults(test) defaults(test)],[0.5,1.0],'Color','k','LineStyle',':','LineWidth',lw) % marks the default parameter

set(gca,'YTick',yt)
set(gca,'YTickLabel',yt,'fontsize',fs)

if test==1
    xt=get(gca,'XTick');
    set(gca,'XTick',[min(parvec),xt(3),xt(5)])
elseif test==2
    set(gca,'XTick',[0,7,14],'fontsize',fs)
elseif test==3
    set(gca,'XTick',[0,0.5,1],'fontsize',fs)

end
if test<3
    axis([0,max(parvec),0.45,1.05])
else
    axis([0,1,0.45,1.05])
end

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
