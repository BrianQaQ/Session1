// 练习 3-2：长按清零。短按（松开时按住不足 1 秒）计数器加 1，按住满 1 秒计数器清零
`timescale 1ns / 1ps
module btn_long_press_clr #(
    parameter CNT_MAX  = 21'd2_000_000,    // 消抖 20ms @ 100MHz（仿真时改为 21'd10）
    parameter LONG_MAX = 27'd100_000_000   // 长按 1s @ 100MHz（仿真时改为 27'd100）
)(
    input            clk,
    input            rst_n,
    input            btn_in,               // 按键输入，按下为高
    output reg [7:0] led                   // 计数值，二进制显示
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

    // ---------------- 第三部分：按住计时 ----------------
    // btn_level 为高时计数，计到 LONG_MAX-1（满 1 秒）后保持；松开清零
    reg [26:0] hold_cnt;                   // 2^27 = 134,217,728 > 100,000,000
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            hold_cnt <= 27'd0;
        else if (!btn_level)
            hold_cnt <= 27'd0;
        else if (hold_cnt == LONG_MAX - 1)
            hold_cnt <= hold_cnt;          // 保持，表示已经是长按
        else
            hold_cnt <= hold_cnt + 1'b1;
    end

    // btn_neg 为高的那一拍，hold_cnt 还没被清零，保存的正是这次按住的时长
    wire long_press = (hold_cnt == LONG_MAX - 1);

    // ---------------- 第四部分：8 位计数器 ----------------
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            led <= 8'd0;
        else if (long_press)               // 按住满 1 秒：立即清零（按住期间一直保持 0）
            led <= 8'd0;
        else if (btn_neg)                  // 不足 1 秒就松开：短按，加 1
            led <= led + 1'b1;
    end
endmodule
