## 练习 1 约束文件（EGO1）
## 时钟 100MHz
set_property PACKAGE_PIN P17 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]
create_clock -period 10.000 -name sys_clk [get_ports clk]

## 复位：S6 复位按键，低有效
set_property PACKAGE_PIN P15 [get_ports rst_n]
set_property IOSTANDARD LVCMOS33 [get_ports rst_n]

## 按键：右侧 5 个通用按键之一（R11），高有效
set_property PACKAGE_PIN R11 [get_ports btn_in]
set_property IOSTANDARD LVCMOS33 [get_ports btn_in]

## LED：led 是练习要求的翻转灯；其余输出也必须分配引脚，否则无法生成比特流
set_property PACKAGE_PIN K2 [get_ports led]
set_property IOSTANDARD LVCMOS33 [get_ports led]
set_property PACKAGE_PIN J2 [get_ports btn_level]
set_property IOSTANDARD LVCMOS33 [get_ports btn_level]
set_property PACKAGE_PIN J3 [get_ports btn_pos]
set_property IOSTANDARD LVCMOS33 [get_ports btn_pos]
set_property PACKAGE_PIN H4 [get_ports btn_neg]
set_property IOSTANDARD LVCMOS33 [get_ports btn_neg]
