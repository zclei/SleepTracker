%%
BWb = imbinarize(b);%,'adaptive');
figure;imagesc(BWb);
%%
a = BG;
edgth = .1*(2:9);
%%

for i = 1:8
    figure;imagesc(FG);
%     b = localcontrast(curF,.4,.5);
    b = imflatfield(BG,20);
    BWb = imbinarize(b);
    Recs = regionprops_int(BWb);
    idxA = [Recs(:).Area];
    ArenasOr = Recs(idxA>10000 & idxA<20000);
    hold on;
    for ii = 1:size(ArenasOr,1)
        rectangle('Position', ArenasOr(ii).BoundingBox, ...
            'Linewidth', 1, 'EdgeColor', 'b', 'LineStyle', '-');
        text(ArenasOr(ii).Centroid(1),ArenasOr(ii).Centroid(2),num2str(ii),...
            'color','r');
    end
end
%%
figure;imagesc(BG);

figure;imagesc(tmp(:,:,1));
figure;imagesc(curF);
%%
hold on;

for ii = 1:size(ArenasOr,1)
        rectangle('Position', ArenasOr(ii).BoundingBox, ...
            'Linewidth', 1, 'EdgeColor', 'b', 'LineStyle', '-');
        text(ArenasOr(ii).Centroid(1),ArenasOr(ii).Centroid(2),num2str(ii),...
            'color','r');
end
%%
hold on;

for ii = 1:size(Arenas,1)
        rectangle('Position', Arenas(ii).BoundingBox, ...
            'Linewidth', 1, 'EdgeColor', 'r', 'LineStyle', '-');
        text(Arenas(ii).Centroid(1),Arenas(ii).Centroid(2),num2str(ii),...
            'color','r');
end
%%
figure;
imagesc(curF);
% imagesc(FG);
%%
hold on;
for ii= 1:size(Flies,1)%flyNo
   
rectangle('Position', Flies(ii).BoundingBox, ...
            'Linewidth', 1, 'EdgeColor', 'r', 'LineStyle', '-');
        text(Flies(ii).Centroid(1),Flies(ii).Centroid(2),...
            num2str(ii),'color','r');
end
%% tracker
i=9;
k = 1085;
ct = chunk(1)+ k/5;
vobj.CurrentTime = ct;
%%
boxF = reshape([Flies(:).BoundingBox],4,[])';
boxSizeF = boxF(:,3).*boxF(:,4);


%%
mv.CurrentTime = 539.8;
a = readFrame(mv);

mv.CurrentTime = 1;
k=1;
while hasFrame(mv)
    readFrame(mv);
    ts(k)=mv.CurrentTime;
end
%%
figure;hist(dist(1,:));

%% 
figure;
plot(dist(1,:));
%%
figure;plot(distT(:,1440:1800)');
%%

hold on;
scatter(S.up,ones(1,S.bouts));
hold on;scatter(S.down,ones(1,S.bouts),'r');
%%
figure; plot(1-bw(1,:),'b','LineWidth',2);
hold on;plot(isSleep(1,:),'r','LineWidth',1);
 yticks([0,1]); xlim([0,1000]); ylim([-.2,1.2]);
 xticks((0:6:18000));xlabel('time(min)');
 xticklabels((0:1:3000));
 ax = gca;
labels = string(ax.XAxis.TickLabels); 
labelsp =string(nan(size(labels)));
labelsp(1:5:end) = labels(1:5:end); 
% labels(2:2:end) = nan;
ax.XAxis.TickLabels = labelsp; 
 title('Arena # 1, locomotion vs sleep');
 box off;
 %%
 ii  = 1;
 figure;plot(bw(ii,:))
hold on;plot(isSleep(ii,:))
figure;plot(sleepBin(ii,:));
 

%%
% mask areans
mask = zeros(1080,1920);
trim = 5;
for i = 1:aNo
   mask(Arenas(i).BoundingBox(2)+trim:...
       Arenas(i).BoundingBox(2)+Arenas(i).BoundingBox(4)-trim,...
       Arenas(i).BoundingBox(1)+trim:...
       Arenas(i).BoundingBox(1)+Arenas(i).BoundingBox(3)-trim) = 1;
end
 
 
 