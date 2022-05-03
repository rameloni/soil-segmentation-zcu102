# Script compliant with Vivado 2017.1

###########################
# IP Settings
###########################

# paths

# user should properly set root path
set root "."
set iproot $root/s_accelerator
set ipdir $iproot/project_ip

set hdl_files_path $root/s_accelerator/hdl

set bd_pkg_dir s_accelerator/bd
set drivers_dir s_accelerator/drivers

set constraints_files []

# FPGA device
set partname "xc7z020clg484-1"


# Board part
set boardpart "em.avnet.com:zed:part0:1.0"

# Design name
set ip_name "s_accelerator"
set design $ip_name

###########################
# Create IP
###########################

create_project -force $design $ipdir -part $partname 
set_property board_part $boardpart [current_project]
set_property target_language Verilog [current_project]

add_files $hdl_files_path
import_files -force


if {[llength [glob -nocomplain -dir $hdl_files_path *.dat]] != 0} {
	foreach dat_file [glob -dir $hdl_files_path *.dat] {
		import_file $dat_file
	}
}

if {[llength [glob -nocomplain -dir $hdl_files_path *.mem]] != 0} {
	foreach mem_file [glob -dir $hdl_files_path *.mem] {
		import_file $mem_file
	}
}

if {[llength [glob -nocomplain -dir $hdl_files_path *.tcl]] != 0} {
	 foreach tcl_file [glob -dir $hdl_files_path *.tcl] {
	     source $tcl_file
	}
}

set_property top $ip_name [current_fileset]

ipx::package_project -root_dir $ipdir -vendor user.org -library user -taxonomy AXI_Peripheral

ipx::remove_address_block reg0 [ipx::get_memory_maps s00_axi -of_objects [ipx::current_core]]
ipx::add_address_block s00_axi_reg [ipx::get_memory_maps s00_axi -of_objects [ipx::current_core]]
set_property usage register [ipx::get_address_blocks s00_axi_reg -of_objects [ipx::get_memory_maps s00_axi -of_objects [ipx::current_core]]]
ipx::add_address_block_parameter OFFSET_BASE_PARAM [ipx::get_address_blocks s00_axi_reg -of_objects [ipx::get_memory_maps s00_axi -of_objects [ipx::current_core]]]
ipx::add_address_block_parameter OFFSET_HIGH_PARAM [ipx::get_address_blocks s00_axi_reg -of_objects [ipx::get_memory_maps s00_axi -of_objects [ipx::current_core]]]
set_property value C_CFG_BASEADDR [ipx::get_address_block_parameters OFFSET_BASE_PARAM -of_objects [ipx::get_address_blocks s00_axi_reg -of_objects [ipx::get_memory_maps s00_axi -of_objects [ipx::current_core]]]]
set_property value C_CFG_HIGHADDR [ipx::get_address_block_parameters OFFSET_HIGH_PARAM -of_objects [ipx::get_address_blocks s00_axi_reg -of_objects [ipx::get_memory_maps s00_axi -of_objects [ipx::current_core]]]]	

file copy -force $iproot/drivers $ipdir
set drivers_dir drivers
ipx::add_file_group -type software_driver {} [ipx::current_core]
ipx::add_file $drivers_dir/src/s_accelerator.c [ipx::get_file_groups xilinx_softwaredriver -of_objects [ipx::current_core]]
set_property type cSource [ipx::get_files $drivers_dir/src/s_accelerator.c -of_objects [ipx::get_file_groups xilinx_softwaredriver -of_objects [ipx::current_core]]]
ipx::add_file $drivers_dir/src/s_accelerator.h [ipx::get_file_groups xilinx_softwaredriver -of_objects [ipx::current_core]]
set_property type cSource [ipx::get_files $drivers_dir/src/s_accelerator.h -of_objects [ipx::get_file_groups xilinx_softwaredriver -of_objects [ipx::current_core]]]
ipx::add_file $drivers_dir/src/Makefile [ipx::get_file_groups xilinx_softwaredriver -of_objects [ipx::current_core]]
set_property type unknown [ipx::get_files $drivers_dir/src/Makefile -of_objects [ipx::get_file_groups xilinx_softwaredriver -of_objects [ipx::current_core]]]
ipx::add_file $drivers_dir/data/s_accelerator.tcl [ipx::get_file_groups xilinx_softwaredriver -of_objects [ipx::current_core]]
set_property type tclSource [ipx::get_files $drivers_dir/data/s_accelerator.tcl -of_objects [ipx::get_file_groups xilinx_softwaredriver -of_objects [ipx::current_core]]]
ipx::add_file $drivers_dir/data/s_accelerator.mdd [ipx::get_file_groups xilinx_softwaredriver -of_objects [ipx::current_core]]
set_property type mdd [ipx::get_files $drivers_dir/data/s_accelerator.mdd -of_objects [ipx::get_file_groups xilinx_softwaredriver -of_objects [ipx::current_core]]]
		
set_property core_revision 3 [ipx::current_core]
ipx::create_xgui_files [ipx::current_core]
ipx::update_checksums [ipx::current_core]
ipx::save_core [ipx::current_core]
set_property  ip_repo_paths $ipdir [current_project]
update_ip_catalog
close_project
