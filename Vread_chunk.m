function Vout=Vread_chunk(vobj,chunk)
% reading specified chunk of the video
% chunk is defined by start time and end time.



vobj.CurrentTime=chunk(1);
No_f = int16 (vobj.FrameRate*(chunk(2)-chunk(1)));
Vout=zeros(vobj.Height,vobj.Width,No_f);
tic
k=1;
while vobj.CurrentTime< chunk(2)
        tmp = readFrame(vobj);
        Vout(:,:,k) = tmp(:,:,1);
        k=k+1;
end
toc