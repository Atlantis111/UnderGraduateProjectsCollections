#约束A输入端口管脚为1.8V电平
set_property PACKAGE_PIN V5 [get_ports A]

set_property IOSTANDARD LVCMOS18 [get_ports B]
#对应左边第二个开关
set_property IOSTANDARD LVCMOS18 [get_ports C]
#对应左边第三个开关
#对应左边第四个开关
set_property IOSTANDARD LVCMOS18 [get_ports E]
#对应左边第五个开关
set_property IOSTANDARD LVCMOS18 [get_ports F]

set_property PACKAGE_PIN U8 [get_ports B]
set_property PACKAGE_PIN T8 [get_ports C]
set_property PACKAGE_PIN R8 [get_ports D]
set_property PACKAGE_PIN T6 [get_ports E]
set_property PACKAGE_PIN R7 [get_ports F]
set_property IOSTANDARD LVCMOS18 [get_ports D]
set_property IOSTANDARD LVCMOS18 [get_ports A]
