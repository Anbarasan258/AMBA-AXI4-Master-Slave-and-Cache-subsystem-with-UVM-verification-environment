`include "Axi_master.sv"
`include "Axi_slave.sv"
`include "cache_controller.sv"

module Axi_top (clk,resetn,wr_start_in,wid_in,wr_address_in,wr_burst_length_in,wr_burst_type_in,wr_burst_size_in,wr_lock_access_in,wr_cache_in,wr_protect_in,wr_burst_data_in,wr_response_out,wr_bid,rd_start_in,rdid_in,rd_address_in,rd_burst_length_in,rd_burst_type_in,rd_burst_size_in,rd_lock_access_in,rd_cache_in,rd_protect_in,rd_data_out,rd_response_out);
  
  input   clk;
  input   resetn;
  
    // Master Testbench Control Interface (Writes)
  input wr_start_in;
  input [3:0] wid_in;
  input [31:0] wr_address_in;
  input [7:0] wr_burst_length_in;
  input [1:0] wr_burst_type_in;
  input [2:0] wr_burst_size_in;
  input wr_lock_access_in;
  input [3:0] wr_cache_in;
  input [2:0] wr_protect_in;
  input [31:0] wr_burst_data_in [255:0];
  output [1:0] wr_response_out;
  output [3:0] wr_bid;
    
    // Master Testbench Control Interface (Reads)
  input rd_start_in;
  input [3:0] rdid_in;
  input [31:0] rd_address_in;
  input [7:0] rd_burst_length_in;
  input [1:0] rd_burst_type_in;
  input [2:0] rd_burst_size_in;
  input rd_lock_access_in;
  input [3:0] rd_cache_in;
  input [2:0] rd_protect_in;
  output [31:0] rd_data_out;
  output [1:0] rd_response_out;

    // ============================================================
    // AXI4 INTERCONNECT: MASTER <---> CACHE CONTROLLER (SLAVE IF)
    // ============================================================
    
    // Write Address Channel (M -> CC_S)
  wire [3:0] m2c_awid_in;
  wire [31:0] m2c_awaddr;
  wire [7:0] m2c_awlen;
  wire [2:0] m2c_awsize;
  wire [1:0] m2c_awburst;
  wire m2c_awlock;
  wire [3:0] m2c_awcache;
  wire [2:0] m2c_awprot;
  wire m2c_awvalid;
  wire m2c_awready;

    // Write Data Channel (M -> CC_S)
  wire [31:0] m2c_wdata;
  wire [3:0] m2c_wstrb;
  wire m2c_wlast;
  wire m2c_wvalid;
  wire m2c_wready;

    // Write Response Channel (CC_S -> M)
  wire [3:0] m2c_bid;
  wire [1:0] m2c_bresp;
  wire m2c_bvalid;
  wire m2c_bready;

    // Read Address Channel (M -> CC_S)
  wire [3:0] m2c_arid;
  wire [31:0] m2c_araddr;
  wire [7:0] m2c_arlen;
  wire [2:0] m2c_arsize;
  wire [1:0] m2c_arburst;
  wire m2c_arlock;
  wire [3:0] m2c_arcache;
  wire [2:0] m2c_arprot;
  wire m2c_arvalid;
  wire m2c_arready;

    // Read Data Channel (CC_S -> M)
  wire [3:0] m2c_rid;
  wire [31:0] m2c_rdata;
  wire [1:0] m2c_rresp;
  wire m2c_rlast;
  wire m2c_rvalid;
  wire m2c_rready;

    // ============================================================
    // AXI4 INTERCONNECT: CACHE CONTROLLER (MASTER IF) <---> SLAVE
    // ============================================================

    // Write Address Channel (CC_M -> S)
  wire [3:0] c2s_awid_in;
  wire [31:0] c2s_awaddr;
  wire [7:0] c2s_awlen;
  wire [2:0] c2s_awsize;
  wire [1:0] c2s_awburst;
  wire c2s_awlock;
  wire [3:0] c2s_awcache;
  wire [2:0] c2s_awprot;
  wire c2s_awvalid;
  wire c2s_awready;

    // Write Data Channel (CC_M -> S)
  wire [31:0] c2s_wdata;
  wire [3:0] c2s_wstrb;
  wire c2s_wlast;
  wire c2s_wvalid;
  wire c2s_wready;

    // Write Response Channel (S -> CC_M)
  wire [3:0] c2s_bid;
  wire [1:0] c2s_bresp;
  wire c2s_bvalid;
  wire c2s_bready;

    // Read Address Channel (CC_M -> S)
  wire [3:0] c2s_arid;
  wire [31:0] c2s_araddr;
  wire [7:0] c2s_arlen;
  wire [2:0] c2s_arsize;
  wire [1:0] c2s_arburst;
  wire c2s_arlock;
  wire [3:0] c2s_arcache;
  wire [2:0] c2s_arprot;
  wire c2s_arvalid;
  wire c2s_arready;

    // Read Data Channel (S -> CC_M)
  wire [3:0] c2s_rid;
  wire [31:0] c2s_rdata;
  wire [1:0] c2s_rresp;
  wire c2s_rlast;
  wire c2s_rvalid; 
  wire c2s_rready;

    
  Axi_master dut1 (.ACLK(clk),.RESETn(resetn),.wr_start(wr_start_in),.wid(wid_in),.wr_address_in(wr_address_in),.wr_burst_length(wr_burst_length_in),.wr_burst_type    (wr_burst_type_in),.wr_burst_size(wr_burst_size_in),.wr_lock_access(wr_lock_access_in),.wr_cache(wr_cache_in),.wr_protect(wr_protect_in),.wr_burst_data(wr_burst_data_in),.wr_response(wr_response_out),.rep_id(wr_bid),.rd_start(rd_start_in),.rdid(rdid_in),.rd_address_in(rd_address_in),.rd_burst_length  (rd_burst_length_in),.rd_burst_type(rd_burst_type_in),.rd_burst_size(rd_burst_size_in),.rd_lock_access(rd_lock_access_in),.rd_cache(rd_cache_in),.rd_protect   (rd_protect_in),.rd_data_out(rd_data_out),.rd_response(rd_response_out),.AWID(m2c_awid_in),.AWADDR(m2c_awaddr),.AWLEN(m2c_awlen),.AWSIZE(m2c_awsize),.AWBURST(m2c_awburst),.AWLOCK(m2c_awlock),.AWCACHE(m2c_awcache),.AWPROT(m2c_awprot),.AWVALID(m2c_awvalid),.AWREADY(m2c_awready),
.WDATA(m2c_wdata),.WSTRB(m2c_wstrb),.WLAST(m2c_wlast),.WVALID(m2c_wvalid),.WREADY(m2c_wready),.BID(m2c_bid),.BRESP(m2c_bresp),.BVALID(m2c_bvalid),.BREADY(m2c_bready),.ARID(m2c_arid),.ARADDR(m2c_araddr),.ARLEN(m2c_arlen),.ARSIZE(m2c_arsize),.ARBURST(m2c_arburst),.ARLOCK(m2c_arlock),.ARCACHE(m2c_arcache),.ARPROT(m2c_arprot),.ARVALID(m2c_arvalid),.ARREADY(m2c_arready),.RID(m2c_rid),.RDATA(m2c_rdata),.RRESP(m2c_rresp),.RLAST(m2c_rlast),.RVALID(m2c_rvalid),.RREADY(m2c_rready));

        
  cache_controller dut3 (.ACLK(clk),.ARESETn(resetn),.S_AWID(m2c_awid_in),.S_AWADDR(m2c_awaddr),.S_AWLEN(m2c_awlen),.S_AWSIZE(m2c_awsize),.S_AWBURST(m2c_awburst),.S_AWLOCK(m2c_awlock),.S_AWCACHE(m2c_awcache),.S_AWPROT(m2c_awprot),.S_AWVALID(m2c_awvalid),.S_AWREADY(m2c_awready),.S_WDATA(m2c_wdata),.S_WSTRB(m2c_wstrb),.S_WLAST(m2c_wlast),.S_WVALID(m2c_wvalid),.S_WREADY(m2c_wready),.S_BID(m2c_bid),.S_BRESP(m2c_bresp),.S_BREADY(m2c_bready),.S_BVALID(m2c_bvalid),.S_ARID(m2c_arid),.S_ARADDR(m2c_araddr),.S_ARLEN(m2c_arlen),.S_ARSIZE(m2c_arsize),.S_ARBURST(m2c_arburst),.S_ARLOCK(m2c_arlock),.S_ARCACHE(m2c_arcache),.S_ARPROT(m2c_arprot),.S_ARVALID(m2c_arvalid),.S_ARREADY(m2c_arready),.S_RID(m2c_rid),.S_RDATA(m2c_rdata),.S_RRESP(m2c_rresp),.S_RLAST(m2c_rlast),.S_RVALID(m2c_rvalid),.S_RREADY(m2c_rready),.M_AWID(c2s_awid_in),.M_AWADDR(c2s_awaddr),.M_AWLEN(c2s_awlen),.M_AWSIZE(c2s_awsize),.M_AWBURST(c2s_awburst),.M_AWLOCK(c2s_awlock),.M_AWCACHE(c2s_awcache),.M_AWPROT(c2s_awprot),.M_AWVALID(c2s_awvalid),.M_AWREADY(c2s_awready),.M_WDATA(c2s_wdata),.M_WSTRB(c2s_wstrb),.M_WLAST(c2s_wlast),.M_WVALID(c2s_wvalid),.M_WREADY(c2s_wready),.M_BID(c2s_bid),.M_BRESP(c2s_bresp),.M_BREADY(c2s_bready),.M_BVALID(c2s_bvalid),.M_ARID(c2s_arid),.M_ARADDR(c2s_araddr),.M_ARLEN(c2s_arlen),.M_ARSIZE(c2s_arsize),.M_ARBURST(c2s_arburst),.M_ARLOCK(c2s_arlock),.M_ARCACHE(c2s_arcache),.M_ARPROT(c2s_arprot),.M_ARVALID(c2s_arvalid),.M_ARREADY(c2s_arready),.M_RID(c2s_rid),.M_RDATA(c2s_rdata),.M_RRESP(c2s_rresp),.M_RLAST(c2s_rlast),.M_RVALID(c2s_rvalid),.M_RREADY(c2s_rready));
  

   
  Axi_slave dut2 (.ACLK(clk),.ARESETn(resetn),.AWID(c2s_awid_in),.AWADDR(c2s_awaddr),.AWLEN(c2s_awlen),.AWSIZE(c2s_awsize),.AWBURST(c2s_awburst),.AWLOCK(c2s_awlock),.AWCACHE(c2s_awcache),.AWPROT(c2s_awprot),.AWVALID(c2s_awvalid),.AWREADY(c2s_awready),.WDATA(c2s_wdata),.WSTRB(c2s_wstrb),.WLAST(c2s_wlast),.WVALID(c2s_wvalid),.WREADY(c2s_wready),.BID(c2s_bid),.BRESP(c2s_bresp),.BVALID(c2s_bvalid),.BREADY(c2s_bready),.ARID(c2s_arid),.ARADDR(c2s_araddr),.ARLEN(c2s_arlen),.ARSIZE(c2s_arsize),.ARBURST(c2s_arburst),.ARLOCK(c2s_arlock),.ARCACHE(c2s_arcache),.ARPROT(c2s_arprot),.ARVALID(c2s_arvalid),.ARREADY(c2s_arready),.RID(c2s_rid),.RDATA(c2s_rdata),.RRESP(c2s_rresp),.RLAST(c2s_rlast),.RVALID(c2s_rvalid),.RREADY(c2s_rready));

endmodule
