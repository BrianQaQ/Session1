`timescale 1ns / 1ps
// 练习 3-2 仿真：短按加 1，长按清零（CNT_MAX = 10，LONG_MAX = 100 相当于"1 秒 = 100 个周期"）
module tb_long_press_clr;
    reg        clk, rst_n, btn_in;
    wire [7:0] led;

    btn_long_press_clr #(.CNT_MAX(21'd10), .LONG_MAX(27'd100)) u_dut (
        .clk(clk), .rst_n(rst_n), .btn_in(btn_in), .led(led)
    );

    initial clk = 0;
    always #5 clk = ~clk;                       // 100MHz

    `include "stimulus.vh"

    reg ok = 1;
    task expect(input [7:0] value);
        begin
            $display("%0d ns: led = %0d（期望 %0d）", $time, led, value);
            if (led !== value) ok = 0;
        end
    endtask

    initial begin
        $dumpfile("tb_long_press_clr.vcd");
        $dumpvars(0, tb_long_press_clr);
        rst_n = 0; btn_in = 0;
        #100 rst_n = 1;
        #100;

        press_with_bounce(30, 30);              // 短按 3 次 → 3
        press_with_bounce(30, 30);
        press_with_bounce(30, 30);
        expect(8'd3);

        press_with_bounce(80, 30);              // 按住 80 个周期，不到"1 秒" → 4
        expect(8'd4);

        btn_in = 1; #1200;                      // 长按：按住 120 个周期，还没松开
        expect(8'd0);                           // 按住期间已经清零
        btn_in = 0; #300;                       // 松开，不应再加 1
        expect(8'd0);

        press_with_bounce(30, 30);              // 再短按 2 次 → 2
        press_with_bounce(30, 30);
        expect(8'd2);

        if (ok) $display("PASS: 短按加 1，长按清零");
        else    $display("FAIL");
        $finish;
    end
endmodule
