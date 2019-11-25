
################################################################
# This is a generated script based on design: tb_core_top
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

namespace eval _tcl {
proc get_script_folder {} {
   set script_path [file normalize [info script]]
   set script_folder [file dirname $script_path]
   return $script_folder
}
}
variable script_folder
set script_folder [_tcl::get_script_folder]

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2018.3
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   catch {common::send_msg_id "BD_TCL-109" "ERROR" "This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."}

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source tb_core_top_script.tcl


# The design that will be created by this Tcl script contains the following 
# module references:
# core_top_wrapper, tb_clk_gen

# Please add the sources of those modules before sourcing this Tcl script.

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part xc7s50csga324-1
   set_property BOARD_PART digilentinc.com:arty-s7-50:part0:1.0 [current_project]
}


# CHANGE DESIGN NAME HERE
variable design_name
set design_name tb_core_top

# If you do not already have an existing IP Integrator design open,
# you can create a design using the following command:
#    create_bd_design $design_name

# Creating design if needed
set errMsg ""
set nRet 0

set cur_design [current_bd_design -quiet]
set list_cells [get_bd_cells -quiet]

if { ${design_name} eq "" } {
   # USE CASES:
   #    1) Design_name not set

   set errMsg "Please set the variable <design_name> to a non-empty value."
   set nRet 1

} elseif { ${cur_design} ne "" && ${list_cells} eq "" } {
   # USE CASES:
   #    2): Current design opened AND is empty AND names same.
   #    3): Current design opened AND is empty AND names diff; design_name NOT in project.
   #    4): Current design opened AND is empty AND names diff; design_name exists in project.

   if { $cur_design ne $design_name } {
      common::send_msg_id "BD_TCL-001" "INFO" "Changing value of <design_name> from <$design_name> to <$cur_design> since current design is empty."
      set design_name [get_property NAME $cur_design]
   }
   common::send_msg_id "BD_TCL-002" "INFO" "Constructing design in IPI design <$cur_design>..."

} elseif { ${cur_design} ne "" && $list_cells ne "" && $cur_design eq $design_name } {
   # USE CASES:
   #    5) Current design opened AND has components AND same names.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 1
} elseif { [get_files -quiet ${design_name}.bd] ne "" } {
   # USE CASES: 
   #    6) Current opened design, has components, but diff names, design_name exists in project.
   #    7) No opened design, design_name exists in project.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 2

} else {
   # USE CASES:
   #    8) No opened design, design_name not in project.
   #    9) Current opened design, has components, but diff names, design_name not in project.

   common::send_msg_id "BD_TCL-003" "INFO" "Currently there is no design <$design_name> in project, so creating one..."

   create_bd_design $design_name

   common::send_msg_id "BD_TCL-004" "INFO" "Making design <$design_name> as current_bd_design."
   current_bd_design $design_name

}

common::send_msg_id "BD_TCL-005" "INFO" "Currently the variable <design_name> is equal to \"$design_name\"."

if { $nRet != 0 } {
   catch {common::send_msg_id "BD_TCL-114" "ERROR" $errMsg}
   return $nRet
}

##################################################################
# DESIGN PROCs
##################################################################



# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  variable script_folder
  variable design_name

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports

  # Create ports

  # Create instance: axi_interconnect_0, and set properties
  set axi_interconnect_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_interconnect_0 ]
  set_property -dict [ list \
   CONFIG.ENABLE_ADVANCED_OPTIONS {1} \
   CONFIG.NUM_MI {2} \
   CONFIG.NUM_SI {2} \
 ] $axi_interconnect_0

  # Create instance: clk_wiz, and set properties
  set clk_wiz [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:6.0 clk_wiz ]

  # Create instance: core_top_wrapper_0, and set properties
  set block_name core_top_wrapper
  set block_cell_name core_top_wrapper_0
  if { [catch {set core_top_wrapper_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $core_top_wrapper_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: core_wrapper_0, and set properties
  set core_wrapper_0 [ create_bd_cell -type ip -vlnv xilinx.com:user:core_wrapper:1.0 core_wrapper_0 ]

  # Create instance: data_mem, and set properties
  set data_mem [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.4 data_mem ]
  set_property -dict [ list \
   CONFIG.Assume_Synchronous_Clk {true} \
   CONFIG.Enable_B {Use_ENB_Pin} \
   CONFIG.Memory_Type {True_Dual_Port_RAM} \
   CONFIG.Port_B_Clock {100} \
   CONFIG.Port_B_Enable_Rate {100} \
   CONFIG.Port_B_Write_Rate {50} \
   CONFIG.Use_RSTB_Pin {true} \
 ] $data_mem

  # Create instance: data_mem_ctrl, and set properties
  set data_mem_ctrl [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.1 data_mem_ctrl ]

  # Create instance: instr_mem, and set properties
  set instr_mem [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.4 instr_mem ]
  set_property -dict [ list \
   CONFIG.Assume_Synchronous_Clk {true} \
   CONFIG.Coe_File {../../../../../../../test/asm/median/median.coe} \
   CONFIG.Enable_B {Use_ENB_Pin} \
   CONFIG.Load_Init_File {true} \
   CONFIG.Memory_Type {Dual_Port_ROM} \
   CONFIG.Port_A_Write_Rate {0} \
   CONFIG.Port_B_Clock {100} \
   CONFIG.Port_B_Enable_Rate {100} \
   CONFIG.Use_Byte_Write_Enable {false} \
   CONFIG.Use_RSTB_Pin {true} \
 ] $instr_mem

  # Create instance: instr_mem_ctrl, and set properties
  set instr_mem_ctrl [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.1 instr_mem_ctrl ]

  # Create instance: rst_clk_wiz_100M, and set properties
  set rst_clk_wiz_100M [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_clk_wiz_100M ]

  # Create instance: tb_clk_gen_0, and set properties
  set block_name tb_clk_gen
  set block_cell_name tb_clk_gen_0
  if { [catch {set tb_clk_gen_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $tb_clk_gen_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create interface connections
  connect_bd_intf_net -intf_net axi_bram_ctrl_0_BRAM_PORTA [get_bd_intf_pins instr_mem/BRAM_PORTA] [get_bd_intf_pins instr_mem_ctrl/BRAM_PORTA]
  connect_bd_intf_net -intf_net axi_bram_ctrl_0_BRAM_PORTB [get_bd_intf_pins instr_mem/BRAM_PORTB] [get_bd_intf_pins instr_mem_ctrl/BRAM_PORTB]
  connect_bd_intf_net -intf_net axi_interconnect_0_M00_AXI [get_bd_intf_pins axi_interconnect_0/M00_AXI] [get_bd_intf_pins instr_mem_ctrl/S_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M01_AXI [get_bd_intf_pins axi_interconnect_0/M01_AXI] [get_bd_intf_pins data_mem_ctrl/S_AXI]
  connect_bd_intf_net -intf_net core_wrapper_0_m_data [get_bd_intf_pins axi_interconnect_0/S00_AXI] [get_bd_intf_pins core_wrapper_0/m_data]
  connect_bd_intf_net -intf_net core_wrapper_0_m_instr [get_bd_intf_pins axi_interconnect_0/S01_AXI] [get_bd_intf_pins core_wrapper_0/m_instr]
  connect_bd_intf_net -intf_net data_mem_ctrl_BRAM_PORTA [get_bd_intf_pins data_mem/BRAM_PORTA] [get_bd_intf_pins data_mem_ctrl/BRAM_PORTA]
  connect_bd_intf_net -intf_net data_mem_ctrl_BRAM_PORTB [get_bd_intf_pins data_mem/BRAM_PORTB] [get_bd_intf_pins data_mem_ctrl/BRAM_PORTB]

  # Create port connections
  connect_bd_net -net S00_AXI_awsize_1 [get_bd_pins axi_interconnect_0/S00_AXI_awsize] [get_bd_pins core_top_wrapper_0/o_instr_awsize]
  connect_bd_net -net axi_interconnect_0_S00_AXI_arready [get_bd_pins axi_interconnect_0/S00_AXI_arready] [get_bd_pins core_top_wrapper_0/i_instr_arready]
  connect_bd_net -net axi_interconnect_0_S00_AXI_awready [get_bd_pins axi_interconnect_0/S00_AXI_awready] [get_bd_pins core_top_wrapper_0/i_instr_awready]
  connect_bd_net -net axi_interconnect_0_S00_AXI_bresp [get_bd_pins axi_interconnect_0/S00_AXI_bresp] [get_bd_pins core_top_wrapper_0/i_instr_bresp]
  connect_bd_net -net axi_interconnect_0_S00_AXI_bvalid [get_bd_pins axi_interconnect_0/S00_AXI_bvalid] [get_bd_pins core_top_wrapper_0/i_instr_bvalid]
  connect_bd_net -net axi_interconnect_0_S00_AXI_rdata [get_bd_pins axi_interconnect_0/S00_AXI_rdata] [get_bd_pins core_top_wrapper_0/i_instr_rdata]
  connect_bd_net -net axi_interconnect_0_S00_AXI_rlast [get_bd_pins axi_interconnect_0/S00_AXI_rlast] [get_bd_pins core_top_wrapper_0/i_instr_rlast]
  connect_bd_net -net axi_interconnect_0_S00_AXI_rvalid [get_bd_pins axi_interconnect_0/S00_AXI_rvalid] [get_bd_pins core_top_wrapper_0/i_instr_rvalid]
  connect_bd_net -net axi_interconnect_0_S00_AXI_wready [get_bd_pins axi_interconnect_0/S00_AXI_wready] [get_bd_pins core_top_wrapper_0/i_instr_wready]
  connect_bd_net -net axi_interconnect_0_S01_AXI_arready [get_bd_pins axi_interconnect_0/S01_AXI_arready] [get_bd_pins core_top_wrapper_0/i_data_arready]
  connect_bd_net -net axi_interconnect_0_S01_AXI_awready [get_bd_pins axi_interconnect_0/S01_AXI_awready] [get_bd_pins core_top_wrapper_0/i_data_awready]
  connect_bd_net -net axi_interconnect_0_S01_AXI_bresp [get_bd_pins axi_interconnect_0/S01_AXI_bresp] [get_bd_pins core_top_wrapper_0/i_data_bresp]
  connect_bd_net -net axi_interconnect_0_S01_AXI_bvalid [get_bd_pins axi_interconnect_0/S01_AXI_bvalid] [get_bd_pins core_top_wrapper_0/i_data_bvalid]
  connect_bd_net -net axi_interconnect_0_S01_AXI_rdata [get_bd_pins axi_interconnect_0/S01_AXI_rdata] [get_bd_pins core_top_wrapper_0/i_data_rdata]
  connect_bd_net -net axi_interconnect_0_S01_AXI_rlast [get_bd_pins axi_interconnect_0/S01_AXI_rlast] [get_bd_pins core_top_wrapper_0/i_data_rlast]
  connect_bd_net -net axi_interconnect_0_S01_AXI_rvalid [get_bd_pins axi_interconnect_0/S01_AXI_rvalid] [get_bd_pins core_top_wrapper_0/i_data_rvalid]
  connect_bd_net -net axi_interconnect_0_S01_AXI_wready [get_bd_pins axi_interconnect_0/S01_AXI_wready] [get_bd_pins core_top_wrapper_0/i_data_wready]
  connect_bd_net -net clk_wiz_clk_out1 [get_bd_pins axi_interconnect_0/ACLK] [get_bd_pins axi_interconnect_0/M00_ACLK] [get_bd_pins axi_interconnect_0/M01_ACLK] [get_bd_pins axi_interconnect_0/S00_ACLK] [get_bd_pins axi_interconnect_0/S01_ACLK] [get_bd_pins clk_wiz/clk_out1] [get_bd_pins core_top_wrapper_0/i_aclk] [get_bd_pins core_wrapper_0/m_data_aclk] [get_bd_pins core_wrapper_0/m_instr_aclk] [get_bd_pins data_mem_ctrl/s_axi_aclk] [get_bd_pins instr_mem_ctrl/s_axi_aclk] [get_bd_pins rst_clk_wiz_100M/slowest_sync_clk]
  connect_bd_net -net clk_wiz_locked [get_bd_pins clk_wiz/locked] [get_bd_pins rst_clk_wiz_100M/dcm_locked]
  connect_bd_net -net core_top_wrapper_0_o_data_araddr [get_bd_pins axi_interconnect_0/S01_AXI_araddr] [get_bd_pins core_top_wrapper_0/o_data_araddr]
  connect_bd_net -net core_top_wrapper_0_o_data_arburst [get_bd_pins axi_interconnect_0/S01_AXI_arburst] [get_bd_pins core_top_wrapper_0/o_data_arburst]
  connect_bd_net -net core_top_wrapper_0_o_data_arlen [get_bd_pins axi_interconnect_0/S01_AXI_arlen] [get_bd_pins core_top_wrapper_0/o_data_arlen]
  connect_bd_net -net core_top_wrapper_0_o_data_arsize [get_bd_pins axi_interconnect_0/S01_AXI_arsize] [get_bd_pins core_top_wrapper_0/o_data_arsize]
  connect_bd_net -net core_top_wrapper_0_o_data_arvalid [get_bd_pins axi_interconnect_0/S01_AXI_arvalid] [get_bd_pins core_top_wrapper_0/o_data_arvalid]
  connect_bd_net -net core_top_wrapper_0_o_data_awaddr [get_bd_pins axi_interconnect_0/S01_AXI_awaddr] [get_bd_pins core_top_wrapper_0/o_data_awaddr]
  connect_bd_net -net core_top_wrapper_0_o_data_awburst [get_bd_pins axi_interconnect_0/S01_AXI_awburst] [get_bd_pins core_top_wrapper_0/o_data_awburst]
  connect_bd_net -net core_top_wrapper_0_o_data_awlen [get_bd_pins axi_interconnect_0/S01_AXI_awlen] [get_bd_pins core_top_wrapper_0/o_data_awlen]
  connect_bd_net -net core_top_wrapper_0_o_data_awsize [get_bd_pins axi_interconnect_0/S01_AXI_awsize] [get_bd_pins core_top_wrapper_0/o_data_awsize]
  connect_bd_net -net core_top_wrapper_0_o_data_awvalid [get_bd_pins axi_interconnect_0/S01_AXI_awvalid] [get_bd_pins core_top_wrapper_0/o_data_awvalid]
  connect_bd_net -net core_top_wrapper_0_o_data_bready [get_bd_pins axi_interconnect_0/S01_AXI_bready] [get_bd_pins core_top_wrapper_0/o_data_bready]
  connect_bd_net -net core_top_wrapper_0_o_data_rready [get_bd_pins axi_interconnect_0/S01_AXI_rready] [get_bd_pins core_top_wrapper_0/o_data_rready]
  connect_bd_net -net core_top_wrapper_0_o_data_wdata [get_bd_pins axi_interconnect_0/S01_AXI_wdata] [get_bd_pins core_top_wrapper_0/o_data_wdata]
  connect_bd_net -net core_top_wrapper_0_o_data_wlast [get_bd_pins axi_interconnect_0/S01_AXI_wlast] [get_bd_pins core_top_wrapper_0/o_data_wlast]
  connect_bd_net -net core_top_wrapper_0_o_data_wstrb [get_bd_pins axi_interconnect_0/S01_AXI_wstrb] [get_bd_pins core_top_wrapper_0/o_data_wstrb]
  connect_bd_net -net core_top_wrapper_0_o_data_wvalid [get_bd_pins axi_interconnect_0/S01_AXI_wvalid] [get_bd_pins core_top_wrapper_0/o_data_wvalid]
  connect_bd_net -net core_top_wrapper_0_o_instr_araddr [get_bd_pins axi_interconnect_0/S00_AXI_araddr] [get_bd_pins core_top_wrapper_0/o_instr_araddr]
  connect_bd_net -net core_top_wrapper_0_o_instr_arburst [get_bd_pins axi_interconnect_0/S00_AXI_arburst] [get_bd_pins core_top_wrapper_0/o_instr_arburst]
  connect_bd_net -net core_top_wrapper_0_o_instr_arlen [get_bd_pins axi_interconnect_0/S00_AXI_arlen] [get_bd_pins core_top_wrapper_0/o_instr_arlen]
  connect_bd_net -net core_top_wrapper_0_o_instr_arsize [get_bd_pins axi_interconnect_0/S00_AXI_arsize] [get_bd_pins core_top_wrapper_0/o_instr_arsize]
  connect_bd_net -net core_top_wrapper_0_o_instr_arvalid [get_bd_pins axi_interconnect_0/S00_AXI_arvalid] [get_bd_pins core_top_wrapper_0/o_instr_arvalid]
  connect_bd_net -net core_top_wrapper_0_o_instr_awaddr [get_bd_pins axi_interconnect_0/S00_AXI_awaddr] [get_bd_pins core_top_wrapper_0/o_instr_awaddr]
  connect_bd_net -net core_top_wrapper_0_o_instr_awburst [get_bd_pins axi_interconnect_0/S00_AXI_awburst] [get_bd_pins core_top_wrapper_0/o_instr_awburst]
  connect_bd_net -net core_top_wrapper_0_o_instr_awlen [get_bd_pins axi_interconnect_0/S00_AXI_awlen] [get_bd_pins core_top_wrapper_0/o_instr_awlen]
  connect_bd_net -net core_top_wrapper_0_o_instr_awvalid [get_bd_pins axi_interconnect_0/S00_AXI_awvalid] [get_bd_pins core_top_wrapper_0/o_instr_awvalid]
  connect_bd_net -net core_top_wrapper_0_o_instr_bready [get_bd_pins axi_interconnect_0/S00_AXI_bready] [get_bd_pins core_top_wrapper_0/o_instr_bready]
  connect_bd_net -net core_top_wrapper_0_o_instr_rready [get_bd_pins axi_interconnect_0/S00_AXI_rready] [get_bd_pins core_top_wrapper_0/o_instr_rready]
  connect_bd_net -net core_top_wrapper_0_o_instr_wdata [get_bd_pins axi_interconnect_0/S00_AXI_wdata] [get_bd_pins core_top_wrapper_0/o_instr_wdata]
  connect_bd_net -net core_top_wrapper_0_o_instr_wlast [get_bd_pins axi_interconnect_0/S00_AXI_wlast] [get_bd_pins core_top_wrapper_0/o_instr_wlast]
  connect_bd_net -net core_top_wrapper_0_o_instr_wstrb [get_bd_pins axi_interconnect_0/S00_AXI_wstrb] [get_bd_pins core_top_wrapper_0/o_instr_wstrb]
  connect_bd_net -net core_top_wrapper_0_o_instr_wvalid [get_bd_pins axi_interconnect_0/S00_AXI_wvalid] [get_bd_pins core_top_wrapper_0/o_instr_wvalid]
  connect_bd_net -net core_top_wrapper_0_o_unused [get_bd_pins axi_interconnect_0/S00_AXI_arcache] [get_bd_pins axi_interconnect_0/S00_AXI_arlock] [get_bd_pins axi_interconnect_0/S00_AXI_arprot] [get_bd_pins axi_interconnect_0/S00_AXI_awcache] [get_bd_pins axi_interconnect_0/S00_AXI_awlock] [get_bd_pins axi_interconnect_0/S00_AXI_awprot] [get_bd_pins axi_interconnect_0/S01_AXI_arcache] [get_bd_pins axi_interconnect_0/S01_AXI_arid] [get_bd_pins axi_interconnect_0/S01_AXI_arlock] [get_bd_pins axi_interconnect_0/S01_AXI_arprot] [get_bd_pins axi_interconnect_0/S01_AXI_arqos] [get_bd_pins axi_interconnect_0/S01_AXI_awcache] [get_bd_pins axi_interconnect_0/S01_AXI_awid] [get_bd_pins axi_interconnect_0/S01_AXI_awlock] [get_bd_pins axi_interconnect_0/S01_AXI_awprot] [get_bd_pins axi_interconnect_0/S01_AXI_awqos] [get_bd_pins core_top_wrapper_0/o_unused] [get_bd_pins core_wrapper_0/m_data_init_axi_txn] [get_bd_pins core_wrapper_0/m_instr_init_axi_txn]
  connect_bd_net -net rst_clk_wiz_100M_peripheral_aresetn [get_bd_pins axi_interconnect_0/ARESETN] [get_bd_pins axi_interconnect_0/M00_ARESETN] [get_bd_pins axi_interconnect_0/M01_ARESETN] [get_bd_pins axi_interconnect_0/S00_ARESETN] [get_bd_pins axi_interconnect_0/S01_ARESETN] [get_bd_pins core_top_wrapper_0/i_areset_n] [get_bd_pins core_wrapper_0/m_data_aresetn] [get_bd_pins core_wrapper_0/m_instr_aresetn] [get_bd_pins data_mem_ctrl/s_axi_aresetn] [get_bd_pins instr_mem_ctrl/s_axi_aresetn] [get_bd_pins rst_clk_wiz_100M/peripheral_aresetn]
  connect_bd_net -net tb_clk_gen_0_o_areset [get_bd_pins clk_wiz/reset] [get_bd_pins tb_clk_gen_0/o_areset]
  connect_bd_net -net tb_clk_gen_0_o_areset_n [get_bd_pins rst_clk_wiz_100M/ext_reset_in] [get_bd_pins tb_clk_gen_0/o_areset_n]
  connect_bd_net -net tb_clk_gen_0_o_clk [get_bd_pins clk_wiz/clk_in1] [get_bd_pins tb_clk_gen_0/o_clk]

  # Create address segments
  create_bd_addr_seg -range 0x00001000 -offset 0x00000000 [get_bd_addr_spaces core_wrapper_0/m_instr] [get_bd_addr_segs instr_mem_ctrl/S_AXI/Mem0] SEG_axi_bram_ctrl_0_Mem0
  create_bd_addr_seg -range 0x00001000 -offset 0x00000000 [get_bd_addr_spaces core_wrapper_0/m_data] [get_bd_addr_segs instr_mem_ctrl/S_AXI/Mem0] SEG_axi_bram_ctrl_0_Mem0
  create_bd_addr_seg -range 0x00010000 -offset 0x00100000 [get_bd_addr_spaces core_wrapper_0/m_instr] [get_bd_addr_segs data_mem_ctrl/S_AXI/Mem0] SEG_data_mem_ctrl_Mem0
  create_bd_addr_seg -range 0x00010000 -offset 0x00100000 [get_bd_addr_spaces core_wrapper_0/m_data] [get_bd_addr_segs data_mem_ctrl/S_AXI/Mem0] SEG_data_mem_ctrl_Mem0


  # Restore current instance
  current_bd_instance $oldCurInst

  validate_bd_design
  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""

