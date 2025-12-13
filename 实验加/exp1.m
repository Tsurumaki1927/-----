close all;clc;clear;


%% 参数设置
u = 3.986e14; % 地球引力常数
r0 = [-6311227.13644808; -1112839.62553522; 3700000]; % 初始位置
v0 = [1274.45143229237; -7227.77323794544; 2.24700438581515e-13]; % 初始速度
state0 = [r0; v0]; % 初始状态向量 [x,y,z,vx,vy,vz]


%% 求解
tspan = [0, 7000]; % 时间范围（秒）
option=odeset('MaxStep',1);
[t, state] = ode23(@satellite_ode, tspan, state0,option);%指定最大步长0.1，
x1 = state(:,1); y1 = state(:,2); z1 = state(:,3); 
save exp1 x1 y1 z1;


%% 绘图
figure(1);
plot3(x1, y1, z1, 'b-', 'LineWidth', 2);
grid on; xlabel('X (m)'); ylabel('Y (m)'); zlabel('Z (m)');
legend("轨道曲线");
title("第一问图像（数值求解）")
view(3);


%% 微分方程
function dydt = satellite_ode(t, state)
    u = 3.986e14;
    r = state(1:3);
    a = -u * r / norm(r)^3;
    dydt = [state(4:6); a]; % [vx,vy,vz, ax,ay,az]
end
