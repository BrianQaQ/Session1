// 练习 2：方法二（脉冲型消抖），每按一次按键 LED 翻转一次
`timescale 1ns / 1ps
module btn_debounce_pulse #(
    parameter CNT_MAX = 21'd2_000_000      // 20ms @ 100MHz（仿真时改为 21'd10）
)(
    input      clk,
    input      rst_n,
    input      btn_in,                     // 按键输入，按下为高
    output reg btn_pulse,                  // 每次按下输出 1 个时钟周期的脉冲
    output reg led                         // 每按一次翻转一次
);
    // 按住时计数，计到 N-1 后保持；松开或抖动回低则清零
    reg [20:0] cnt;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            cnt <= 21'd0;
        else if (btn_in == 1'b0)
            cnt <= 21'd0;
        else if (cnt == CNT_MAX - 1)
            cnt <= cnt;                    // 保持不变，防止重复触发
        else
            cnt <= cnt + 1'b1;
    end

    // 计数器只会经过 CNT_MAX-2 一次，因此只输出一个周期的脉冲
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            btn_pulse <= 1'b0;
        else if (cnt == CNT_MAX - 2)
            // cnt 为 N-2 时，下一个时钟沿 cnt 变为 N-1，btn_pulse 同时拉高
            btn_pulse <= 1'b1;
        else
            btn_pulse <= 1'b0;
    end

    // LED 翻转：btn_pulse 已经是单周期脉冲，不需要再做边沿检测
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            led <= 1'b0;
        else if (btn_pulse)
            led <= ~led;
    end
endmodule
