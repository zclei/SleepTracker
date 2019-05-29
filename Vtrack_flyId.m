function [refPos, id, err,FliesOut] = Vtrack_flyId(aBox,Flies,rnd,frame,flySize)
% aBox, arena box by x1,y1,w,l
% fPos, fly centroid
% rnd, loop rounds
% frame, frame #
fPos = (reshape([Flies(:).Centroid],2,[]))';
fNo = size(fPos,1);
aNo = size(aBox,1);
id = nan(aNo,1);
refPos = nan(aNo,4);
err = [];
for ii = 1:fNo
    Flies(ii).id = ii;
end
widx = zeros(fNo,aNo)>0;
% FliesOut = struct;%repmat(Flies(1),aNo,1);

for i=1:aNo
    d = (fPos-aBox(i,1:2));
    widx(:,i) =(d(:,1)<=aBox(i,3)&...
        d(:,1)>= 0&...
        d(:,2)<=aBox(i,4)&...
        d(:,2)>= 0);
    curNo = sum(widx(:,i));
    %     disp(i);
    %     disp(curNo);
    if curNo ==0
        id(i) = nan;
        err = [rnd,frame,i,fNo];
%         disp(err);
        continue
    end
    
    curFlies = Flies(widx(:,i));
    [~,idx] = max([curFlies(:).Area]);
    id(i) = curFlies(idx).id;
    FliesOut(i) = Flies(id(i)); 
    refPos(i,1:2) = fPos(id(i),:)-aBox(i,1:2)+0.5*aBox(i,3:4);
    refPos(i,3:4) = fPos(id(i),:);
end
 FliesOut = FliesOut';