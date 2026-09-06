clc; clear;

w1 = 2.7; h1 = 2.2; d1 = 3; %rover dimensions (meters)
w2 = 3; h2 = 2.5; d2 = 3;   %sky crane dimensions (meters)
M = 1025; m = 500;  %rover mass and sky crane mass, respectively (kg)
L = 25; l1 = m/(M+m)*L; l2 = L - l1;    %cable lengths; l1 = distance from rover to center of mass (meters)
g = 3.711;  %Martian gravitational acceleration (m/s^2)
x0 = zeros(12,1);   %initial states

%Moments of inertia for rover and sky crane relative to the center of mass
Izz1 = 1/12*M*(w1^2+d1^2); Izz2 = 1/12*m*(w2^2+d2^2);%along the axis of the cable
Iyy1 = 1/12*M*(w1^2+h1^2+12*l1^2); Iyy2 = 1/12*m*(w2^2+h2^2+12*l2^2);   %along the phi axis
Ixx1 = 1/12*M*(d1^2+h1^2+12*l1^2); Ixx2 = 1/12*m*(d2^2+h2^2+12*l2^2);   %along the theta axis

Izz = Izz1 + Izz2; Iyy = Iyy1 + Iyy2; Ixx = Ixx1 + Ixx2;    %moments of inertia for entire assembly


A = [0,0,0,0,0,0,1,0,0,0,0,0;
     0,0,0,0,0,0,0,1,0,0,0,0;
     0,0,0,0,0,0,0,0,1,0,0,0;
     0,0,0,0,0,0,0,0,0,1,0,0;
     0,0,0,0,0,0,0,0,0,0,1,0;
     0,0,0,0,0,0,0,0,0,0,0,1;
     0,0,0,0,-g,0,0,0,0,0,0,0;
     0,0,0,g,0,0,0,0,0,0,0,0;
     0,0,0,0,0,0,0,0,0,0,0,0;
     0,0,0,0,0,0,0,0,0,0,0,0;
     0,0,0,0,0,0,0,0,0,0,0,0;
     0,0,0,0,0,0,0,0,0,0,0,0;];

A_new = A; % copy matrix A
A_new([6, 12], :) = []; % remove row 6 and 12
A_new(:, [6, 12]) = []; % remove col 6 and 12

B = [0,0,0
     0,0,0
     0,0,0
     0,0,0
     0,0,0
     0,0,0
     0,0,0
     0,0,0
     -1/(M+m),0,0
     0,1/Ixx,0
     0,0,1/Iyy
     0,0,0];

B_new = B; % copy matrix B
B_new([6, 12], :) = []; % remove row 6 and 12

C = eye(12); % identity matrix

% Fix D to match 12 outputs and 3 inputs
D = zeros(12, 3);

sys_ss = ss(A, B, C, D);

% pole placements
poles = [-0.2, -0.3, -0.4, -0.5, -0.6, -0.7, -0.8, -0.9, -1.0, -1.1];
K = place(A_new,B_new,poles);
K_full = zeros(3, 12);
kept_indices = [1, 2, 3, 4, 5, 7, 8, 9, 10, 11];
% add 0 back in
K_full(:, kept_indices) = K; % final K matrix
 
p = [M, m, Ixx, Iyy, Izz, g, zeros(1,12)]; % parameters for NLS_Dynamics Function

% equilibrium values for inputs (I defined reference values as constant on
                                    % simulink model)
u1o = (M + m) * g;
u2o = 0;
u3o = 0;

simout = sim('nonlinsim_bonus','StartTime','0','StopTime','300','FixedStep','0.01'); % call the simulink model

% extract for plotting
t = simout.t;
u_vec = simout.u;
u_0dist = simout.u_no_disturbances;
x_vec = simout.x;

%% Plots
% Figure 1 for height
figure(1);
subplot(2,1,1);
plot(t, x_vec(:,3), 'b', 'LineWidth', 1.5); 
hold on;
grid on;
xlabel('Time (s)');
ylabel('height (m)');
title('Output 3 (Height) Tracking');

subplot(2,1,2);
plot(t, u_vec(:,1), 'k', 'LineWidth', 1.5);
hold on;
plot(t, u_0dist(:,1), 'r--', 'LineWidth', 1.5);
grid on;
xlabel('Time (s)');
ylabel('Total Thrust (N)');
title('Control Input');
legend('input with disturbance', 'input without disturbance');

% Figure 2 for Roll
figure(2);
subplot(2,1,1);
plot(t, x_vec(:,4), 'b', 'LineWidth', 1.5);
hold on;
grid on;
xlabel('Time (s)');
ylabel('Roll (rad)');
title('Output 4 (Roll) Tracking');

subplot(2,1,2);
plot(t, u_vec(:,2), 'k', 'LineWidth', 1.5);
hold on;
plot(t, u_0dist(:,2), 'r--', 'LineWidth', 1.5);
grid on;
xlabel('Time (s)');
ylabel('Moment Around x-axis (Nm)');
title('Control Input');
legend('input with disturbance', 'input without disturbance');

% Figure 3 for pitch
figure(3);
subplot(2,1,1);
plot(t, x_vec(:,5), 'b', 'LineWidth', 1.5);
hold on;
grid on;
xlabel('Time (s)');
ylabel('Pitch (rad)');
title('Output 5 (Pitch) Tracking');

subplot(2,1,2);
plot(t, u_vec(:,3), 'k', 'LineWidth', 1.5);
hold on;
plot(t, u_0dist(:,3), 'r--', 'LineWidth', 1.5);
grid on;
xlabel('Time (s)');
ylabel('Moment Around y-axis (Nm)');
title('Control Input');
legend('input with disturbance', 'input without disturbance');

