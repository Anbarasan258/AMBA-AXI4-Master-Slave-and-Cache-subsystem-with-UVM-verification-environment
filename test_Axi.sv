import uvm_pkg :: *;
`include "axi_master.sv"
`include "axi_slave.sv"
`include "cache_controller.sv" 
`include "interconnect.sv"
`include "AXI_interface.sv"
`include "AXI_package.sv"
`include "uvm_macros.svh"
import AXI_package::*;

module test_Axi;
  bit clk;
  
  always #5 clk = ~ clk;
  
  AXI_interface vif(clk);
  
  axi4_top dut_top(.aclk(vif.ACLK),.aresetn(vif.aresetn),.wr_req(vif.wr_req),.wr_addr(vif.wr_addr),.wr_len(vif.wr_len),.wr_size(vif.wr_size),.wr_burst(vif.wr_burst),.wr_id(vif.wr_id),.wr_lock(vif.wr_lock),.wr_cache(vif.wr_cache),.wr_prot(vif.wr_prot),.wr_strb(vif.wr_strb),.write_data(vif.write_data),.wlast(vif.wlast),.b_id(vif.b_id),.b_resp(vif.b_resp),.bvalid(vif.bvalid),.bready(vif.bready),.rd_req(vif.rd_req),.rd_addr(vif.rd_addr),.rd_len(vif.rd_len),.rd_size(vif.rd_size),.rd_burst(vif.rd_burst),.rd_id(vif.rd_id),.rd_cache(vif.rd_cache),.rd_lock(vif.rd_lock),.rd_prot(vif.rd_prot),.rd_id_out(vif.rd_id_out),.rdata_out(vif.rdata_out),.rd_response_out(vif.rd_response_out),.rlast(vif.rlast),.rvalid(vif.rvalid),.rready(vif.rready),.awvalid(vif.awvalid),.awready(vif.awready),.wvalid(vif.wvalid),.wready(vif.wready),.arvalid(vif.arvalid),.arready(vif.arready));
  
  assign vif.wb_flush = dut_top.cache_controller_dut.flushing;
  always@(posedge clk)
    begin
      if(vif.wr_req)
        dut_top.master_dut.wr_mem = vif.wr_mem;
    end
  
//   initial begin
//     wait(vif.aresetn);
//     for(int i=0; i<256; i++)begin
//       dut_top.master_dut.wr_mem[i]=$urandom_range(0,900);
//     end
//   end
  
//   initial begin
//     wait(vif.aresetn);
//     force dut_top.slave_dut.awready = 1'b0;
//     repeat(10) @(posedge clk);
//     #0;
//     release dut_top.slave_dut.awready;
//     dut_top.slave_dut.awready = 1'b1;
    

//     force dut_top.slave_dut.wready = 1'b0;
//     repeat(10) @(posedge clk);
//     #0;
//     release dut_top.slave_dut.wready;
//     dut_top.slave_dut.wready = 1'b1;

//     wait(vif.bvalid);
//     force dut_top.master_dut.bready = 1'b0;
//     repeat(10) @(posedge clk);
//     release dut_top.master_dut.bready;
//     dut_top.master_dut.bready = 1'b1;

//     wait(vif.arvalid);
//     force dut_top.slave_dut.arready = 1'b0;
//     repeat(10) @(posedge clk);
//     #0;
//     release dut_top.slave_dut.arready;
//     dut_top.slave_dut.arready = 1'b1;

//   end
  
  
  initial
    begin
      clk = 1'b0;
      $dumpfile("axi4_top.vcd");
      $dumpvars(0,test_Axi);
      
      uvm_config_db#(virtual AXI_interface) :: set(null,"*","vif",vif);
//       run_test("AXI_test"); // [tc for topology printing]
//       run_test("axi_reset_test"); // [reset tc]
//       run_test("write_read_test"); // [tc 1 & 11]
//       run_test("b2b_write_read_test"); // [tc 53 & 52]
//       run_test("write_read_max_test"); // [tc 20 & 45]
//       run_test("write_read_unaligned_test"); //[tc 5 & 17]
//       run_test("write_invalid_addr_test"); // [tc 6 & 15 & 8]
//       run_test("multi_beat_write_read_test"); // [tc 2 & 12]
//       run_test("write_read_fixed_burst_test") ; // [tc 3 & 13]
//       run_test("write_read_wrap_test"); // [tc 4 & 14]
//       run_test("narrow_read_write_test"); // [tc 7 & 16] 
//       run_test("unaligned_narrow_read_write_test"); //[tc 7 & 16]
//       run_test("out_of_order_test"); // [tc 9 & 23]
//       run_test("order_sequence_test"); // [tc 10 & 18]
//       run_test("prot_error_test"); // [tc 42]  //
//       run_test("normal_read_write_okay_test"); // [tc 21]
//       run_test("exclusive_read_write_test"); // [tc 22 & 24]
//       run_test("exclusive_read_write_limit_test"); // [tc 25] 
//       run_test("exclusive_read_write_diff_size_test"); // [tc 26] 
//       run_test("exclusive_read_write_diff_addr_test"); // [tc 27] 
//       run_test("exclusive_read_write_same_id_test"); // [tc 28,47] 
//       run_test("all_prot_test"); //[tc 41,50,51] 
//       run_test("wrap_error_test"); //[tc 46] 
//       run_test("paralle_write_read_test"); //[tc 48] 
//       run_test("non_buf_write_read_test"); //[tc 29 & 30] 
//       run_test("buf_read_write_test"); // [tc 31 & 32] 
//       run_test("modifiable_read_write_test"); // [tc 33 & 34];
//       run_test("write_back_allocate_test") ; // [tc 39] 
//       run_test("read_back_allocate_test"); // [tc 40 & 36] 
//       run_test("write_back_noallocate_test"); // [tc 37] 
//       run_test("read_back_noallocate_test"); // [tc 38] 
//       run_test("write_back_read_allocate_test"); // [tc 35] 
//       run_test("reset_during_transfer_test"); // [tc 43 & 49]
//       run_test("reset_after_transfer_test"); // [tc 44] 
      
      run_test("AXI_regression_test"); // regression test 
    end
endmodule
