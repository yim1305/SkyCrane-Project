clc; clear;

num = 4.723e-6;
den = [1,0,0];
P = tf(num,den);

controlSystemDesigner(P);
