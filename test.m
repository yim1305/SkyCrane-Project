clc; clear;

K  = 2.117298e+07;
z1 = 0.5;  z2 = 10.0;  p1 = 200;

num = K*conv([1 z1],[1 z2]);
den = conv([1 p1],[1 p1]);
C   = tf(num, den);

G = tf([4.723e-6],[1 0 0]);
L = C*G;
T = feedback(L,1);

figure; margin(L)
figure; step(T)