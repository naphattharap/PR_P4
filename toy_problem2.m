x1= [-2,-1,0,1,2];
y1 = [-5,9,11,13,27];

axis equal
%scatter(x1,y1)

x        = [-2,-1,0,1,2,3,4];
xSquared = [4,1,0,1,4,9,16];
y = ['A','A','B','B','B','A','A'];
xa = [-2,-1,3,4];
xa2 = xa.^2;
ya = [0,0,0,0];
scatter(xa,xa2,"filled");
%scatter(xa,ya,"filled");
hold on
xb = [0,1,2];
xb2 = xb.^2;
yb = [0,0,0];
%scatter(xb,yb,"filled");
scatter(xb,xb2,"filled");
legend('A','B','Location','Best');
