`timescale 1ns / 1ps
// 练习 1 仿真：方法一 + LED 翻转
module tb_btn_debounce;
    reg  clk, rst_n, btn_in;
    wire btn_level, btn_pos, btn_neg, led;

    // 仿真时把 CNT_MAX 改小为 10，也可以直接改模块里的默认值（见 4.5 节）
    btn_debounce #(.CNT_MAX(21'd10)) u_dut (
        .clk(clk), .rst_n(rst_n), .btn_in(btn_in),
        .btn_level(btn_level), .btn_pos(btn_pos), .btn_neg(btn_neg), .led(led)
    );

    initial clk = 0;
    always #5 clk = ~clk;                       // 100MHz

    `include "stimulus.vh"

    integer n_pos = 0, n_neg = 0, n_toggle = 0;
    always @(posedge clk) begin
        if (btn_pos) n_pos = n_pos + 1;
        if (btn_neg) n_neg = n_neg + 1;
    end
    always @(led) if (rst_n) n_toggle = n_toggle + 1;

    initial begin
        $dumpfile("tb_btn_debounce.vcd");
        $dumpvars(0, tb_btn_debounce);
        rst_n = 0; btn_in = 0;
        #100 rst_n = 1;
        #100;

        press_with_bounce(30, 30);              // 第 1 次按键
        glitch(6);                              // 6 个周期的尖峰：应被忽略
        press_with_bounce(15, 15);              // 第 2~4 次：连续快速按键
        press_with_bounce(15, 15);
        press_with_bounce(15, 15);
        #300;

        $display("btn_pos=%0d  btn_neg=%0d  LED 翻转=%0d  最终 led=%b", n_pos, n_neg, n_toggle, led);
        if (n_pos == 4 && n_neg == 4 && n_toggle == 4 && led == 1'b0)
            $display("PASS: 按 4 次，LED 翻转 4 次");
        else
            $display("FAIL");
        $finish;
    end
endmodule
