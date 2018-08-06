function [rmse_quiz,Rhat_quiz]=computeRMSEquiz(U,V,quizSet,meanRank,dataSet,disply)

if nargin<6
    disply=0;
end

% Quiz RMSE
Rhat_quiz=sum(U(:,quizSet(:,2)).*V(:,quizSet(:,1)))'+meanRank;
% Clip ratings
Rhat_quiz=clipRatings(Rhat_quiz,dataSet);

R=quizSet(:,3);
rmse_quiz=sqrt(mean((Rhat_quiz-R).^2));

if disply
        disp(['Quiz RMSE: ',num2str(rmse_quiz)]);
end
