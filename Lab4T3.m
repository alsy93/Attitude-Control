
% STABILITY
% Case of geostazionary orbit
n=2*pi/(24*3600);

Ix = 0.01;
Iy = 0.1;
Iz = 0.07;

Kx = (Iz-Iy)/Ix;
Ky = (Iz-Ix)/Iy;

A = [0 0 1 0; 0 0 0 1; -Kx*n^2 0 0 (1-Kx)*n;0 -Ky*n^2 (Ky-1)*n 0];

lambda=eig(A);
plot(lambda,'o')
grid on

%The system is instable

B = [0 0;0 0;0 0;0 1];

Co = ctrb(A,B);
rank(Co) % The system is controllable



