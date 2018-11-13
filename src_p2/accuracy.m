function [accuracyPercent] = accuracy(yPredict,yTrue)
%Calculate correctness from prediction
    lenData = length(yPredict);
        sumAccuracy = 0;
        for j=1:lenData
            %fprintf('Predict %f Actual %f\n', predictLabels(i), testLabels(i));
            if yPredict(j) == yTrue(j)
                sumAccuracy = sumAccuracy + 1;
            end
        end
      accuracyPercent = (sumAccuracy/lenData)*100;  
end

