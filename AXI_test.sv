class AXI_test extends uvm_test;
  `uvm_component_utils(AXI_test)
  
  AXI_environment env_h;
  AXI_env_config env_config;
  
  function new(string name = "AXI_test",uvm_component parent);
    super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env_h      = AXI_environment :: type_id :: create("env_h",this);
    env_config = AXI_env_config :: type_id :: create("env_config");
    env_config.cfg = AXI_agent_config :: type_id :: create("cfg");
    
    if(!uvm_config_db#(virtual AXI_interface) :: get(this,"","vif",env_config.cfg.vif))
      `uvm_fatal("TEST","vif not  get in test")
      uvm_config_db#(AXI_env_config) :: set(this,"*","cfg",env_config);
  endfunction
      
  function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    uvm_top.print_topology();
  endfunction
endclass

// reset testcase
class axi_reset_test extends AXI_test;
  `uvm_component_utils(axi_reset_test)
  
  function new(string name = "axi_reset_test",uvm_component parent);
    super.new(name,parent);
  endfunction
  
  task run_phase(uvm_phase phase);
    reset_sequence seq;
    phase.raise_objection(this);
    seq = reset_sequence :: type_id :: create("seq");
    seq.start(env_h.agnth.seqr);
    phase.drop_objection(this);
  endtask
endclass

// write and read in the same location with wrap burst

class write_read_test extends AXI_test;
  `uvm_component_utils(write_read_test)
  
  function new(string name = "write_read_test",uvm_component parent);
    super.new(name,parent);
  endfunction
  
  task run_phase(uvm_phase phase);
    write_read_sequence seq;
    phase.raise_objection(this);
    seq = write_read_sequence :: type_id :: create("seq");
    seq.start(env_h.agnth.seqr);
    #450;
    phase.drop_objection(this);
  endtask
endclass


// back to back write and read in the same location
class b2b_write_read_test extends AXI_test;
  `uvm_component_utils(b2b_write_read_test)
  
  function new(string name = "b2b_write_read_test",uvm_component parent);
    super.new(name,parent);
  endfunction
  
  task run_phase(uvm_phase phase);
    b2b_write_read_sequence seq;
    phase.raise_objection(this);
    seq = b2b_write_read_sequence :: type_id :: create("seq");
    seq.start(env_h.agnth.seqr);
    #1000;
//     #2000;
    phase.drop_objection(this);
  endtask
endclass

// write and read transfer with beat legth of 256
class write_read_max_test extends AXI_test; 
  `uvm_component_utils(write_read_max_test)
  
  function new(string name = "write_read_max_test",uvm_component parent);
    super.new(name,parent);
  endfunction
  
  task run_phase(uvm_phase phase);
    write_read_max_sequence seq;
    phase.raise_objection(this);
    seq = write_read_max_sequence :: type_id :: create("seq");
    seq.start(env_h.agnth.seqr);
    #6000;
    phase.drop_objection(this);
  endtask
endclass

// unaligned write and read transfers
class write_read_unaligned_test extends AXI_test; 
  `uvm_component_utils(write_read_unaligned_test)
  
  function new(string name = "write_read_unaligned_test",uvm_component parent);
    super.new(name,parent);
  endfunction
  
  task run_phase(uvm_phase phase);
    write_read_unaligned_sequence seq;
    phase.raise_objection(this);
    seq = write_read_unaligned_sequence :: type_id :: create("seq");
    seq.start(env_h.agnth.seqr);
    #400;
    phase.drop_objection(this);
  endtask
endclass

// write to the inavlid address [tc 6 and 16 and 8]
class write_invalid_addr_test extends AXI_test; 
  `uvm_component_utils(write_invalid_addr_test)
  
  function new(string name = "write_invalid_addr_test",uvm_component parent);
    super.new(name,parent);
  endfunction
  
  task run_phase(uvm_phase phase);
    write_invalid_addr_sequence seq;
    phase.raise_objection(this);
    seq = write_invalid_addr_sequence :: type_id :: create("seq");
    seq.start(env_h.agnth.seqr);
    #700;
    phase.drop_objection(this);
  endtask
endclass


class multi_beat_write_read_test extends AXI_test;  
  `uvm_component_utils(multi_beat_write_read_test)
  
  function new(string name = "multi_beat_write_read_test",uvm_component parent);
    super.new(name,parent);
  endfunction
  
  task run_phase(uvm_phase phase);
    multi_beat_write_read_sequence seq;
    
    phase.raise_objection(this);
    seq = multi_beat_write_read_sequence :: type_id :: create("seq");
    seq.start(env_h.agnth.seqr);
    #850;
    phase.drop_objection(this);
  endtask
endclass

// write and read transfer with fixed burst [tc 3 & 13]
class write_read_fixed_burst_test extends AXI_test; 
  `uvm_component_utils(write_read_fixed_burst_test)
  
  function new(string name = "write_read_fixed_burst_test",uvm_component parent);
    super.new(name,parent);
  endfunction
  
  task run_phase(uvm_phase phase);
    write_read_fixed_burst_sequence seq;
    
    phase.raise_objection(this);
    seq = write_read_fixed_burst_sequence :: type_id :: create("seq");
    seq.start(env_h.agnth.seqr);
    #600;
    phase.drop_objection(this);
  endtask
endclass

// write and read transfer with wrap burst [tc 4 & 14]

class write_read_wrap_test extends AXI_test; 
  `uvm_component_utils(write_read_wrap_test)
  
  function new(string name = "write_read_wrap_test",uvm_component parent);
    super.new(name,parent);
  endfunction
  
  task run_phase(uvm_phase phase);
    write_read_wrap_sequence seq;
    phase.raise_objection(this);
    seq = write_read_wrap_sequence :: type_id :: create("seq");
    seq.start(env_h.agnth.seqr);
    #600;
    phase.drop_objection(this);
  endtask
endclass


// narrow read and write transfer [ tc 7 & 17]

class narrow_read_write_test extends AXI_test; 
  `uvm_component_utils(narrow_read_write_test)
  
  function new(string name = "narrow_read_write_test",uvm_component parent);
    super.new(name,parent);
  endfunction
  
  task run_phase(uvm_phase phase);
    narrow_read_write_sequence seq;
    phase.raise_objection(this);
    seq = narrow_read_write_sequence :: type_id :: create("seq");
    seq.start(env_h.agnth.seqr);
    #900;
    phase.drop_objection(this);
  endtask
endclass

// narrow read and write transfer with unaligned address

class unaligned_narrow_read_write_test extends AXI_test;
  `uvm_component_utils(unaligned_narrow_read_write_test)
  
  function new(string name = "unaligned_narrow_read_write_test",uvm_component parent);
    super.new(name,parent);
  endfunction
  
  task run_phase(uvm_phase phase);
    unaligned_narrow_read_write_sequence seq;
    phase.raise_objection(this);
    seq = unaligned_narrow_read_write_sequence :: type_id :: create("seq");
    seq.start(env_h.agnth.seqr);
    #900;
    phase.drop_objection(this);
  endtask
endclass

// out-of-ordering completion for different id's of read and write [tc 9 & 23]

class out_of_order_test extends AXI_test;  
  `uvm_component_utils(out_of_order_test)
  
  function new(string name = "out_of_order_test",uvm_component parent);
    super.new(name,parent);
  endfunction
  
  task run_phase(uvm_phase phase);
    out_of_order_sequence seq;
    phase.raise_objection(this);
    seq = out_of_order_sequence :: type_id :: create("seq");
    seq.start(env_h.agnth.seqr);
    #600;
    phase.drop_objection(this);
  endtask
endclass


// ordering completion for same id's of read and write [tc 10 & 19]

class order_sequence_test extends AXI_test; 
  `uvm_component_utils(order_sequence_test)
  
  function new(string name = "order_sequence_test",uvm_component parent);
    super.new(name,parent);
  endfunction
  
  task run_phase(uvm_phase phase);
    order_sequence seq;
    phase.raise_objection(this);
    seq = order_sequence :: type_id :: create("seq");
    seq.start(env_h.agnth.seqr);
    #600;
    phase.drop_objection(this);
  endtask
endclass

// protection error testcase

class prot_error_test extends AXI_test; 
  `uvm_component_utils(prot_error_test)
  
  function new(string name = "prot_error_test",uvm_component parent);
    super.new(name,parent);
  endfunction
  
  task run_phase(uvm_phase phase);
    prot_error_seq seq;
    
    phase.raise_objection(this);
    seq = prot_error_seq :: type_id :: create("seq");
    seq.start(env_h.agnth.seqr);
    #500;
    phase.drop_objection(this);
  endtask
endclass

// normal read and write for all type of burst with OKAY response [tc 21]

class normal_read_write_okay_test extends AXI_test; 
  `uvm_component_utils(normal_read_write_okay_test)
  
  function new(string name = "normal_read_write_okay_test",uvm_component parent);
    super.new(name,parent);
  endfunction
  
  task run_phase(uvm_phase phase);
    normal_read_write_okay_seq seq;
    
    phase.raise_objection(this);
    seq = normal_read_write_okay_seq :: type_id :: create("seq");
    seq.start(env_h.agnth.seqr);
    #800;
    phase.drop_objection(this);
  endtask
endclass

// exclusive read and write in the same loction and checking the write response for all type of burst [tc 22 & 24] 

class exclusive_read_write_test extends AXI_test;
  `uvm_component_utils(exclusive_read_write_test)
  
  function new(string name = "exclusive_read_write_test",uvm_component parent);
    super.new(name,parent);
  endfunction
  
  task run_phase(uvm_phase phase);
    exclusive_read_write_seq seq;
    
    phase.raise_objection(this);
    seq = exclusive_read_write_seq :: type_id :: create("seq");
    seq.start(env_h.agnth.seqr);
    #2000;
    phase.drop_objection(this);
  endtask
endclass


// exclusive read and write in the out-of-bound loction [tc 25] 

class exclusive_read_write_limit_test extends AXI_test; 
  `uvm_component_utils(exclusive_read_write_limit_test)
  
  function new(string name = "exclusive_read_write_limit_test",uvm_component parent);
    super.new(name,parent);
  endfunction
  
  task run_phase(uvm_phase phase);
    exclusive_read_write_limit_seq seq;
    
    phase.raise_objection(this);
    seq = exclusive_read_write_limit_seq :: type_id :: create("seq");
    seq.start(env_h.agnth.seqr);
    #800;
    phase.drop_objection(this);
  endtask
endclass

// exclusive read and write with different size and checking the response [tc 26]

class exclusive_read_write_diff_size_test extends AXI_test; 
  `uvm_component_utils(exclusive_read_write_diff_size_test)
  
  function new(string name = "exclusive_read_write_diff_size_test",uvm_component parent);
    super.new(name,parent);
  endfunction
  
  task run_phase(uvm_phase phase);
    exclusive_read_write_diff_size_seq seq;
    
    phase.raise_objection(this);
    seq = exclusive_read_write_diff_size_seq :: type_id :: create("seq");
    seq.start(env_h.agnth.seqr);
    #2000;
    phase.drop_objection(this);
  endtask
endclass

// exclusive read and write with same ID and different address and checking the response [tc 27]

class exclusive_read_write_diff_addr_test extends AXI_test; 
  `uvm_component_utils(exclusive_read_write_diff_addr_test)
  
  function new(string name = "exclusive_read_write_diff_addr_test",uvm_component parent);
    super.new(name,parent);
  endfunction
  
  task run_phase(uvm_phase phase);
    exclusive_read_write_diff_addr_seq seq;
    
    phase.raise_objection(this);
    seq = exclusive_read_write_diff_addr_seq :: type_id :: create("seq");
    seq.start(env_h.agnth.seqr);
    #2000;
    phase.drop_objection(this);
  endtask
endclass


// two exclusive read with same id and followed by write on the first id's address signal [tc 28]

class exclusive_read_write_same_id_test extends AXI_test; 
  `uvm_component_utils(exclusive_read_write_same_id_test)
  
  function new(string name = "exclusive_read_write_same_id_test",uvm_component parent);
    super.new(name,parent);
  endfunction
  
  task run_phase(uvm_phase phase);
    exclusive_read_write_same_id_seq seq;
    
    phase.raise_objection(this);
    seq = exclusive_read_write_same_id_seq :: type_id :: create("seq");
    seq.start(env_h.agnth.seqr);
    #800;
    phase.drop_objection(this);
  endtask
endclass

// all type of protect signals for both write and read [tc 41,52,53]

class all_prot_test extends AXI_test;
  `uvm_component_utils(all_prot_test)
  
  function new(string name = "all_prot_test",uvm_component parent);
    super.new(name,parent);
  endfunction
  
  task run_phase(uvm_phase phase);
    all_prot_seq seq;
    
    phase.raise_objection(this);
    seq = all_prot_seq :: type_id :: create("seq");
    seq.start(env_h.agnth.seqr);
    #9000;
    phase.drop_objection(this);
  endtask
endclass

// To check the wrap error conditions [tc 46]

class wrap_error_test extends AXI_test;
  `uvm_component_utils(wrap_error_test)
  
  function new(string name = "wrap_error_test",uvm_component parent);
    super.new(name,parent);
  endfunction
  
  task run_phase(uvm_phase phase);
    wrap_error_seq seq;
    
    phase.raise_objection(this);
    seq = wrap_error_seq :: type_id :: create("seq");
    seq.start(env_h.agnth.seqr);
    #1000;
    phase.drop_objection(this);
  endtask
endclass

// parallel write and read [tc 48]

class paralle_write_read_test extends AXI_test; 
  `uvm_component_utils(paralle_write_read_test)
  
  function new(string name = "paralle_write_read_test",uvm_component parent);
    super.new(name,parent);
  endfunction
  
  task run_phase(uvm_phase phase);
    paralle_write_read_seq seq;
    
    phase.raise_objection(this);
    seq = paralle_write_read_seq :: type_id :: create("seq");
    seq.start(env_h.agnth.seqr);
    #800;
    phase.drop_objection(this);
  endtask
endclass


// non-bufferable write and read [tc 29 & 30]

class non_buf_write_read_test extends AXI_test;
  `uvm_component_utils(non_buf_write_read_test)
  
  function new(string name = "non_buf_write_read_test",uvm_component parent);
    super.new(name,parent);
  endfunction
  
  task run_phase(uvm_phase phase);
    non_buf_write_read_seq seq;
    
    phase.raise_objection(this);
    seq = non_buf_write_read_seq :: type_id :: create("seq");
    seq.start(env_h.agnth.seqr);
    #800;
    phase.drop_objection(this);
  endtask
endclass


// bufferable write and read transfers [tc 31 & 32]

class buf_read_write_test extends AXI_test; 
  `uvm_component_utils(buf_read_write_test)
  
  function new(string name = "buf_read_write_test",uvm_component parent);
    super.new(name,parent);
  endfunction
  
  task run_phase(uvm_phase phase);
    buf_read_write_seq seq;
    
    phase.raise_objection(this);
    seq = buf_read_write_seq :: type_id :: create("seq");
    seq.start(env_h.agnth.seqr);
    #2000;
    phase.drop_objection(this);
  endtask
endclass


// non-bufferable,non-cacheable and modifiable write and read transfer

class modifiable_read_write_test extends AXI_test;  
  `uvm_component_utils(modifiable_read_write_test)
  
  function new(string name = "modifiable_read_write_test",uvm_component parent);
    super.new(name,parent);
  endfunction
  
  task run_phase(uvm_phase phase);
    modifiable_read_write_seq seq;
    
    phase.raise_objection(this);
    seq = modifiable_read_write_seq :: type_id :: create("seq");
    seq.start(env_h.agnth.seqr);
    #1000;
    phase.drop_objection(this);
  endtask
endclass

// write back allocate in chache [tc 39]

class write_back_allocate_test extends AXI_test; 
  `uvm_component_utils(write_back_allocate_test)
  
  function new(string name = "write_back_allocate_test",uvm_component parent);
    super.new(name,parent);
  endfunction
  
  task run_phase(uvm_phase phase);
    write_back_allocate_seq seq;
    
    phase.raise_objection(this);
    seq = write_back_allocate_seq :: type_id :: create("seq");
    seq.start(env_h.agnth.seqr);
    #1000;
    phase.drop_objection(this);
  endtask
endclass

// read back and allocate in cachable transfer [tc 40]

class read_back_allocate_test extends AXI_test; 
  `uvm_component_utils(read_back_allocate_test)
  
  function new(string name = "read_back_allocate_test",uvm_component parent);
    super.new(name,parent);
  endfunction
  
  task run_phase(uvm_phase phase);
    read_back_allocate_seq seq;
    
    phase.raise_objection(this);
    seq = read_back_allocate_seq :: type_id :: create("seq");
    seq.start(env_h.agnth.seqr);
    #1000;
    phase.drop_objection(this);
  endtask
endclass

// write back and no allocate for the cacheable transfer [tc 37]

class write_back_noallocate_test extends AXI_test; 
  `uvm_component_utils(write_back_noallocate_test)
  
  function new(string name = "write_back_noallocate_test",uvm_component parent);
    super.new(name,parent);
  endfunction
  
  task run_phase(uvm_phase phase);
    write_back_noallocate_seq seq;
    
    phase.raise_objection(this);
    seq = write_back_noallocate_seq :: type_id :: create("seq");
    seq.start(env_h.agnth.seqr);
    #1000;
    phase.drop_objection(this);
  endtask
endclass

// read back and no allocate for the cacheable transfer [tc 38]

class read_back_noallocate_test extends AXI_test; 
  `uvm_component_utils(read_back_noallocate_test)
  
  function new(string name = "read_back_noallocate_test",uvm_component parent);
    super.new(name,parent);
  endfunction
  
  task run_phase(uvm_phase phase);
    read_back_noallocate_seq seq;
    
    phase.raise_objection(this);
    seq = read_back_noallocate_seq :: type_id :: create("seq");
    seq.start(env_h.agnth.seqr);
    #1000;
    phase.drop_objection(this);
  endtask
endclass

// write back and read allocate for the cacheable transfer [tc 35]

class write_back_read_allocate_test extends AXI_test; 
  `uvm_component_utils(write_back_read_allocate_test)
  
  function new(string name = "write_back_read_allocate_test",uvm_component parent);
    super.new(name,parent);
  endfunction
  
  task run_phase(uvm_phase phase);
    write_back_read_allocate_seq seq;
    
    phase.raise_objection(this);
    seq = write_back_read_allocate_seq :: type_id :: create("seq");
    seq.start(env_h.agnth.seqr);
    #1000;
    phase.drop_objection(this);
  endtask
endclass

// // write back and read allocate for the cacheable transfer [tc 36]

// class read_back_read_allocate_test extends AXI_test;
//   `uvm_component_utils(read_back_read_allocate_test)
  
//   function new(string name = "read_back_read_allocate_test",uvm_component parent);
//     super.new(name,parent);
//   endfunction
  
//   task run_phase(uvm_phase phase);
//     read_back_read_allocate_seq seq;
    
//     phase.raise_objection(this);
//     seq = read_back_read_allocate_seq :: type_id :: create("seq");
//     seq.start(env_h.agnth.seqr);
//     phase.drop_objection(this);
//   endtask
// endclass

// reset after read and write transfer [tc 43]

class reset_after_transfer_test extends AXI_test; 
  `uvm_component_utils(reset_after_transfer_test)
  
  function new(string name = "reset_after_transfer_test",uvm_component parent);
    super.new(name,parent);
  endfunction
  
  task run_phase(uvm_phase phase);
    reset_after_transfer_seq seq;
    
    phase.raise_objection(this);
    seq = reset_after_transfer_seq :: type_id :: create("seq");
    seq.start(env_h.agnth.seqr);
    #1000;
    phase.drop_objection(this);
  endtask
endclass 

// reset during read and write transfer [tc 43 & 49]

class reset_during_transfer_test extends AXI_test; 
  `uvm_component_utils(reset_during_transfer_test)
  
  function new(string name = "reset_during_transfer_test",uvm_component parent);
    super.new(name,parent);
  endfunction
  
  task run_phase(uvm_phase phase);
    reset_during_transfer_seq seq;
    
    phase.raise_objection(this);
    seq = reset_during_transfer_seq :: type_id :: create("seq");
    seq.start(env_h.agnth.seqr);
    #1000;
    phase.drop_objection(this);
  endtask
endclass 

class AXI_regression_test extends AXI_test;
  `uvm_component_utils(AXI_regression_test)
  
  function new(string name = "AXI_regression_test",uvm_component parent);
    super.new(name,parent);
  endfunction
  
  task run_phase(uvm_phase phase);
    reset_after_transfer_seq  seq1;
    reset_during_transfer_seq seq2;
    write_read_sequence  seq3;
    b2b_write_read_sequence seq4;
    write_read_max_sequence seq5;
    write_read_unaligned_sequence seq6;
    write_invalid_addr_sequence seq7;
    multi_beat_write_read_sequence seq8;
    write_read_fixed_burst_sequence seq9;
    write_read_wrap_sequence seq10;
    narrow_read_write_sequence seq11;
    unaligned_narrow_read_write_sequence seq12;
    out_of_order_sequence seq13;
    order_sequence seq14;
    prot_error_seq seq15;
    normal_read_write_okay_seq seq16;
    exclusive_read_write_seq seq17;
    exclusive_read_write_limit_seq seq18;
    exclusive_read_write_diff_size_seq seq19;
    exclusive_read_write_diff_addr_seq seq20;
    exclusive_read_write_same_id_seq seq21;
    all_prot_seq seq22;
    wrap_error_seq seq23;
    paralle_write_read_seq seq24;
    non_buf_write_read_seq seq25;
    buf_read_write_seq seq26;
    modifiable_read_write_seq seq27;
    write_back_allocate_seq seq28;
    read_back_allocate_seq seq29;
    write_back_noallocate_seq seq30;
    read_back_noallocate_seq seq31;
    write_back_read_allocate_seq seq32;
    
    phase.raise_objection(this);
    
    seq1 = reset_after_transfer_seq :: type_id :: create("seq1");
    seq2 = reset_during_transfer_seq :: type_id :: create("seq2");
    seq3 = write_read_sequence :: type_id :: create("seq3");
    seq4 = b2b_write_read_sequence :: type_id :: create("seq4");
    seq5 = write_read_max_sequence :: type_id :: create("seq5");
    seq6 = write_read_unaligned_sequence :: type_id :: create("seq6");
    seq7 = write_invalid_addr_sequence :: type_id :: create("seq7");
    seq8 = multi_beat_write_read_sequence :: type_id :: create("seq8");
    seq9 = write_read_fixed_burst_sequence :: type_id :: create("seq9");
    seq10 = write_read_wrap_sequence :: type_id :: create("seq10");
    seq11 = narrow_read_write_sequence :: type_id :: create("seq11");
    seq12 = unaligned_narrow_read_write_sequence :: type_id :: create("seq12");
    seq13 = out_of_order_sequence :: type_id :: create("seq13");
    seq14 = order_sequence :: type_id :: create("seq14");
    seq15 = prot_error_seq :: type_id :: create("seq15");
    seq16 = normal_read_write_okay_seq :: type_id :: create("seq16");
    seq17 = exclusive_read_write_seq :: type_id :: create("seq17");
    seq18 = exclusive_read_write_limit_seq :: type_id :: create("seq18");
    seq19 = exclusive_read_write_diff_size_seq :: type_id :: create("seq19");
    seq20 = exclusive_read_write_diff_addr_seq :: type_id :: create("seq20");
    seq21 = exclusive_read_write_same_id_seq :: type_id :: create("seq21");
    seq22 = all_prot_seq :: type_id :: create("seq22");
    seq23 = wrap_error_seq :: type_id :: create("seq23");
    seq24 = paralle_write_read_seq :: type_id :: create("seq24");
    seq25 = non_buf_write_read_seq :: type_id :: create("seq25");
    seq26 = buf_read_write_seq :: type_id :: create("seq26");
    seq27 = modifiable_read_write_seq :: type_id :: create("seq27");
    seq28 = write_back_allocate_seq :: type_id :: create("seq28");
    seq29 = read_back_allocate_seq :: type_id :: create("seq29");
    seq30 = write_back_noallocate_seq :: type_id :: create("seq30");
    seq31 = read_back_noallocate_seq :: type_id :: create("seq31");
    seq32 = write_back_read_allocate_seq :: type_id :: create("seq32");
    
    seq1.start(env_h.agnth.seqr);
    `uvm_info("TEST","reset_after_transfer is completed[seq1]",UVM_LOW)
    $display("");
    seq2.start(env_h.agnth.seqr);
    `uvm_info("TEST","reset_during_transfer is completed[seq2]",UVM_LOW)
    $display("");
    seq3.start(env_h.agnth.seqr);
    `uvm_info("TEST","write_read_sequence tranfer is completed[seq3]",UVM_LOW)
    $display("");
    seq4.start(env_h.agnth.seqr);
    `uvm_info("TEST","b2b_write_read_sequence tranfer is completed[seq4]",UVM_LOW)
    $display("");
    seq5.start(env_h.agnth.seqr);
    `uvm_info("TEST","write_read_max_sequence tranfer is completed[seq5]",UVM_LOW)
    $display("");
    seq6.start(env_h.agnth.seqr);
    `uvm_info("TEST","write_read_unaligned_sequence tranfer is completed[seq6]",UVM_LOW)
    $display("");
    seq7.start(env_h.agnth.seqr);
    `uvm_info("TEST","write_invalid_addr_sequence tranfer is completed[seq7]",UVM_LOW)
    $display("");
    seq8.start(env_h.agnth.seqr);
    `uvm_info("TEST","multi_beat_write_read_sequence tranfer is completed[seq8]",UVM_LOW)
    $display("");
    seq9.start(env_h.agnth.seqr);
    `uvm_info("TEST","write_read_fixed_burst_sequence tranfer is completed[seq9]",UVM_LOW)
    $display("");
    seq10.start(env_h.agnth.seqr);
    `uvm_info("TEST","write_read_wrap_sequence tranfer is completed[seq10]",UVM_LOW)
    $display("");
    seq11.start(env_h.agnth.seqr);
    `uvm_info("TEST","narrow_read_write_sequence tranfer is completed[seq11]",UVM_LOW)
    $display("");
    seq12.start(env_h.agnth.seqr);
    `uvm_info("TEST","unaligned_narrow_read_write_sequence tranfer is completed[seq12]",UVM_LOW)
    $display("");
    seq13.start(env_h.agnth.seqr);
    `uvm_info("TEST","out_of_order_sequence tranfer is completed[seq13]",UVM_LOW)
    $display("");
    seq14.start(env_h.agnth.seqr);
    `uvm_info("TEST","order_sequence tranfer is completed[seq14]",UVM_LOW)
    $display("");
    seq15.start(env_h.agnth.seqr);
    `uvm_info("TEST","prot_error_seq tranfer is completed[seq15]",UVM_LOW)
    $display("");
    seq16.start(env_h.agnth.seqr);
    `uvm_info("TEST","normal_read_write_okay_seq tranfer is completed[seq16]",UVM_LOW)
    $display("");
    seq17.start(env_h.agnth.seqr);
    `uvm_info("TEST","exclusive_read_write_seq tranfer is completed[seq17]",UVM_LOW)
    $display("");
    seq18.start(env_h.agnth.seqr);
    `uvm_info("TEST","exclusive_read_write_limit_seq tranfer is completed[seq18]",UVM_LOW)
    $display("");
    seq19.start(env_h.agnth.seqr);
    `uvm_info("TEST","exclusive_read_write_diff_size_seq tranfer is completed[seq19]",UVM_LOW)
    $display("");
    seq20.start(env_h.agnth.seqr);
    `uvm_info("TEST","exclusive_read_write_diff_addr_seq tranfer is completed[seq20]",UVM_LOW)
    $display("");
    seq21.start(env_h.agnth.seqr);
    `uvm_info("TEST","exclusive_read_write_same_id_seq tranfer is completed[seq21]",UVM_LOW)
    $display("");
    seq22.start(env_h.agnth.seqr);
    `uvm_info("TEST","all_prot_seq tranfer is completed[seq22]",UVM_LOW)
    $display("");
    seq23.start(env_h.agnth.seqr);
    `uvm_info("TEST","wrap_error_seq tranfer is completed[seq23]",UVM_LOW)
    $display("");
    seq24.start(env_h.agnth.seqr);
    `uvm_info("TEST","paralle_write_read_seq tranfer is completed[seq24]",UVM_LOW)
    $display("");
    seq25.start(env_h.agnth.seqr);
    `uvm_info("TEST","non_buf_write_read_seq tranfer is completed[seq25]",UVM_LOW)
    $display("");
    seq26.start(env_h.agnth.seqr);
    `uvm_info("TEST","buf_read_write_seq tranfer is completed[seq26]",UVM_LOW)
    $display("");
    seq27.start(env_h.agnth.seqr);
    `uvm_info("TEST","modifiable_read_write_seq tranfer is completed[seq27]",UVM_LOW)
    $display("");
    seq28.start(env_h.agnth.seqr);
    `uvm_info("TEST","write_back_allocate_seq tranfer is completed[seq28]",UVM_LOW)
    $display("");
    seq29.start(env_h.agnth.seqr);
    `uvm_info("TEST","read_back_allocate_seq tranfer is completed[seq29]",UVM_LOW)
    $display("");
    seq30.start(env_h.agnth.seqr);
    `uvm_info("TEST","write_back_noallocate_seq tranfer is completed[seq30]",UVM_LOW)
    $display("");
    seq31.start(env_h.agnth.seqr);
    `uvm_info("TEST","read_back_noallocate_seq tranfer is completed[seq31]",UVM_LOW)
    $display("");
    seq32.start(env_h.agnth.seqr);
    `uvm_info("TEST","write_back_read_allocate_seq tranfer is completed[seq32]",UVM_LOW)
    $display("");
    
    #67965;
    phase.drop_objection(this);
   
  endtask
endclass
