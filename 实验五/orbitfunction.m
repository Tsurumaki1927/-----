function statedot=orbitfunction(t,state)
    mu=398600;
    % Y = [x; y; z; vx; vy; vz]
    r = norm(state(1:3)); % 位置矢量的模
    statedot = zeros(6,1);
    statedot(1:3) = state(4:6); % 速度
    statedot(4:6) = -mu * state(1:3) / r^3; % 加速度
end
