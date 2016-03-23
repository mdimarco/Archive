function accs = do_SVM( features, labels )


    %Shuffling
    randomInd = randperm(size(features,1));
    features = features(randomInd,:);
    labels = labels(randomInd);

    numFeatures = size(features,1);
    numTrain = ceil(numFeatures * 0.80);
    numTest = numFeatures - numTrain;

    trainData = features(1:numTrain,:);
    trainLabels = labels(1:numTrain);

    testData = features(numTrain+1:numFeatures,:);
    testLabels = labels(numTrain+1:numFeatures);

    %Train
    SVMModel = fitcecoc(trainData, trainLabels);
    %Test
    [pred_labs, pred_score] = predict( SVMModel, testData );
    %Acc
    accs = eval_accuracy( testLabels, pred_labs );
end