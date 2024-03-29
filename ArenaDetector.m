function [Arenas,Flies,h,flySize,mask,ppm] = ArenaDetector(FG,chamberType,BG)
% for rectangualr arean detection in sleep chamber
% grayscale image prefered

if nargin<2
    chamberType = 'rec';
end

if nargin<3
   BWb = imbinarize(FG);

else
   b = imflatfield(BG,10);
   BWb = imbinarize(b);

end



switch chamberType
    case('rec14')
        arenaSize = [40000,80000];
        aRow = 1;aCol = 14;
    case('rec28')
        arenaSize = [20000,40000];
        aRow = 2;aCol = 14;
    case('rec72')
        arenaSize = [10000,20000];
        aRow = 8;aCol = 9;
        
        %%% circul wells
    case('rnd8')
        arenaSize = [80000,130000];
        aRow = 2;aCol = 4;
        realSize = [18,18]; % diameter by mm
        BWb = imbinarize(BG);
    case('rnd18')
        
        aRow = 4;aCol = 5;
    case('rnd50')
        arenaSize = [80000,100000];
        aRow = 5;aCol = 10;
end

Recs = regionprops_int(BWb);
[~,asq] = sort([Recs(:).Area]);
Recs = Recs(asq);
areA = [Recs(:).Area];
boxA = reshape([Recs(:).BoundingBox],4,[]);
idxA = boxA(3,:).*boxA(4,:);

ArenasOr = Recs(idxA>arenaSize(1)& idxA<arenaSize(2) &...
            areA>arenaSize(1) & areA < arenaSize(2));

% sort Arenas
Apos = reshape([ArenasOr(:).Centroid],2,[])';
Apos = Apos - min(Apos);
interval = max(Apos)./[aCol-1,aRow-1];
Apos = round(Apos./interval);
[~,sq] = sortrows(Apos,[2,1],'ascend');
Arenas = ArenasOr(sq,:);
aNo = size(Arenas,1);
Abox = reshape([Arenas(:).BoundingBox],4,[])';
ppm = mean(Abox(:,3:4))./realSize;
ppm= mean(ppm);


% Arena mask
mask = zeros(size(BG));
trim = 5;
for i = 1:aNo
   mask(Arenas(i).BoundingBox(2)+trim:...
       Arenas(i).BoundingBox(2)+Arenas(i).BoundingBox(4)-trim,...
       Arenas(i).BoundingBox(1)+trim:...
       Arenas(i).BoundingBox(1)+Arenas(i).BoundingBox(3)-trim) = 1;
end
% detect flies
[Flies,flySize] = FlyDetector(FG,Arenas,BG,chamberType,mask);
fNo = size(Flies,1);

if aNo == 0 || fNo == 0
    hold on;
    title('No arenas or flies found');
    return
end

% % remove empty arenas
% arenaBox = (reshape([Arenas(:).BoundingBox],4,[]))';
% flyPos = (reshape([Flies(:).Centroid],2,[]))';
% idxF = Vtrack_emptyArena(arenaBox, flyPos);
% Arenas(~idxF) = [];
% aNo = size(Arenas,1);
% idxF_or = idxF;
% idxF(idxF==0) = [];
% Flies=Flies(idxF);

% show the image and draw the detected Arenas on it
h = figure;imshow(FG); 
hold on;
for k = 1:aNo
%         Arenas(k).BoundingBox = round(Arenas(k).BoundingBox);
%         Msk = mk;
%         Msk(Arenas(k).BoundingBox(2) : Arenas(k).BoundingBox(2)+Arenas(k).BoundingBox(4) ,...
%             Arenas(k).BoundingBox(1) : Arenas(k).BoundingBox(1)+Arenas(k).BoundingBox(3)) = 1;
%         Arenas(k).bw = poly2mask(xi,yi,m,n);
        rectangle('Position', Arenas(k).BoundingBox, ...
            'Linewidth', 1, 'EdgeColor', 'b', 'LineStyle', '-');
        text(Arenas(k).Centroid(1),Arenas(k).Centroid(2),num2str(k),'color','b');
%         Arenas(k).msk = Msk>0; 
end
for i=1:fNo
    rectangle('Position', Flies(i).BoundingBox, ...
            'Linewidth', 1, 'EdgeColor', 'r', 'LineStyle', '-.','LineWidth',.5);
%     hold on;plot(Flies(i).Centroid(1),Flies(i).Centroid(2),'ro');
%     text(Flies(idxF(k)).Centroid(1),Flies(idxF(k)).Centroid(2),num2str(k),'color','r');

end
title(['A total of ',num2str(aNo),' arenas found']);



% text(920,0,['A total of ',num2str(k),'arenas found']);