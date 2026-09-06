clc; clear;

% My gains 
Kp = 4000; 
Kd = 9000;  
Ki = 0.5;

% G = 0.0006557 / s^2 (negative sign is removed to make math easier)
s = tf('s');
G = 0.0006557 / s^2;
C = Kp + Ki/s + Kd*s;

% Closed loop TF
H = feedback(C*G, 1);

% Plot
figure;
step(10*H);
grid on;

% display info to make it easier to verify with the given requirements
info = stepinfo(10*H);
display(info);
[y, t] = step(10 * H);
actual_final_height = y(end);
ss_error = 10 - actual_final_height;
display(ss_error);