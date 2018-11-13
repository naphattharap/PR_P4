
% In Toy Problem 2
% We want to see if given data points are linearly separable or not
% then try using basis function to transform data and see the result.


% Plot data points in 1D.
figure();
A = [-2,-1,3,4];
B = [0,1,2];

aMin = min(A)-1;
aMax = max(A)+1;

hAxes = axes('NextPlot','add',...           
             'DataAspectRatio',[1 1 1],...  
             'XLim',[aMin aMax],...         
             'YLim',[0 eps],...             
             'Color','none'); 

         plot(A,0,'o','MarkerSize',10, ...
        'MarkerEdgeColor','b',...
        'MarkerFaceColor',[0.0 0.6 1.0]);
plot(B,0,'o','MarkerSize',10, ...
        'MarkerEdgeColor','r',...
        'MarkerFaceColor',[1.0 0.0 0.0]);

hold off;


% Plot data points in 2D since we have new variable from x^2
figure;
hold on;
datasetA = [-2, -1, 3, 4];
datasetASqr = datasetA.^2;
scatter(datasetA, datasetASqr, 'DisplayName','A', ...
     'Marker', 'o',...
     'MarkerFaceColor',[0.0 0.6 1.0]);
 
datasetB = [0, 1, 2];
datasetBSqr = datasetB.^2;
scatter(datasetB, datasetBSqr,'DisplayName','B', ...
      'Marker', 'o',...
      'MarkerFaceColor',[1.0 0.0 0.0]);
xlim([-3 5])
ylim([-1 20])
title("2D");
legend;
hold off;


