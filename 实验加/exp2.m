clear; clc; close all;

%% 参数设置
% 地球引力常数 (m^3/s^2)
u = 3.986004418e14;

% 初始状态
r0 = [-6311227.13644808; -1112839.62553522; 3700000]; % 初始位置
v0 = [1274.45143229237; -7227.77323794544; 2.24700438581515e-13]; % 初始速度

%% 计算轨道根数
% 基本计算
r_norm = norm(r0);
v_norm = norm(v0);
h = cross(r0, v0);
h_norm = norm(h);

% 计算偏心率矢量
e_vec = ((v_norm^2 - u/r_norm) * r0 - dot(r0, v0) * v0) / u;
e = norm(e_vec);

% 计算轨道倾角
i = acos(h(3)/h_norm);

% 计算升交点赤经
n = cross([0;0;1], h);
Omega = atan2(n(2), n(1));


% 计算近地点幅角
omega = atan2(dot(e_vec, n)/(e*norm(n)), dot(e_vec, cross(h, n))/(e*h_norm*norm(n)));


% 计算真近点角
nu = atan2(dot(r0, cross(h, e_vec))/(h_norm*e), dot(r0, e_vec)/(r_norm*e));


% 计算半长轴和轨道周期
a = 1 / (2/r_norm - v_norm^2/u);
T = 2*pi*sqrt(a^3/u);

% 显示结果
fprintf('半长轴 a = %.2f km\n', a/1000);
fprintf('偏心率 e = %.6f\n', e);
fprintf('轨道倾角 i = %.2f rad\n', i);
fprintf('升交点赤经 Ω = %.2f rad\n', Omega);
fprintf('近地点幅角 ω = %.2f rad\n', omega);
fprintf('真近点角 ν = %.2f rad\n', nu);
fprintf('轨道周期 T = %.2f s\n', T);


%% 计算真近点角和坐标转换
num_points = 500;
t = linspace(0, T, num_points);
pos = zeros(3, num_points);

% 计算初始偏近点角
E0 = 2 * atan(sqrt((1-e)/(1+e)) * tan(nu/2));
M0 = E0 - e*sin(E0);

for idx = 1:num_points
    % 当前时刻的平近点角
    M = M0 + sqrt(u/a^3) * t(idx);
    M = mod(M, 2*pi);
    
    % 解开普勒方程求偏近点角
    E = M;
    for iter = 1:10
        E = M + e*sin(E);
    end
    
    % 计算真近点角
    nu_t = 2 * atan(sqrt((1+e)/(1-e)) * tan(E/2));
    
    % 计算在轨道平面内的坐标
    r_t = a * (1 - e*cos(E));
    r_pf = r_t * [cos(nu_t); sin(nu_t); 0];
    
    % 转换到惯性系
    Rz_Omega = [cos(Omega), -sin(Omega), 0; sin(Omega), cos(Omega), 0; 0, 0, 1];
    Rx_i = [1, 0, 0; 0, cos(i), -sin(i); 0, sin(i), cos(i)];
    Rz_omega = [cos(omega), -sin(omega), 0; sin(omega), cos(omega), 0; 0, 0, 1];
    
    pos(:, idx) = Rz_Omega * Rx_i * Rz_omega * r_pf;
    x2=pos(1,:);y2=pos(2,:);z2=pos(3,:);
end
save exp2 x2 y2 z2;

%% 绘图
figure(1);

earthRadius_m = 6371 * 1000; % 地球半径，单位：米
[Xs, Ys, Zs] = sphere(40);
Xs = earthRadius_m * Xs;
Ys = earthRadius_m * Ys;
Zs = earthRadius_m * Zs;

hold on; grid on; axis equal;
plot3(x2,y2,z2, ...
      'r-', 'LineWidth', 2);
xlabel('X (m)', 'FontSize', 12);
ylabel('Y (m)', 'FontSize', 12);
zlabel('Z (m)', 'FontSize', 12);
hold off;
legend("卫星轨迹")
title("第二题答案（解析法）");
view(3);
