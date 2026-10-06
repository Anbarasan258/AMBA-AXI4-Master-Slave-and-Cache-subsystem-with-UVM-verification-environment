class AXI_agent_config extends uvm_object;
  `uvm_object_utils(AXI_agent_config)
  
  virtual AXI_interface vif;
  
  uvm_active_passive_enum is_active = UVM_ACTIVE;
  
  bit has_driver = 1;
  bit has_monitor = 1;
  
  function new(string name = "AXI_agent_config");
    super.new(name);
  endfunction
  
endclass
