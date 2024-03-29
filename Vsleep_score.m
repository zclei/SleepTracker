function [SSb,h,isSleep]= Vsleep_score(Dis,thresholdLoco,binSizeLoco,binSizeSleep,initialTime)
% walking distance as input
% sleep score % per 30 min as output
% walking distance binned in 10 seconds
% threshold for walking distance is 10mm per 10 seconds
if nargin<4
    initialTime = 1;
end

if isempty(thresholdLoco)
    thresholdLoco = 10;
end

%%
thresholdSleep = 300./binSizeLoco; % sleep threshold 5 mins
[flyNo,binNo]=size(Dis);
distT = Dis;
% distT(isnan(Dis)) = 0;
distT(distT<=thresholdLoco) = 0;
bw =1-(distT>0);
bw(isnan(distT)) = nan;

% mask time windows that flies are lost track
idxNan = isnan(distT);
edgeNan = diff([zeros(flyNo,1),idxNan,zeros(flyNo,1)],[],2); 


%%
isSleep=zeros(flyNo,binNo);
isSleep(idxNan) = nan;
% edge = diff([zeros(flyNo,1),bw,zeros(flyNo,1)],[],2); 

for j = 1:flyNo
    % wrap Nans with 0s
    curBw = bw(j,:)';
    nanUp = find(edgeNan(j,:)'>0);
    nanDown = find(edgeNan(j,:)'<0)-1;
    
    curBw(nanUp(:)) = 0;
    curBw(nanDown(:)) = 0;
    curEdge = diff([0;curBw;0]);

    S(j).up = find(curEdge>0);
    S(j).down = find(curEdge<0)-1;
    S(j).bouts = size(S(j).up,1);
    S(j).dur = S(j).down-S(j).up+1;
    sidx = find(S(j).dur>=thresholdSleep);
    for i = 1:size(sidx,1)
%         isSleep(j,S(j).up(sidx(i)):S(j).down(sidx(i))) = ...
%             isSleep(j,S(j).up(sidx(i)):S(j).down(sidx(i)))+1;
                isSleep(j,S(j).up(sidx(i)):S(j).down(sidx(i))) = 1;
    end
   
end
%% 

SSb = 30*binSizeLoco*...
    binn(isSleep,binSizeSleep./binSizeLoco,2)./binSizeSleep;
% SSb = binSizeLoco*...
%     binn_ratio(isSleep,binSizeSleep./binSizeLoco,2)./60;
binNoS = size(SSb,2);

%% plot sleep trace of single fly


%% 
% h1 = figure;plot(SS');
% % hold on; plot(mean(SS),'LineWidth',2);
% % hold on;errorbar(nanmean(SS),nansem(SS,1),'b','LineWidth',2);
% 
% box off;
% ylabel('Sleep (min/30min)');
% xlabel('ZT (hr)');
% 
% hr = ceil(binSizeSleep*binNoS./3600);
% if hr>6
%     xtickstep = uint8(3600./binSizeSleep);
%     xlim([0,binNoS+xtickstep]);
%     xticks((0:1:binNoS));
% %     ax = gca;
% %     labels = string(ax.XAxis.TickLabels);
%     
%     ZT = repmat((1:1:24),1,4);
%     st = find(ZT==floor(initialTime));
%     ZTlabel = ZT(st(1):st(1)+hr+1);
%     labelsp =string(nan(binNoS+xtickstep,1));
%     labelIdx = 1:xtickstep:binNoS+xtickstep;
%     labelsp(labelIdx) = string(ZTlabel(1:length(labelIdx)));
%     xticklabels(labelsp);
% else
%     xticklabels((0:binNoS+1));
% end
%%
% h = figure('position',[50,-400,400,1000],'color',[1,1,1]);
%     imagesc(SS.*30);colorbar;
%     yticks([(1:9:flyNo),flyNo]);
%     ylabel({'Arena #'});
%     xlabel(['Time (',num2str(binSizeSleep./60),'min)']);
%     

%%
% plotSq = [1:8:8*ceil(flyNo/8),...
%           2:8:8*ceil(flyNo/8),...
%           3:8:8*ceil(flyNo/8),...
%           4:8:8*ceil(flyNo/8),...
%           5:8:8*ceil(flyNo/8),...
%           6:8:8*ceil(flyNo/8),...
%           7:8:8*ceil(flyNo/8),...
%           8:8:8*ceil(flyNo/8)]';
% ceil(flyNo./8)
%%
ym = prctile(Dis(:),99.95);
ym = 50*ceil(ym./50);
h = figure('position',[50,-400,2400,2000],'color',[1,1,1]);
for i = 1:flyNo
    subplot(2,9,i);%plotSq(i));
    bar(Dis(i,:)','LineWidth',1);
    hold on; plot(.3*ym*isSleep(i,:),'LineWidth',1);
    ylim([0,ym]);
%     ylabel({'Walking distance / Sleep'});
%     xlabel(['Time (',num2str(binSize),'s)']);
    
    title(['Arena #', num2str(i)]);
end





end


