## 练习 3-1 约束文件（EGO1）
set_property PACKAGE_PIN P17 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]
create_clock -period 10.000 -name sys_clk [get_ports clk]

## 复位：S6 复位按键，低有效
set_property PACKAGE_PIN P15 [get_ports rst_n]
set_property IOSTANDARD LVCMOS33 [get_ports rst_n]

## 按键：右侧 5 个通用按键之一（R11），高有效
set_property PACKAGE_PIN R11 [get_ports btn_in]
set_property IOSTANDARD LVCMOS33 [get_ports btn_in]

set_property PACKAGE_PIN K2 [get_ports led]
set_property IOSTANDARD LVCMOS33 [get_ports led]
