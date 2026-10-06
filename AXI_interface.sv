interface AXI_interface(input bit ACLK);
  
  logic aresetn;
  logic wr_req,wr_lock,rd_req,rd_lock;
  logic [31:0] wr_addr,rd_addr;
  logic [7:0] wr_len,rd_len;
  logic [3:0] wr_strb;
  logic [2:0] wr_size,rd_size;
  logic [1:0] wr_burst,rd_burst;
  logic [3:0] wr_id,rd_id,b_id;
  logic [3:0] wr_cache,rd_cache;
  logic [2:0] wr_prot,rd_prot;
  logic [31:0] write_data;
  logic [3:0] rd_id_out;
  logic [31:0] rdata_out;
  logic [1:0] rd_response_out,b_resp;
  
  logic arready,arvalid,rvalid,rready,rlast;
  logic awvalid,awready,wvalid,wready,wlast,bvalid,bready;
  logic wb_flush;
  
  logic [31:0] wr_mem [0:255];
  
  clocking cb_drv@(posedge ACLK);
    default input #1 output #2;
    output aresetn;
    output wr_req ,wr_id,wr_lock,wr_addr,wr_len,wr_size,wr_burst,wr_cache,wr_prot,wr_mem;
    output rd_req,rd_id,rd_lock,rd_addr,rd_len,rd_size,rd_burst,rd_cache,rd_prot;
    input awvalid,awready,wvalid,wready,bvalid,bready;
    input rd_id_out,arvalid,arready,rdata_out,rvalid,rready,rlast,wb_flush;
  endclocking
  
  clocking cb_wr_mon@(posedge ACLK);
    default input #0 output #1;
    input aresetn;
    input wr_req,wr_id,wr_lock,wr_addr,wr_len,wr_strb,wr_size,wr_burst,wr_cache,wr_prot,write_data,b_resp,b_id;
  
    input awvalid,awready,wvalid,wlast,wready,bvalid,bready;
    
  endclocking
  
  clocking cb_rd_mon@(posedge ACLK);
    default input #0 output #1;
    input aresetn;
    input rd_req,rd_id,rd_lock,rd_addr,rd_len,rd_size,rd_burst,rd_cache,rd_prot;
    
    input arvalid,arready,rvalid,rready,rlast,rd_response_out,rdata_out,rd_id_out;
    
  endclocking
    
  modport DRV(clocking cb_drv);
  modport WR_MON(clocking cb_wr_mon);
  modport RD_MON(clocking cb_rd_mon);
    
  property write_address_handshake;
    disable iff(!aresetn)
    @(posedge ACLK)
    $rose(awvalid) |-> ##[0:$] awready; 
  endproperty
    
  property write_data_handshake;
    disable iff(!aresetn)
    @(posedge ACLK)
    $rose(wvalid) |-> ##[0:$] wready;
  endproperty
    
  property write_response_handshake;
    disable iff(!aresetn)
    @(posedge ACLK)
    $rose(bvalid) |-> ##[0:$] bready;
  endproperty
    
  property read_address_handshake;
    disable iff(!aresetn)
    @(posedge ACLK)
    $rose(arvalid) |-> ##[0:$] arready;
  endproperty
    
    property read_data_handshake;
      disable iff(!aresetn)
      @(posedge ACLK)
      $rose(rvalid) |-> ##[0:$] rready;
    endproperty
    
    assert property(write_address_handshake)
      `uvm_info("FROM INTERFACE","Assertion for write address handshake is passed successfully",UVM_LOW)
      else
        `uvm_error("FROM INTERFACE","Assertion for write address handshake is failed")
        
    assert property(write_data_handshake)
      `uvm_info("FROM INTERFACE","Assertion for write data handshake is passed successfully",UVM_LOW)
      else
        `uvm_error("FROM INTERFACE","Assertion for write data handshake is failed")
        
    assert property(write_response_handshake)
      `uvm_info("FROM INTERFACE","Assertion for write response handshake is passed successfully",UVM_LOW)
      else
        `uvm_error("FROM INTERFACE","Assertion for write response handshake is failed")
        
    assert property(read_address_handshake)
      `uvm_info("FROM INTERFACE","Assertion for read address handshake is passed successfully",UVM_LOW)
      else
        `uvm_error("FROM INTERFACE","Assertion for read address handshake is failed")
        
     assert property(read_data_handshake)
       `uvm_info("FROM INTERFACE","Assertion for read data handshake is passed successfully",UVM_LOW)
      else
        `uvm_error("FROM INTERFACE","Assertion for read data handshake is failed") 
endinterface
