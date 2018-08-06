function [rmse_quiz,Rhat_quiz]=computeRMSEquiz_bias(U,V,quizSet,meanRank,c,d,dataSet,disply)

if nargin<8
    disply=0;
end

% Quiz RMSE
Rhat_quiz=sum(U(:,quizSet(:,2)).*V(:,quizSet(:,1)))'+meanRank+c(quizSet(:,2))+d(quizSet(:,1));
% Clip ratings
Rhat_quiz=clipRatings(Rhat_quiz,dataSet);

R=quizSet(:,3);
rmse_quiz=sqrt(mean((Rhat_quiz-R).^2));

if disply
        disp(['Quiz RMSE: ',num2str(rmse_quiz)]);
end
