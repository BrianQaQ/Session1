`timescale 1ns / 1ps
// 练习 3-1 仿真：按下时 LED 不变，松开时才翻转
module tb_release_toggle;
    reg  clk, rst_n, btn_in;
    wire led;

    btn_release_toggle #(.CNT_MAX(21'd10)) u_dut (
        .clk(clk), .rst_n(rst_n), .btn_in(btn_in), .led(led)
    );

    initial clk = 0;
    always #5 clk = ~clk;                       // 100MHz

    `include "stimulus.vh"

    reg ok = 1;
    // 按下并稳定 20 个周期后（还没松开），LED 必须仍是 expect_before
    task check_press(input expect_before);
        begin
            btn_in = 1; #30;  btn_in = 0; #20;  // 按下抖动
            btn_in = 1; #200;                   // 稳定按住 20 个周期
            if (led !== expect_before) begin
                $display("FAIL: %0d ns 按住期间 LED 变了", $time); ok = 0;
            end
            btn_in = 0; #40;  btn_in = 1; #30;  // 释放抖动
            btn_in = 0; #300;                   // 稳定松开
            if (led !== ~expect_before) begin
                $display("FAIL: %0d ns 松开后 LED 没有翻转", $time); ok = 0;
            end
        end
    endtask

    initial begin
        $dumpfile("tb_release_toggle.vcd");
        $dumpvars(0, tb_release_toggle);
        rst_n = 0; btn_in = 0;
        #100 rst_n = 1;
        #100;
        check_press(1'b0);
        check_press(1'b1);
        glitch(6);                              // 尖峰：不应翻转
        check_press(1'b0);
        $display("最终 led=%b", led);
        if (ok && led == 1'b1) $display("PASS: 按下不变，松开翻转");
        else                   $display("FAIL");
        $finish;
    end
endmodule
