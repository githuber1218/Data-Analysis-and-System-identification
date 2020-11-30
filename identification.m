clc;
clear;

% 预分配内存
b_oe = zeros(100, 4);
a_oe = zeros(100, 3);
b_arx = zeros(100, 4);
a_arx = zeros(100, 3);
b_bj = zeros(100, 4);
a_bj = zeros(100, 3);
c_bj = zeros(100, 2);
d_bj = zeros(100, 2);

u = gbngen(1000, 10, sum(100*clock));
b0 = [0, 0, 0.8, 0.5];
a0 = [1, -1.5, 0.7];
y0 = filter(b0, a0, u);

for i=1:100
    [data,y]=generate();
    sys_oe = oe(data, [2, 2, 2]);
    sys_arx = arx(data, [2, 2, 2]);
    sys_bj = bj(data, [2, 1, 1, 2, 2]);
    b_oe(i, :) = sys_oe.B;
    a_oe(i, :) = sys_oe.F;
    b_arx(i, :) = sys_arx.B;
    a_arx(i, :) = sys_arx.A;
    b_bj(i, :) = sys_bj.B;
    a_bj(i, :) = sys_bj.F;
    c_bj(i, :) = sys_bj.C;
    d_bj(i, :) = sys_bj.D;
end

% 取第一次试验绘图
y_arx = filter(b_arx(1, :), a_arx(1, :), u);
y_oe = filter(b_oe(1, :), a_oe(1, :), u);
y_bj = filter(b_bj(1, :), a_bj(1, :), u);

figure(1);
plot(y);
hold on;
plot(y_arx);
hold off;
xlabel("t");
ylabel("y(t)");
legend("y_r_e_a_l(t)", "y_a_r_x(t)");

figure(2);
plot(y);
hold on;
plot(y_oe);
hold off;
xlabel("t");
ylabel("y(t)");
legend("y_r_e_a_l(t)", "y_o_e(t)");

figure(3);
plot(y);
hold on;
plot(y_bj);
hold off;
xlabel("t");
ylabel("y(t)");
legend("y_r_e_a_l(t)", "y_b_j(t)");


% 均值
b_oe_m = mean(b_oe);
a_oe_m = mean(a_oe);
b_arx_m = mean(b_arx);
a_arx_m = mean(a_arx);
b_bj_m = mean(b_bj);
a_bj_m = mean(a_bj);
c_bj_m = mean(c_bj);
d_bj_m = mean(d_bj);

% 标准差
b_oe_std = std(b_oe);
a_oe_std = std(a_oe);
b_arx_std = std(b_arx);
a_arx_std = std(a_arx);
b_bj_std = std(b_bj);
a_bj_std = std(a_bj);
c_bj_std = std(c_bj);
d_bj_std = std(d_bj);

% 标准偏差
b_oe_d = sqrt(var(b_oe, 1) + (b_oe_m - b0) .^ 2);
a_oe_d = sqrt(var(a_oe, 1) + (a_oe_m - a0) .^ 2);
b_arx_d = sqrt(var(b_arx, 1) + (b_arx_m - b0) .^ 2);
a_arx_d = sqrt(var(a_arx, 1) + (a_arx_m - a0) .^ 2);
b_bj_d = sqrt(var(b_bj, 1) + (b_bj_m - b0) .^ 2);
a_bj_d = sqrt(var(a_bj, 1) + (a_bj_m - a0) .^ 2);
c_bj_d = sqrt(var(c_bj, 1) + c_bj_m .^ 2);
d_bj_d = sqrt(var(d_bj, 1) + d_bj_m .^ 2);

function [data,y] = generate()
u = gbngen(1000, 10, sum(100*clock));
b0 = [0, 0, 0.8, 0.5];
a0 = [1, -1.5, 0.7];
y0 = filter(b0, a0, u);
vari = sum(y0 .^ 2) / 1000;
v = randn([1000, 1]) * sqrt(vari * 0.1);
y = y0 + v;
data = iddata(y, u);
end
