%%Trajectory generation
close all

 if(~exist('p560','var'))
        mdl_puma560
        p560 = p560.nofriction;
 end

qs=[0 pi/4 -pi/2 0 0 0]; % one of the many singular configurations where l1 and l2 are collinear

p560.plot(qs)
pstart=p560.fkine(qs).t';
pend=pstart-[0.2 0 0.2];

%singular positions
%pstart=[0 -0.150 0.020];
%pend=[0.5 0.3 0.5];

%correct config.
%pend=[-0.5 -0.6 0.3];
%pstart=[-0.5 -0.2 0.6];

%segment passing inside
%pend=[-0.4 -0.4 0.3];
%pstart=[+0.4 +0.3 0.6];

% qstart=[0 pi/4 0 0 0 0]; %sing cfg
% Tstart=p560.fkine(qstart);
% pstart=Tstart.t';
% pend=pstart;
% pend(2)=pend(2)-0.5;

% qend=[0 pi/2 0 0 0 0];
% qend=[pi/2 pi/2 -pi/6 0 0 0];
% Tend=p560.fkine(qend);
% pend=Tend.t';


%LINE
T1 = transl(pstart); % START
T2 = transl(pend);	% DESTINATION

res=200;
TTl=ctraj(T1,T2,res);
qq=ikine6s(p560,TTl);

qq(:,4)=0;
qq(:,5)=0;
qq(:,6)=pi/4;

% signal for simulink
 
tfin=2;
timegran=size(qq);
timestep=timegran(1);
t=linspace(0,tfin,timestep);
jointsignals=timeseries(qq,t);

plot(t,qq)

%%
close all
p560.plot(qq(1,:),'workspace',[-1.2 1.2 -1.2 1.2 -1.5 1.5])
hold on
linePlot=plot2([pstart ;pend],'LineWidth',2,'Color','g');

for i=1:numel(qq)/6
    p560.plot(qq(i,:),'delay',1/1000)
    p560.vellipse(qq(i,:),'alpha',0.4,'fillcolor','w')
end

pause
delete(linePlot)
p560.teach('callback', @(r,q) r.vellipse(q));


%%
wn=30;
damp=0.95;
kp=wn^2;
kd=wn*damp*2;
timeStep=5e-3;

h = waitbar(0,'Running simulation...');
myoptions = simset('SrcWorkspace','current','DstWorkspace','current','FixedStep', timeStep);
sim('PDgrav',tfin,myoptions)
close(h)
beep
%%


close all

subplot(1,2,1)

qqr=qqresult.Data;
plot2([pstart ;pend],'LineWidth',2)
hold on
p560.plot(qqr,'fps',100)

clear pRes
TTres=fkine(p560,qqr);
for i=1:numel(TTres)
    tmp=TTres(i);
    pRes(i,:)=tmp.t';
end
plot2(pRes,'LineWidth',2,'Color','r')

%% overlay the actual trajectory to ideal one

subplot(1,2,2)

plot3([pstart(1) ;pend(1)],[pstart(2) ;pend(2)],[pstart(3) ;pend(3)],'LineWidth',2)
hold on

plot2(pRes,'LineWidth',2,'Color','r')

