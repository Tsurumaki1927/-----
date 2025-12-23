close all; clc; clear;

%% 初始条件 (400km圆轨道)
mu = 398600;
R_earth = 6371;
h = 40000;
r0 = R_earth + h;
v0 = sqrt(mu/r0);
state0 = [r0; 0; 0; 0 ; 0; v0];

%% 仿真参数
t_end = 72;  
dt = 0.1;        
t = 0:dt:t_end; 
steps = length(t);

%% RK4法求解 (保持不变)
Y_rk4 = zeros(steps, 6);
Y_rk4(1,:) = state0';
for i = 1:steps-1
    k1 = orbitfunction(0, Y_rk4(i,:)');
    k2 = orbitfunction(0, Y_rk4(i,:)' + dt/2*k1);
    k3 = orbitfunction(0, Y_rk4(i,:)' + dt/2*k2);
    k4 = orbitfunction(0, Y_rk4(i,:)' + dt*k3);
    Y_rk4(i+1,:) = Y_rk4(i,:) + (dt/6)*(k1 + 2*k2 + 2*k3 + k4)';
end

%% RKF78法求解 (替换欧拉法)
h0 = 10;        % 初始步长
tol = 1e-6;     % 容差
[t_rk78, Y_rk78, h_actual] = rkf78(@orbitfunction, [0, t_end], state0', h0, tol);
Y_rk78 = Y_rk78';  % 转置为 [steps, 6] 格式以匹配绘图代码

%% 位置分量对比图 (x,y,z vs t)
figure(1);
subplot(3,1,1);
plot(t/60, Y_rk4(:,1), 'b-', 'LineWidth', 1.5, 'DisplayName', 'RK4');
hold on;
plot(t_rk78/60, Y_rk78(:,1), 'r--', 'LineWidth', 1.5, 'DisplayName', 'RKF78');
ylabel('X (km)');
title1 = sprintf('位置分量 vs 时间 (dt=%.1f秒)', dt);
title(title1);
grid on;
legend('Location', 'best');

subplot(3,1,2);
plot(t/60, Y_rk4(:,2), 'b-', 'LineWidth', 1.5, 'DisplayName', 'RK4');
hold on;
plot(t_rk78/60, Y_rk78(:,2), 'r--', 'LineWidth', 1.5, 'DisplayName', 'RKF78');
ylabel('Y (km)');
grid on;
legend('Location', 'best');

subplot(3,1,3);
plot(t/60, Y_rk4(:,3), 'b-', 'LineWidth', 1.5, 'DisplayName', 'RK4');
hold on;
plot(t_rk78/60, Y_rk78(:,3), 'r--', 'LineWidth', 1.5, 'DisplayName', 'RKF78');
grid on;
legend('Location', 'best');

%% 3D轨道对比图
figure(2);
hold on;
plot3(Y_rk4(:,1), Y_rk4(:,2), Y_rk4(:,3), 'b-', 'LineWidth', 1.5, 'DisplayName', 'RK4');
plot3(Y_rk78(:,1), Y_rk78(:,2), Y_rk78(:,3), 'r--', 'LineWidth', 1.5, 'DisplayName', 'RKF78');
plot3(r0, 0, 0, 'bo', 'MarkerSize', 8, 'MarkerFaceColor', 'y', 'DisplayName', '开始点');
grid on;
hold off;
legend('Location', 'best');
view(3);
title2 = sprintf('3D轨道对比 (dt=%.1f秒)', dt);
title(title2);
axis equal;  % 添加这一行确保比例正确


%% 误差分析
figure(3);
hold on;

Y_rk78_interp = zeros(length(t), 6);
for i = 1:6
    Y_rk78_interp(:,i) = interp1(t_rk78, Y_rk78(:,i), t, 'linear', 'extrap');
end


plot(t/60, Y_rk4(:,1) - Y_rk78_interp(:,1), 'b-', 'LineWidth', 1.5, 'DisplayName', 'X误差');
plot(t/60, Y_rk4(:,2) - Y_rk78_interp(:,2), 'r--', 'LineWidth', 1.5, 'DisplayName', 'Y误差');
plot(t/60, Y_rk4(:,3) - Y_rk78_interp(:,3), 'g-.', 'LineWidth', 1.5, 'DisplayName', 'Z误差');

hold off;
xlabel('t');
ylabel('km');
title('RK4 与 RKF78 位置误差对比');
grid on;