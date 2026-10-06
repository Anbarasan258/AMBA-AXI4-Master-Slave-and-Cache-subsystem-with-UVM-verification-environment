package AXI_package;
import uvm_pkg :: *;
`include "uvm_macros.svh"

`uvm_analysis_imp_decl(_wr)
`uvm_analysis_imp_decl(_rd)

`include "AXI_agent_config.sv"
`include "AXI_env_config.sv"
`include "AXI_sequence_item.sv"
`include "AXI_sequence.sv"
`include "AXI_sequencer.sv"
`include "AXI_driver.sv"
`include "AXI_write_monitor.sv"
`include "AXI_read_monitor.sv"
`include "AXI_agent.sv"
`include "AXI_scoreboard.sv"
`include "AXI_coverage.sv"
`include "AXI_environment.sv"
`include "AXI_test.sv"

endpackage
