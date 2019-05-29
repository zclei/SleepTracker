function idx = Vtrack_emptyArena(aBox, fPos)

aNo = size(aBox,1);
idx = zeros(aNo,1);

for i=1:aNo
    d = fPos-aBox(i,1:2);
    widx(:,i) =(d(:,1)<=aBox(i,3)&...
                d(:,1)>= 0&...
                d(:,2)<=aBox(i,4)&...
                d(:,2)>= 0);
    if sum(widx(:,i))==1
        idx(i) = find(widx(:,i));
    end
    
end
idx = uint8(idx);
%%
% for i=1:7
% rectangle('Position', Flies(i).BoundingBox, ...
%             'Linewidth', 1, 'EdgeColor', 'r', 'LineStyle', '-');
% end
