% measurement of light power vs voltage to LED driver

spotdiam = .105;
spotsize = pi*(spotdiam/2)^2;


v = [ % in Volts. From daq to external control of LED driver. 1000 mA at 10 V
0.0088914  
0.015811
0.028117
0.05
0.088914
0.15811
0.28117
0.5
0.88914
1.5811
2.8117
5
];  

power = [ % in uW. 
    nan
    nan
2.65
11.12
27
55
108
202
363
638
1.12*1E3
1.88*1E3
];
power = power/1E3; %mW
power = power/spotsize; %mW/mm^2

figure
loglog(v,power), hold on
loglog(v,power,'.')

%% What should the power be for a particular value of v
V = 0.0704;
%  V = 0.25;
% % V = 0.1250;
%  V = 0.1875;
% % V = 0.05;
%  V = 0.1581;

P = 0;

v1 = find(v<=V,1,'last');
v2 = v(v1+1);
p1 = power(v1);
p2 = power(v1+1);
v1 = v(v1);

m = (p2-p1)/(v2-v1);
P = m*(V-v1)+p1;

plot(V,P,'go');
delete(findobj(gcf,'type','text'));
text(V+1,P+20,[num2str(P) ' mW/mm^2'])
