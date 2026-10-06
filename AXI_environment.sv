class AXI_environment extends uvm_env;
  `uvm_component_utils(AXI_environment)
  AXI_agent agnth;
  AXI_scoreboard score_b;
  AXI_coverage  cov_g;
  AXI_env_config env_config;
  
  function new(string name = "AXI_environment",uvm_component parent);
    super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(AXI_env_config) :: get(this,"","cfg",env_config))
      `uvm_fatal("ENVIRONMENT","configuration is not set for environment")
    if(env_config.has_scoreboard)
      begin
      score_b = AXI_scoreboard :: type_id :: create("score_b",this);
//         uvm_config_db#(AXI_agent_config) :: set(this,"score_b","cfg",env_config.cfg);
      end
    if(env_config.has_coverage)
      cov_g = AXI_coverage :: type_id :: create("cov_g",this);
    
    agnth = AXI_agent :: type_id :: create("agnth",this);
    uvm_config_db#(AXI_agent_config)::set(this,"agnth*","cfg",env_config.cfg);

  endfunction
  
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    agnth.wr_mon.wr_analysis_port.connect(score_b.wrmon_imp_port);
    agnth.rd_mon.rd_analysis_port.connect(score_b.rdmon_imp_port);
    agnth.wr_mon.wr_analysis_port.connect(cov_g.wrmon_imp_port);
    agnth.rd_mon.rd_analysis_port.connect(cov_g.rdmon_imp_port);
  endfunction
  
endclass
    
