clc; close all; clear all;                       

f1 = 1_000;
f3 = 3*f1;
f5 = 5*f1;
f7 = 7*f1;    


phi1 = 0;
phi3 = 0;
phi5 = 0;
phi7 = 0;                         
A1 = 1;
A3 = 1;
A5 = 1;
A7 = 1;

T = 1/f1;
fs = 400 * f7;                    
ts = 1/fs;                     
t = 0 : ts : 1;   

x1_t = A1*sin(2*pi*f1*t + phi1);
x3_t = A3*sin(2*pi*f3*t + phi3);
x5_t = A5*sin(2*pi*f5*t + phi5);
x7_t = A7*sin(2*pi*f7*t + phi7);

x_t = x1_t + (1/3 * x3_t) + (1/5 * x5_t) + (1/7 * x7_t);

figure; hold on;

subplot(4,1,1)
plot(t,x1_t);
xlim([0 5*T]);
grid on

subplot(4,1,2)
plot(t,x3_t);
xlim([0 5*T]);
grid on

subplot(4,1,3)
plot(t,x5_t);
xlim([0 5*T]);
grid on

subplot(4,1,4)
plot(t,x7_t);
xlim([0 5*T]);
grid on

figure
plot(t,x_t);
xlim([0 5*T]);
grid on;
                 

