
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%% Practice 4   %%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%% SVM Kernel   %%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Referenes link to learn:
% https://uk.mathworks.com/help/stats/fitcecoc.html
% https://uk.mathworks.com/help/stats/templatesvm.html

%choose the emotion labels we want to classify in the database
% 0:Neutral 
% 1:Angry 
% 2:Bored 
% 3:Disgust 
% 4:Fear 
% 5:Happiness 
% 6:Sadness 
% 7:Surprise
emotionsUsed = [0 1 3 4 5 6 7];  

%%%%%%%%%%%%%%%% EXTRACT DATA %%%%%%%%%%%%
[imagesData shapeData labels stringLabels] = extractData('../CKDB', emotionsUsed);

totalNumberOfImages = length(imagesData);

%%%%%%%%%%%%%%%% EXTRACT FEATURES %%%%%%%%%%%%


% Setting parameters here
pcaTargetDim = 300;
ldaTargetDim = 3;
% Coding — fitcecoc searches among 'onevsall' or 'onevsone'.
Coding = 'onevsone';
% Flag to standardize the predictor, 'Standardize' value are true (1) or false (0).
Standardize = 1;
% K-fold
K = 2;

% Split data into K folder by k-fold cross validation
% it shuffles data and return indexes of folder
indexes = crossvalind('Kfold', totalNumberOfImages, K);

% From the return folder indexes, split to train and test
trainImages = [];
trainLabels = [];
trainStringLabels = [];

% Combine folder from 1 to K-1 for training dataset 
% and leave the last one for testing.
for k=1:(K-1)
    trainImages = [trainImages; imagesData(indexes==k,:,:)];
    trainLabels = [trainLabels, labels(indexes==k)];
    trainStringLabels = [trainStringLabels; stringLabels(indexes==k,:)];
end

% Prepare testing da
testImages = imagesData(indexes==K,:,:);
testLabels = labels(indexes==K);
testStringLabels = stringLabels(indexes==k,:);

% fprintf("Confirm we have all labels in train: %f \n",length(unique(trainLabels)));
% fprintf("Confirm we have all labels in test: %f \n",length(unique(testLabels)));

% Check number of each facial expression in train and test.
trainLabelGroup = [length(find(trainLabels==0))...
                  length(find(trainLabels==1))...
                  length(find(trainLabels==3))...
                  length(find(trainLabels==4))...
                  length(find(trainLabels==5))...
                  length(find(trainLabels==6))...
                  length(find(trainLabels==7))];
testLabelGroup = [length(find(testLabels==0))...
                  length(find(testLabels==1))...
                  length(find(testLabels==3))...
                  length(find(testLabels==4))...
                  length(find(testLabels==5))...
                  length(find(testLabels==6))...
                  length(find(testLabels==7))];
              
% fprintf("Number of each facial expression in train data: %f \n",trainLabelGroup);
% fprintf("Number of each facial expression in test data: %f \n",testLabelGroup);


% Use PCA and LDA techniques to reduce dimesion of images from 128x128
% pixel to above setting number.

trainGrayscaleFeatures = extractFeaturesFromData(trainImages,'grayscale');
[trainDataProjected, trainMeanProjection, trainVectorsProjection]...
    = reduceDimensionality(trainGrayscaleFeatures, 'PCA', pcaTargetDim, trainLabels);
 
[trainDataProjectedLda, meanProjectionLda, vectorsProjectionLda]...
    = reduceDimensionality(trainDataProjected, 'LDA', ldaTargetDim, trainLabels);

testGrayscaleFeatures = extractFeaturesFromData(testImages, 'grayscale');
[testDataProjected, testDataMeanProjection, ...
    testDataVectorsProjection] = ...
    reduceDimensionality(testGrayscaleFeatures, 'PCA', pcaTargetDim, testLabels);

[testDataProjectedLda, testDataMeanProjectionLda, ...
    testDataVectorsProjectionLda] = ...
    reduceDimensionality(testDataProjected, 'LDA', ldaTargetDim, testLabels);



% Define SVM Kernel function name that we're going to use.
kernelFunctions = ["rbf", "linear", "polynomial"];


% Traspose trainLabels from row to column for checking result with predicted
% result.
trainLabelTranspose = trainLabels.';
% If class of train labels are double, convert to string.
if isa(trainLabelTranspose,"double") 
    trainLabelTranspose = string(trainLabelTranspose);
end


% Polynomial degree that we want to test when KernelFunction is polynomial.
polynomialDegree = [1, 2, 3, 4, 5, 6, 7 , 8, 9, 10];

for i = 1:length(kernelFunctions)
    
    kernelFunction = kernelFunctions(i);
    
    % disp(kernelFunction);
    
    % Here are steps from matlab and functions' usage.
    % ========================================================
    % - Specify template as a binary learner for an ECOC multiclass model.
    % - Train the ECOC classifier, and specify the class order.
    % - 'Verbose': Display diagnostic messages during the training
    % - It is good practice to specify the class order.
    % - By default, the empty properties are filled to template.
    
    % Practice:
    % - It is good practice to standardize the predictors.
    
    
    % if template is polynomail, test all defined degree.
    if strcmp(kernelFunction, "polynomial")
        % We run polynomial for different degree
        fprintf("--------------- Polynomial Running --------------\n");
        for polyDegree = 1:length(polynomialDegree)
            
            polyDegreeVal = polynomialDegree(polyDegree);
            
            polyTem = templateSVM('Standardize',Standardize, ...
                        'KernelFunction','polynomial', ...
                        'PolynomialOrder', polyDegreeVal);
                    
            Mdl = fitcecoc(trainDataProjectedLda, trainLabels,...
                        'Coding', Coding, ...
                        'Learners',polyTem, ...
                        'ClassNames',{'0','1','3','4','5','6','7'});
            % Predict
            predictLabels = predict(Mdl, testDataProjectedLda); 
            
            % Calculate prediciton result
            accuracyPercent = accuracy(predictLabels, trainLabelTranspose);
            
            fprintf('KernelFunction %s PCA %.0f \tLDA %.0f \tCoding: %s \tStandardize %.0f \tPolynomial degree %.0f \tAccuracy %.0f percent.\n', ...
                    kernelFunction, pcaTargetDim, ldaTargetDim, Coding, ...
                    Standardize, polyDegreeVal, accuracyPercent);
        end
    else
        % If KernelFunction is not "polynomial" we don't need loop.
        % Intialize template
        template = templateSVM('Standardize',Standardize, ...
                                'KernelFunction', kernelFunction);
        
        % Initialize Model 
        Mdl = fitcecoc(trainDataProjectedLda, trainLabels,...
                'Coding', Coding, ...
                'Learners', template, ...
                'ClassNames',{'0','1','3','4','5','6','7'}); 
        
        % Predict 
        predictLabels = predict(Mdl, testDataProjectedLda); 
        
        % Calculate prediciton result
        accuracyPercent = accuracy(predictLabels, trainLabelTranspose);
        fprintf('KernelFunction %s \tPCA %.0f \tLDA %.0f \tCoding: %s \tStandardize %.0f \tAccuracy %.0f percent.\n', ...
                kernelFunction, pcaTargetDim, ldaTargetDim, Coding, Standardize, ...
                accuracyPercent);
            
        inSampleError = resubLoss(Mdl);
        % Estimate the classification error
        % If the classification error is less, 
        % it indicates that the ECOC classifier generalizes fairly well.
        %         loss = kfoldLoss(CVMdl);
        
        %     disp(Mdl);
        %     disp(Mdl.BinaryLearners{1});
        %     disp(Mdl.BinaryLearners{1}.KernelParameters);
        %     disp(loss);
        %     disp(inSampleError);
    end 
end

% disp(length(trainLabels))
% disp(length(testLabels))
% disp(arrAccuracy);




