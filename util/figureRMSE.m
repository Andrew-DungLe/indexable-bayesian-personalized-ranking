function figureRMSE(rmse_train,rmse_quiz,it,param)

if param.computeRMSEtrain
    figure(100)
    plot(1:it,rmse_train(1:it),'-b.','LineWidth',2,'MarkerSize',16)
    grid on
    title('Train RMSE','FontSize',12)
    xlabel('Epochs','FontSize',12)
    ylabel('Train RMSE','FontSize',12)
    ylim(sort([min(rmse_train(1:it))-0.005 min([max(rmse_train(1:it))+0.005 0.8])]))
%     export_fig(100,[param.bkp_file,'_train'],'-pdf','-transparent')
    saveas(gcf,[param.bkp_file,'_train'],'fig')
end

if param.computeRMSEquiz
    figure(200)
    plot(1:it,rmse_quiz(1:it),'-b.','LineWidth',2,'MarkerSize',16)
    grid on
    title('Quiz RMSE','FontSize',12)
    xlabel('Epochs','FontSize',12)
    ylabel('Quiz RMSE','FontSize',12)
%     ylim(sort([min(rmse_quiz(1:it))-0.005 min([max(rmse_quiz(1:it))+0.005 0.92])]))
    drawnow
%     export_fig(200,[param.bkp_file,'_quiz'],'-pdf','-transparent')
    saveas(gcf,[param.bkp_file,'_quiz'],'fig')
end