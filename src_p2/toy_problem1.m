
% In Toy Problem 1
% We want to see plotting result of given data points
% and consider which transform mapping function we should use to build
% linear regression model.
% Linear regression model is trying to fit data with straigh line.

% Defind data point x, y as 5 rows * 2 columns
data = [-2 -5; -1 9; 0 11; 1 13; 2 27];

% Use scatter plot to visualize data for non-basis function 
% and each given basis function
scatter(data(:,1), data(:,2), ...
 'MarkerFaceColor',[0.0 0.6 1.0]);
xlim([-3 3]);
ylim([-10 30]);
title("x");
title("φ(x) = x (no basis function)");

x = [-2 -1 0 1 2];
y = [-5 9 11 13 27];

min_y = min(y) - 2;
max_y = max(y) + 2;

x_sqr = x.^2;
x_power3 = x.^3;
x_power4 = x.^4;

figure();
min_x_sqr = min(x_sqr) - 2;
max_x_sqr = max(x_sqr) + 2;
scatter(x_sqr, y, ...
    'MarkerFaceColor',[0.0 0.6 1.0]);
xlim([min_x_sqr max_x_sqr])
ylim([min_y max_y])
ylim([min_y max_y])
title("φ(x) = x²");

figure();
min_x_p3 = min(x_power3) - 2;
max_x_p3 = max(x_power3) + 2;
scatter(x_power3, y, ...
    'MarkerFaceColor',[0.0 0.6 1.0]);
xlim([min_x_p3 max_x_p3])
ylim([min_y max_y])
title("φ(x) = x³");

figure();
min_x_p4 = min(x_power4) - 2;
max_x_p4 = max(x_power4) + 2;
xlim([min_x_p4 max_x_p4])
ylim([min_y max_y])
scatter(x_power4, y, ...
    'MarkerFaceColor',[0.0 0.6 1.0]);
title("φ(x) = x⁴")
