if(initSim)
    %%
    close all
    
    if(~exist('p560','var') || ~exist('p560Unc','var'))
        mdl_puma560
        p560 = p560.nofriction;
        
        MyUncertainPumaCreation
        p560Unc = p560Unc.nofriction;
    end
    
    %%
    %q0=[-pi -pi +3/2*pi -pi 0 +pi/4];
    %qf=[pi pi -3/2*pi pi 0 -pi/4];
    
    q0=[0 pi/4 -pi 0 0 0];
     qf=[3/4*pi 3/4*pi -pi 0 0 0];
    
    %q0=[-pi/4 -pi/4 -pi 0 0 0];
    %qf=[3/4*pi -3/4*pi pi 0 0 0];
    
    wn=[1 2 1 1 1 2].*10;
    damping=[0.8 0.8 0.8 0.6 0.8 0.9];
    
    kps=wn.*wn;
    KP=diag(kps);
    
    kds=2.*wn.*damping;
    KD=diag(kds);
    
    D=[zeros(6); eye(6)];
    Htilde=[zeros(6) eye(6); -KP -KD];
    P=eye(12);
    %P=[KP zeros(6); KD zeros(6)];
    %P=[KP zeros(6); zeros(6) KD];
    
    Q=lyap(Htilde',P);
    
    p=50;
    timeStep=0.01;
    tfin=2;
    
    
else
    %%
    
    
    close all
    clear pRes
    
    qddTraj=trajectory.Data(:,1:6);
    qdTraj=trajectory.Data(:,7:12);
    qTraj=trajectory.Data(:,13:18);
    
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