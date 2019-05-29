function [SSb,refPos,aerrorF]=VsleepTracking_singleVideo (FN,PN,...
    binSize,...
    arenaType,...
    outDir,...
    initialTime...
    )
path = [PN,FN];
mv=VideoReader(path);
vH = mv.Height;
vW = mv.Width;
vD = mv.Duration;
vFR = mv.FrameRate;
if nargin<5
    outDir = [PN,'\dataPlot\'];
    if ~exist(outDir,'dir')
        mkdir(outDir);
    end
end
if nargin<4
    aerrorF = {'arena type not defined'};
    return
end

if nargin<6
    initialTime = 1;
end

hw = waitbar(0,'Detecting arenas and flies...','Name','Tracking status');
%% background
vFT = vD*vFR;

% if Frame_tot>=400
% tic
    bga = nan(vH,vW,3,200);
    kf = floor(1:vFT/200:vFT);
    parfor i=1:200
        bga(:,:,:,i) = Vread_singleFrame(mv,kf(i));
    end
    BG = uint8(mean(bga(:,:,1,:),4)); clear bga;
%     h=figure;imagesc(BG);axis image;axis off;
%     hold on;title('backgroud');
% else
%     im = Vread_chunk(mv,[0 mv.Duration]);
%     BG = squeeze(mean(im(:,:,1,:),4));    
% end
% toc
%
%% find arenas and flies
mv.CurrentTime = 0;
AG = rgb2gray(readFrame(mv));
[Arenas,~,h,flySize,mask] = ArenaDetector(AG,arenaType,BG);
saveas (h, [outDir,FN,'_Arenas.png']); 
close(h);
clear h;
save([outDir,FN,'.mat'],'-regexp', '^(?!(hw)$).');
arenaNo = size(Arenas,1);

%% parallel reading by chuncks
figure(hw);
waitbar(1/4,hw,{'Arenas and flies detected';...
                'Tracking flies...'},...
                'name','Tracking status');
chunkSize = floor(vFT./48);
chunkS = ((1:chunkSize:vFT)-1)'./vFR;
chunkE = [chunkS(2:end);vD];
chunk = [chunkS,chunkE];clear chunkS chunkE;
chunk(:,3:4) = chunk.*vFR;
chunkNo = size(chunk,1);

%% tracking
tic
mv.CurrentTime = 0;
parfor i=1:chunkNo
%     disp(i);
    [Pos{i,1},errorF{i,1}] = Vtrack_chunk(mv,chunk(i,1:2),...
        BG,Arenas,i,flySize,mask);
    
end
elap = [num2str(toc),'s'];
clear i;

figure(hw);
waitbar(2/4,hw,{'Arenas and flies detected';...
                ['Tracking was done in',elap];...
                'data in plot...'},...
                'name','Tracking status');

aPos = [];
% aBox = [];
aerrorF= [];

for i=1:chunkNo
    aPos = cat(3,aPos,Pos{i});
%     aBox = cat(4,aBox,Box{i});
    aerrorF = cat(1,aerrorF,errorF{i});
end
% % loco-motion ploting
% moving distance
% binSize = 60;
refPos = aPos(:,1:2,:);

[Disb,h] = Vplot_dist(refPos,vFR,binSize);
hold on;subtitle(FN);
[flyNo,binNo] = size(Disb);
% saveas (h, [outDir,FN,'_walkingDistance_',num2str(binSize),'s.png']); 
close(h);
clear h;

% clear h;

% save([outDir,FN,'.mat'],'-regexp', '^(?!(hw)$).');


%
% % % trace plot in Arenas
% % h = figure('position',[100 200 2800 400]);
% % for i = 1:arenaNo
% %     subplot(1,arenaNo,i);
% %     plot(squeeze(aPos(i,1,:)),squeeze(aPos(i,2,:)));
% %     title(['Arena #', num2str(i)]);
% %     axis image;
% %     axis off;
% % end
% % if exist([outDir,FN,'_traces.png'],'file')
% %     saveas (h, [outDir,FN,'_traces.png']);
% % else
% %     saveas (h, [outDir,FN,'_loco.png']);
% % end
% % 
% % close(gcf);clear h;
% sleep ploting
% if sleepTog
    
    [SSb,h,SS]= Vsleep_score(Disb,400,binSize,1800,initialTime);
    hold on;subtitle(FN);
    if exist([outDir,FN,'_Sleep.png'],'file')
        saveas (h, [outDir,FN,'_Sleep(1).png']);
    else
        saveas (h, [outDir,FN,'_Sleep.png']);
    end
    close(h);
    clear h;

figure(hw);
waitbar(3/4,hw,{'Arenas and flies detected';...
                ['Tracking was done in',elap];...
                'data ploted';...
                'saving meta data...'},...
                'name','Tracking status');
            pause(1);
%     save([outDir,FN,'.mat']);
% end

%
% h = figure('position',[0 0 1500 800]);
% plot(Disb','LineWidth',1);%,'Color',[.5,.5,.5]);
% hold on;errorbar((1:binNo),mean(Disb)',nansem(Disb',2),'-ob','LineWidth',2);
% ylabel({'Walking distance';'(pixel)'});
% xlabel({'Time';['binSize:',num2str(binSize),'s']});
% saveas (h, [outDir,FN,'_walkingDistance_mean.png']);
% close(gcf);
% clear h;
%

save([outDir,FN,'.mat'],'-regexp', '^(?!(hw)$).');
disp(['data saved to:',outDir,FN,'.mat']);

figure(hw);
waitbar(4/4,hw,{'Arenas and flies detected';...
               ['Tracking was done in',elap];...
                'data ploted';...
                'meta data saved';
                'done'},...
                'Tracking status');
pause(3);
close(hw);
           
