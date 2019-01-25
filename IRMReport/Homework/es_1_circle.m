%%Trajectory generation
close all

 if(~exist('p560','var'))
        mdl_puma560
        p560 = p560.nofriction;
 end

 %vertical robot
 q0=[0 pi/2 -pi/2 0 0 0];
 T0=p560.fkine(q0);
 p0=T0.t';
 
 cx=p0(1);
 cy=p0(2);
 height=p0(3);
 
%cartesian circle
radius=0.3;
res=100;
gran=linspace(0,2*pi,res);
cx=0.452;
cy=-0.150;
x=radius*cos(gran)+cx;
y=radius*sin(gran)+cy;
height=0.4;


for i=1:res
    TTc(:,:,i)=transl([x(i) y(i) height]);
end
qq=ikine6s(p560,TTc);

qq(:,4)=0;
qq(:,5)=0;
qq(:,6)=pi/4;

%signal for simulink

tfin=5;
timegran=size(qq);
timestep=timegran(1);
t=linspace(0,tfin,timestep);
jointsignals=timeseries(qq,t);

plot(t,qq)

%% velocity ellipsoid
close all

p560.plot(qq(1,:),'workspace',[-1.2 1.2 -1.2 1.2 -1.5 1.5])
hold on
circlePlot=plot2([x' y' height*ones(size(x'))],'LineWidth',2,'Color','g');

for i=1:numel(qq)/6
    p560.plot(qq(i,:),'delay',1/1000)
   p560.vellipse(qq(i,:),'alpha',0.4,'fillcolor','w')
end

pause
delete(circlePlot)
p560.teach('callback', @(r,q) r.vellipse(q));


%%
wn=15;
damp=0.95;
kp=wn^2;
kd=wn*damp*2;
timeStep=1e-2;

h = waitbar(0,'Running simulation...');
myoptions = simset('SrcWorkspace','current','DstWorkspace','current','FixedStep', timeStep);
sim('PDgrav',tfin,myoptions)
close(h)
beep
%%

close all
qqr=qqresult.Data;
plot2([x' y' height.*ones(size(x'))],'LineWidth',2)
hold on
p560.plot(qqr,'fps',100)

%% overlay the actual trajectory to ideal one

figure
plot2([x' y' 0.25.*ones(size(x'))],'LineWidth',2)
hold on


clear pRes
TTres=fkine(p560,qqr);
for i=1:numel(TTres)
    tmp=TTres(i);
    pRes(i,:)=tmp.t';
end
pause
plot2(pRes,'LineWidth',2,'Color','r')


