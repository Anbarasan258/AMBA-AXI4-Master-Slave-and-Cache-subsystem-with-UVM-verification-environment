class AXI_coverage extends uvm_component;
  `uvm_component_utils(AXI_coverage)
  
  uvm_analysis_imp_wr#(AXI_sequence_item,AXI_coverage) wrmon_imp_port;
  uvm_analysis_imp_rd#(AXI_sequence_item,AXI_coverage) rdmon_imp_port;
  
  AXI_sequence_item wr_item,rd_item;
  
  covergroup write_coverage ;
    RESET : coverpoint wr_item.aresetn;
    WRITE_ADDRESS : coverpoint wr_item.wr_addr {
      bins low  = {[0:1364]};
      bins mid  = {[1365:2782]};
      bins high = {[2783:4095]};
    }
    WRITE_STROBE : coverpoint wr_item.wr_addr {
      bins low  = {[1:4]};
      bins mid  = {[5:8]};
      bins high = {[9:15]};
      ignore_bins invalid_strobe = {0};
    }
    WRITE_LEN : coverpoint wr_item.wr_len {
      bins low  = {[0:3]};
      bins mid  = {[4:7]};
      bins high = {[8:15]};
    }
    WRITE_SIZE : coverpoint wr_item.wr_size {
      bins size = {[0:2]};
      illegal_bins invalid_size = {[3:7]};
    }
    WRITE_BURST : coverpoint wr_item.wr_burst {
      bins fixed = {0};
      bins incr = {1};
      bins wrap = {2};
      illegal_bins invalid_burst = {3};
    }
    WRITE_LOCK : coverpoint wr_item.wr_lock {
      bins normal    = {0};
      bins exclusive = {1};
    }
    
  endgroup
  
  covergroup read_coverage ;
    RESET : coverpoint rd_item.aresetn;
    READ_ADDRESS : coverpoint rd_item.rd_addr {
      bins low  = {[0:1364]};
      bins mid  = {[1365:2782]};
      bins high = {[2783:4095]};
    }
    READ_LEN : coverpoint rd_item.rd_len {
      bins low  = {[0:3]};
      bins mid  = {[4:7]};
      bins high = {[8:15]};
    }
    READ_SIZE : coverpoint rd_item.rd_size {
      bins size = {[0:2]};
      illegal_bins invalid_size = {[3:7]};
    }
    READ_BURST : coverpoint rd_item.rd_burst {
      bins fixed = {0};
      bins incr = {1};
      bins wrap = {2};
      illegal_bins invalid_burst = {3};
    }
    READ_LOCK : coverpoint rd_item.rd_lock {
      bins normal    = {0};
      bins exclusive = {1};
    }
  endgroup
  
  function new(string name = "AXI_coverage",uvm_component parent);
    super.new(name,parent);
    wrmon_imp_port = new("wrmon_imp_port",this);
    rdmon_imp_port = new("rdmon_imp_port",this);
    write_coverage = new();
    read_coverage  = new();
  endfunction
  
  function void write_wr(AXI_sequence_item item);
    wr_item = item;
    write_coverage.sample();
  endfunction
  
  function void write_rd(AXI_sequence_item item);
    rd_item = item;
    read_coverage.sample();
  endfunction
endclass
