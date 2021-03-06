% Lab 7 Task 1
clc; clear all; close all

% Data 
v1n = [0.2673; 0.5345; 0.8018];     %magnetometer inertial
v2n = [-0.3124; 0.937; 0.1562];     %sun inertial 

vbs1 = [0.7749; 0.3447; 0.5297];    %magnetometer perfect reading
vbs2 = [0.6295; 0.6944; -0.3486];   %Sun sensor perfect reading



Sb = vbs2;  hb = vbs1;
Sn = v2n;   hn = v1n;   

% Compute Abn without considering accuracy

SbXhb = cross(Sb,hb);
SnXhn = cross(Sn,hn);
Vb = [ Sb  SbXhb/norm(SbXhb) cross(Sb,SbXhb/norm(SbXhb))]; 
Vn = [ Sn  SnXhn/norm(SnXhn) cross(Sn,SnXhn/norm(SnXhn))]; 
Abn = Vb*Vn';

%%

vbs1_err = [0.7835; 0.3690; 0.4971];%Magnetometer 5 deg error
vbs2_err = [0.6272; 0.6965; -0.3484];% Sun sensor 1/8 error

Sb = vbs2_err;  hb = vbs1_err;
Sn = v2n;   hn = v1n;   

% Compute Abn considering accuracy

SbXhb = cross(Sb,hb);
SnXhn = cross(Sn,hn);
Vb = [ Sb  SbXhb/norm(SbXhb) cross(Sb,SbXhb/norm(SbXhb))]; 
Vn = [ Sn  SnXhn/norm(SnXhn) cross(Sn,SnXhn/norm(SnXhn))]; 
Abn_err = Vb*Vn';

%% Check on vb_err (extra point)

% Data 
v1n = [0.2673; 0.5345; 0.8018];     %magnetometer inertial
v2n = [-0.3124; 0.937; 0.1562];     %sun inertial 


es = 1/8 * pi/180;
em = 5 * pi/180;

    Aes = [cos(es)*cos(es) cos(es)*sin(es)*sin(es)+sin(es)*cos(es) -cos(es)*sin(es)*cos(es)+sin(es)*sin(es);...
          -sin(es)*cos(es) -sin(es)*sin(es)*sin(es)+cos(es)*cos(es) sin(es)*sin(es)*cos(es)+cos(es)*sin(es);...
          sin(es) -cos(es)*sin(es) cos(es)*cos(es)];
      
    Aem = [cos(em)*cos(em) cos(em)*sin(em)*sin(em)+sin(em)*cos(em) -cos(em)*sin(em)*cos(em)+sin(em)*sin(em);...
      -sin(em)*cos(em) -sin(em)*sin(em)*sin(em)+cos(em)*cos(em) sin(em)*sin(em)*cos(em)+cos(em)*sin(em);...
      sin(em) -cos(em)*sin(em) cos(em)*cos(em)];
  
vbs1_err_check = Aem*Abn*v1n;
vbs2err_check = Aes*Abn*v2n;
  
err_magn = abs(vbs1_err_check - vbs1_err);
err_sun = abs(vbs2err_check - vbs2_err);

%% Q - METHOD

alpha1 = 1;     %NOTE: Maxlambda is infuelced by theese quantities
alpha2 = 1;

B = alpha1 * vbs1*v1n' + alpha2 * vbs2*v2n';
S = B' + B; 
sigma = trace(B);
z = [B(2,3)-B(3,2);B(3,1)-B(1,3);B(1,2)-B(2,1)];

K = [S-sigma.*eye(3) z;z' sigma];

[Evect,Eval] = eig(K);
[Maxlambda,posMaxlambda] = max(diag(Eval)); % Max lambda is that one which minimize J
q = Evect(:,posMaxlambda);                  %Extraction of the right quaternion values

q1 = q(1);
q2 = q(2);
q3 = q(3);
q4 = q(4);

Abn_qmethod = [q1^2-q2^2-q3^2+q4^2 2*(q1*q2+q3*q4) 2*(q1*q3-q2*q4);...
    2*(q1*q2-q3*q4) -q1^2+q2^2-q3^2+q4^2 2*(q2*q3+q1*q4);...
    2*(q1*q3+q2*q4) 2*(q2*q3-q1*q4) -q1^2-q2^2+q3^2+q4^2];

%% QUEST

A = -((Maxlambda + sigma)*eye(length(S)) - S);
b = -z;

g = linsolve(A,b);

g1 = g(1);
g2 = g(2);
g3 = g(3);

Abn_quest = 1/(1 + (g1^2+g2^2+g3^2)) * [1 + g1^2-g2^2-g3^2, 2*(g1*g2+g3), 2*(g1*g3-g2);...
            2*(g1*g2-g3), 1 - g1^2+g2^2-g3^2, 2*(g2*g3+g1);...
            2*(g1*g3+g2), 2*(g2*g3-g1), 1-g1^2-g2^2+g3^2];
        
%% Fmincon

