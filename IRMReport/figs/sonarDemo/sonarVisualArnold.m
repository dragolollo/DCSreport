close all
clear all


step=0.1;
t=0:step:10;

theta=0;
phi=0;


vf=0.5;
vr=4;
minva=-pi/2;
maxva=pi/2;

xprec=0;
yprec=0;

visionTrajX=zeros(1,numel(t));
visionTrajY=zeros(1,numel(t));

goUp=true;

h=figure;
axis tight manual % this ensures that getframe() returns a consistent size
filename = 'testAnimated%d.png';

xlim([0 5+.5*cos(t(numel(t)))+5*t(numel(t))]);
ylim([0 5+-2*sin(t(numel(t)))+3*t(numel(t))]);
hold on

set(gca,'Box','on')
set(gca,'xtick',[])
set(gca,'ytick',[])

j=1;
jIncr=1;
sensorPositions=[deg2rad(-50) deg2rad(-15) deg2rad(15) deg2rad(50)] 

for i=1:numel(t)
    x = .5*cos(t(i))+5*t(i);
    y = -2*sin(t(i))+3*t(i); 
    
    theta=atan2(y-yprec,x-xprec);
    
    visionx=x+vr*cos(theta+phi);
    visiony=y+vr*sin(theta+phi);
    
    visionTrajX(i)=visionx;
    visionTrajY(i)=visiony;
    
    j=j+jIncr;
    if(j>4)
        j=4;
        jIncr=-1;
    elseif (j<1)
            j=1;
            jIncr=+1;
    end
    
    phi=sensorPositions(j);
    
    if(i==1)
        robotPlot=plot(x,y,'b*');
        sightPlot=plot(visionx,visiony,'r.');
        linePlot=line([visionx,x],[visiony,y]);
        
    else
        set(robotPlot,'XData',x,'YData',y);
        set(sightPlot,'XData',visionx,'YData',visiony);
        set(linePlot,'XData',[visionx,x],'YData',[visiony,y]);
    end
    
    drawnow
    
    
          % Capture the plot as an image 
      frame = getframe(h); 
      im = frame2im(frame); 
      [imind,cm] = rgb2ind(im,256); 
%       % Write to the GIF File 
%       if i == 1 
%           imwrite(imind,cm,filename,'gif', 'Loopcount',inf); 
%       else 
%           imwrite(imind,cm,filename,'gif','WriteMode','append'); 
%       end 
      path=sprintf(filename,i-1);
      imwrite(imind,cm,path);
      

      
      
    
    xprec=x;
    yprec=y;

end

xx=min(visionTrajX):.25:max(visionTrajX);
yy=spline(visionTrajX,visionTrajY,xx);


