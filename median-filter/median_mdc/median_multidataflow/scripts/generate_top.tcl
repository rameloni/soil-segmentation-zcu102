# Script compliant with Vivado 2017.1

###########################
# IP Settings
###########################

# paths

# user should properly set root path
set root "."
set projdir $root/project_top
set ipdir $root/s_accelerator/project_ip

set constraints_files []

# FPGA device
set partname "xc7z020clg484-1"

# Board part
set boardpart "em.avnet.com:zed:part0:1.0"

# Design name
set design system
set bd_design "design_1"

set ip_name "s_accelerator"
set ip_version "1.0"
set ip_v "v1_0"


###########################
# Create Project
###########################
create_project -force $design $projdir -part $partname 
set_property board_part $boardpart [current_project]
set_property target_language Verilog [current_project]
set_property  ip_repo_paths $ipdir [current_project]
update_ip_catalog -rebuild -scan_changes
###########################
#create block design
create_bd_design $bd_design

# Zynq PS
create_bd_cell -type ip -vlnv xilinx.com:ip:processing_system7:5.5 processing_system7_0
apply_bd_automation -rule xilinx.com:bd_rule:processing_system7 -config {make_external "FIXED_IO, DDR" apply_board_preset "1" Master "Disable" Slave "Disable" }  [get_bd_cells processing_system7_0]
connect_bd_net [get_bd_pins processing_system7_0/M_AXI_GP0_ACLK] [get_bd_pins processing_system7_0/FCLK_CLK0]

# accelerator IP
create_bd_cell -type ip -vlnv user.org:user:$ip_name:$ip_version $ip_name\_0
apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config {Master "/processing_system7_0/M_AXI_GP0" intc_ip "New AXI Interconnect" Clk_xbar "Auto" Clk_master "Auto" Clk_slave "Auto" }  [get_bd_intf_pins $ip_name\_0/s00_axi]

# fifos - accelerator side
# fifo_in 2
connect_bd_net [get_bd_pins processing_system7_0/FCLK_CLK0] [get_bd_pins s_accelerator_0/s02_axis_aclk]
connect_bd_net [get_bd_pins rst_ps7_0_100M/peripheral_aresetn] [get_bd_pins s_accelerator_0/s02_axis_aresetn]
create_bd_cell -type ip -vlnv xilinx.com:ip:axis_data_fifo:1.1 axis_data_fifo_in_2
connect_bd_intf_net [get_bd_intf_pins axis_data_fifo_in_2/M_AXIS] [get_bd_intf_pins s_accelerator_0/s02_axis]
connect_bd_net [get_bd_pins processing_system7_0/FCLK_CLK0] [get_bd_pins axis_data_fifo_in_2/s_axis_aclk]
connect_bd_net [get_bd_pins rst_ps7_0_100M/peripheral_aresetn] [get_bd_pins axis_data_fifo_in_2/s_axis_aresetn]
# fifo_in 3
connect_bd_net [get_bd_pins processing_system7_0/FCLK_CLK0] [get_bd_pins s_accelerator_0/s03_axis_aclk]
connect_bd_net [get_bd_pins rst_ps7_0_100M/peripheral_aresetn] [get_bd_pins s_accelerator_0/s03_axis_aresetn]
create_bd_cell -type ip -vlnv xilinx.com:ip:axis_data_fifo:1.1 axis_data_fifo_in_3
connect_bd_intf_net [get_bd_intf_pins axis_data_fifo_in_3/M_AXIS] [get_bd_intf_pins s_accelerator_0/s03_axis]
connect_bd_net [get_bd_pins processing_system7_0/FCLK_CLK0] [get_bd_pins axis_data_fifo_in_3/s_axis_aclk]
connect_bd_net [get_bd_pins rst_ps7_0_100M/peripheral_aresetn] [get_bd_pins axis_data_fifo_in_3/s_axis_aresetn]
# fifo_in 1
connect_bd_net [get_bd_pins processing_system7_0/FCLK_CLK0] [get_bd_pins s_accelerator_0/s01_axis_aclk]
connect_bd_net [get_bd_pins rst_ps7_0_100M/peripheral_aresetn] [get_bd_pins s_accelerator_0/s01_axis_aresetn]
create_bd_cell -type ip -vlnv xilinx.com:ip:axis_data_fifo:1.1 axis_data_fifo_in_1
connect_bd_intf_net [get_bd_intf_pins axis_data_fifo_in_1/M_AXIS] [get_bd_intf_pins s_accelerator_0/s01_axis]
connect_bd_net [get_bd_pins processing_system7_0/FCLK_CLK0] [get_bd_pins axis_data_fifo_in_1/s_axis_aclk]
connect_bd_net [get_bd_pins rst_ps7_0_100M/peripheral_aresetn] [get_bd_pins axis_data_fifo_in_1/s_axis_aresetn]
# fifo_in 4
connect_bd_net [get_bd_pins processing_system7_0/FCLK_CLK0] [get_bd_pins s_accelerator_0/s04_axis_aclk]
connect_bd_net [get_bd_pins rst_ps7_0_100M/peripheral_aresetn] [get_bd_pins s_accelerator_0/s04_axis_aresetn]
create_bd_cell -type ip -vlnv xilinx.com:ip:axis_data_fifo:1.1 axis_data_fifo_in_4
connect_bd_intf_net [get_bd_intf_pins axis_data_fifo_in_4/M_AXIS] [get_bd_intf_pins s_accelerator_0/s04_axis]
connect_bd_net [get_bd_pins processing_system7_0/FCLK_CLK0] [get_bd_pins axis_data_fifo_in_4/s_axis_aclk]
connect_bd_net [get_bd_pins rst_ps7_0_100M/peripheral_aresetn] [get_bd_pins axis_data_fifo_in_4/s_axis_aresetn]
# fifo_in 0
connect_bd_net [get_bd_pins processing_system7_0/FCLK_CLK0] [get_bd_pins s_accelerator_0/s00_axis_aclk]
connect_bd_net [get_bd_pins rst_ps7_0_100M/peripheral_aresetn] [get_bd_pins s_accelerator_0/s00_axis_aresetn]
create_bd_cell -type ip -vlnv xilinx.com:ip:axis_data_fifo:1.1 axis_data_fifo_in_0
connect_bd_intf_net [get_bd_intf_pins axis_data_fifo_in_0/M_AXIS] [get_bd_intf_pins s_accelerator_0/s00_axis]
connect_bd_net [get_bd_pins processing_system7_0/FCLK_CLK0] [get_bd_pins axis_data_fifo_in_0/s_axis_aclk]
connect_bd_net [get_bd_pins rst_ps7_0_100M/peripheral_aresetn] [get_bd_pins axis_data_fifo_in_0/s_axis_aresetn]

# fifo_out 
connect_bd_net [get_bd_pins processing_system7_0/FCLK_CLK0] [get_bd_pins s_accelerator_0/m02_axis_aclk]
connect_bd_net [get_bd_pins rst_ps7_0_100M/peripheral_aresetn] [get_bd_pins s_accelerator_0/m02_axis_aresetn]
create_bd_cell -type ip -vlnv xilinx.com:ip:axis_data_fifo:1.1 axis_data_fifo_out_2
connect_bd_intf_net [get_bd_intf_pins s_accelerator_0/m02_axis] [get_bd_intf_pins axis_data_fifo_out_2/S_AXIS]
connect_bd_net [get_bd_pins processing_system7_0/FCLK_CLK0] [get_bd_pins axis_data_fifo_out_2/s_axis_aclk]
connect_bd_net [get_bd_pins rst_ps7_0_100M/peripheral_aresetn] [get_bd_pins axis_data_fifo_out_2/s_axis_aresetn]
# fifo_out 
connect_bd_net [get_bd_pins processing_system7_0/FCLK_CLK0] [get_bd_pins s_accelerator_0/m01_axis_aclk]
connect_bd_net [get_bd_pins rst_ps7_0_100M/peripheral_aresetn] [get_bd_pins s_accelerator_0/m01_axis_aresetn]
create_bd_cell -type ip -vlnv xilinx.com:ip:axis_data_fifo:1.1 axis_data_fifo_out_1
connect_bd_intf_net [get_bd_intf_pins s_accelerator_0/m01_axis] [get_bd_intf_pins axis_data_fifo_out_1/S_AXIS]
connect_bd_net [get_bd_pins processing_system7_0/FCLK_CLK0] [get_bd_pins axis_data_fifo_out_1/s_axis_aclk]
connect_bd_net [get_bd_pins rst_ps7_0_100M/peripheral_aresetn] [get_bd_pins axis_data_fifo_out_1/s_axis_aresetn]
# fifo_out 
connect_bd_net [get_bd_pins processing_system7_0/FCLK_CLK0] [get_bd_pins s_accelerator_0/m04_axis_aclk]
connect_bd_net [get_bd_pins rst_ps7_0_100M/peripheral_aresetn] [get_bd_pins s_accelerator_0/m04_axis_aresetn]
create_bd_cell -type ip -vlnv xilinx.com:ip:axis_data_fifo:1.1 axis_data_fifo_out_4
connect_bd_intf_net [get_bd_intf_pins s_accelerator_0/m04_axis] [get_bd_intf_pins axis_data_fifo_out_4/S_AXIS]
connect_bd_net [get_bd_pins processing_system7_0/FCLK_CLK0] [get_bd_pins axis_data_fifo_out_4/s_axis_aclk]
connect_bd_net [get_bd_pins rst_ps7_0_100M/peripheral_aresetn] [get_bd_pins axis_data_fifo_out_4/s_axis_aresetn]
# fifo_out 
connect_bd_net [get_bd_pins processing_system7_0/FCLK_CLK0] [get_bd_pins s_accelerator_0/m03_axis_aclk]
connect_bd_net [get_bd_pins rst_ps7_0_100M/peripheral_aresetn] [get_bd_pins s_accelerator_0/m03_axis_aresetn]
create_bd_cell -type ip -vlnv xilinx.com:ip:axis_data_fifo:1.1 axis_data_fifo_out_3
connect_bd_intf_net [get_bd_intf_pins s_accelerator_0/m03_axis] [get_bd_intf_pins axis_data_fifo_out_3/S_AXIS]
connect_bd_net [get_bd_pins processing_system7_0/FCLK_CLK0] [get_bd_pins axis_data_fifo_out_3/s_axis_aclk]
connect_bd_net [get_bd_pins rst_ps7_0_100M/peripheral_aresetn] [get_bd_pins axis_data_fifo_out_3/s_axis_aresetn]
# fifo_out 
connect_bd_net [get_bd_pins processing_system7_0/FCLK_CLK0] [get_bd_pins s_accelerator_0/m00_axis_aclk]
connect_bd_net [get_bd_pins rst_ps7_0_100M/peripheral_aresetn] [get_bd_pins s_accelerator_0/m00_axis_aresetn]
create_bd_cell -type ip -vlnv xilinx.com:ip:axis_data_fifo:1.1 axis_data_fifo_out_0
connect_bd_intf_net [get_bd_intf_pins s_accelerator_0/m00_axis] [get_bd_intf_pins axis_data_fifo_out_0/S_AXIS]
connect_bd_net [get_bd_pins processing_system7_0/FCLK_CLK0] [get_bd_pins axis_data_fifo_out_0/s_axis_aclk]
connect_bd_net [get_bd_pins rst_ps7_0_100M/peripheral_aresetn] [get_bd_pins axis_data_fifo_out_0/s_axis_aresetn]

# fifos - processor side
# DMA 0
create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 axi_dma_0
apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config {Master "/processing_system7_0/M_AXI_GP0" intc_ip "/ps7_0_axi_periph" Clk_xbar "Auto" Clk_master "Auto" Clk_slave "Auto" }  [get_bd_intf_pins axi_dma_0/S_AXI_LITE]
set_property -dict [list CONFIG.PCW_USE_S_AXI_HP0 {1}] [get_bd_cells processing_system7_0]
set_property -dict [list CONFIG.c_include_sg {0} CONFIG.c_sg_include_stscntrl_strm {0}] [get_bd_cells axi_dma_0]
connect_bd_intf_net [get_bd_intf_pins axis_data_fifo_in_0/S_AXIS] [get_bd_intf_pins axi_dma_0/M_AXIS_MM2S]						
apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config {Master "/axi_dma_0/M_AXI_MM2S" intc_ip "Auto" Clk_xbar "Auto" Clk_master "Auto" Clk_slave "Auto" }  [get_bd_intf_pins processing_system7_0/S_AXI_HP0]
connect_bd_intf_net [get_bd_intf_pins axis_data_fifo_out_0/M_AXIS] [get_bd_intf_pins axi_dma_0/S_AXIS_S2MM]
apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config {Slave "/processing_system7_0/S_AXI_HP0" intc_ip "/axi_smc" Clk_xbar "Auto" Clk_master "Auto" Clk_slave "Auto" }  [get_bd_intf_pins axi_dma_0/M_AXI_S2MM]
# DMA 1
create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 axi_dma_1
apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config {Master "/processing_system7_0/M_AXI_GP0" intc_ip "/ps7_0_axi_periph" Clk_xbar "Auto" Clk_master "Auto" Clk_slave "Auto" }  [get_bd_intf_pins axi_dma_1/S_AXI_LITE]
set_property -dict [list CONFIG.PCW_USE_S_AXI_HP1 {1}] [get_bd_cells processing_system7_0]
set_property -dict [list CONFIG.c_include_sg {0} CONFIG.c_sg_include_stscntrl_strm {0}] [get_bd_cells axi_dma_1]
connect_bd_intf_net [get_bd_intf_pins axis_data_fifo_in_1/S_AXIS] [get_bd_intf_pins axi_dma_1/M_AXIS_MM2S]						
apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config {Master "/axi_dma_1/M_AXI_MM2S" intc_ip "Auto" Clk_xbar "Auto" Clk_master "Auto" Clk_slave "Auto" }  [get_bd_intf_pins processing_system7_0/S_AXI_HP1]
connect_bd_intf_net [get_bd_intf_pins axis_data_fifo_out_1/M_AXIS] [get_bd_intf_pins axi_dma_1/S_AXIS_S2MM]
apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config {Slave "/processing_system7_0/S_AXI_HP1" intc_ip "/axi_smc" Clk_xbar "Auto" Clk_master "Auto" Clk_slave "Auto" }  [get_bd_intf_pins axi_dma_1/M_AXI_S2MM]
# DMA 2
create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 axi_dma_2
apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config {Master "/processing_system7_0/M_AXI_GP0" intc_ip "/ps7_0_axi_periph" Clk_xbar "Auto" Clk_master "Auto" Clk_slave "Auto" }  [get_bd_intf_pins axi_dma_2/S_AXI_LITE]
set_property -dict [list CONFIG.PCW_USE_S_AXI_HP2 {1}] [get_bd_cells processing_system7_0]
set_property -dict [list CONFIG.c_include_sg {0} CONFIG.c_sg_include_stscntrl_strm {0}] [get_bd_cells axi_dma_2]
connect_bd_intf_net [get_bd_intf_pins axis_data_fifo_in_2/S_AXIS] [get_bd_intf_pins axi_dma_2/M_AXIS_MM2S]						
apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config {Master "/axi_dma_2/M_AXI_MM2S" intc_ip "Auto" Clk_xbar "Auto" Clk_master "Auto" Clk_slave "Auto" }  [get_bd_intf_pins processing_system7_0/S_AXI_HP2]
connect_bd_intf_net [get_bd_intf_pins axis_data_fifo_out_2/M_AXIS] [get_bd_intf_pins axi_dma_2/S_AXIS_S2MM]
apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config {Slave "/processing_system7_0/S_AXI_HP2" intc_ip "/axi_smc" Clk_xbar "Auto" Clk_master "Auto" Clk_slave "Auto" }  [get_bd_intf_pins axi_dma_2/M_AXI_S2MM]
# DMA 3
create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 axi_dma_3
apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config {Master "/processing_system7_0/M_AXI_GP0" intc_ip "/ps7_0_axi_periph" Clk_xbar "Auto" Clk_master "Auto" Clk_slave "Auto" }  [get_bd_intf_pins axi_dma_3/S_AXI_LITE]
set_property -dict [list CONFIG.PCW_USE_S_AXI_HP3 {1}] [get_bd_cells processing_system7_0]
set_property -dict [list CONFIG.c_include_sg {0} CONFIG.c_sg_include_stscntrl_strm {0}] [get_bd_cells axi_dma_3]
connect_bd_intf_net [get_bd_intf_pins axis_data_fifo_in_3/S_AXIS] [get_bd_intf_pins axi_dma_3/M_AXIS_MM2S]						
apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config {Master "/axi_dma_3/M_AXI_MM2S" intc_ip "Auto" Clk_xbar "Auto" Clk_master "Auto" Clk_slave "Auto" }  [get_bd_intf_pins processing_system7_0/S_AXI_HP3]
connect_bd_intf_net [get_bd_intf_pins axis_data_fifo_out_3/M_AXIS] [get_bd_intf_pins axi_dma_3/S_AXIS_S2MM]
apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config {Slave "/processing_system7_0/S_AXI_HP3" intc_ip "/axi_smc" Clk_xbar "Auto" Clk_master "Auto" Clk_slave "Auto" }  [get_bd_intf_pins axi_dma_3/M_AXI_S2MM]
# DMA 4
create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 axi_dma_4
apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config {Master "/processing_system7_0/M_AXI_GP0" intc_ip "/ps7_0_axi_periph" Clk_xbar "Auto" Clk_master "Auto" Clk_slave "Auto" }  [get_bd_intf_pins axi_dma_4/S_AXI_LITE]
set_property -dict [list CONFIG.PCW_USE_S_AXI_HP4 {1}] [get_bd_cells processing_system7_0]
set_property -dict [list CONFIG.c_include_sg {0} CONFIG.c_sg_include_stscntrl_strm {0}] [get_bd_cells axi_dma_4]
connect_bd_intf_net [get_bd_intf_pins axis_data_fifo_in_4/S_AXIS] [get_bd_intf_pins axi_dma_4/M_AXIS_MM2S]						
apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config {Master "/axi_dma_4/M_AXI_MM2S" intc_ip "Auto" Clk_xbar "Auto" Clk_master "Auto" Clk_slave "Auto" }  [get_bd_intf_pins processing_system7_0/S_AXI_HP4]
connect_bd_intf_net [get_bd_intf_pins axis_data_fifo_out_4/M_AXIS] [get_bd_intf_pins axi_dma_4/S_AXIS_S2MM]
apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config {Slave "/processing_system7_0/S_AXI_HP4" intc_ip "/axi_smc" Clk_xbar "Auto" Clk_master "Auto" Clk_slave "Auto" }  [get_bd_intf_pins axi_dma_4/M_AXI_S2MM]

make_wrapper -files [get_files $projdir/$design.srcs/sources_1/bd/design_1/design_1.bd] -top
add_files -norecurse $projdir/$design.srcs/sources_1/bd/design_1/hdl/design_1_wrapper.v

generate_target all [get_files  $projdir/$design.srcs/sources_1/bd/design_1/design_1.bd]
