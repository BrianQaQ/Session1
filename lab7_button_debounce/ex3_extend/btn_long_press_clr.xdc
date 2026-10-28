## 练习 3-2 约束文件（EGO1）
set_property PACKAGE_PIN P17 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]
create_clock -period 10.000 -name sys_clk [get_ports clk]

## 复位：S6 复位按键，低有效
set_property PACKAGE_PIN P15 [get_ports rst_n]
set_property IOSTANDARD LVCMOS33 [get_ports rst_n]

## 按键：右侧 5 个通用按键之一（R11），高有效
set_property PACKAGE_PIN R11 [get_ports btn_in]
set_property IOSTANDARD LVCMOS33 [get_ports btn_in]

## 8 个 LED，led[0] 为最低位
set_property PACKAGE_PIN K2 [get_ports {led[0]}]
set_property PACKAGE_PIN J2 [get_ports {led[1]}]
set_property PACKAGE_PIN J3 [get_ports {led[2]}]
set_property PACKAGE_PIN H4 [get_ports {led[3]}]
set_property PACKAGE_PIN J4 [get_ports {led[4]}]
set_property PACKAGE_PIN G3 [get_ports {led[5]}]
set_property PACKAGE_PIN G4 [get_ports {led[6]}]
set_property PACKAGE_PIN F6 [get_ports {led[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[*]}]
