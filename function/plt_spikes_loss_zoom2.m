function [] = plt_spikes_loss_zoom2(spiketime,error,cost,loss,dt,figname, savefig,savefile,pos_vec)

%%

fs=15;
ms=8;
lw=1.2;
lwa=1.5;
tl=0.01;
T=size(error,2);
nsec=(T*dt)/1000;
tidx=nsec*(1:T)/T*1000;

fs=15;

xt=0:tidx(end);     % in milliseconds   
yt=0:15:75;

%purple=[0.7,0.3,0.5];
%green=[0.2,0.7,0.1];
gray=[0.5,0.5,0.5];
col={'k', 'r'};
legserror={'Error (E neurons)','Spike times (all E neurons)'};
legscost={'Cost (E neurons)','Spike times (all E neurons)'};
legsloss={'Loss (E neurons)','Spike times (all E neurons)'};
stdt=spiketime*dt ;
ns=length(spiketime);

%%

H=figure('name',figname);
tiledlayout("vertical")
nexttile()

hold on
plot(tidx,error,'color','k')
for ii=1:ns
    plot(stdt(ii),error(spiketime(ii)-1)+0.5,'rx','MarkerSize',12,'LineWidth',lw)
    box on
end
hold off
% xlabel('Time [ms]')
ylabel({'Squared'; 'error'},'fontsize',fs)
for k=1:2
    text(0.05,0.9-(k-1)*0.2,legserror{k},'color',col{k},'units','normalized','fontsize',fs-1)
end

set(gca,'LineWidth',lwa,'TickLength',[tl tl]);
set(gca,'XTick',[]);
set(gca,'YTick',yt);
set(gca,'YTickLabel',yt);
set(gca,'XTickLabel',[]);

set(H, 'Units','centimeters', 'Position', pos_vec)
set(H,'PaperPositionMode','Auto','PaperUnits', 'centimeters','PaperSize',[pos_vec(3), pos_vec(4)]) % for saving in the right size

%

nexttile()
hold on
plot(tidx,cost,'color','k')
for ii=1:ns
    plot(stdt(ii),cost(spiketime(ii)-1)+1.,'rx','MarkerSize',12,'LineWidth',lw)
    box on
end
hold off
% xlabel('Time [ms]')
ylabel({'Metabolic'; 'cost'},'fontsize',fs)

for k=1:2
    text(0.05,0.9-(k-1)*0.2,legscost{k},'color',col{k},'units','normalized','fontsize',fs-1)
end


set(gca,'LineWidth',lwa,'TickLength',[tl tl]);
% set(gca,'XTick',[]);
% set(gca,'YTick',yt);
set(gca,'YTickLabel',yt);
set(gca,'XTickLabel',[]);

set(H, 'Units','centimeters', 'Position', pos_vec)
set(H,'PaperPositionMode','Auto','PaperUnits', 'centimeters','PaperSize',[pos_vec(3), pos_vec(4)]) % for saving in the right size

%

nexttile()
hold on
plot(tidx,loss,'color','k')
for ii=1:ns
    plot(stdt(ii),loss(spiketime(ii)-1)+0.5,'rx','MarkerSize',12,'LineWidth',lw)
    box on
end
hold off
xlabel('Time [ms]','fontsize',fs)
ylabel('Loss','fontsize',fs)

for k=1:2
    text(0.05,0.9-(k-1)*0.2,legsloss{k},'color',col{k},'units','normalized','fontsize',fs-1)
end


set(gca,'XTick',xt);
set(gca,'YTick',yt);
set(gca,'YTickLabel',yt);
set(gca,'XTickLabel',xt);
set(gca,'LineWidth',lwa,'TickLength',[tl tl]);

set(H, 'Units','centimeters', 'Position', pos_vec)
set(H,'PaperPositionMode','Auto','PaperUnits', 'centimeters','PaperSize',[pos_vec(3), pos_vec(4)]) % for saving in the right size

if savefig==1
    exportgraphics(H,'zoom.svg')
    print(H,[savefile,figname],'-dpng','-r300');
end


end

