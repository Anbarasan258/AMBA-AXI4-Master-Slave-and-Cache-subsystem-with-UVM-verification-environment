class AXI_sequence_item extends uvm_sequence_item;
  `uvm_object_utils(AXI_sequence_item)
  
  logic aresetn;
  rand logic wr_req,wr_lock,rd_req,rd_lock;
  rand logic [31:0] wr_addr,rd_addr;
  rand logic [7:0] wr_len,rd_len;
  rand logic [2:0] wr_size,rd_size;
  rand logic [1:0] wr_burst,rd_burst,b_resp;
  rand logic [3:0] wr_id,rd_id,b_id;
  rand logic [3:0] wr_cache,rd_cache;
  rand logic [2:0] wr_prot,rd_prot;
  logic [3:0]wr_strb[];
  logic [3:0] rd_id_out;
  logic [31:0] rdata_out[];
  logic [1:0] rd_response_out[];
  logic [31:0] write_data[];
  
  logic bvalid,bready;
  logic awvalid,awready,wvalid,wready,wlast;
  logic arvalid,arready,rready,rvalid,rlast;
  
  rand logic [31:0] wr_mem [0:255];
  
  constraint wr_datas {foreach(wr_mem[i])
    wr_mem [i] inside {[100 : 1000]};}
  
  constraint wr_address {wr_addr inside{[32'd0 : 32'd4095]};}
  constraint rd_address {rd_addr inside{[32'd0 : 32'd4095]};}
  constraint wr_length {wr_len inside{[0:255]};}
  constraint rd_length {rd_len inside{[0:255]};}
  
  constraint write_id {wr_id inside {[0:7]};}
  constraint read_id {rd_id inside {[0:7]};}
  
  function new(string name = "AXI_sequence_item");
    super.new(name);
  endfunction
endclass
