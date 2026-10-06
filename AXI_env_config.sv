class AXI_env_config extends uvm_object;
  `uvm_object_utils(AXI_env_config)
  
  AXI_agent_config cfg;
  
  
  bit has_scoreboard = 1;
  bit has_coverage   = 1;
  
  function new(string name = "AXI_env_config");
    super.new(name);
  endfunction
endclass
