# handshakes_revise2022_0426_2331
# 这个Vivado工程文件包含RTL代码和行为级仿真，Verilog代码(hand_shake.v)位置在目录Handshakes\Handshakes_r\Handshakes_r.srcs\sources_1\imports\Handshakes_r\下。
# 仿真截图文件(hand.png)位置在目录Handshakes\Handshakes_r\下。
# 代码说明如下：
# clk_m,clk_s分别表示master和slave的时钟，在仿真中时钟周期设置值分别为10ns和14ns
# rst_n表示低电平复位，仿真中采用同步复位方式，第10ns时rst_n被拉高，往后一直处于高电平状态
# master发送的数据由RAM[9:0]提供，RAM[9:0]自定义为每1ns进行一次加1操作，握手传输数据由master根据时钟采样得到。
# 仿真截图文件(hand.png)中data表示master发送的数据，data_r表示slave接收并存储的数据
