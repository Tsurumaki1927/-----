close all,clc, clear;

%% 数据读取
load exp1.mat;
load exp2.mat;

%% 画图
figure(1)

earthRadius_m = 6371 * 1000; % 地球半径，单位：米
[Xs, Ys, Zs] = sphere(40);
Xs = earthRadius_m * Xs;
Ys = earthRadius_m * Ys;
Zs = earthRadius_m * Zs;


subplot(2,2,1)
plot3(x1, y1, z1, 'b-', 'LineWidth', 2);
grid on; xlabel('X (m)'); ylabel('Y (m)'); zlabel('Z (m)');
title("第一问图像（数值求解）")
hold on;
surf(Xs,Ys,Zs, 'FaceColor','texturemap','FaceAlpha',0.2,'EdgeColor', 'none');
hold off;
view(3);

subplot(2,2,2)
plot3(x2,y2,z2, ...
      'r-', 'LineWidth', 2);
xlabel('X (m)', 'FontSize', 12);
ylabel('Y (m)', 'FontSize', 12);
zlabel('Z (m)', 'FontSize', 12);
title("第二题答案（解析法）");
hold on;
surf(Xs,Ys,Zs, 'FaceColor','texturemap','FaceAlpha',0.2,'EdgeColor', 'none');
hold off;
grid on;
view(3);

subplot(2,2,[3,4])
plot3(x1,y1,z1,'b-',x2,y2,z2,'r-','LineWidth',2);
xlabel('X (m)', 'FontSize', 12);
ylabel('Y (m)', 'FontSize', 12);
zlabel('Z (m)', 'FontSize', 12);
title("对比图")
hold on;
surf(Xs,Ys,Zs, 'FaceColor','texturemap','FaceAlpha',0.2,'EdgeColor', 'none');
hold off;
grid on;
view(3);

