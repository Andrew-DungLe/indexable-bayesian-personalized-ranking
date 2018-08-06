function plotMCMCsphere(smpl,mu,p,col)
dim=length(mu);

if dim==2
    figure(210)
    plot(smpl(:,1),smpl(:,2),'.')
    axis image
elseif dim==3
%     aa(find(aa(:,3)<0),:)=[]; % Plot semisphere
    figure(210)
%     clf;
%     subplot 121
    hold on
    hmu=plot3(mu(1),mu(2),mu(3),'kx','MarkerSize',12,'LineWidth',2);
    plot3(smpl(:,1),smpl(:,2),smpl(:,3),'.','Color',col)
    xlabel('x_1','FontSize',12)
    ylabel('x_2','FontSize',12)
    zlabel('x_3','FontSize',12)
%     title('Metropolis-Hastings','FontSize',12)
    axis square
    [x y z] = sphere(128);
    h = surfl(p*x, p*y, p*z);
    hAnnotation = get(h,'Annotation');
    hLegendEntry = get(hAnnotation','LegendInformation');
    set(hLegendEntry,'IconDisplayStyle','off')
    set(h, 'FaceAlpha', 0.5)
    shading interp
    set(210,'Position',[ 403   116   560   550])

    if strcmp(col,'b')%     set(210,'Position',[ 403   116   560   550])
        hAnnotation = get(hmu,'Annotation');
        hLegendEntry = get(hAnnotation','LegendInformation');
        set(hLegendEntry,'IconDisplayStyle','off')
        legend('Starting point','MH','GMC')
%         saveFigure(210,['MHsamplesGMC'])
%         export_fig(210,['sphereGMC'],'-r300','-transparent')
    end
%     saveFigure(210,['MHsamples',num2str(k)])
else dim>3
%     aa(find(aa(:,3)<0),:)=[]; % Plot semisphere
    rng(length(mu))
    rd=randperm(dim);
%     rd=[3,16,19,12,15,2]
    rd=sort(rd(1:min(dim,6)));
    figure(30)
    hold on
    for i=1:length(rd)
        subplot(2,3,i)
        hold on
        plot(smpl(:,rd(i)),'Color',col)
        if ~strcmp(col,'b')
            xlim([1 size(smpl,1)])
        end
       
        title(['Component ',num2str(rd(i))])
        if i==1 && strcmp(col,'b')
            legend('MH','GMC')
        end
    end
    set(30,'Position',[16 67 1316 610])
    if strcmp(col,'b')
        saveFigure(30,['highDimGMC'])
    end
end