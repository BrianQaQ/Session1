// 练习 1：方法一（电平型消抖 + 边沿检测），每按一次按键 LED 翻转一次
`timescale 1ns / 1ps
module btn_debounce #(
    parameter CNT_MAX = 21'd2_000_000      // 20ms @ 100MHz（仿真时改为 21'd10）
)(
    input      clk,
    input      rst_n,
    input      btn_in,                     // 按键输入，按下为高
    output reg btn_level,                  // 消抖后的干净电平
    output     btn_pos,                    // 按下时的单周期脉冲
    output     btn_neg,                    // 释放时的单周期脉冲
    output reg led                         // 每按一次翻转一次
);
    // ---------------- 第一部分：电平型消抖 ----------------
    // 输入与当前输出不同，并持续 20ms，才更新输出
    reg [20:0] cnt;                        // 2^21 = 2,097,152 > 2,000,000
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt       <= 21'd0;
            btn_level <= 1'b0;
        end
        else if (btn_in == btn_level)      // 没有变化（或抖动变回原值）：清零
            cnt <= 21'd0;
        else if (cnt == CNT_MAX - 1) begin // 新电平稳定满 20ms：更新输出
            btn_level <= btn_in;
            cnt       <= 21'd0;
        end
        else                               // 有变化但还没稳定够 20ms：继续计数
            cnt <= cnt + 1'b1;
    end

    // ---------------- 第二部分：边沿检测 ----------------
    reg btn_level_d;                       // btn_level 延迟一拍
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            btn_level_d <= 1'b0;
        else
            btn_level_d <= btn_level;
    end

    assign btn_pos = btn_level & ~btn_level_d;   // 上升沿：按下
    assign btn_neg = ~btn_level & btn_level_d;   // 下降沿：释放

    // ---------------- 第三部分：LED 翻转 ----------------
    // btn_pos 每次按下只高一个周期，所以每按一次只翻转一次
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            led <= 1'b0;
        else if (btn_pos)
            led <= ~led;
    end
endmodule
