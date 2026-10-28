// 两个 testbench 共用的按键激励（CNT_MAX = 10，时钟周期 10ns）
// 所有抖动的宽度都小于 10 个时钟周期，稳定时间都大于 10 个时钟周期

// 一次带抖动的完整按键：按下抖动 → 稳定按住 hold 个周期 → 释放抖动 → 稳定松开 gap 个周期
task press_with_bounce(input integer hold, input integer gap);
    begin
        btn_in = 1; #30;  btn_in = 0; #20;     // 按下抖动
        btn_in = 1; #50;  btn_in = 0; #40;
        btn_in = 1; #(hold*10);                // 稳定按下
        btn_in = 0; #40;  btn_in = 1; #30;     // 释放抖动
        btn_in = 0; #20;  btn_in = 1; #60;
        btn_in = 0; #(gap*10);                 // 稳定松开
    end
endtask

// 一个短于消抖时间的尖峰，不应该被当作按键
task glitch(input integer width);
    begin
        btn_in = 1; #(width*10);
        btn_in = 0; #300;
    end
endtask
