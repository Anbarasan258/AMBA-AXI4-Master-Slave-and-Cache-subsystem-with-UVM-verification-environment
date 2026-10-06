class AXI_agent extends uvm_agent;
  `uvm_component_utils(AXI_agent)
  
  AXI_sequencer seqr;
  AXI_driver drv;
  AXI_write_monitor wr_mon;
  AXI_read_monitor  rd_mon;
  AXI_agent_config cfg;
  
  function new(string name = "AXI_agent",uvm_component parent);
    super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(AXI_agent_config) :: get(this,"","cfg",cfg))
      `uvm_fatal("AGENT","configuration is not set for agent")
    if(cfg.is_active == UVM_ACTIVE)
      begin
        seqr = AXI_sequencer :: type_id :: create("seqr",this);
        drv = AXI_driver :: type_id :: create("drv",this);
      end
    wr_mon = AXI_write_monitor :: type_id :: create("wr_mon",this);
    rd_mon = AXI_read_monitor :: type_id :: create("rd_mon",this);
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if(cfg.is_active == UVM_ACTIVE)
      drv.seq_item_port.connect(seqr.seq_item_export);
  endfunction
endclass
