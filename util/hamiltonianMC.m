function [samples, acc] = hamiltonianMC(negLogPdf,x0,epsilon_HMC,Tau_HMC,LM,nsamples)
% HAMILTONIANMC draws samples using Hamiltonian Monte Carlo
% negLogPdf     returns the (unnormalized) negative of the log pdf we want to
%               sample from and its derivative with respect to the variable we are sampling. 
% x0            starting point
% epsilon_HMC   Size of leapfrog step
% Tau_HMC       Number of leapfrog steps
% LM            is the lower Cholesky decomposition of the mass matrix (for momentum
%               variables): M=LM*LM';
% nsamples      number of samples needed

D=length(x0);

% typeVar='gpuArray';
%% HMC
% Variables to be stored
samples = zeros(D,nsamples);
energies = zeros(1,nsamples);
acceptances = zeros(1,nsamples);
% xx=zeros(D,Tau_HMC*nsamples+1); % store all leapfrog steps
% pp=zeros(D,Tau_HMC*nsamples+1); % momentums


x=x0;

% xx(:,1)=x; 
% idx=2;
% idxp=1;
[energy, dx]=negLogPdf(x);
% tstart_hmc=tic;
for t=1:nsamples
    
    % Sample the momentum
    p=LM*randn(1,D)';        
    fM=LM\p;
    H=energy+1/2*(fM'*fM);
    
    % Store old variables
    xold=x;
    energyold=energy;
    dxold=dx;
    
    % Leapfrog integrator
    for tau=1:Tau_HMC
        p=p-epsilon_HMC/2*dx;

        fp=LM\p;
        x=x+epsilon_HMC*(LM'\fp);
%         xx(:,idx)=x;
%         idx=idx+1;

        [energy, dx]=negLogPdf(x);
        p=p-epsilon_HMC/2*dx;   
%         pp(:,idxp)=p;
%         idxp=idxp+1;
    end
    
    % Accept/reject
    fM=LM\p;
    Hnew=energy+1/2*(fM'*fM);
    if rand < exp(H-Hnew) % accept
        H = Hnew;               
        acceptances(t) = 1;            
    else % reject
        dx = dxold;                            
        x = xold;
        energy = energyold;
        acceptances(t) = 0;

%         xx(:,idx-Tau_HMC:idx-1)=repmat(xold,1,Tau_HMC);
    end   

    samples(:,t) = x
    energies(t) = energy;        
end
% t_hmc=toc(tstart_hmc);
acc=sum(acceptances)/length(acceptances);
% disp(['Acceptance rate HMC: ',num2str(length(find(acceptances))/length(acceptances)),', took ',num2str(t_hmc),' seconds'])


% truth=mvnrnd(mu,Sigma,1000)';
% 
% function hamiltonianMC(fun,x0,epsilon_HMC,Tau_HMC,nsamples,X,Y,Z,showinit,ax)
% 
% figure(1)
% subplot(1,3,2)
% contour (X,Y,Z, 30)
% % plot(truth(1,:),truth(2,:),'k.')
% hold on
% plot([x0(1) samples(1,:)],[x0(2) samples(2,:)],'b.','MarkerSize',12)
% plot([x0(1) samples(1,1:showinit)], [x0(2) samples(2,1:showinit)],'-r.','LineWidth',1.5,'MarkerSize',12)
% plot(x0(1),x0(2),'kx','LineWidth',3,'MarkerSize',10)
% axis image
% axis(ax)
% title('Hamiltonian Monte Carlo','FontSize',12)
% 
% 
% showsamples=1;
% figure(2)
% subplot(1,2,1)
% % plot(truth(1,:),truth(2,:),'k.')
% contour (X,Y,Z)
% hold on
% plot(xx(1,1:showsamples*Tau_HMC+1),xx(2,1:showsamples*Tau_HMC+1),'-b.')
% plot(x0(1),x0(2),'kx','LineWidth',3,'MarkerSize',10)
% plot([samples(1,1:showsamples)], [samples(2,1:showsamples)],'r.','LineWidth',1.5,'MarkerSize',12)
% % plot(xx(1,1:1000),xx(2,1:1000),'-b.')
% % plot([x0(1) samples(1,1:showinit)], [x0(2) samples(2,1:showinit)],'-r.','LineWidth',2,'MarkerSize',14)
% axis image
% title('Hamiltonian Monte Carlo','FontSize',12)
% 
% figure(3)
% subplot(1,2,1)
% % plot(truth(1,:),truth(2,:),'k.')
% hold on
% plot(pp(1,1:showsamples*Tau_HMC+1),pp(2,1:showsamples*Tau_HMC+1),'-b.')
% % plot([ (1,1:showsamples)], [ pp(2,1:showsamples)],'r.','LineWidth',1.5,'MarkerSize',12)
% % plot(x0(1),x0(2),'kx','LineWidth',3,'MarkerSize',10)
% % plot(xx(1,1:1000),xx(2,1:1000),'-b.')
% % plot([x0(1) samples(1,1:showinit)], [x0(2) samples(2,1:showinit)],'-r.','LineWidth',2,'MarkerSize',14)
% axis image
% title('Hamiltonian Monte Carlo','FontSize',12)
% 
% 
