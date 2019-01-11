eRange=150;
minLight=250;
maxLight=800;
light=minLight:0.1:maxLight;
m=eRange/(maxLight-minLight);
c=eRange/2-m*maxLight;
e=m*light+c;
plot(light,e)