function VwriteXls(data,dataType,outDir,PN,FN,arenaType,binSize)

tp = datestr(now,30);
xlsName = [outDir,FN,'_',dataType{1},'_',tp];
[Noa,Nob] = size(data);
if exist(xlsName,'file')
        xlsName = [xlsName,'(copy)'];
end

Header = {PN;FN;'dataType';'arenaType';'binSize(s)';[];'Arena #\Bin #'};

xlswrite([xlsName,'.xlsx'],Header,1,'A1');
xlswrite([xlsName,'.xlsx'],{[dataType{1},dataType{2}];arenaType;binSize;[];'Avg'},1,'B3');  
xlswrite([xlsName,'.xlsx'],(1:Noa)',1,'A8');  
xlswrite([xlsName,'.xlsx'],(1:Nob),1,'C7');
xlswrite([xlsName,'.xlsx'],[nanmean(data,2),data],1,'B8');




