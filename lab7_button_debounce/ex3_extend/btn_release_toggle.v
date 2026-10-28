// 练习 3-1：松开才响应。按下时 LED 不变，松开时 LED 翻转一次
`timescale 1ns / 1ps
module btn_release_toggle #(
    parameter CNT_MAX = 21'd2_000_000      // 20ms @ 100MHz（仿真时改为 21'd10）
)(
    input      clk,
    input      rst_n,
    input      btn_in,                     // 按键输入，按下为高
    output reg led                         // 每松开一次翻转一次
);
    // ---------------- 第一部分：电平型消抖 ----------------
    reg [20:0] cnt;
    reg        btn_level;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt       <= 21'd0;
            btn_level <= 1'b0;
        end
        else if (btn_in == btn_level)
            cnt <= 21'd0;
        else if (cnt == CNT_MAX - 1) begin
            btn_level <= btn_in;
            cnt       <= 21'd0;
        end
        else
            cnt <= cnt + 1'b1;
    end

    // ---------------- 第二部分：边沿检测（只需要下降沿） ----------------
    reg btn_level_d;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            btn_level_d <= 1'b0;
        else
            btn_level_d <= btn_level;
    end

    wire btn_neg = ~btn_level & btn_level_d;     // 下降沿：释放

    // ---------------- 第三部分：松开时 LED 翻转 ----------------
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            led <= 1'b0;
        else if (btn_neg)
            led <= ~led;
    end
endmodule
