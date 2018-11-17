% LAB 1 Numerical Analysis of the Euler Equations
% Task 1
clear all
close all
clc

set(0,'DefaultFigureWindowStyle','docked');
set(0,'defaulttextInterpreter','latex');
set(0,'defaultTextFontSize',12);
set(0,'DefaultLegendFontSize',5);
set(0,'defaultAxesFontSize',12);

model = 'Euler_eqs.slx';
load_system(model)
sim(model)

hold on
plot(tout,omega,'LineWidth',1.5)
xlabel('Time');ylabel('Angular velocity');
legend('OmegaX','OmegaY','OmegaZ')
grid on

%% TASK 2

model2 = 'Lab1T2';
load_system(model2)
sim(model2)

%% TASK 3


