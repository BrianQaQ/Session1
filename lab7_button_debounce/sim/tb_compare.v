`timescale 1ns / 1ps
// 练习 2 仿真：同一个按键激励同时驱动两种方案，对比 LED 翻转时刻和释放行为
module tb_compare;
    reg  clk, rst_n, btn_in;
    wire btn_level, btn_pos, btn_neg, led1;     // 方法一
    wire btn_pulse, led2;                       // 方法二

    btn_debounce #(.CNT_MAX(21'd10)) u_level (
        .clk(clk), .rst_n(rst_n), .btn_in(btn_in),
        .btn_level(btn_level), .btn_pos(btn_pos), .btn_neg(btn_neg), .led(led1)
    );

    btn_debounce_pulse #(.CNT_MAX(21'd10)) u_pulse (
        .clk(clk), .rst_n(rst_n), .btn_in(btn_in),
        .btn_pulse(btn_pulse), .led(led2)
    );

    initial clk = 0;
    always #5 clk = ~clk;                       // 100MHz

    `include "stimulus.vh"

    // 记录按键最后一次变高 / 变低的时刻，即"稳定按下 / 稳定松开"的起点
    time t_press, t_release;
    always @(posedge btn_in) t_press   = $time;
    always @(negedge btn_in) t_release = $time;

    always @(led1) if (rst_n)
        $display("[方法一] %0d ns: LED 翻转，比稳定按下晚 %0d ns（%0d 个周期）",
                 $time, $time - t_press, ($time - t_press) / 10);
    always @(led2) if (rst_n)
        $display("[方法二] %0d ns: LED 翻转，比稳定按下晚 %0d ns（%0d 个周期）",
                 $time, $time - t_press, ($time - t_press) / 10);
    always @(negedge btn_level) if (rst_n)
        $display("[方法一] %0d ns: btn_level 变低，比稳定松开晚 %0d ns（%0d 个周期）",
                 $time, $time - t_release, ($time - t_release) / 10);

    initial begin
        $dumpfile("tb_compare.vcd");
        $dumpvars(0, tb_compare);
        rst_n = 0; btn_in = 0;
        #100 rst_n = 1;
        #100;

        press_with_bounce(30, 30);
        glitch(6);
        press_with_bounce(15, 15);
        #300;

        $display("最终 led1=%b led2=%b", led1, led2);
        $finish;
    end
endmodule
