if(initSim)
    %%
    
    close all
    
    uncertain=true;
    
    if(~exist('p560','var') || ~exist('p560Unc','var'))
        mdl_puma560
        p560 = p560.nofriction;
        
        MyUncertainPumaCreation
        p560Unc = p560Unc.nofriction;
    end
    
    if(uncertain)
        p560_canc=p560Unc;
    else
        p560_canc=p560;
    end
    
    %%
    %q0=[-pi -pi +3/2*pi -pi 0 +pi/4];
    %qf=[pi pi -3/2*pi pi 0 -pi/4];
    
    q0=[0 pi/4 -pi 0 0 0];
    qf=[3/4*pi 3/4*pi -pi 0 0 0];
    
    %q0=[-pi/4 -pi/4 -pi 0 0 0];
    %qf=[3/4*pi -3/4*pi pi 0 0 0];
    
    wn=20;
    damp=0.8;
    kp=wn*wn;
    kd=2*wn*damp;
    
    timeStep=5e-3;
    trajStep=5e-3;
    
    tfin=2;
    
else
    %%
    
    
    close all
    clear pRes
    
    qTraj=trajectory.Data;
    
    p560.plot(q0)
    hold on
    
    TTTRaj=fkine(p560,qTraj);
    for i=1:numel(TTTRaj)
        tmp=TTTRaj(i);
        pRes(i,:)=tmp.t';
    end
    plot2(pRes,'LineWidth',2,'Color','r')
    
    p560.plot(qResult.Data,'fps',100)
    
    
    %%
end