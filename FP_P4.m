clc; clear;

% define the constant term as K 
K = 0.0006557; 

% Case 1
num1 = [K, 0, 0];          
den1 = [1, 0, 10*K, K];    
sys_1 = tf(num1, den1);

% Case 2
num2 = [K, 0];          
den2 = [1, K, 0, K];    
sys_2 = tf(num2, den2);

% Case 3
num3 = [0, K];          
den3 = [1, 10*K, 10*K, 0];    
sys_3 = tf(num3, den3);

% Plots
figure;
rlocus(sys_1)
title('Root Locus: Varying K_D (K_P=10, K_I=1)')

figure;
rlocus(sys_2)
title('Root Locus: Varying K_P (K_D=1, K_I=1)')

figure;
rlocus(sys_3)
title('Root Locus: Varying K_I (K_D=10, K_P=10)')