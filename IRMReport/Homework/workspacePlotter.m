clear all
close all

mdl_puma560

ql=p560.qlim;
%p560.plot(qr)

stepq1=0.2;
stepq2=0.2;
stepq3=0.2;

totalIterations=numel(ql(1,1):stepq1:ql(1,2))*numel(ql(2,1):stepq2:ql(2,2))*numel(ql(3,1):stepq3:ql(3,2));

x=zeros(1,totalIterations);
y=zeros(size(x));
z=zeros(size(x));
i=1;
h = waitbar(0,'Computing workspace');
for q1=ql(1,1):stepq1:ql(1,2)
    for q2=ql(2,1):stepq2:ql(2,2)
        for q3=ql(3,1):stepq3:ql(3,2)
            Tresult=p560.fkine([q1 q2 q3 0 0 0]);
            tmp=Tresult.t';
            x(i)=tmp(1);
            y(i)=tmp(2);
            z(i)=tmp(3);
            i=i+1;
            waitbar(i/totalIterations)
        end
    end
   % fprintf("%f\n",100*(q1-ql(1,1))/(ql(1,2)-ql(1,1)));
end
delete h
subplot(1,2,1)
scatter3(x, y, z,1,1:totalIterations)

subplot(1,2,2)
P=[x' y' z'];
k=boundary(P);
trisurf(k,P(:,1),P(:,2),P(:,3),'Facecolor','red','FaceAlpha',0.1)
