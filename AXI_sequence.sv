class AXI_sequence extends uvm_sequence#(AXI_sequence_item);
  `uvm_object_utils(AXI_sequence)
  
  function new(string name = "AXI_sequence");
    super.new(name);
  endfunction
  
  task reset();
    AXI_sequence_item item;
    item = AXI_sequence_item :: type_id :: create("item");
    start_item(item);
    item.aresetn = 1'b0;
    finish_item(item);
    #20;
    start_item(item);
    item.aresetn = 1'b1;
    finish_item(item);
  endtask
endclass

// reset sequence

class reset_sequence extends AXI_sequence;
  `uvm_object_utils(reset_sequence)
  
  function new(string name = "reset_sequence");
    super.new(name);
  endfunction
  
  task body();
    reset();
  endtask
endclass

// write and read from the same location test

  class write_read_sequence extends AXI_sequence;
  `uvm_object_utils(write_read_sequence)
  
  function new(string name = "write_read_sequence");
    super.new(name);
  endfunction
  
  task write();
    AXI_sequence_item item;
    
    item = AXI_sequence_item :: type_id :: create("item");
    
    start_item(item);
    item.aresetn = 1'b1;
    item.randomize() with {wr_req == 1'b1 ; wr_id == 4'd7; wr_addr == 32'd512; wr_len == 8'd3; wr_size == 3'd2; wr_burst == 2'b10; wr_cache == 4'b0000; wr_lock == 1'b0; wr_prot == 3'b0; rd_req == 1'b0 ; rd_id == 4'd0; rd_addr == 32'd0; rd_len == 8'd0; rd_size == 3'd0; rd_burst == 2'b00; rd_cache == 4'b0000; rd_lock == 1'b0; rd_prot == 3'b0;};
    finish_item(item);
    
  endtask
  
  task read();
    AXI_sequence_item item;
    
    item = AXI_sequence_item :: type_id :: create("item");
    
    start_item(item);
    item.aresetn = 1'b1;
    item.randomize() with {wr_req == 1'b0 ; wr_id == 4'd0; wr_addr == 32'd0; wr_len == 8'd0; wr_size == 3'd0; wr_burst == 2'b00; wr_cache == 4'b0000; wr_lock == 1'b0; wr_prot == 3'b0; rd_req == 1'b1 ; rd_id == 4'd7; rd_addr == 32'd512; rd_len == 8'd3; rd_size == 3'd2; rd_burst == 2'b10; rd_cache == 4'b0000; rd_lock == 1'b0; rd_prot == 3'b0;};
    finish_item(item);
  endtask
  
  
  task body();
    reset();
    write();
    read();
  endtask
endclass

// back to back write and read in the same location

class b2b_write_read_sequence extends AXI_sequence;
  `uvm_object_utils(b2b_write_read_sequence)
  
  function new(string name = "b2b_write_read_sequence");
    super.new(name);
  endfunction
  
  task write();
     AXI_sequence_item item;
    
    item = AXI_sequence_item :: type_id :: create("item");
    
    start_item(item);
    item.aresetn = 1'b1;
    item.randomize() with {wr_req == 1'b1 ; wr_id == 4'd1; wr_addr == 32'd100; wr_len == 8'd7; wr_size == 3'd2; wr_burst == 2'b01; wr_cache == 4'b0000; wr_lock == 1'b0; wr_prot == 3'b0; rd_req == 1'b0 ; rd_id == 4'd0; rd_addr == 32'd0; rd_len == 8'd0; rd_size == 3'd0; rd_burst == 2'b00; rd_cache == 4'b0000; rd_lock == 1'b0; rd_prot == 3'b0;};
    finish_item(item);
    
    start_item(item);
    item.aresetn = 1'b1;
    item.randomize() with {wr_req == 1'b1 ; wr_id == 4'd2; wr_addr == 32'd512; wr_len == 8'd3; wr_size == 3'd2; wr_burst == 2'b01; wr_cache == 4'b0000; wr_lock == 1'b0; wr_prot == 3'b0; rd_req == 1'b0 ; rd_id == 4'd0; rd_addr == 32'd0; rd_len == 8'd0; rd_size == 3'd0; rd_burst == 2'b00; rd_cache == 4'b0000; rd_lock == 1'b0; rd_prot == 3'b0;};
    finish_item(item);
    
    start_item(item);
    item.aresetn = 1'b1;
    item.randomize() with {wr_req == 1'b1 ; wr_id == 4'd3; wr_addr == 32'd60; wr_len == 8'd3; wr_size == 3'd2; wr_burst == 2'b10; wr_cache == 4'b0000; wr_lock == 1'b0; wr_prot == 3'b0; rd_req == 1'b0 ; rd_id == 4'd0; rd_addr == 32'd0; rd_len == 8'd0; rd_size == 3'd0; rd_burst == 2'b00; rd_cache == 4'b0000; rd_lock == 1'b0; rd_prot == 3'b0;};
    finish_item(item);
  endtask
  
  task read();
     AXI_sequence_item item;
    
    item = AXI_sequence_item :: type_id :: create("item");
    
    start_item(item);
    item.aresetn = 1'b1;
    item.randomize() with {wr_req == 1'b0 ; wr_id == 4'd0; wr_addr == 32'd0; wr_len == 8'd0; wr_size == 3'd0; wr_burst == 2'b00; wr_cache == 4'b0000; wr_lock == 1'b0; wr_prot == 3'b0; rd_req == 1'b1 ; rd_id == 4'd1; rd_addr == 32'd100; rd_len == 8'd7; rd_size == 3'd2; rd_burst == 2'b01; rd_cache == 4'b0000; rd_lock == 1'b0; rd_prot == 3'b0;};
    finish_item(item);
    
    start_item(item);
    item.aresetn = 1'b1;
    item.randomize() with {wr_req == 1'b0 ; wr_id == 4'd0; wr_addr == 32'd0; wr_len == 8'd0; wr_size == 3'd0; wr_burst == 2'b00; wr_cache == 4'b0000; wr_lock == 1'b0; wr_prot == 3'b0; rd_req == 1'b1 ; rd_id == 4'd2; rd_addr == 32'd512; rd_len == 8'd3; rd_size == 3'd2; rd_burst == 2'b01; rd_cache == 4'b0000; rd_lock == 1'b0; rd_prot == 3'b0;};
    finish_item(item);
    
    start_item(item);
    item.aresetn = 1'b1;
    item.randomize() with {wr_req == 1'b0 ; wr_id == 4'd0; wr_addr == 32'd0; wr_len == 8'd0; wr_size == 3'd0; wr_burst == 2'b00; wr_cache == 4'b0000; wr_lock == 1'b0; wr_prot == 3'b0; rd_req == 1'b1 ; rd_id == 4'd3; rd_addr == 32'd60; rd_len == 8'd3; rd_size == 3'd2; rd_burst == 2'b10; rd_cache == 4'b0000; rd_lock == 1'b0; rd_prot == 3'b0;};
    finish_item(item);
  endtask
  
  task body();
    reset();
    write();
//     #400;
    read();
  endtask
endclass


// write and read transfer with beat legth of 256

class write_read_max_sequence extends AXI_sequence;
  `uvm_object_utils(write_read_max_sequence)
  
  function new(string name = "write_read_max_sequence");
    super.new(name);
  endfunction
  
  task write();
    AXI_sequence_item item;
    
    item = AXI_sequence_item :: type_id :: create("item");
    
    start_item(item);
    item.aresetn = 1'b1;
    item.randomize() with {wr_req == 1'b1 ; wr_id == 4'd3; wr_addr == 32'd0; wr_len == 8'd255; wr_size == 3'd2; wr_burst == 2'b01; wr_cache == 4'b0000; wr_lock == 1'b0; wr_prot == 3'b0; rd_req == 1'b0 ; rd_id == 4'd0; rd_addr == 32'd0; rd_len == 8'd0; rd_size == 3'd0; rd_burst == 2'b00; rd_cache == 4'b0000; rd_lock == 1'b0; rd_prot == 3'b0;};
    finish_item(item);
  endtask
  
  task read();
    AXI_sequence_item item;
    
    item = AXI_sequence_item :: type_id :: create("item");
    
    start_item(item);
    item.aresetn = 1'b1;
    item.randomize() with {wr_req == 1'b0 ; wr_id == 4'd0; wr_addr == 32'd0; wr_len == 8'd0; wr_size == 3'd0; wr_burst == 2'b00; wr_cache == 4'b0000; wr_lock == 1'b0; wr_prot == 3'b0; rd_req == 1'b1 ; rd_id == 4'd3; rd_addr == 32'd0; rd_len == 8'd255; rd_size == 3'd2; rd_burst == 2'b01; rd_cache == 4'b0000; rd_lock == 1'b0; rd_prot == 3'b0;};
    finish_item(item);
  endtask
  
  task body();
    reset();
    write();
    read();
  endtask
endclass

// unaligned write and read transfers

class write_read_unaligned_sequence extends AXI_sequence;
  `uvm_object_utils(write_read_unaligned_sequence)
  
  function new(string name = "write_read_unaligned_sequence");
    super.new(name);
  endfunction
  
  task write();
     AXI_sequence_item item;
    
    item = AXI_sequence_item :: type_id :: create("item");
    
    start_item(item);
    item.aresetn = 1'b1;
    item.randomize() with {wr_req == 1'b1 ; wr_id == 4'd3; wr_addr == 32'd105; wr_len == 8'd3; wr_size == 3'd2; wr_burst == 2'b01; wr_cache == 4'b0000; wr_lock == 1'b0; wr_prot == 3'b0; rd_req == 1'b0 ; rd_id == 4'd0; rd_addr == 32'd0; rd_len == 8'd0; rd_size == 3'd0; rd_burst == 2'b00; rd_cache == 4'b0000; rd_lock == 1'b0; rd_prot == 3'b0;};
    finish_item(item);
  endtask
  
  task read();
    AXI_sequence_item item;
    
    item = AXI_sequence_item :: type_id :: create("item");
    
    start_item(item);
    item.aresetn = 1'b1;
    item.randomize() with {wr_req == 1'b0 ; wr_id == 4'd0; wr_addr == 32'd0; wr_len == 8'd0; wr_size == 3'd0; wr_burst == 2'b00; wr_cache == 4'b0000; wr_lock == 1'b0; wr_prot == 3'b0; rd_req == 1'b1 ; rd_id == 4'd3; rd_addr == 32'd105; rd_len == 8'd3; rd_size == 3'd2; rd_burst == 2'b01; rd_cache == 4'b0000; rd_lock == 1'b0; rd_prot == 3'b0;};
    finish_item(item);
  endtask
  
  task body();
    reset();
    write();
    read();
  endtask
endclass


// write to the inavlid address  [tc 6 and 16 and 8]

class write_invalid_addr_sequence extends AXI_sequence;
  `uvm_object_utils(write_invalid_addr_sequence)
  
  function new(string name = "write_invalid_addr_sequence");
    super.new(name);
  endfunction
  
  task write();
    AXI_sequence_item item;
    
    item = AXI_sequence_item :: type_id :: create("item");
    
    start_item(item);
    item.aresetn = 1'b1;
//     item.wr_address.constraint_mode(0);
    item.randomize() with {wr_req == 1'b1 ; wr_id == 4'd3; wr_addr == 32'd4092; wr_len == 8'd4; wr_size == 3'd2; wr_burst == 2'b01; wr_cache == 4'b0000; wr_lock == 1'b0; wr_prot == 3'b0; rd_req == 1'b0 ; rd_id == 4'd0; rd_addr == 32'd0; rd_len == 8'd0; rd_size == 3'd0; rd_burst == 2'b00; rd_cache == 4'b0000; rd_lock == 1'b0; rd_prot == 3'b0;};
    finish_item(item);
    
    start_item(item);
    item.aresetn = 1'b1;
    item.wr_address.constraint_mode(0);
    item.randomize() with {wr_req == 1'b1 ; wr_id == 4'd4; wr_addr == 32'd4096; wr_len == 8'd3; wr_size == 3'd2; wr_burst == 2'b10; wr_cache == 4'b0000; wr_lock == 1'b0; wr_prot == 3'b0; rd_req == 1'b0 ; rd_id == 4'd0; rd_addr == 32'd0; rd_len == 8'd0; rd_size == 3'd0; rd_burst == 2'b00; rd_cache == 4'b0000; rd_lock == 1'b0; rd_prot == 3'b0;};
    finish_item(item);
    
    start_item(item);
    item.aresetn = 1'b1;
    item.wr_address.constraint_mode(0);
    item.randomize() with {wr_req == 1'b1 ; wr_id == 4'd5; wr_addr == 32'd4096; wr_len == 8'd4; wr_size == 3'd2; wr_burst == 2'b00; wr_cache == 4'b0000; wr_lock == 1'b0; wr_prot == 3'b0; rd_req == 1'b0 ; rd_id == 4'd0; rd_addr == 32'd0; rd_len == 8'd0; rd_size == 3'd0; rd_burst == 2'b00; rd_cache == 4'b0000; rd_lock == 1'b0; rd_prot == 3'b0;};
    finish_item(item);
  endtask
  
  task read();
    AXI_sequence_item item;
    
    item = AXI_sequence_item :: type_id :: create("item");
    
    start_item(item);
    item.aresetn = 1'b1;
    item.randomize() with {wr_req == 1'b0 ; wr_id == 4'd0; wr_addr == 32'd0; wr_len == 8'd0; wr_size == 3'd0; wr_burst == 2'b00; wr_cache == 4'b0000; wr_lock == 1'b0; wr_prot == 3'b0; rd_req == 1'b1 ; rd_id == 4'd3; rd_addr == 32'd4092; rd_len == 8'd4; rd_size == 3'd2; rd_burst == 2'b01; rd_cache == 4'b0000; rd_lock == 1'b0; rd_prot == 3'b0;};
    finish_item(item);
    
    start_item(item);
    item.rd_address.constraint_mode(0);
    item.aresetn = 1'b1;
    item.randomize() with {wr_req == 1'b0 ; wr_id == 4'd0; wr_addr == 32'd0; wr_len == 8'd0; wr_size == 3'd0; wr_burst == 2'b00; wr_cache == 4'b0000; wr_lock == 1'b0; wr_prot == 3'b0; rd_req == 1'b1 ; rd_id == 4'd4; rd_addr == 32'd4096; rd_len == 8'd3; rd_size == 3'd2; rd_burst == 2'b10; rd_cache == 4'b0000; rd_lock == 1'b0; rd_prot == 3'b0;};
    finish_item(item); 
    
    start_item(item);
    item.rd_address.constraint_mode(0);
    item.aresetn = 1'b1;
    item.randomize() with {wr_req == 1'b0 ; wr_id == 4'd0; wr_addr == 32'd0; wr_len == 8'd0; wr_size == 3'd0; wr_burst == 2'b00; wr_cache == 4'b0000; wr_lock == 1'b0; wr_prot == 3'b0; rd_req == 1'b1 ; rd_id == 4'd5; rd_addr == 32'd4096; rd_len == 8'd3; rd_size == 3'd2; rd_burst == 2'b00; rd_cache == 4'b0000; rd_lock == 1'b0; rd_prot == 3'b0;};
    finish_item(item);
  endtask
  
  task body();
    reset();
    write();
    read();
  endtask
endclass



// mutli-beat read and write increment burst [tc 2 & 12]

class multi_beat_write_read_sequence extends AXI_sequence;
  `uvm_object_utils(multi_beat_write_read_sequence)
  
  function new(string name = "multi_beat_write_read_sequence");
    super.new(name);
  endfunction
  
  task write();
    AXI_sequence_item item;
    item = AXI_sequence_item :: type_id :: create("this");
    
    start_item(item);
    item.aresetn = 1'b1;
    item.randomize() with {wr_req == 1'b1 ; wr_id == 4'd7; wr_addr == 32'd7; wr_len == 8'd7; wr_size == 3'd2; wr_burst == 2'b01; wr_cache == 4'b0000; wr_lock == 1'b0; wr_prot == 3'b0; rd_req == 1'b0 ; rd_id == 4'd0; rd_addr == 32'd0; rd_len == 8'd0; rd_size == 3'd0; rd_burst == 2'b00; rd_cache == 4'b0000; rd_lock == 1'b0; rd_prot == 3'b0;};
    finish_item(item);
    
    start_item(item);
    item.aresetn = 1'b1;
    item.randomize() with {wr_req == 1'b1 ; wr_id == 4'd4; wr_addr == 32'd77; wr_len == 8'd9; wr_size == 3'd2; wr_burst == 2'b01; wr_cache == 4'b0000; wr_lock == 1'b0; wr_prot == 3'b0; rd_req == 1'b0 ; rd_id == 4'd0; rd_addr == 32'd0; rd_len == 8'd0; rd_size == 3'd0; rd_burst == 2'b00; rd_cache == 4'b0000; rd_lock == 1'b0; rd_prot == 3'b0;};
    finish_item(item);
    
  endtask
  
  task read();
    AXI_sequence_item item;
    item = AXI_sequence_item :: type_id :: create("this");
    
    start_item(item);
    item.aresetn = 1'b1;
    item.randomize() with {wr_req == 1'b0 ; wr_id == 4'd0; wr_addr == 32'd0; wr_len == 8'd0; wr_size == 3'd0; wr_burst == 2'b00; wr_cache == 4'b0000; wr_lock == 1'b0; wr_prot == 3'b0; rd_req == 1'b1 ; rd_id == 4'd7; rd_addr == 32'd7; rd_len == 8'd7; rd_size == 3'd2; rd_burst == 2'b01; rd_cache == 4'b0000; rd_lock == 1'b0; rd_prot == 3'b0;};
    finish_item(item);
    
    start_item(item);
    item.aresetn = 1'b1;
    item.randomize() with {wr_req == 1'b0 ; wr_id == 4'd0; wr_addr == 32'd0; wr_len == 8'd0; wr_size == 3'd0; wr_burst == 2'b00; wr_cache == 4'b0000; wr_lock == 1'b0; wr_prot == 3'b0; rd_req == 1'b1 ; rd_id == 4'd4; rd_addr == 32'd77; rd_len == 8'd9; rd_size == 3'd2; rd_burst == 2'b01; rd_cache == 4'b0000; rd_lock == 1'b0; rd_prot == 3'b0;};
    finish_item(item);
  endtask
  
  
  task body();
    reset();
    write();
    read();
  endtask
  
endclass

// write and read transfer with fixed burst [tc 3 & 13]

class write_read_fixed_burst_sequence extends AXI_sequence;
  `uvm_object_utils(write_read_fixed_burst_sequence)
  
  function new(string name = "write_read_fixed_burst_sequence");
    super.new(name);
  endfunction

  task write();
    AXI_sequence_item item;
    item = AXI_sequence_item :: type_id :: create("this");
    
    start_item(item);
    item.aresetn = 1'b1;
    item.randomize() with {wr_req == 1'b1 ; wr_id == 4'd7; wr_addr == 32'd4; wr_len == 8'd3; wr_size == 3'd2; wr_burst == 2'b00; wr_cache == 4'b0000; wr_lock == 1'b0; wr_prot == 3'b0; rd_req == 1'b0 ; rd_id == 4'd0; rd_addr == 32'd0; rd_len == 8'd0; rd_size == 3'd0; rd_burst == 2'b00; rd_cache == 4'b0000; rd_lock == 1'b0; rd_prot == 3'b0;};
    finish_item(item);
  endtask
  
  task read();
    AXI_sequence_item item;
    item = AXI_sequence_item :: type_id :: create("this");
    
    start_item(item);
    item.aresetn = 1'b1;
    item.randomize() with {wr_req == 1'b0 ; wr_id == 4'd0; wr_addr == 32'd0; wr_len == 8'd0; wr_size == 3'd0; wr_burst == 2'b00; wr_cache == 4'b0000; wr_lock == 1'b0; wr_prot == 3'b0; rd_req == 1'b1 ; rd_id == 4'd7; rd_addr == 32'd4; rd_len == 8'd3; rd_size == 3'd2; rd_burst == 2'b00; rd_cache == 4'b0000; rd_lock == 1'b0; rd_prot == 3'b0;};
    finish_item(item);
  endtask
  
  task body();
    reset();
    write();
    read();
  endtask
endclass

// write and read transfer with wrap burst [tc 4 & 14]

class write_read_wrap_sequence extends AXI_sequence;
  `uvm_object_utils(write_read_wrap_sequence)
  
  function new(string name ="write_read_wrap_sequence");
    super.new(name);
  endfunction
  
  task write();
    AXI_sequence_item item;
    item = AXI_sequence_item :: type_id :: create("this");
    
    start_item(item);
    item.aresetn = 1'b1;
    item.randomize() with {wr_req == 1'b1 ; wr_id == 4'd2; wr_addr == 32'd116; wr_len == 8'd3; wr_size == 3'd2; wr_burst == 2'b10; wr_cache == 4'b0000; wr_lock == 1'b0; wr_prot == 3'b0; rd_req == 1'b0 ; rd_id == 4'd0; rd_addr == 32'd0; rd_len == 8'd0; rd_size == 3'd0; rd_burst == 2'b00; rd_cache == 4'b0000; rd_lock == 1'b0; rd_prot == 3'b0;};
    finish_item(item);
  endtask
  
  task read();
    AXI_sequence_item item;
    item = AXI_sequence_item :: type_id :: create("this");
    
    start_item(item);
    item.aresetn = 1'b1;
    item.randomize() with {wr_req == 1'b0 ; wr_id == 4'd0; wr_addr == 32'd0; wr_len == 8'd0; wr_size == 3'd0; wr_burst == 2'b00; wr_cache == 4'b0000; wr_lock == 1'b0; wr_prot == 3'b0; rd_req == 1'b1 ; rd_id == 4'd2; rd_addr == 32'd116; rd_len == 8'd3; rd_size == 3'd2; rd_burst == 2'b10; rd_cache == 4'b0000; rd_lock == 1'b0; rd_prot == 3'b0;};
    finish_item(item);
  endtask
  
  task body();
    reset();
    write();
    read();
  endtask
endclass

// narrow read and write transfer [ tc 7 & 17]

class narrow_read_write_sequence extends AXI_sequence;
  `uvm_object_utils(narrow_read_write_sequence)
  
  function new(string name = "narrow_read_write_sequence");
    super.new(name);
  endfunction
  
  task write();
    AXI_sequence_item item;
    item = AXI_sequence_item :: type_id :: create("this");
    
    start_item(item);
    item.aresetn = 1'b1;
    item.randomize() with {wr_req == 1'b1 ; wr_id == 4'd1; wr_addr == 32'd100; wr_len == 8'd3; wr_size == 3'd0; wr_burst == 2'b01; wr_cache == 4'b0000; wr_lock == 1'b0; wr_prot == 3'b0; rd_req == 1'b0 ; rd_id == 4'd0; rd_addr == 32'd0; rd_len == 8'd0; rd_size == 3'd0; rd_burst == 2'b00; rd_cache == 4'b0000; rd_lock == 1'b0; rd_prot == 3'b0;};
    finish_item(item);
    
    start_item(item);
    item.aresetn = 1'b1;
    item.randomize() with {wr_req == 1'b1 ; wr_id == 4'd2; wr_addr == 32'd202; wr_len == 8'd3; wr_size == 3'd0; wr_burst == 2'b10; wr_cache == 4'b0000; wr_lock == 1'b0; wr_prot == 3'b0; rd_req == 1'b0 ; rd_id == 4'd0; rd_addr == 32'd0; rd_len == 8'd0; rd_size == 3'd0; rd_burst == 2'b00; rd_cache == 4'b0000; rd_lock == 1'b0; rd_prot == 3'b0;};
    finish_item(item);
    
     start_item(item);
    item.aresetn = 1'b1;
    item.randomize() with {wr_req == 1'b1 ; wr_id == 4'd3; wr_addr == 32'd0; wr_len == 8'd3; wr_size == 3'd1; wr_burst == 2'b01; wr_cache == 4'b0000; wr_lock == 1'b0; wr_prot == 3'b0; rd_req == 1'b0 ; rd_id == 4'd0; rd_addr == 32'd0; rd_len == 8'd0; rd_size == 3'd0; rd_burst == 2'b00; rd_cache == 4'b0000; rd_lock == 1'b0; rd_prot == 3'b0;};
    finish_item(item);
    
    start_item(item);
    item.aresetn = 1'b1;
    item.randomize() with {wr_req == 1'b1 ; wr_id == 4'd4; wr_addr == 32'd306; wr_len == 8'd3; wr_size == 3'd1; wr_burst == 2'b10; wr_cache == 4'b0000; wr_lock == 1'b0; wr_prot == 3'b0; rd_req == 1'b0 ; rd_id == 4'd0; rd_addr == 32'd0; rd_len == 8'd0; rd_size == 3'd0; rd_burst == 2'b00; rd_cache == 4'b0000; rd_lock == 1'b0; rd_prot == 3'b0;};
    finish_item(item);
       
  endtask
  
  task read();
    AXI_sequence_item item;
    item = AXI_sequence_item :: type_id :: create("this");
    
    start_item(item);
    item.aresetn = 1'b1;
    item.randomize() with {wr_req == 1'b0 ; wr_id == 4'd0; wr_addr == 32'd0; wr_len == 8'd0; wr_size == 3'd0; wr_burst == 2'b00; wr_cache == 4'b0000; wr_lock == 1'b0; wr_prot == 3'b0; rd_req == 1'b1 ; rd_id == 4'd1; rd_addr == 32'd100; rd_len == 8'd3; rd_size == 3'd0; rd_burst == 2'b01; rd_cache == 4'b0000; rd_lock == 1'b0; rd_prot == 3'b0;};
    finish_item(item);
    
     start_item(item);
    item.aresetn = 1'b1;
    item.randomize() with {wr_req == 1'b0 ; wr_id == 4'd0; wr_addr == 32'd0; wr_len == 8'd0; wr_size == 3'd0; wr_burst == 2'b00; wr_cache == 4'b0000; wr_lock == 1'b0; wr_prot == 3'b0; rd_req == 1'b1 ; rd_id == 4'd2; rd_addr == 32'd202; rd_len == 8'd3; rd_size == 3'd0; rd_burst == 2'b10; rd_cache == 4'b0000; rd_lock == 1'b0; rd_prot == 3'b0;};
    finish_item(item);
    
     start_item(item);
    item.aresetn = 1'b1;
    item.randomize() with {wr_req == 1'b0 ; wr_id == 4'd0; wr_addr == 32'd0; wr_len == 8'd0; wr_size == 3'd0; wr_burst == 2'b00; wr_cache == 4'b0000; wr_lock == 1'b0; wr_prot == 3'b0; rd_req == 1'b1 ; rd_id == 4'd3; rd_addr == 32'd0; rd_len == 8'd3; rd_size == 3'd0; rd_burst == 2'b01; rd_cache == 4'b0000; rd_lock == 1'b0; rd_prot == 3'b0;};
    finish_item(item);
    
     start_item(item);
    item.aresetn = 1'b1;
    item.randomize() with {wr_req == 1'b0 ; wr_id == 4'd0; wr_addr == 32'd0; wr_len == 8'd0; wr_size == 3'd0; wr_burst == 2'b00; wr_cache == 4'b0000; wr_lock == 1'b0; wr_prot == 3'b0; rd_req == 1'b1 ; rd_id == 4'd4; rd_addr == 32'd306; rd_len == 8'd3; rd_size == 3'd0; rd_burst == 2'b10; rd_cache == 4'b0000; rd_lock == 1'b0; rd_prot == 3'b0;};
    finish_item(item);
  endtask
  
  task body();
    reset();
    write();
    read();
  endtask
endclass

// narrow read and write transfer with unaligned address 

class unaligned_narrow_read_write_sequence extends AXI_sequence;
  `uvm_object_utils(unaligned_narrow_read_write_sequence)
  
  function new(string name = "unaligned_narrow_read_write_sequence");
    super.new(name);
  endfunction
  
  task write();
    AXI_sequence_item item;
    integer i;
    item = AXI_sequence_item :: type_id :: create("this");
    
    start_item(item);
    item.aresetn = 1'b1;
    item.randomize() with {wr_req == 1'b1 ; wr_id == 4'd1; wr_addr == 32'd105; wr_len == 8'd3; wr_size == 3'd0; wr_burst == 2'b01; wr_cache == 4'b0000; wr_lock == 1'b0; wr_prot == 3'b0; rd_req == 1'b0 ; rd_id == 4'd0; rd_addr == 32'd0; rd_len == 8'd0; rd_size == 3'd0; rd_burst == 2'b00; rd_cache == 4'b0000; rd_lock == 1'b0; rd_prot == 3'b0;};
    finish_item(item);
    
    start_item(item);
    item.aresetn = 1'b1;
    item.randomize() with {wr_req == 1'b1 ; wr_id == 4'd2; wr_addr == 32'd205; wr_len == 8'd3; wr_size == 3'd0; wr_burst == 2'b10; wr_cache == 4'b0000; wr_lock == 1'b0; wr_prot == 3'b0; rd_req == 1'b0 ; rd_id == 4'd0; rd_addr == 32'd0; rd_len == 8'd0; rd_size == 3'd0; rd_burst == 2'b00; rd_cache == 4'b0000; rd_lock == 1'b0; rd_prot == 3'b0;};
    finish_item(item);
    
     start_item(item);
    item.aresetn = 1'b1;
    item.randomize() with {wr_req == 1'b1 ; wr_id == 4'd3; wr_addr == 32'd5; wr_len == 8'd3; wr_size == 3'd1; wr_burst == 2'b01; wr_cache == 4'b0000; wr_lock == 1'b0; wr_prot == 3'b0; rd_req == 1'b0 ; rd_id == 4'd0; rd_addr == 32'd0; rd_len == 8'd0; rd_size == 3'd0; rd_burst == 2'b00; rd_cache == 4'b0000; rd_lock == 1'b0; rd_prot == 3'b0;};
    finish_item(item);
    
    start_item(item);
    item.aresetn = 1'b1;
    item.randomize() with {wr_req == 1'b1 ; wr_id == 4'd4; wr_addr == 32'd304; wr_len == 8'd3; wr_size == 3'd1; wr_burst == 2'b10; wr_cache == 4'b0000; wr_lock == 1'b0; wr_prot == 3'b0; rd_req == 1'b0 ; rd_id == 4'd0; rd_addr == 32'd0; rd_len == 8'd0; rd_size == 3'd0; rd_burst == 2'b00; rd_cache == 4'b0000; rd_lock == 1'b0; rd_prot == 3'b0;};
    finish_item(item);
       
  endtask
  
  task read();
    AXI_sequence_item item;
    item = AXI_sequence_item :: type_id :: create("this");
    
    start_item(item);
    item.aresetn = 1'b1;
    item.randomize() with {wr_req == 1'b0 ; wr_id == 4'd0; wr_addr == 32'd0; wr_len == 8'd0; wr_size == 3'd0; wr_burst == 2'b00; wr_cache == 4'b0000; wr_lock == 1'b0; wr_prot == 3'b0; rd_req == 1'b1 ; rd_id == 4'd1; rd_addr == 32'd105; rd_len == 8'd3; rd_size == 3'd0; rd_burst == 2'b01; rd_cache == 4'b0000; rd_lock == 1'b0; rd_prot == 3'b0;};
    finish_item(item);
    
     start_item(item);
    item.aresetn = 1'b1;
    item.randomize() with {wr_req == 1'b0 ; wr_id == 4'd0; wr_addr == 32'd0; wr_len == 8'd0; wr_size == 3'd0; wr_burst == 2'b00; wr_cache == 4'b0000; wr_lock == 1'b0; wr_prot == 3'b0; rd_req == 1'b1 ; rd_id == 4'd2; rd_addr == 32'd205; rd_len == 8'd3; rd_size == 3'd0; rd_burst == 2'b10; rd_cache == 4'b0000; rd_lock == 1'b0; rd_prot == 3'b0;};
    finish_item(item);
    
     start_item(item);
    item.aresetn = 1'b1;
    item.randomize() with {wr_req == 1'b0 ; wr_id == 4'd0; wr_addr == 32'd0; wr_len == 8'd0; wr_size == 3'd0; wr_burst == 2'b00; wr_cache == 4'b0000; wr_lock == 1'b0; wr_prot == 3'b0; rd_req == 1'b1 ; rd_id == 4'd3; rd_addr == 32'd5; rd_len == 8'd3; rd_size == 3'd1; rd_burst == 2'b01; rd_cache == 4'b0000; rd_lock == 1'b0; rd_prot == 3'b0;};
    finish_item(item);
    
    start_item(item);
    item.aresetn = 1'b1;
    item.randomize() with {wr_req == 1'b0 ; wr_id == 4'd0; wr_addr == 32'd0; wr_len == 8'd0; wr_size == 3'd0; wr_burst == 2'b00; wr_cache == 4'b0000; wr_lock == 1'b0; wr_prot == 3'b0; rd_req == 1'b1 ; rd_id == 4'd4; rd_addr == 32'd304; rd_len == 8'd3; rd_size == 3'd1; rd_burst == 2'b10; rd_cache == 4'b0000; rd_lock == 1'b0; rd_prot == 3'b0;};
    finish_item(item);
  endtask
  
  task body();
    reset();
    write();
    read();
  endtask
endclass

// out-of-ordering completion for different id's of read and write [tc 9 & 23]

class out_of_order_sequence extends AXI_sequence;
  `uvm_object_utils(out_of_order_sequence)
  
  function new(string name = "out_of_order_sequence");
    super.new(name);
  endfunction
  
  task write();
    AXI_sequence_item item;
    item = AXI_sequence_item :: type_id :: create("this");
    
    start_item(item);
    item.aresetn = 1'b1;
    item.randomize() with {wr_req == 1'b1 ; wr_id == 4'd1; wr_addr == 32'd100; wr_len == 8'd3; wr_size == 3'd2; wr_burst == 2'b01; wr_cache == 4'b0000; wr_lock == 1'b0; wr_prot == 3'b0; rd_req == 1'b0 ; rd_id == 4'd0; rd_addr == 32'd0; rd_len == 8'd0; rd_size == 3'd0; rd_burst == 2'b00; rd_cache == 4'b0000; rd_lock == 1'b0; rd_prot == 3'b0;};
    finish_item(item);
    
     start_item(item);
    item.aresetn = 1'b1;
    item.randomize() with {wr_req == 1'b1 ; wr_id == 4'd2; wr_addr == 32'd500; wr_len == 8'd3; wr_size == 3'd2; wr_burst == 2'b01; wr_cache == 4'b0000; wr_lock == 1'b0; wr_prot == 3'b0; rd_req == 1'b0 ; rd_id == 4'd0; rd_addr == 32'd0; rd_len == 8'd0; rd_size == 3'd0; rd_burst == 2'b00; rd_cache == 4'b0000; rd_lock == 1'b0; rd_prot == 3'b0;};
    finish_item(item);
    
     start_item(item);
    item.aresetn = 1'b1;
    item.randomize() with {wr_req == 1'b1 ; wr_id == 4'd3; wr_addr == 32'd600; wr_len == 8'd3; wr_size == 3'd2; wr_burst == 2'b01; wr_cache == 4'b0000; wr_lock == 1'b0; wr_prot == 3'b0; rd_req == 1'b0 ; rd_id == 4'd0; rd_addr == 32'd0; rd_len == 8'd0; rd_size == 3'd0; rd_burst == 2'b00; rd_cache == 4'b0000; rd_lock == 1'b0; rd_prot == 3'b0;};
    finish_item(item);
  endtask
  
  task read();
    AXI_sequence_item item;
    item = AXI_sequence_item :: type_id :: create("this");
    
    start_item(item);
    item.aresetn = 1'b1;
    item.randomize() with {wr_req == 1'b0 ; wr_id == 4'd0; wr_addr == 32'd0; wr_len == 8'd0; wr_size == 3'd0; wr_burst == 2'b00; wr_cache == 4'b0000; wr_lock == 1'b0; wr_prot == 3'b0; rd_req == 1'b1 ; rd_id == 4'd1; rd_addr == 32'd100; rd_len == 8'd3; rd_size == 3'd2; rd_burst == 2'b01; rd_cache == 4'b0000; rd_lock == 1'b0; rd_prot == 3'b0;};
    finish_item(item);
    
     start_item(item);
    item.aresetn = 1'b1;
    item.randomize() with {wr_req == 1'b0 ; wr_id == 4'd0; wr_addr == 32'd0; wr_len == 8'd0; wr_size == 3'd0; wr_burst == 2'b00; wr_cache == 4'b0000; wr_lock == 1'b0; wr_prot == 3'b0; rd_req == 1'b1 ; rd_id == 4'd2; rd_addr == 32'd500; rd_len == 8'd3; rd_size == 3'd2; rd_burst == 2'b01; rd_cache == 4'b0000; rd_lock == 1'b0; rd_prot == 3'b0;};
    finish_item(item);
    
     start_item(item);
    item.aresetn = 1'b1;
    item.randomize() with {wr_req == 1'b0 ; wr_id == 4'd0; wr_addr == 32'd0; wr_len == 8'd0; wr_size == 3'd0; wr_burst == 2'b00; wr_cache == 4'b0000; wr_lock == 1'b0; wr_prot == 3'b0; rd_req == 1'b1 ; rd_id == 4'd3; rd_addr == 32'd600; rd_len == 8'd3; rd_size == 3'd2; rd_burst == 2'b01; rd_cache == 4'b0000; rd_lock == 1'b0; rd_prot == 3'b0;};
    finish_item(item);
  endtask
  
   
  task body();
    reset();
    write();
    read();
  endtask
endclass


// ordering completion for same id's of read and write [tc 10 & 19]

class order_sequence extends AXI_sequence;
  `uvm_object_utils(order_sequence)
  
  function new(string name = "order_sequence");
    super.new(name);
  endfunction
  
  task write();
    AXI_sequence_item item;
    item = AXI_sequence_item :: type_id :: create("this");
    
    start_item(item);
    item.aresetn = 1'b1;
    item.randomize() with {wr_req == 1'b1 ; wr_id == 4'd1; wr_addr == 32'd100; wr_len == 8'd3; wr_size == 3'd2; wr_burst == 2'b01; wr_cache == 4'b0000; wr_lock == 1'b0; wr_prot == 3'b0; rd_req == 1'b0 ; rd_id == 4'd0; rd_addr == 32'd0; rd_len == 8'd0; rd_size == 3'd0; rd_burst == 2'b00; rd_cache == 4'b0000; rd_lock == 1'b0; rd_prot == 3'b0;};
    finish_item(item);
    
     start_item(item);
    item.aresetn = 1'b1;
    item.randomize() with {wr_req == 1'b1 ; wr_id == 4'd1; wr_addr == 32'd500; wr_len == 8'd3; wr_size == 3'd2; wr_burst == 2'b01; wr_cache == 4'b0000; wr_lock == 1'b0; wr_prot == 3'b0; rd_req == 1'b0 ; rd_id == 4'd0; rd_addr == 32'd0; rd_len == 8'd0; rd_size == 3'd0; rd_burst == 2'b00; rd_cache == 4'b0000; rd_lock == 1'b0; rd_prot == 3'b0;};
    finish_item(item);
    
     start_item(item);
    item.aresetn = 1'b1;
    item.randomize() with {wr_req == 1'b1 ; wr_id == 4'd1; wr_addr == 32'd600; wr_len == 8'd3; wr_size == 3'd2; wr_burst == 2'b01; wr_cache == 4'b0000; wr_lock == 1'b0; wr_prot == 3'b0; rd_req == 1'b0 ; rd_id == 4'd0; rd_addr == 32'd0; rd_len == 8'd0; rd_size == 3'd0; rd_burst == 2'b00; rd_cache == 4'b0000; rd_lock == 1'b0; rd_prot == 3'b0;};
    finish_item(item);
  endtask
  
  task read();
        AXI_sequence_item item;
    item = AXI_sequence_item :: type_id :: create("this");
    
    start_item(item);
    item.aresetn = 1'b1;
    item.randomize() with {wr_req == 1'b0 ; wr_id == 4'd0; wr_addr == 32'd0; wr_len == 8'd0; wr_size == 3'd0; wr_burst == 2'b00; wr_cache == 4'b0000; wr_lock == 1'b0; wr_prot == 3'b0; rd_req == 1'b1 ; rd_id == 4'd1; rd_addr == 32'd100; rd_len == 8'd3; rd_size == 3'd2; rd_burst == 2'b01; rd_cache == 4'b0000; rd_lock == 1'b0; rd_prot == 3'b0;};
    finish_item(item);
    
     start_item(item);
    item.aresetn = 1'b1;
    item.randomize() with {wr_req == 1'b0 ; wr_id == 4'd0; wr_addr == 32'd0; wr_len == 8'd0; wr_size == 3'd0; wr_burst == 2'b00; wr_cache == 4'b0000; wr_lock == 1'b0; wr_prot == 3'b0; rd_req == 1'b1 ; rd_id == 4'd1; rd_addr == 32'd500; rd_len == 8'd3; rd_size == 3'd2; rd_burst == 2'b01; rd_cache == 4'b0000; rd_lock == 1'b0; rd_prot == 3'b0;};
    finish_item(item);
    
     start_item(item);
    item.aresetn = 1'b1;
    item.randomize() with {wr_req == 1'b0 ; wr_id == 4'd0; wr_addr == 32'd0; wr_len == 8'd0; wr_size == 3'd0; wr_burst == 2'b00; wr_cache == 4'b0000; wr_lock == 1'b0; wr_prot == 3'b0; rd_req == 1'b1 ; rd_id == 4'd1; rd_addr == 32'd600; rd_len == 8'd3; rd_size == 3'd2; rd_burst == 2'b01; rd_cache == 4'b0000; rd_lock == 1'b0; rd_prot == 3'b0;};
    finish_item(item);
  endtask
  
  task body();
    reset();
    write();
    read();
  endtask
endclass

// protection error testcase [tc 42]
class prot_error_seq extends AXI_sequence;
  `uvm_object_utils(prot_error_seq)
  
  function new(string name = "prot_error_seq");
    super.new(name);
  endfunction
  
  task write();
    AXI_sequence_item item;
    item = AXI_sequence_item :: type_id :: create("item");
    
    start_item(item);
    item.aresetn = 1'b1;
    item.randomize() with {wr_req == 1'b1 ; wr_id == 4'd7; wr_addr == 32'd12; wr_len == 8'd3; wr_size == 3'd2; wr_burst == 2'b01; wr_cache == 4'b0000; wr_lock == 1'b0; wr_prot == 3'b010; rd_req == 1'b0 ; rd_id == 4'd0; rd_addr == 32'd0; rd_len == 8'd0; rd_size == 3'd0; rd_burst == 2'b00; rd_cache == 4'b0000; rd_lock == 1'b0; rd_prot == 3'b0;};
    finish_item(item);
    
  endtask
  
  task read();
    AXI_sequence_item item;
    item = AXI_sequence_item :: type_id :: create("item");
    
    start_item(item);
    item.aresetn = 1'b1;
    item.randomize() with {wr_req == 1'b0 ; wr_id == 4'd7; wr_addr == 32'd0; wr_len == 8'd0; wr_size == 3'd0; wr_burst == 2'b00; wr_cache == 4'b0000; wr_lock == 1'b0; wr_prot == 3'b000; rd_req == 1'b1 ; rd_id == 4'd7; rd_addr == 32'd12; rd_len == 8'd3; rd_size == 3'd2; rd_burst == 2'b01; rd_cache == 4'b0000; rd_lock == 1'b0; rd_prot == 3'b0;};
    finish_item(item);
  endtask
  
  task body();
    reset();
    write();
    read();
  endtask
endclass

// normal read and write for all type of burst with OKAY response [tc 21]

class normal_read_write_okay_seq extends AXI_sequence;
  `uvm_object_utils(normal_read_write_okay_seq)
  
  function new(string name = "normal_read_write_okay_seq");
    super.new(name);
  endfunction
  
  task write();
    AXI_sequence_item item;
    item = AXI_sequence_item :: type_id :: create("item");
    
    start_item(item);
    item.aresetn = 1'b1;
    item.randomize() with {wr_req == 1'b1 ; wr_id == 4'd1; wr_addr == 32'd9; wr_len == 8'd3; wr_size == 3'd2; wr_burst == 2'b00; wr_cache == 4'b0000; wr_lock == 1'b0; wr_prot == 3'b000; rd_req == 1'b0 ; rd_id == 4'd0; rd_addr == 32'd0; rd_len == 8'd0; rd_size == 3'd0; rd_burst == 2'b00; rd_cache == 4'b0000; rd_lock == 1'b0; rd_prot == 3'b0;};
    finish_item(item);
    
    start_item(item);
    item.aresetn = 1'b1;
    item.randomize() with {wr_req == 1'b1 ; wr_id == 4'd2; wr_addr == 32'd109; wr_len == 8'd3; wr_size == 3'd2; wr_burst == 2'b01; wr_cache == 4'b0000; wr_lock == 1'b0; wr_prot == 3'b000; rd_req == 1'b0 ; rd_id == 4'd0; rd_addr == 32'd0; rd_len == 8'd0; rd_size == 3'd0; rd_burst == 2'b00; rd_cache == 4'b0000; rd_lock == 1'b0; rd_prot == 3'b0;};
    finish_item(item);
    
    start_item(item);
    item.aresetn = 1'b1;
    item.randomize() with {wr_req == 1'b1 ; wr_id == 4'd3; wr_addr == 32'd200; wr_len == 8'd3; wr_size == 3'd2; wr_burst == 2'b10; wr_cache == 4'b0000; wr_lock == 1'b0; wr_prot == 3'b000; rd_req == 1'b0 ; rd_id == 4'd0; rd_addr == 32'd0; rd_len == 8'd0; rd_size == 3'd0; rd_burst == 2'b00; rd_cache == 4'b0000; rd_lock == 1'b0; rd_prot == 3'b0;};
    finish_item(item);
  endtask
  
  task read();
    AXI_sequence_item item;
    item = AXI_sequence_item :: type_id :: create("item");
    
    start_item(item);
    item.aresetn = 1'b1;
    item.randomize() with {wr_req == 1'b0 ; wr_id == 4'd0; wr_addr == 32'd0; wr_len == 8'd0; wr_size == 3'd0; wr_burst == 2'b00; wr_cache == 4'b0000; wr_lock == 1'b0; wr_prot == 3'b010; rd_req == 1'b1 ; rd_id == 4'd1; rd_addr == 32'd9; rd_len == 8'd3; rd_size == 3'd2; rd_burst == 2'b00; rd_cache == 4'b0000; rd_lock == 1'b0; rd_prot == 3'b0;};
    finish_item(item);
    
    start_item(item);
    item.aresetn = 1'b1;
    item.randomize() with {wr_req == 1'b0 ; wr_id == 4'd0; wr_addr == 32'd0; wr_len == 8'd0; wr_size == 3'd0; wr_burst == 2'b00; wr_cache == 4'b0000; wr_lock == 1'b0; wr_prot == 3'b010; rd_req == 1'b1 ; rd_id == 4'd2; rd_addr == 32'd109; rd_len == 8'd3; rd_size == 3'd2; rd_burst == 2'b01; rd_cache == 4'b0000; rd_lock == 1'b0; rd_prot == 3'b0;};
    finish_item(item);
    
    start_item(item);
    item.aresetn = 1'b1;
    item.randomize() with {wr_req == 1'b0 ; wr_id == 4'd0; wr_addr == 32'd0; wr_len == 8'd0; wr_size == 3'd0; wr_burst == 2'b00; wr_cache == 4'b0000; wr_lock == 1'b0; wr_prot == 3'b010; rd_req == 1'b1 ; rd_id == 4'd3; rd_addr == 32'd200; rd_len == 8'd3; rd_size == 3'd2; rd_burst == 2'b10; rd_cache == 4'b0000; rd_lock == 1'b0; rd_prot == 3'b0;};
    finish_item(item);
  endtask
  
  task body();
    reset();
    write();
    read();
  endtask
endclass


// exclusive read and write in the same loction and checking the write response for all type of burst [tc 22 & 24] 

class exclusive_read_write_seq extends AXI_sequence;
  `uvm_object_utils(exclusive_read_write_seq)
  
  function new(string name = "exclusive_read_write_seq");
    super.new(name);
  endfunction
  
  task write_fixed();
    AXI_sequence_item item;
    item = AXI_sequence_item :: type_id :: create("item");
    
    start_item(item);
    item.aresetn = 1'b1;
    item.randomize() with {wr_req == 1'b1 ; wr_id == 4'd1; wr_addr == 32'd100; wr_len == 8'd0; wr_size == 3'd2; wr_burst == 2'b00; wr_cache == 4'b0000; wr_lock == 1'b1; wr_prot == 3'b000; rd_req == 1'b0 ; rd_id == 4'd0; rd_addr == 32'd0; rd_len == 8'd0; rd_size == 3'd0; rd_burst == 2'b00; rd_cache == 4'b0000; rd_lock == 1'b0; rd_prot == 3'b0;};
    finish_item(item);
  endtask
  
  task write_incr();
    AXI_sequence_item item;
    item = AXI_sequence_item :: type_id :: create("item");
    
    start_item(item);
    item.aresetn = 1'b1;
    item.randomize() with {wr_req == 1'b1 ; wr_id == 4'd2; wr_addr == 32'd200; wr_len == 8'd3; wr_size == 3'd2; wr_burst == 2'b01; wr_cache == 4'b0000; wr_lock == 1'b1; wr_prot == 3'b000; rd_req == 1'b0 ; rd_id == 4'd0; rd_addr == 32'd0; rd_len == 8'd0; rd_size == 3'd0; rd_burst == 2'b00; rd_cache == 4'b0000; rd_lock == 1'b0; rd_prot == 3'b0;};
    finish_item(item);
  endtask
  
  task write_wrap();
    AXI_sequence_item item;
    item = AXI_sequence_item :: type_id :: create("item");
    
    start_item(item);
    item.aresetn = 1'b1;
    item.randomize() with {wr_req == 1'b1 ; wr_id == 4'd3; wr_addr == 32'd400; wr_len == 8'd3; wr_size == 3'd2; wr_burst == 2'b10; wr_cache == 4'b0000; wr_lock == 1'b1; wr_prot == 3'b000; rd_req == 1'b0 ; rd_id == 4'd0; rd_addr == 32'd0; rd_len == 8'd0; rd_size == 3'd0; rd_burst == 2'b00; rd_cache == 4'b0000; rd_lock == 1'b0; rd_prot == 3'b0;};
    finish_item(item);
  endtask
  
  task read_fixed();
    AXI_sequence_item item;
    item = AXI_sequence_item :: type_id :: create("item");
    
    start_item(item);
    item.aresetn = 1'b1;
    item.randomize() with {wr_req == 1'b0 ; wr_id == 4'd0; wr_addr == 32'd0; wr_len == 8'd0; wr_size == 3'd0; wr_burst == 2'b00; wr_cache == 4'b0000; wr_lock == 1'b0; wr_prot == 3'b000; rd_req == 1'b1 ; rd_id == 4'd1; rd_addr == 32'd100; rd_len == 8'd0; rd_size == 3'd2; rd_burst == 2'b00; rd_cache == 4'b0000; rd_lock == 1'b1; rd_prot == 3'b0;};
    finish_item(item);
  endtask
  
  task read_incr();
    AXI_sequence_item item;
    item = AXI_sequence_item :: type_id :: create("item");
    
    start_item(item);
    item.aresetn = 1'b1;
    item.randomize() with {wr_req == 1'b0 ; wr_id == 4'd0; wr_addr == 32'd0; wr_len == 8'd0; wr_size == 3'd0; wr_burst == 2'b00; wr_cache == 4'b0000; wr_lock == 1'b0; wr_prot == 3'b000; rd_req == 1'b1 ; rd_id == 4'd2; rd_addr == 32'd200; rd_len == 8'd3; rd_size == 3'd2; rd_burst == 2'b01; rd_cache == 4'b0000; rd_lock == 1'b1; rd_prot == 3'b0;};
    finish_item(item);
  endtask
  
  task read_wrap();
    AXI_sequence_item item;
    item = AXI_sequence_item :: type_id :: create("item");
    
    start_item(item);
    item.aresetn = 1'b1;
    item.randomize() with {wr_req == 1'b0 ; wr_id == 4'd0; wr_addr == 32'd0; wr_len == 8'd0; wr_size == 3'd0; wr_burst == 2'b00; wr_cache == 4'b0000; wr_lock == 1'b0; wr_prot == 3'b000; rd_req == 1'b1 ; rd_id == 4'd3; rd_addr == 32'd400; rd_len == 8'd3; rd_size == 3'd2; rd_burst == 2'b10; rd_cache == 4'b0000; rd_lock == 1'b1; rd_prot == 3'b0;};
    finish_item(item);
  endtask
  
  task body();
    reset();
    read_fixed();
    write_fixed();
    read_incr();
    write_incr();
    read_wrap();
    write_wrap();
  endtask
endclass


// exclusive read and write in the out-of-bound loction [tc 25] 

class exclusive_read_write_limit_seq extends AXI_sequence;
  `uvm_object_utils(exclusive_read_write_limit_seq)
  
  function new(string name = "exclusive_read_write_limit_seq");
    super.new(name);
  endfunction
  
  task write_fixed();
    AXI_sequence_item item;
    item = AXI_sequence_item :: type_id :: create("item");
    
    start_item(item);
    item.aresetn = 1'b1;
    item.wr_address.constraint_mode(0);
    item.randomize() with {wr_req == 1'b1 ; wr_id == 4'd1; wr_addr == 32'd4097; wr_len == 8'd0; wr_size == 3'd2; wr_burst == 2'b00; wr_cache == 4'b0000; wr_lock == 1'b1; wr_prot == 3'b000; rd_req == 1'b0 ; rd_id == 4'd0; rd_addr == 32'd0; rd_len == 8'd0; rd_size == 3'd0; rd_burst == 2'b00; rd_cache == 4'b0000; rd_lock == 1'b0; rd_prot == 3'b0;};
    finish_item(item);
  endtask
  
  task write_incr();
    AXI_sequence_item item;
    item = AXI_sequence_item :: type_id :: create("item");
    
    start_item(item);
    item.aresetn = 1'b1;
    item.wr_address.constraint_mode(0);
    item.randomize() with {wr_req == 1'b1 ; wr_id == 4'd2; wr_addr == 32'd4096; wr_len == 8'd4; wr_size == 3'd2; wr_burst == 2'b01; wr_cache == 4'b0000; wr_lock == 1'b1; wr_prot == 3'b000; rd_req == 1'b0 ; rd_id == 4'd0; rd_addr == 32'd0; rd_len == 8'd0; rd_size == 3'd0; rd_burst == 2'b00; rd_cache == 4'b0000; rd_lock == 1'b0; rd_prot == 3'b0;};
    finish_item(item);
  endtask
  
  task write_wrap();
    AXI_sequence_item item;
    item = AXI_sequence_item :: type_id :: create("item");
    
    start_item(item);
    item.aresetn = 1'b1;
    item.wr_address.constraint_mode(0);
    item.randomize() with {wr_req == 1'b1 ; wr_id == 4'd3; wr_addr == 32'd4096; wr_len == 8'd3; wr_size == 3'd2; wr_burst == 2'b10; wr_cache == 4'b0000; wr_lock == 1'b1; wr_prot == 3'b000; rd_req == 1'b0 ; rd_id == 4'd0; rd_addr == 32'd0; rd_len == 8'd0; rd_size == 3'd0; rd_burst == 2'b00; rd_cache == 4'b0000; rd_lock == 1'b0; rd_prot == 3'b0;};
    finish_item(item);
  endtask
  
  task read_fixed();
    AXI_sequence_item item;
    item = AXI_sequence_item :: type_id :: create("item");
    
    start_item(item);
    item.aresetn = 1'b1;
    item.rd_address.constraint_mode(0);
    item.randomize() with {wr_req == 1'b0 ; wr_id == 4'd0; wr_addr == 32'd0; wr_len == 8'd0; wr_size == 3'd0; wr_burst == 2'b00; wr_cache == 4'b0000; wr_lock == 1'b0; wr_prot == 3'b000; rd_req == 1'b1 ; rd_id == 4'd1; rd_addr == 32'd4096; rd_len == 8'd0; rd_size == 3'd2; rd_burst == 2'b00; rd_cache == 4'b0000; rd_lock == 1'b1; rd_prot == 3'b0;};
    finish_item(item);
  endtask
  
  task read_incr();
    AXI_sequence_item item;
    item = AXI_sequence_item :: type_id :: create("item");
    
    start_item(item);
    item.aresetn = 1'b1;
    item.randomize() with {wr_req == 1'b0 ; wr_id == 4'd0; wr_addr == 32'd0; wr_len == 8'd0; wr_size == 3'd0; wr_burst == 2'b00; wr_cache == 4'b0000; wr_lock == 1'b0; wr_prot == 3'b000; rd_req == 1'b1 ; rd_id == 4'd2; rd_addr == 32'd4092; rd_len == 8'd4; rd_size == 3'd2; rd_burst == 2'b01; rd_cache == 4'b0000; rd_lock == 1'b1; rd_prot == 3'b0;};
    finish_item(item);
  endtask
  
  task read_wrap();
    AXI_sequence_item item;
    item = AXI_sequence_item :: type_id :: create("item");
    
    start_item(item);
    item.aresetn = 1'b1;
    item.rd_address.constraint_mode(0);
    item.randomize() with {wr_req == 1'b0 ; wr_id == 4'd0; wr_addr == 32'd0; wr_len == 8'd0; wr_size == 3'd0; wr_burst == 2'b00; wr_cache == 4'b0000; wr_lock == 1'b0; wr_prot == 3'b000; rd_req == 1'b1 ; rd_id == 4'd3; rd_addr == 32'd4096; rd_len == 8'd3; rd_size == 3'd2; rd_burst == 2'b10; rd_cache == 4'b0000; rd_lock == 1'b1; rd_prot == 3'b0;};
    finish_item(item);
  endtask
  
  task body();
    reset();
    read_fixed();
    write_fixed();
    read_incr();
    write_incr();
    read_wrap();
    write_wrap();
  endtask
endclass


// exclusive read and write with different size and checking the response [tc 26]

class exclusive_read_write_diff_size_seq extends AXI_sequence;
  `uvm_object_utils(exclusive_read_write_diff_size_seq)
  
  function new(string name = "exclusive_read_write_diff_size_seq");
    super.new(name);
  endfunction
  
   task write_fixed();
    AXI_sequence_item item;
    item = AXI_sequence_item :: type_id :: create("item");
    
    start_item(item);
    item.aresetn = 1'b1;
//     item.wr_address.constraint_mode(0);
     item.randomize() with {wr_req == 1'b1 ; wr_id == 4'd1; wr_addr == 32'd100; wr_len == 8'd0; wr_size == 3'd1; wr_burst == 2'b00; wr_cache == 4'b0000; wr_lock == 1'b1; wr_prot == 3'b000; rd_req == 1'b0 ; rd_id == 4'd0; rd_addr == 32'd0; rd_len == 8'd0; rd_size == 3'd0; rd_burst == 2'b00; rd_cache == 4'b0000; rd_lock == 1'b0; rd_prot == 3'b0;};
    finish_item(item);
  endtask
  
  task write_incr();
    AXI_sequence_item item;
    item = AXI_sequence_item :: type_id :: create("item");
    
    start_item(item);
    item.aresetn = 1'b1;
    item.randomize() with {wr_req == 1'b1 ; wr_id == 4'd2; wr_addr == 32'd200; wr_len == 8'd3; wr_size == 3'd1; wr_burst == 2'b01; wr_cache == 4'b0000; wr_lock == 1'b1; wr_prot == 3'b000; rd_req == 1'b0 ; rd_id == 4'd0; rd_addr == 32'd0; rd_len == 8'd0; rd_size == 3'd0; rd_burst == 2'b00; rd_cache == 4'b0000; rd_lock == 1'b0; rd_prot == 3'b0;};
    finish_item(item);
  endtask
  
  task write_wrap();
    AXI_sequence_item item;
    item = AXI_sequence_item :: type_id :: create("item");
    
    start_item(item);
    item.aresetn = 1'b1;
    item.wr_address.constraint_mode(0);
    item.randomize() with {wr_req == 1'b1 ; wr_id == 4'd3; wr_addr == 32'd300; wr_len == 8'd3; wr_size == 3'd1; wr_burst == 2'b10; wr_cache == 4'b0000; wr_lock == 1'b1; wr_prot == 3'b000; rd_req == 1'b0 ; rd_id == 4'd0; rd_addr == 32'd0; rd_len == 8'd0; rd_size == 3'd0; rd_burst == 2'b00; rd_cache == 4'b0000; rd_lock == 1'b0; rd_prot == 3'b0;};
    finish_item(item);
  endtask
  
  task read_fixed();
    AXI_sequence_item item;
    item = AXI_sequence_item :: type_id :: create("item");
    
    start_item(item);
    item.aresetn = 1'b1;
    item.rd_address.constraint_mode(0);
    item.randomize() with {wr_req == 1'b0 ; wr_id == 4'd0; wr_addr == 32'd0; wr_len == 8'd0; wr_size == 3'd0; wr_burst == 2'b00; wr_cache == 4'b0000; wr_lock == 1'b0; wr_prot == 3'b000; rd_req == 1'b1 ; rd_id == 4'd1; rd_addr == 32'd100; rd_len == 8'd0; rd_size == 3'd2; rd_burst == 2'b00; rd_cache == 4'b0000; rd_lock == 1'b1; rd_prot == 3'b0;};
    finish_item(item);
  endtask
  
  task read_incr();
    AXI_sequence_item item;
    item = AXI_sequence_item :: type_id :: create("item");
    
    start_item(item);
    item.aresetn = 1'b1;
    item.randomize() with {wr_req == 1'b0 ; wr_id == 4'd0; wr_addr == 32'd0; wr_len == 8'd0; wr_size == 3'd0; wr_burst == 2'b00; wr_cache == 4'b0000; wr_lock == 1'b0; wr_prot == 3'b000; rd_req == 1'b1 ; rd_id == 4'd2; rd_addr == 32'd200; rd_len == 8'd4; rd_size == 3'd2; rd_burst == 2'b01; rd_cache == 4'b0000; rd_lock == 1'b1; rd_prot == 3'b0;};
    finish_item(item);
  endtask
  
  task read_wrap();
    AXI_sequence_item item;
    item = AXI_sequence_item :: type_id :: create("item");
    
    start_item(item);
    item.aresetn = 1'b1;
    item.rd_address.constraint_mode(0);
    item.randomize() with {wr_req == 1'b0 ; wr_id == 4'd0; wr_addr == 32'd0; wr_len == 8'd0; wr_size == 3'd0; wr_burst == 2'b00; wr_cache == 4'b0000; wr_lock == 1'b0; wr_prot == 3'b000; rd_req == 1'b1 ; rd_id == 4'd3; rd_addr == 32'd300; rd_len == 8'd3; rd_size == 3'd2; rd_burst == 2'b10; rd_cache == 4'b0000; rd_lock == 1'b1; rd_prot == 3'b0;};
    finish_item(item);
  endtask
  
  task body();
    reset();
    read_fixed();
    write_fixed();
    read_incr();
    write_incr();
    read_wrap();
    write_wrap();
  endtask
endclass


// exclusive read and write with same ID and different address and checking the response [tc 27]

class exclusive_read_write_diff_addr_seq extends AXI_sequence;
  `uvm_object_utils(exclusive_read_write_diff_addr_seq)
  
  function new(string name = "exclusive_read_write_diff_addr_seq");
    super.new(name);
  endfunction
  
   task write_fixed();
    AXI_sequence_item item;
    item = AXI_sequence_item :: type_id :: create("item");
    
    start_item(item);
    item.aresetn = 1'b1;
//     item.wr_address.constraint_mode(0);
     item.randomize() with {wr_req == 1'b1 ; wr_id == 4'd1; wr_addr == 32'd104; wr_len == 8'd0; wr_size == 3'd2; wr_burst == 2'b00; wr_cache == 4'b0000; wr_lock == 1'b1; wr_prot == 3'b000; rd_req == 1'b0 ; rd_id == 4'd0; rd_addr == 32'd0; rd_len == 8'd0; rd_size == 3'd0; rd_burst == 2'b00; rd_cache == 4'b0000; rd_lock == 1'b0; rd_prot == 3'b0;};
    finish_item(item);
  endtask
  
  task write_incr();
    AXI_sequence_item item;
    item = AXI_sequence_item :: type_id :: create("item");
    
    start_item(item);
    item.aresetn = 1'b1;
    item.randomize() with {wr_req == 1'b1 ; wr_id == 4'd2; wr_addr == 32'd204; wr_len == 8'd3; wr_size == 3'd2; wr_burst == 2'b01; wr_cache == 4'b0000; wr_lock == 1'b1; wr_prot == 3'b000; rd_req == 1'b0 ; rd_id == 4'd0; rd_addr == 32'd0; rd_len == 8'd0; rd_size == 3'd0; rd_burst == 2'b00; rd_cache == 4'b0000; rd_lock == 1'b0; rd_prot == 3'b0;};
    finish_item(item);
  endtask
  
  task write_wrap();
    AXI_sequence_item item;
    item = AXI_sequence_item :: type_id :: create("item");
    
    start_item(item);
    item.aresetn = 1'b1;
    item.wr_address.constraint_mode(0);
    item.randomize() with {wr_req == 1'b1 ; wr_id == 4'd3; wr_addr == 32'd304; wr_len == 8'd3; wr_size == 3'd2; wr_burst == 2'b10; wr_cache == 4'b0000; wr_lock == 1'b1; wr_prot == 3'b000; rd_req == 1'b0 ; rd_id == 4'd0; rd_addr == 32'd0; rd_len == 8'd0; rd_size == 3'd0; rd_burst == 2'b00; rd_cache == 4'b0000; rd_lock == 1'b0; rd_prot == 3'b0;};
    finish_item(item);
  endtask
  
  task read_fixed();
    AXI_sequence_item item;
    item = AXI_sequence_item :: type_id :: create("item");
    
    start_item(item);
    item.aresetn = 1'b1;
    item.rd_address.constraint_mode(0);
    item.randomize() with {wr_req == 1'b0 ; wr_id == 4'd0; wr_addr == 32'd0; wr_len == 8'd0; wr_size == 3'd0; wr_burst == 2'b00; wr_cache == 4'b0000; wr_lock == 1'b0; wr_prot == 3'b000; rd_req == 1'b1 ; rd_id == 4'd1; rd_addr == 32'd100; rd_len == 8'd0; rd_size == 3'd2; rd_burst == 2'b00; rd_cache == 4'b0000; rd_lock == 1'b1; rd_prot == 3'b0;};
    finish_item(item);
  endtask
  
  task read_incr();
    AXI_sequence_item item;
    item = AXI_sequence_item :: type_id :: create("item");
    
    start_item(item);
    item.aresetn = 1'b1;
    item.randomize() with {wr_req == 1'b0 ; wr_id == 4'd0; wr_addr == 32'd0; wr_len == 8'd0; wr_size == 3'd0; wr_burst == 2'b00; wr_cache == 4'b0000; wr_lock == 1'b0; wr_prot == 3'b000; rd_req == 1'b1 ; rd_id == 4'd2; rd_addr == 32'd200; rd_len == 8'd4; rd_size == 3'd2; rd_burst == 2'b01; rd_cache == 4'b0000; rd_lock == 1'b1; rd_prot == 3'b0;};
    finish_item(item);
  endtask
  
  task read_wrap();
    AXI_sequence_item item;
    item = AXI_sequence_item :: type_id :: create("item");
    
    start_item(item);
    item.aresetn = 1'b1;
    item.rd_address.constraint_mode(0);
    item.randomize() with {wr_req == 1'b0 ; wr_id == 4'd0; wr_addr == 32'd0; wr_len == 8'd0; wr_size == 3'd0; wr_burst == 2'b00; wr_cache == 4'b0000; wr_lock == 1'b0; wr_prot == 3'b000; rd_req == 1'b1 ; rd_id == 4'd3; rd_addr == 32'd300; rd_len == 8'd3; rd_size == 3'd2; rd_burst == 2'b10; rd_cache == 4'b0000; rd_lock == 1'b1; rd_prot == 3'b0;};
    finish_item(item);
  endtask
  
  task body();
    reset();
    read_fixed();
    write_fixed();
    read_incr();
    write_incr();
    read_wrap();
    write_wrap();
  endtask
endclass

// two exclusive read with same id and followed by write on the first id's address signal [tc 28]

class exclusive_read_write_same_id_seq extends AXI_sequence;
  `uvm_object_utils(exclusive_read_write_same_id_seq)
  
  function new(string name = "exclusive_read_write_same_id_seq");
    super.new(name);
  endfunction
  

  task write_incr();
    AXI_sequence_item item;
    item = AXI_sequence_item :: type_id :: create("item");
    
    start_item(item);
    item.aresetn = 1'b1;
    item.randomize() with {wr_req == 1'b1 ; wr_id == 4'd2; wr_addr == 32'd200; wr_len == 8'd3; wr_size == 3'd2; wr_burst == 2'b01; wr_cache == 4'b0000; wr_lock == 1'b1; wr_prot == 3'b000; rd_req == 1'b0 ; rd_id == 4'd0; rd_addr == 32'd0; rd_len == 8'd0; rd_size == 3'd0; rd_burst == 2'b00; rd_cache == 4'b0000; rd_lock == 1'b0; rd_prot == 3'b0;};
    finish_item(item);
    
    
    start_item(item);
    item.aresetn = 1'b1;
    item.randomize() with {wr_req == 1'b1 ; wr_id == 4'd2; wr_addr == 32'd300; wr_len == 8'd3; wr_size == 3'd2; wr_burst == 2'b01; wr_cache == 4'b0000; wr_lock == 1'b1; wr_prot == 3'b000; rd_req == 1'b0 ; rd_id == 4'd0; rd_addr == 32'd0; rd_len == 8'd0; rd_size == 3'd0; rd_burst == 2'b00; rd_cache == 4'b0000; rd_lock == 1'b0; rd_prot == 3'b0;};
    finish_item(item);
  endtask
  
  
  task read_incr();
    AXI_sequence_item item;
    item = AXI_sequence_item :: type_id :: create("item");
    
    start_item(item);
    item.aresetn = 1'b1;
    item.randomize() with {wr_req == 1'b0 ; wr_id == 4'd0; wr_addr == 32'd0; wr_len == 8'd0; wr_size == 3'd0; wr_burst == 2'b00; wr_cache == 4'b0000; wr_lock == 1'b0; wr_prot == 3'b000; rd_req == 1'b1 ; rd_id == 4'd2; rd_addr == 32'd200; rd_len == 8'd3; rd_size == 3'd2; rd_burst == 2'b01; rd_cache == 4'b0000; rd_lock == 1'b1; rd_prot == 3'b0;};
    finish_item(item);
    
    start_item(item);
    item.aresetn = 1'b1;
    item.randomize() with {wr_req == 1'b0 ; wr_id == 4'd0; wr_addr == 32'd0; wr_len == 8'd0; wr_size == 3'd0; wr_burst == 2'b00; wr_cache == 4'b0000; wr_lock == 1'b0; wr_prot == 3'b000; rd_req == 1'b1 ; rd_id == 4'd2; rd_addr == 32'd300; rd_len == 8'd3; rd_size == 3'd2; rd_burst == 2'b01; rd_cache == 4'b0000; rd_lock == 1'b1; rd_prot == 3'b0;};
    finish_item(item);
  endtask
  
  task body();
    reset();
    read_incr();
    write_incr();
  endtask
endclass

// all type of protect signals for both write and read [tc 41,52,53]

class all_prot_seq extends AXI_sequence;
  `uvm_object_utils(all_prot_seq)
  
  function new(string name = "all_prot_seq");
    super.new(name);
  endfunction
  
  task write_fixed();
    AXI_sequence_item item;
    item = AXI_sequence_item :: type_id :: create("item");
    
    for(int i = 0; i < 8 ; i = i+1)
      begin
        start_item(item);
        item.aresetn = 1'b1;
        item.randomize() with {wr_req == 1'b1 ; wr_id == i; wr_addr == 32'd0 +  (20*i) ; wr_len == 8'd0; wr_size == 3'd2; wr_burst == 2'b00; wr_cache == 4'b0000; wr_lock == 1'b0; wr_prot == i; rd_req == 1'b0 ; rd_id == 4'd0; rd_addr == 32'd0; rd_len == 8'd0; rd_size == 3'd0; rd_burst == 2'b00; rd_cache == 4'b0000; rd_lock == 1'b0; rd_prot == 3'b0;};
        finish_item(item);
      end
  endtask
  
  task write_incr();
    AXI_sequence_item item;
    item = AXI_sequence_item :: type_id :: create("item");
    
    for(int i = 0; i < 8 ; i = i+1)
      begin
        start_item(item);
        item.aresetn = 1'b1;
        item.randomize() with {wr_req == 1'b1 ; wr_id == i; wr_addr == 32'd100 +  (20*i) ; wr_len == 8'd3; wr_size == 3'd2; wr_burst == 2'b01; wr_cache == 4'b0000; wr_lock == 1'b0; wr_prot == i; rd_req == 1'b0 ; rd_id == 4'd0; rd_addr == 32'd0; rd_len == 8'd0; rd_size == 3'd0; rd_burst == 2'b00; rd_cache == 4'b0000; rd_lock == 1'b0; rd_prot == 3'b0;};
        finish_item(item);
      end
  endtask
  
  task write_wrap();
    AXI_sequence_item item;
    item = AXI_sequence_item :: type_id :: create("item");
    
    for(int i = 0; i < 8 ; i = i+1)
      begin
        start_item(item);
        item.aresetn = 1'b1;
        item.randomize() with {wr_req == 1'b1 ; wr_id == i; wr_addr == 32'd200 + (20*i) ; wr_len == 8'd3; wr_size == 3'd2; wr_burst == 2'b10; wr_cache == 4'b0000; wr_lock == 1'b0; wr_prot == i; rd_req == 1'b0 ; rd_id == 4'd0; rd_addr == 32'd0; rd_len == 8'd0; rd_size == 3'd0; rd_burst == 2'b00; rd_cache == 4'b0000; rd_lock == 1'b0; rd_prot == 3'b0;};
        finish_item(item);
      end
  endtask
  
  task read_fixed();
    AXI_sequence_item item;
    item = AXI_sequence_item :: type_id :: create("item");
    
    for(int i = 0; i < 8 ; i = i+1)
      begin
        start_item(item);
        item.aresetn = 1'b1;
        item.randomize() with {wr_req == 1'b0 ; wr_id == 4'd0; wr_addr == 32'd0 +(20*i); wr_len == 8'd0; wr_size == 3'd0; wr_burst == 2'b00; wr_cache == 4'b0000; wr_lock == 1'b0; wr_prot == 3'd0; rd_req == 1'b1 ; rd_id == i; rd_addr == 32'd0 + (10*i); rd_len == 8'd0; rd_size == 3'd2; rd_burst == 2'b00; rd_cache == 4'b0000; rd_lock == 1'b0; rd_prot == i;};
        finish_item(item);
      end
  endtask
  
  task read_incr();
    AXI_sequence_item item;
    item = AXI_sequence_item :: type_id :: create("item");
    
    for(int i = 0; i < 8 ; i = i+1)
      begin
        start_item(item);
        item.aresetn = 1'b1;
        item.randomize() with {wr_req == 1'b0 ; wr_id == 4'd0; wr_addr == 32'd0 ; wr_len == 8'd0; wr_size == 3'd0; wr_burst == 2'b00; wr_cache == 4'b0000; wr_lock == 1'b0; wr_prot == 3'd0; rd_req == 1'b1 ; rd_id == i; rd_addr == 32'd100 + (20*i); rd_len == 8'd3; rd_size == 3'd2; rd_burst == 2'b01; rd_cache == 4'b0000; rd_lock == 1'b0; rd_prot == i;};
        finish_item(item);
      end
  endtask
  
  task read_wrap();
    AXI_sequence_item item;
    item = AXI_sequence_item :: type_id :: create("item");
    
    for(int i = 0; i < 8 ; i = i+1)
      begin
        start_item(item);
        item.aresetn = 1'b1;
        item.randomize() with {wr_req == 1'b0 ; wr_id == 4'd0; wr_addr == 32'd0 ; wr_len == 8'd0; wr_size == 3'd0; wr_burst == 2'b00; wr_cache == 4'b0000; wr_lock == 1'b0; wr_prot == 3'd0; rd_req == 1'b1 ; rd_id == i; rd_addr == 32'd200 + (20*i); rd_len == 8'd3; rd_size == 3'd2; rd_burst == 2'b10; rd_cache == 4'b0000; rd_lock == 1'b0; rd_prot == i;};
        finish_item(item);
      end
  endtask
  
  task body();
    reset();
    write_fixed();
    read_fixed();
    write_incr();
    read_incr();
    write_wrap();
    read_wrap();
  endtask
endclass

// To check the wrap error conditions [tc 46]

class wrap_error_seq extends AXI_sequence;
  `uvm_object_utils(wrap_error_seq)
  
  function new(string name = "wrap_error_seq");
    super.new(name);
  endfunction
  
  task write();
    AXI_sequence_item item;
    item = AXI_sequence_item :: type_id :: create("item");
    
    start_item(item);
    item.aresetn = 1'b1;
    item.randomize() with {wr_req == 1'b1 ; wr_id == 4'd1; wr_addr == 32'd200 ; wr_len == 8'd16; wr_size == 3'd2; wr_burst == 2'b10; wr_cache == 4'b0000; wr_lock == 1'b0; wr_prot == 3'd0; rd_req == 1'b0 ; rd_id == 4'd0; rd_addr == 32'd0; rd_len == 8'd0; rd_size == 3'd0; rd_burst == 2'b00; rd_cache == 4'b0000; rd_lock == 1'b0; rd_prot == 3'b0;};
    finish_item(item);
    
    start_item(item);
    item.aresetn = 1'b1;
    item.randomize() with {wr_req == 1'b1 ; wr_id == 4'd2; wr_addr == 32'd300; wr_len == 8'd0; wr_size == 3'd2; wr_burst == 2'b10; wr_cache == 4'b0000; wr_lock == 1'b0; wr_prot == 3'd0; rd_req == 1'b0 ; rd_id == 4'd0; rd_addr == 32'd0; rd_len == 8'd0; rd_size == 3'd0; rd_burst == 2'b00; rd_cache == 4'b0000; rd_lock == 1'b0; rd_prot == 3'b0;};
    finish_item(item);
    
    start_item(item);
    item.aresetn = 1'b1;
    item.randomize() with {wr_req == 1'b1 ; wr_id == 4'd3; wr_addr == 32'd405 ; wr_len == 8'd3; wr_size == 3'd2; wr_burst == 2'b10; wr_cache == 4'b0000; wr_lock == 1'b0; wr_prot == 3'd0; rd_req == 1'b0 ; rd_id == 4'd0; rd_addr == 32'd0; rd_len == 8'd0; rd_size == 3'd0; rd_burst == 2'b00; rd_cache == 4'b0000; rd_lock == 1'b0; rd_prot == 3'b0;};
    finish_item(item);
    
    start_item(item);
    item.aresetn = 1'b1;
    item.wr_address.constraint_mode(0);
    item.randomize() with {wr_req == 1'b1 ; wr_id == 4'd4; wr_addr == 32'd4096 ; wr_len == 8'd3; wr_size == 3'd2; wr_burst == 2'b10; wr_cache == 4'b0000; wr_lock == 1'b0; wr_prot == 3'd0; rd_req == 1'b0 ; rd_id == 4'd0; rd_addr == 32'd0; rd_len == 8'd0; rd_size == 3'd0; rd_burst == 2'b00; rd_cache == 4'b0000; rd_lock == 1'b0; rd_prot == 3'b0;};
    finish_item(item);
  endtask
  
  task read();
    AXI_sequence_item item;
    item = AXI_sequence_item :: type_id :: create("item");
    
    start_item(item);
    item.aresetn = 1'b1;
    item.randomize() with {wr_req == 1'b0 ; wr_id == 4'd0; wr_addr == 32'd0 ; wr_len == 8'd0; wr_size == 3'd0; wr_burst == 2'b00; wr_cache == 4'b0000; wr_lock == 1'b0; wr_prot == 3'd0; rd_req == 1'b1 ; rd_id == 4'd1; rd_addr == 32'd200; rd_len == 8'd16; rd_size == 3'd2; rd_burst == 2'b10; rd_cache == 4'b0000; rd_lock == 1'b0; rd_prot == 3'd0;};
    finish_item(item);
    
    start_item(item);
    item.aresetn = 1'b1;
    item.randomize() with {wr_req == 1'b0 ; wr_id == 4'd0; wr_addr == 32'd0 ; wr_len == 8'd0; wr_size == 3'd0; wr_burst == 2'b00; wr_cache == 4'b0000; wr_lock == 1'b0; wr_prot == 3'd0; rd_req == 1'b1 ; rd_id == 4'd2; rd_addr == 32'd300; rd_len == 8'd0; rd_size == 3'd2; rd_burst == 2'b10; rd_cache == 4'b0000; rd_lock == 1'b0; rd_prot == 3'd0;};
    finish_item(item);
    
    start_item(item);
    item.aresetn = 1'b1;
    item.randomize() with {wr_req == 1'b0 ; wr_id == 4'd0; wr_addr == 32'd0 ; wr_len == 8'd0; wr_size == 3'd0; wr_burst == 2'b00; wr_cache == 4'b0000; wr_lock == 1'b0; wr_prot == 3'd0; rd_req == 1'b1 ; rd_id == 4'd3; rd_addr == 32'd405; rd_len == 8'd3; rd_size == 3'd2; rd_burst == 2'b10; rd_cache == 4'b0000; rd_lock == 1'b0; rd_prot == 3'd0;};
    finish_item(item);
    
     start_item(item);
    item.aresetn = 1'b1;
    item.rd_address.constraint_mode(0);
    item.randomize() with {wr_req == 1'b0 ; wr_id == 4'd0; wr_addr == 32'd0 ; wr_len == 8'd0; wr_size == 3'd0; wr_burst == 2'b00; wr_cache == 4'b0000; wr_lock == 1'b0; wr_prot == 3'd0; rd_req == 1'b1 ; rd_id == 4'd4; rd_addr == 32'd4096; rd_len == 8'd3; rd_size == 3'd2; rd_burst == 2'b10; rd_cache == 4'b0000; rd_lock == 1'b0; rd_prot == 3'd0;};
    finish_item(item);
  endtask
  
  task body();
    reset();
    write();
    read();
  endtask
endclass

// parallel write and read [tc 48]

class paralle_write_read_seq extends AXI_sequence;
  `uvm_object_utils(paralle_write_read_seq)
  
  function new(string name = "paralle_write_read_seq");
    super.new(name);
  endfunction
  
  task write_read();
    AXI_sequence_item item;
    item = AXI_sequence_item :: type_id :: create("item");
    
    start_item(item);
    item.aresetn = 1'b1;
    item.randomize() with {wr_req == 1'b1 ; wr_id == 4'd1; wr_addr == 32'd1000 ; wr_len == 8'd15; wr_size == 3'd2; wr_burst == 2'b01; wr_cache == 4'b0000; wr_lock == 1'b0; wr_prot == 3'd0; rd_req == 1'b0 ; rd_id == 4'd0; rd_addr == 32'd0; rd_len == 8'd0; rd_size == 3'd0; rd_burst == 2'b00; rd_cache == 4'b0000; rd_lock == 1'b0; rd_prot == 3'd0;};
    finish_item(item);
    
    start_item(item);
    item.aresetn = 1'b1;
    item.randomize() with {wr_req == 1'b0 ; wr_id == 4'd0; wr_addr == 32'd0; wr_len == 8'd0; wr_size == 3'd0; wr_burst == 2'b00; wr_cache == 4'b0000; wr_lock == 1'b0; wr_prot == 3'd0; rd_req == 1'b1 ; rd_id == 4'd1; rd_addr == 32'd1000; rd_len == 8'd15; rd_size == 3'd2; rd_burst == 2'b01; rd_cache == 4'b0000; rd_lock == 1'b0; rd_prot == 3'd0;};
    finish_item(item);
  endtask
 
  task body();
    reset();
    write_read();
  endtask
endclass


// non-bufferable write and read [tc 29 & 30]

class non_buf_write_read_seq extends AXI_sequence;
  `uvm_object_utils(non_buf_write_read_seq)
  
  function new(string name = "non_buf_write_read_seq");
    super.new(name);
  endfunction
  
  task write();
    AXI_sequence_item item;
    item = AXI_sequence_item :: type_id :: create();
    
    start_item(item);
    item.aresetn = 1'b1;
    item.randomize() with {wr_req == 1'b1 ; wr_id == 4'd1; wr_addr == 32'd100; wr_len == 8'd0; wr_size == 3'd2; wr_burst == 2'b00; wr_cache == 4'b0000; wr_lock == 1'b0; wr_prot == 3'b000; rd_req == 1'b0 ; rd_id == 4'd0; rd_addr == 32'd0; rd_len == 8'd0; rd_size == 3'd0; rd_burst == 2'b00; rd_cache == 4'b0000; rd_lock == 1'b0; rd_prot == 3'b0;};
    finish_item(item);
    
     start_item(item);
    item.aresetn = 1'b1;
    item.randomize() with {wr_req == 1'b1 ; wr_id == 4'd2; wr_addr == 32'd200; wr_len == 8'd3; wr_size == 3'd2; wr_burst == 2'b01; wr_cache == 4'b0000; wr_lock == 1'b0; wr_prot == 3'b000; rd_req == 1'b0 ; rd_id == 4'd0; rd_addr == 32'd0; rd_len == 8'd0; rd_size == 3'd0; rd_burst == 2'b00; rd_cache == 4'b0000; rd_lock == 1'b0; rd_prot == 3'b0;};
    finish_item(item);
    
     start_item(item);
    item.aresetn = 1'b1;
    item.randomize() with {wr_req == 1'b1 ; wr_id == 4'd3; wr_addr == 32'd300; wr_len == 8'd3; wr_size == 3'd2; wr_burst == 2'b10; wr_cache == 4'b0000; wr_lock == 1'b0; wr_prot == 3'b000; rd_req == 1'b0 ; rd_id == 4'd0; rd_addr == 32'd0; rd_len == 8'd0; rd_size == 3'd0; rd_burst == 2'b00; rd_cache == 4'b0000; rd_lock == 1'b0; rd_prot == 3'b0;};
    finish_item(item);
  endtask
  
  task read();
    AXI_sequence_item item;
    item = AXI_sequence_item :: type_id :: create();
    
    start_item(item);
    item.aresetn = 1'b1;
    item.randomize() with {wr_req == 1'b0 ; wr_id == 4'd0; wr_addr == 32'd0; wr_len == 8'd0; wr_size == 3'd0; wr_burst == 2'b00; wr_cache == 4'b0000; wr_lock == 1'b0; wr_prot == 3'b000; rd_req == 1'b1 ; rd_id == 4'd1; rd_addr == 32'd100; rd_len == 8'd0; rd_size == 3'd2; rd_burst == 2'b00; rd_cache == 4'b0000; rd_lock == 1'b0; rd_prot == 3'b0;};
    finish_item(item);
    
     start_item(item);
    item.aresetn = 1'b1;
   item.randomize() with {wr_req == 1'b0 ; wr_id == 4'd0; wr_addr == 32'd0; wr_len == 8'd0; wr_size == 3'd0; wr_burst == 2'b00; wr_cache == 4'b0000; wr_lock == 1'b0; wr_prot == 3'b000; rd_req == 1'b1 ; rd_id == 4'd2; rd_addr == 32'd200; rd_len == 8'd3; rd_size == 3'd2; rd_burst == 2'b01; rd_cache == 4'b0000; rd_lock == 1'b0; rd_prot == 3'b0;};
    finish_item(item);
    
     start_item(item);
    item.aresetn = 1'b1;
    item.randomize() with {wr_req == 1'b0 ; wr_id == 4'd0; wr_addr == 32'd0; wr_len == 8'd0; wr_size == 3'd0; wr_burst == 2'b00; wr_cache == 4'b0000; wr_lock == 1'b0; wr_prot == 3'b000; rd_req == 1'b1 ; rd_id == 4'd3; rd_addr == 32'd300; rd_len == 8'd3; rd_size == 3'd2; rd_burst == 2'b10; rd_cache == 4'b0000; rd_lock == 1'b0; rd_prot == 3'b0;};
    finish_item(item);
  endtask
  
  task body();
    reset();
    write();
    read();
  endtask
endclass

// bufferable write and read transfers [tc 31 & 32]

class buf_read_write_seq extends AXI_sequence;
  `uvm_object_utils(buf_read_write_seq)
  
  function new(string name = "buf_read_write_seq");
    super.new(name);
  endfunction
  
  task write_fixed();
    AXI_sequence_item item;
    item = AXI_sequence_item :: type_id :: create("item");
    
    start_item(item);
    item.aresetn = 1'b1;
    item.randomize() with {wr_req == 1'b1 ; wr_id == 4'd1; wr_addr == 32'd740; wr_len == 8'd0; wr_size == 3'd2; wr_burst == 2'b00; wr_cache == 4'b0001; wr_lock == 1'b0; wr_prot == 3'b000; rd_req == 1'b0 ; rd_id == 4'd0; rd_addr == 32'd0; rd_len == 8'd0; rd_size == 3'd0; rd_burst == 2'b00; rd_cache == 4'b0000; rd_lock == 1'b0; rd_prot == 3'b0;};
    finish_item(item);
  endtask
  
  task write_incr();
    AXI_sequence_item item;
    item = AXI_sequence_item :: type_id :: create("item");
    
    start_item(item);
    item.aresetn = 1'b1;
    item.randomize() with {wr_req == 1'b1 ; wr_id == 4'd2; wr_addr == 32'd700; wr_len == 8'd3; wr_size == 3'd2; wr_burst == 2'b01; wr_cache == 4'b0001; wr_lock == 1'b0; wr_prot == 3'b000; rd_req == 1'b0 ; rd_id == 4'd0; rd_addr == 32'd0; rd_len == 8'd0; rd_size == 3'd0; rd_burst == 2'b00; rd_cache == 4'b0000; rd_lock == 1'b0; rd_prot == 3'b0;};
    finish_item(item);
  endtask
  
  task write_wrap();
    AXI_sequence_item item;
    item = AXI_sequence_item :: type_id :: create("item");
    
    start_item(item);
    item.aresetn = 1'b1;
    item.randomize() with {wr_req == 1'b1 ; wr_id == 4'd3; wr_addr == 32'd200; wr_len == 8'd3; wr_size == 3'd2; wr_burst == 2'b10; wr_cache == 4'b0001; wr_lock == 1'b0; wr_prot == 3'b000; rd_req == 1'b0 ; rd_id == 4'd0; rd_addr == 32'd0; rd_len == 8'd0; rd_size == 3'd0; rd_burst == 2'b00; rd_cache == 4'b0000; rd_lock == 1'b0; rd_prot == 3'b0;};
    finish_item(item);
  endtask
  
  task read_fixed();
    AXI_sequence_item item;
    item = AXI_sequence_item :: type_id :: create("item");
    
    start_item(item);
    item.aresetn = 1'b1;
    item.randomize() with {wr_req == 1'b0 ; wr_id == 4'd0; wr_addr == 32'd0; wr_len == 8'd0; wr_size == 3'd0; wr_burst == 2'b00; wr_cache == 4'b0000; wr_lock == 1'b0; wr_prot == 3'b000; rd_req == 1'b1 ; rd_id == 4'd1; rd_addr == 32'd740; rd_len == 8'd0; rd_size == 3'd2; rd_burst == 2'b00; rd_cache == 4'b0001; rd_lock == 1'b0; rd_prot == 3'b0;};
    finish_item(item);
  endtask
  
  task read_incr();
    AXI_sequence_item item;
    item = AXI_sequence_item :: type_id :: create();
    
    start_item(item);
    item.aresetn = 1'b1;
    item.randomize() with {wr_req == 1'b0 ; wr_id == 4'd0; wr_addr == 32'd0; wr_len == 8'd0; wr_size == 3'd0; wr_burst == 2'b00; wr_cache == 4'b0000; wr_lock == 1'b0; wr_prot == 3'b000; rd_req == 1'b1 ; rd_id == 4'd2; rd_addr == 32'd700; rd_len == 8'd3; rd_size == 3'd2; rd_burst == 2'b01; rd_cache == 4'b0001; rd_lock == 1'b0; rd_prot == 3'b0;};
    finish_item(item);
  endtask
  
   task read_wrap();
    AXI_sequence_item item;
     item = AXI_sequence_item :: type_id :: create("item");
    
    start_item(item);
    item.aresetn = 1'b1;
    item.randomize() with {wr_req == 1'b0 ; wr_id == 4'd0; wr_addr == 32'd0; wr_len == 8'd0; wr_size == 3'd0; wr_burst == 2'b00; wr_cache == 4'b0000; wr_lock == 1'b0; wr_prot == 3'b000; rd_req == 1'b1 ; rd_id == 4'd3; rd_addr == 32'd200; rd_len == 8'd3; rd_size == 3'd2; rd_burst == 2'b10; rd_cache == 4'b0001; rd_lock == 1'b0; rd_prot == 3'b0;};
    finish_item(item);
  endtask 
  
  task body();
    reset();
    write_fixed();
    read_fixed();
    write_incr();
    read_incr();
    write_wrap();
    read_wrap();
  endtask
endclass

// non-bufferable,non-cacheable and modifiable write and read transfer

class modifiable_read_write_seq extends AXI_sequence;
  `uvm_object_utils(modifiable_read_write_seq)
  
  function new(string name = "modifiable_read_write_seq");
    super.new(name);
  endfunction
  
  task write();
    AXI_sequence_item item;
    item = AXI_sequence_item :: type_id :: create("item");
    
    start_item(item);
    item.aresetn = 1'b1;
    item.randomize() with {wr_req == 1'b1 ; wr_id == 4'd1; wr_addr == 32'd100; wr_len == 8'd7; wr_size == 3'd2; wr_burst == 2'b01; wr_cache == 4'b0010; wr_lock == 1'b0; wr_prot == 3'b000; rd_req == 1'b0 ; rd_id == 4'd0; rd_addr == 32'd0; rd_len == 8'd0; rd_size == 3'd0; rd_burst == 2'b00; rd_cache == 4'b0000; rd_lock == 1'b0; rd_prot == 3'b0;};
    finish_item(item);
  endtask
  
  task read();
    AXI_sequence_item item;
    item = AXI_sequence_item :: type_id :: create("item");
    
    start_item(item);
    item.aresetn = 1'b1;
    item.randomize() with {wr_req == 1'b0 ; wr_id == 4'd0; wr_addr == 32'd0; wr_len == 8'd0; wr_size == 3'd0; wr_burst == 2'b00; wr_cache == 4'b0000; wr_lock == 1'b0; wr_prot == 3'b000; rd_req == 1'b1 ; rd_id == 4'd1; rd_addr == 32'd100; rd_len == 8'd3; rd_size == 3'd2; rd_burst == 2'b01; rd_cache == 4'b0010; rd_lock == 1'b0; rd_prot == 3'b0;};
    finish_item(item);
  endtask
  
  task body();
    reset();
    write();
    read();
  endtask
endclass


// write back allocate in chache [tc 39]

class write_back_allocate_seq extends AXI_sequence;
  `uvm_object_utils(write_back_allocate_seq)
  
  function new(string name = "write_back_allocate_seq");
    super.new(name);
  endfunction
  
  task write_cache();
    AXI_sequence_item item;
    item = AXI_sequence_item :: type_id :: create("item");
    
    start_item(item);
    item.aresetn  = 1'b1;
    item.randomize() with {wr_req == 1'b1 ; wr_id == 4'd1; wr_addr == 32'd1364; wr_len == 8'd0; wr_size == 3'd2; wr_burst == 2'b00; wr_cache == 4'b1100; wr_lock == 1'b0; wr_prot == 3'b000; rd_req == 1'b0 ; rd_id == 4'd0; rd_addr == 32'd0; rd_len == 8'd0; rd_size == 3'd0; rd_burst == 2'b00; rd_cache == 4'b0000; rd_lock == 1'b0; rd_prot == 3'b0;};
    finish_item(item);
    
    start_item(item);
    item.aresetn  = 1'b1;
    item.randomize() with {wr_req == 1'b1 ; wr_id == 4'd2; wr_addr == 32'd2040; wr_len == 8'd3; wr_size == 3'd2; wr_burst == 2'b01; wr_cache == 4'b1100; wr_lock == 1'b0; wr_prot == 3'b000; rd_req == 1'b0 ; rd_id == 4'd0; rd_addr == 32'd0; rd_len == 8'd0; rd_size == 3'd0; rd_burst == 2'b00; rd_cache == 4'b0000; rd_lock == 1'b0; rd_prot == 3'b0;};
    finish_item(item);
    
    start_item(item);
    item.aresetn  = 1'b1;
    item.randomize() with {wr_req == 1'b1 ; wr_id == 4'd3; wr_addr == 32'd4000; wr_len == 8'd3; wr_size == 3'd2; wr_burst == 2'b01; wr_cache == 4'b1100; wr_lock == 1'b0; wr_prot == 3'b000; rd_req == 1'b0 ; rd_id == 4'd0; rd_addr == 32'd0; rd_len == 8'd0; rd_size == 3'd0; rd_burst == 2'b00; rd_cache == 4'b0000; rd_lock == 1'b0; rd_prot == 3'b0;};
    finish_item(item);
  endtask
  
  task read_cache();
    AXI_sequence_item item;
    item = AXI_sequence_item :: type_id :: create("item");
    start_item(item);
    item.aresetn  = 1'b1;
    item.randomize() with {wr_req == 1'b0 ; wr_id == 4'd0; wr_addr == 32'd0; wr_len == 8'd0; wr_size == 3'd0; wr_burst == 2'b00; wr_cache == 4'b0000; wr_lock == 1'b0; wr_prot == 3'b000; rd_req == 1'b1 ; rd_id == 4'd1; rd_addr == 32'd1364; rd_len == 8'd0; rd_size == 3'd2; rd_burst == 2'b00; rd_cache == 4'b1000; rd_lock == 1'b0; rd_prot == 3'b0;};
    finish_item(item);
    
    start_item(item);
    item.aresetn  = 1'b1;
    item.randomize() with {wr_req == 1'b0 ; wr_id == 4'd0; wr_addr == 32'd0; wr_len == 8'd0; wr_size == 3'd0; wr_burst == 2'b00; wr_cache == 4'b0000; wr_lock == 1'b0; wr_prot == 3'b000; rd_req == 1'b1 ; rd_id == 4'd2; rd_addr == 32'd2040; rd_len == 8'd3; rd_size == 3'd2; rd_burst == 2'b01; rd_cache == 4'b1000; rd_lock == 1'b0; rd_prot == 3'b0;};
    finish_item(item);
    
    start_item(item);
    item.aresetn  = 1'b1;
    item.randomize() with {wr_req == 1'b0 ; wr_id == 4'd0; wr_addr == 32'd0; wr_len == 8'd0; wr_size == 3'd0; wr_burst == 2'b00; wr_cache == 4'b0000; wr_lock == 1'b0; wr_prot == 3'b000; rd_req == 1'b1 ; rd_id == 4'd3; rd_addr == 32'd4000; rd_len == 8'd3; rd_size == 3'd2; rd_burst == 2'b10; rd_cache == 4'b1000; rd_lock == 1'b0; rd_prot == 3'b0;};
    finish_item(item);
  endtask
  
  task read();
    AXI_sequence_item item;
    item = AXI_sequence_item :: type_id :: create("item");
    
    start_item(item);
    item.aresetn  = 1'b1;
    item.randomize() with {wr_req == 1'b0 ; wr_id == 4'd0; wr_addr == 32'd0; wr_len == 8'd0; wr_size == 3'd0; wr_burst == 2'b00; wr_cache == 4'b0000; wr_lock == 1'b0; wr_prot == 3'b000; rd_req == 1'b1 ; rd_id == 4'd1; rd_addr == 32'd1364; rd_len == 8'd0; rd_size == 3'd2; rd_burst == 2'b00; rd_cache == 4'b0000; rd_lock == 1'b0; rd_prot == 3'b0;};
    finish_item(item);
    
    start_item(item);
    item.aresetn  = 1'b1;
    item.randomize() with {wr_req == 1'b0 ; wr_id == 4'd0; wr_addr == 32'd0; wr_len == 8'd0; wr_size == 3'd0; wr_burst == 2'b00; wr_cache == 4'b0000; wr_lock == 1'b0; wr_prot == 3'b000; rd_req == 1'b1 ; rd_id == 4'd2; rd_addr == 32'd2040; rd_len == 8'd3; rd_size == 3'd2; rd_burst == 2'b01; rd_cache == 4'b0000; rd_lock == 1'b0; rd_prot == 3'b0;};
    finish_item(item);
    
    start_item(item);
    item.aresetn  = 1'b1;
    item.randomize() with {wr_req == 1'b0 ; wr_id == 4'd0; wr_addr == 32'd0; wr_len == 8'd0; wr_size == 3'd0; wr_burst == 2'b00; wr_cache == 4'b0000; wr_lock == 1'b0; wr_prot == 3'b000; rd_req == 1'b1 ; rd_id == 4'd3; rd_addr == 32'd4000; rd_len == 8'd3; rd_size == 3'd2; rd_burst == 2'b10; rd_cache == 4'b0000; rd_lock == 1'b0; rd_prot == 3'b0;};
    finish_item(item);
  endtask
  
  task body();
    reset();
    write_cache();
    read();
    write_cache();
    read_cache();
  endtask
endclass

// read back and allocate in cachable transfer [tc 40]

class read_back_allocate_seq extends AXI_sequence;
  `uvm_object_utils(read_back_allocate_seq)
  
  function new(string name = "read_back_allocate_seq");
    super.new(name);
  endfunction
  
  task write();
    AXI_sequence_item item;
    item = AXI_sequence_item :: type_id :: create("item");
    
    start_item(item);
    item.aresetn  = 1'b1;
    item.randomize() with {wr_req == 1'b1 ; wr_id == 4'd1; wr_addr == 32'd1364; wr_len == 8'd0; wr_size == 3'd2; wr_burst == 2'b00; wr_cache == 4'b0000; wr_lock == 1'b0; wr_prot == 3'b000; rd_req == 1'b0 ; rd_id == 4'd0; rd_addr == 32'd0; rd_len == 8'd0; rd_size == 3'd0; rd_burst == 2'b00; rd_cache == 4'b0000; rd_lock == 1'b0; rd_prot == 3'b0;};
    finish_item(item);
    
    start_item(item);
    item.aresetn  = 1'b1;
    item.randomize() with {wr_req == 1'b1 ; wr_id == 4'd2; wr_addr == 32'd2040; wr_len == 8'd3; wr_size == 3'd2; wr_burst == 2'b01; wr_cache == 4'b0000; wr_lock == 1'b0; wr_prot == 3'b000; rd_req == 1'b0 ; rd_id == 4'd0; rd_addr == 32'd0; rd_len == 8'd0; rd_size == 3'd0; rd_burst == 2'b00; rd_cache == 4'b0000; rd_lock == 1'b0; rd_prot == 3'b0;};
    finish_item(item);
    
    start_item(item);
    item.aresetn  = 1'b1;
    item.randomize() with {wr_req == 1'b1 ; wr_id == 4'd3; wr_addr == 32'd4000; wr_len == 8'd3; wr_size == 3'd2; wr_burst == 2'b01; wr_cache == 4'b0000; wr_lock == 1'b0; wr_prot == 3'b000; rd_req == 1'b0 ; rd_id == 4'd0; rd_addr == 32'd0; rd_len == 8'd0; rd_size == 3'd0; rd_burst == 2'b00; rd_cache == 4'b0000; rd_lock == 1'b0; rd_prot == 3'b0;};
    finish_item(item);
  endtask
  
  task write_cache();
    AXI_sequence_item item;
    item = AXI_sequence_item :: type_id :: create("item");
    
    start_item(item);
    item.aresetn  = 1'b1;
    item.randomize() with {wr_req == 1'b1 ; wr_id == 4'd1; wr_addr == 32'd1364; wr_len == 8'd0; wr_size == 3'd2; wr_burst == 2'b00; wr_cache == 4'b1100; wr_lock == 1'b0; wr_prot == 3'b000; rd_req == 1'b0 ; rd_id == 4'd0; rd_addr == 32'd0; rd_len == 8'd0; rd_size == 3'd0; rd_burst == 2'b00; rd_cache == 4'b0000; rd_lock == 1'b0; rd_prot == 3'b0;};
    finish_item(item);
    
    start_item(item);
    item.aresetn  = 1'b1;
    item.randomize() with {wr_req == 1'b1 ; wr_id == 4'd2; wr_addr == 32'd2040; wr_len == 8'd3; wr_size == 3'd2; wr_burst == 2'b01; wr_cache == 4'b1100; wr_lock == 1'b0; wr_prot == 3'b000; rd_req == 1'b0 ; rd_id == 4'd0; rd_addr == 32'd0; rd_len == 8'd0; rd_size == 3'd0; rd_burst == 2'b00; rd_cache == 4'b0000; rd_lock == 1'b0; rd_prot == 3'b0;};
    finish_item(item);
    
    start_item(item);
    item.aresetn  = 1'b1;
    item.randomize() with {wr_req == 1'b1 ; wr_id == 4'd3; wr_addr == 32'd4000; wr_len == 8'd3; wr_size == 3'd2; wr_burst == 2'b01; wr_cache == 4'b1100; wr_lock == 1'b0; wr_prot == 3'b000; rd_req == 1'b0 ; rd_id == 4'd0; rd_addr == 32'd0; rd_len == 8'd0; rd_size == 3'd0; rd_burst == 2'b00; rd_cache == 4'b0000; rd_lock == 1'b0; rd_prot == 3'b0;};
    finish_item(item);
  endtask
  
  
  task read_cache();
    AXI_sequence_item item;
    item = AXI_sequence_item :: type_id :: create("item");
    
    start_item(item);
    item.aresetn  = 1'b1;
    item.randomize() with {wr_req == 1'b0 ; wr_id == 4'd0; wr_addr == 32'd0; wr_len == 8'd0; wr_size == 3'd0; wr_burst == 2'b00; wr_cache == 4'b0000; wr_lock == 1'b0; wr_prot == 3'b000; rd_req == 1'b1 ; rd_id == 4'd1; rd_addr == 32'd1364; rd_len == 8'd0; rd_size == 3'd2; rd_burst == 2'b00; rd_cache == 4'b1100; rd_lock == 1'b0; rd_prot == 3'b0;};
    finish_item(item);
    
    start_item(item);
    item.aresetn  = 1'b1;
    item.randomize() with {wr_req == 1'b0 ; wr_id == 4'd0; wr_addr == 32'd0; wr_len == 8'd0; wr_size == 3'd0; wr_burst == 2'b00; wr_cache == 4'b0000; wr_lock == 1'b0; wr_prot == 3'b000; rd_req == 1'b1 ; rd_id == 4'd2; rd_addr == 32'd2040; rd_len == 8'd3; rd_size == 3'd2; rd_burst == 2'b01; rd_cache == 4'b1100; rd_lock == 1'b0; rd_prot == 3'b0;};
    finish_item(item);
    
    start_item(item);
    item.aresetn  = 1'b1;
    item.randomize() with {wr_req == 1'b0 ; wr_id == 4'd0; wr_addr == 32'd0; wr_len == 8'd0; wr_size == 3'd0; wr_burst == 2'b00; wr_cache == 4'b0000; wr_lock == 1'b0; wr_prot == 3'b000; rd_req == 1'b1 ; rd_id == 4'd3; rd_addr == 32'd4000; rd_len == 8'd3; rd_size == 3'd2; rd_burst == 2'b10; rd_cache == 4'b1100; rd_lock == 1'b0; rd_prot == 3'b0;};
    finish_item(item);
  endtask
  
  task body();
    reset();
    write();
    read_cache();
    write_cache();
    read_cache();
  endtask
endclass

// write back and no allocate for the cacheable transfer [tc 37]

class write_back_noallocate_seq extends AXI_sequence;
  `uvm_object_utils(write_back_noallocate_seq)
  
  function new(string name = "write_back_noallocate_seq");
    super.new(name);
  endfunction
  
  task write_cache();
    AXI_sequence_item item;
    item = AXI_sequence_item :: type_id :: create("item");
    
    start_item(item);
    item.aresetn  = 1'b1;
    item.randomize() with {wr_req == 1'b1 ; wr_id == 4'd1; wr_addr == 32'd1364; wr_len == 8'd0; wr_size == 3'd2; wr_burst == 2'b00; wr_cache == 4'b0100; wr_lock == 1'b0; wr_prot == 3'b000; rd_req == 1'b0 ; rd_id == 4'd0; rd_addr == 32'd0; rd_len == 8'd0; rd_size == 3'd0; rd_burst == 2'b00; rd_cache == 4'b0000; rd_lock == 1'b0; rd_prot == 3'b0;};
    finish_item(item);
    
    start_item(item);
    item.aresetn  = 1'b1;
    item.randomize() with {wr_req == 1'b1 ; wr_id == 4'd2; wr_addr == 32'd2050; wr_len == 8'd3; wr_size == 3'd2; wr_burst == 2'b01; wr_cache == 4'b0100; wr_lock == 1'b0; wr_prot == 3'b000; rd_req == 1'b0 ; rd_id == 4'd0; rd_addr == 32'd0; rd_len == 8'd0; rd_size == 3'd0; rd_burst == 2'b00; rd_cache == 4'b0000; rd_lock == 1'b0; rd_prot == 3'b0;};
    finish_item(item);
    
    
    start_item(item);
    item.aresetn  = 1'b1;
    item.randomize() with {wr_req == 1'b1 ; wr_id == 4'd3; wr_addr == 32'd3060; wr_len == 8'd3; wr_size == 3'd2; wr_burst == 2'b10; wr_cache == 4'b0100; wr_lock == 1'b0; wr_prot == 3'b000; rd_req == 1'b0 ; rd_id == 4'd0; rd_addr == 32'd0; rd_len == 8'd0; rd_size == 3'd0; rd_burst == 2'b00; rd_cache == 4'b0000; rd_lock == 1'b0; rd_prot == 3'b0;};
    finish_item(item);
  endtask
    
  task read();
    AXI_sequence_item item;
    item = AXI_sequence_item :: type_id :: create("item");
    
    start_item(item);
    item.aresetn  = 1'b1;
    item.randomize() with {wr_req == 1'b0 ; wr_id == 4'd0; wr_addr == 32'd0; wr_len == 8'd0; wr_size == 3'd0; wr_burst == 2'b00; wr_cache == 4'b0000; wr_lock == 1'b0; wr_prot == 3'b000; rd_req == 1'b1 ; rd_id == 4'd1; rd_addr == 32'd1364; rd_len == 8'd0; rd_size == 3'd2; rd_burst == 2'b00; rd_cache == 4'b0000; rd_lock == 1'b0; rd_prot == 3'b0;};
    finish_item(item);
    
    start_item(item);
    item.aresetn  = 1'b1;
    item.randomize() with {wr_req == 1'b0 ; wr_id == 4'd0; wr_addr == 32'd0; wr_len == 8'd0; wr_size == 3'd0; wr_burst == 2'b00; wr_cache == 4'b0000; wr_lock == 1'b0; wr_prot == 3'b000; rd_req == 1'b1 ; rd_id == 4'd2; rd_addr == 32'd2050; rd_len == 8'd3; rd_size == 3'd2; rd_burst == 2'b01; rd_cache == 4'b0000; rd_lock == 1'b0; rd_prot == 3'b0;};
    finish_item(item);
    
    start_item(item);
    item.aresetn  = 1'b1;
    item.randomize() with {wr_req == 1'b0 ; wr_id == 4'd0; wr_addr == 32'd0; wr_len == 8'd0; wr_size == 3'd0; wr_burst == 2'b00; wr_cache == 4'b0000; wr_lock == 1'b0; wr_prot == 3'b000; rd_req == 1'b1 ; rd_id == 4'd3; rd_addr == 32'd3060; rd_len == 8'd3; rd_size == 3'd2; rd_burst == 2'b10; rd_cache == 4'b000; rd_lock == 1'b0; rd_prot == 3'b0;};
    finish_item(item);
  endtask
  
    task read_cache();
    AXI_sequence_item item;
    item = AXI_sequence_item :: type_id :: create("item");
    
    start_item(item);
    item.aresetn  = 1'b1;
    item.randomize() with {wr_req == 1'b0 ; wr_id == 4'd0; wr_addr == 32'd0; wr_len == 8'd0; wr_size == 3'd0; wr_burst == 2'b00; wr_cache == 4'b0000; wr_lock == 1'b0; wr_prot == 3'b000; rd_req == 1'b1 ; rd_id == 4'd1; rd_addr == 32'd1364; rd_len == 8'd0; rd_size == 3'd2; rd_burst == 2'b00; rd_cache == 4'b1100; rd_lock == 1'b0; rd_prot == 3'b0;};
    finish_item(item);
    
    start_item(item);
    item.aresetn  = 1'b1;
    item.randomize() with {wr_req == 1'b0 ; wr_id == 4'd0; wr_addr == 32'd0; wr_len == 8'd0; wr_size == 3'd0; wr_burst == 2'b00; wr_cache == 4'b0000; wr_lock == 1'b0; wr_prot == 3'b000; rd_req == 1'b1 ; rd_id == 4'd2; rd_addr == 32'd2050; rd_len == 8'd3; rd_size == 3'd2; rd_burst == 2'b01; rd_cache == 4'b1100; rd_lock == 1'b0; rd_prot == 3'b0;};
    finish_item(item);
    
    start_item(item);
    item.aresetn  = 1'b1;
    item.randomize() with {wr_req == 1'b0 ; wr_id == 4'd0; wr_addr == 32'd0; wr_len == 8'd0; wr_size == 3'd0; wr_burst == 2'b00; wr_cache == 4'b0000; wr_lock == 1'b0; wr_prot == 3'b000; rd_req == 1'b1 ; rd_id == 4'd3; rd_addr == 32'd3060; rd_len == 8'd3; rd_size == 3'd2; rd_burst == 2'b10; rd_cache == 4'b1100; rd_lock == 1'b0; rd_prot == 3'b0;};
    finish_item(item);
    endtask
  
  task body();
    reset();
    write_cache();
    read_cache();
    write_cache();
    read_cache();
  endtask
endclass

// read back and no allocate for the cacheable transfer [tc 38]

class read_back_noallocate_seq extends AXI_sequence;
  `uvm_object_utils(read_back_noallocate_seq)
  
  function new(string name = "read_back_noallocate_seq");
    super.new(name);
  endfunction
  
    task write();
    AXI_sequence_item item;
    item = AXI_sequence_item :: type_id :: create("item");
    
    start_item(item);
    item.aresetn  = 1'b1;
    item.randomize() with {wr_req == 1'b1 ; wr_id == 4'd1; wr_addr == 32'd1364; wr_len == 8'd0; wr_size == 3'd2; wr_burst == 2'b00; wr_cache == 4'b0000; wr_lock == 1'b0; wr_prot == 3'b000; rd_req == 1'b0 ; rd_id == 4'd0; rd_addr == 32'd0; rd_len == 8'd0; rd_size == 3'd0; rd_burst == 2'b00; rd_cache == 4'b0000; rd_lock == 1'b0; rd_prot == 3'b0;};
    finish_item(item);
    
    start_item(item);
    item.aresetn  = 1'b1;
    item.randomize() with {wr_req == 1'b1 ; wr_id == 4'd2; wr_addr == 32'd2050; wr_len == 8'd3; wr_size == 3'd2; wr_burst == 2'b01; wr_cache == 4'b0000; wr_lock == 1'b0; wr_prot == 3'b000; rd_req == 1'b0 ; rd_id == 4'd0; rd_addr == 32'd0; rd_len == 8'd0; rd_size == 3'd0; rd_burst == 2'b00; rd_cache == 4'b0000; rd_lock == 1'b0; rd_prot == 3'b0;};
    finish_item(item);
    
    
    start_item(item);
    item.aresetn  = 1'b1;
    item.randomize() with {wr_req == 1'b1 ; wr_id == 4'd3; wr_addr == 32'd3060; wr_len == 8'd3; wr_size == 3'd2; wr_burst == 2'b10; wr_cache == 4'b0000; wr_lock == 1'b0; wr_prot == 3'b000; rd_req == 1'b0 ; rd_id == 4'd0; rd_addr == 32'd0; rd_len == 8'd0; rd_size == 3'd0; rd_burst == 2'b00; rd_cache == 4'b0000; rd_lock == 1'b0; rd_prot == 3'b0;};
    finish_item(item);
  endtask
    
  task write_cache();
    AXI_sequence_item item;
    item = AXI_sequence_item :: type_id :: create("item");
    
    start_item(item);
    item.aresetn  = 1'b1;
    item.randomize() with {wr_req == 1'b1 ; wr_id == 4'd1; wr_addr == 32'd1364; wr_len == 8'd0; wr_size == 3'd2; wr_burst == 2'b00; wr_cache == 4'b1100; wr_lock == 1'b0; wr_prot == 3'b000; rd_req == 1'b0 ; rd_id == 4'd0; rd_addr == 32'd0; rd_len == 8'd0; rd_size == 3'd0; rd_burst == 2'b00; rd_cache == 4'b0000; rd_lock == 1'b0; rd_prot == 3'b0;};
    finish_item(item);
    
    start_item(item);
    item.aresetn  = 1'b1;
    item.randomize() with {wr_req == 1'b1 ; wr_id == 4'd2; wr_addr == 32'd2050; wr_len == 8'd3; wr_size == 3'd2; wr_burst == 2'b01; wr_cache == 4'b1100; wr_lock == 1'b0; wr_prot == 3'b000; rd_req == 1'b0 ; rd_id == 4'd0; rd_addr == 32'd0; rd_len == 8'd0; rd_size == 3'd0; rd_burst == 2'b00; rd_cache == 4'b0000; rd_lock == 1'b0; rd_prot == 3'b0;};
    finish_item(item);
    
    
    start_item(item);
    item.aresetn  = 1'b1;
    item.randomize() with {wr_req == 1'b1 ; wr_id == 4'd3; wr_addr == 32'd3060; wr_len == 8'd3; wr_size == 3'd2; wr_burst == 2'b10; wr_cache == 4'b1100; wr_lock == 1'b0; wr_prot == 3'b000; rd_req == 1'b0 ; rd_id == 4'd0; rd_addr == 32'd0; rd_len == 8'd0; rd_size == 3'd0; rd_burst == 2'b00; rd_cache == 4'b0000; rd_lock == 1'b0; rd_prot == 3'b0;};
    finish_item(item);
  endtask
  
  task read_cache();
    AXI_sequence_item item;
    item = AXI_sequence_item :: type_id :: create("item");
    
    start_item(item);
    item.aresetn  = 1'b1;
    item.randomize() with {wr_req == 1'b0 ; wr_id == 4'd0; wr_addr == 32'd0; wr_len == 8'd0; wr_size == 3'd0; wr_burst == 2'b00; wr_cache == 4'b0000; wr_lock == 1'b0; wr_prot == 3'b000; rd_req == 1'b1 ; rd_id == 4'd1; rd_addr == 32'd1364; rd_len == 8'd0; rd_size == 3'd2; rd_burst == 2'b00; rd_cache == 4'b1000; rd_lock == 1'b0; rd_prot == 3'b0;};
    finish_item(item);
    
    start_item(item);
    item.aresetn  = 1'b1;
    item.randomize() with {wr_req == 1'b0 ; wr_id == 4'd0; wr_addr == 32'd0; wr_len == 8'd0; wr_size == 3'd0; wr_burst == 2'b00; wr_cache == 4'b0000; wr_lock == 1'b0; wr_prot == 3'b000; rd_req == 1'b1 ; rd_id == 4'd2; rd_addr == 32'd2050; rd_len == 8'd3; rd_size == 3'd2; rd_burst == 2'b01; rd_cache == 4'b1000; rd_lock == 1'b0; rd_prot == 3'b0;};
    finish_item(item);
    
    start_item(item);
    item.aresetn  = 1'b1;
    item.randomize() with {wr_req == 1'b0 ; wr_id == 4'd0; wr_addr == 32'd0; wr_len == 8'd0; wr_size == 3'd0; wr_burst == 2'b00; wr_cache == 4'b0000; wr_lock == 1'b0; wr_prot == 3'b000; rd_req == 1'b1 ; rd_id == 4'd3; rd_addr == 32'd3060; rd_len == 8'd3; rd_size == 3'd2; rd_burst == 2'b10; rd_cache == 4'b1000; rd_lock == 1'b0; rd_prot == 3'b0;};
    finish_item(item);
  endtask
  
  task body();
    reset();
    write();
    read_cache();
    write_cache();
    read_cache();
  endtask
endclass

// write back and read allocate for the cacheable transfer [tc 35]

class write_back_read_allocate_seq extends AXI_sequence;
  `uvm_object_utils(write_back_read_allocate_seq)
  
  function new(string name = "write_back_read_allocate_seq");
    super.new(name);
  endfunction
  
  task write_cache();
    AXI_sequence_item item;
    item = AXI_sequence_item :: type_id :: create("item");
    
    start_item(item);
    item.aresetn  = 1'b1;
    item.randomize() with {wr_req == 1'b1 ; wr_id == 4'd1; wr_addr == 32'd1364; wr_len == 8'd0; wr_size == 3'd2; wr_burst == 2'b00; wr_cache == 4'b0100; wr_lock == 1'b0; wr_prot == 3'b000; rd_req == 1'b0 ; rd_id == 4'd0; rd_addr == 32'd0; rd_len == 8'd0; rd_size == 3'd0; rd_burst == 2'b00; rd_cache == 4'b0000; rd_lock == 1'b0; rd_prot == 3'b0;};
    finish_item(item);
    
    start_item(item);
    item.aresetn  = 1'b1;
    item.randomize() with {wr_req == 1'b1 ; wr_id == 4'd2; wr_addr == 32'd2050; wr_len == 8'd3; wr_size == 3'd2; wr_burst == 2'b01; wr_cache == 4'b0100; wr_lock == 1'b0; wr_prot == 3'b000; rd_req == 1'b0 ; rd_id == 4'd0; rd_addr == 32'd0; rd_len == 8'd0; rd_size == 3'd0; rd_burst == 2'b00; rd_cache == 4'b0000; rd_lock == 1'b0; rd_prot == 3'b0;};
    finish_item(item);
    
    
    start_item(item);
    item.aresetn  = 1'b1;
    item.randomize() with {wr_req == 1'b1 ; wr_id == 4'd3; wr_addr == 32'd3060; wr_len == 8'd3; wr_size == 3'd2; wr_burst == 2'b10; wr_cache == 4'b0100; wr_lock == 1'b0; wr_prot == 3'b000; rd_req == 1'b0 ; rd_id == 4'd0; rd_addr == 32'd0; rd_len == 8'd0; rd_size == 3'd0; rd_burst == 2'b00; rd_cache == 4'b0000; rd_lock == 1'b0; rd_prot == 3'b0;};
    finish_item(item);
  endtask
  
  task read_cache();
    AXI_sequence_item item;
    item = AXI_sequence_item :: type_id :: create("item");
    
    start_item(item);
    item.aresetn  = 1'b1;
    item.randomize() with {wr_req == 1'b0 ; wr_id == 4'd0; wr_addr == 32'd0; wr_len == 8'd0; wr_size == 3'd0; wr_burst == 2'b00; wr_cache == 4'b0000; wr_lock == 1'b0; wr_prot == 3'b000; rd_req == 1'b1 ; rd_id == 4'd1; rd_addr == 32'd1364; rd_len == 8'd0; rd_size == 3'd2; rd_burst == 2'b00; rd_cache == 4'b0100; rd_lock == 1'b0; rd_prot == 3'b0;};
    finish_item(item);
    
    start_item(item);
    item.aresetn  = 1'b1;
    item.randomize() with {wr_req == 1'b0 ; wr_id == 4'd0; wr_addr == 32'd0; wr_len == 8'd0; wr_size == 3'd0; wr_burst == 2'b00; wr_cache == 4'b0000; wr_lock == 1'b0; wr_prot == 3'b000; rd_req == 1'b1 ; rd_id == 4'd2; rd_addr == 32'd2050; rd_len == 8'd3; rd_size == 3'd2; rd_burst == 2'b01; rd_cache == 4'b0100; rd_lock == 1'b0; rd_prot == 3'b0;};
    finish_item(item);
    
    start_item(item);
    item.aresetn  = 1'b1;
    item.randomize() with {wr_req == 1'b0 ; wr_id == 4'd0; wr_addr == 32'd0; wr_len == 8'd0; wr_size == 3'd0; wr_burst == 2'b00; wr_cache == 4'b0000; wr_lock == 1'b0; wr_prot == 3'b000; rd_req == 1'b1 ; rd_id == 4'd3; rd_addr == 32'd3060; rd_len == 8'd3; rd_size == 3'd2; rd_burst == 2'b10; rd_cache == 4'b0100; rd_lock == 1'b0; rd_prot == 3'b0;};
    finish_item(item);
  endtask
  
  task read();
    AXI_sequence_item item;
    item = AXI_sequence_item :: type_id :: create("item");
    
    start_item(item);
    item.aresetn  = 1'b1;
    item.randomize() with {wr_req == 1'b0 ; wr_id == 4'd0; wr_addr == 32'd0; wr_len == 8'd0; wr_size == 3'd0; wr_burst == 2'b00; wr_cache == 4'b0000; wr_lock == 1'b0; wr_prot == 3'b000; rd_req == 1'b1 ; rd_id == 4'd1; rd_addr == 32'd1364; rd_len == 8'd0; rd_size == 3'd2; rd_burst == 2'b00; rd_cache == 4'b0000; rd_lock == 1'b0; rd_prot == 3'b0;};
    finish_item(item);
    
    start_item(item);
    item.aresetn  = 1'b1;
    item.randomize() with {wr_req == 1'b0 ; wr_id == 4'd0; wr_addr == 32'd0; wr_len == 8'd0; wr_size == 3'd0; wr_burst == 2'b00; wr_cache == 4'b0000; wr_lock == 1'b0; wr_prot == 3'b000; rd_req == 1'b1 ; rd_id == 4'd2; rd_addr == 32'd2050; rd_len == 8'd3; rd_size == 3'd2; rd_burst == 2'b01; rd_cache == 4'b0000; rd_lock == 1'b0; rd_prot == 3'b0;};
    finish_item(item);
    
    start_item(item);
    item.aresetn  = 1'b1;
    item.randomize() with {wr_req == 1'b0 ; wr_id == 4'd0; wr_addr == 32'd0; wr_len == 8'd0; wr_size == 3'd0; wr_burst == 2'b00; wr_cache == 4'b0000; wr_lock == 1'b0; wr_prot == 3'b000; rd_req == 1'b1 ; rd_id == 4'd3; rd_addr == 32'd3060; rd_len == 8'd3; rd_size == 3'd2; rd_burst == 2'b10; rd_cache == 4'b0000; rd_lock == 1'b0; rd_prot == 3'b0;};
    finish_item(item);
  endtask  
  
  task body();
    reset();
    write_cache();
    read();
    read_cache();
    write_cache();
    read_cache();
  endtask
endclass

// reset after read and write transfer [tc 43]

class reset_after_transfer_seq extends AXI_sequence;
  `uvm_object_utils(reset_after_transfer_seq)
  
  function new(string name = "reset_after_transfer_seq");
    super.new(name);
  endfunction
  
  task write();
    AXI_sequence_item item;
    
    item = AXI_sequence_item :: type_id :: create("seq");
    
    start_item(item);
    item.aresetn = 1'b1;
    item.randomize() with {wr_req == 1'b1 ; wr_id == 4'd2; wr_addr == 32'd2000; wr_len == 8'd3; wr_size == 3'd2; wr_burst == 2'b01; wr_cache == 4'b0000; wr_lock == 1'b1; wr_prot == 3'b000; rd_req == 1'b0 ; rd_id == 4'd0; rd_addr == 32'd0; rd_len == 8'd0; rd_size == 3'd0; rd_burst == 2'b00; rd_cache == 4'b0000; rd_lock == 1'b0; rd_prot == 3'b0;};
    finish_item(item);
    
    start_item(item);
    item.aresetn = 1'b1;
    item.randomize() with {wr_req == 1'b1 ; wr_id == 4'd3; wr_addr == 32'd4000; wr_len == 8'd3; wr_size == 3'd2; wr_burst == 2'b10; wr_cache == 4'b0000; wr_lock == 1'b1; wr_prot == 3'b000; rd_req == 1'b0 ; rd_id == 4'd0; rd_addr == 32'd0; rd_len == 8'd0; rd_size == 3'd0; rd_burst == 2'b00; rd_cache == 4'b0000; rd_lock == 1'b0; rd_prot == 3'b0;};
    finish_item(item);
  endtask
  
  task read();
     AXI_sequence_item item;
    item = AXI_sequence_item :: type_id :: create("item");
    
    start_item(item);
    item.aresetn  = 1'b1;
    item.randomize() with {wr_req == 1'b0 ; wr_id == 4'd0; wr_addr == 32'd0; wr_len == 8'd0; wr_size == 3'd0; wr_burst == 2'b00; wr_cache == 4'b0000; wr_lock == 1'b0; wr_prot == 3'b000; rd_req == 1'b1 ; rd_id == 4'd2; rd_addr == 32'd2000; rd_len == 8'd3; rd_size == 3'd2; rd_burst == 2'b01; rd_cache == 4'b0000; rd_lock == 1'b1; rd_prot == 3'b0;};
    finish_item(item);
    
    start_item(item);
    item.aresetn  = 1'b1;
    item.randomize() with {wr_req == 1'b0 ; wr_id == 4'd0; wr_addr == 32'd0; wr_len == 8'd0; wr_size == 3'd0; wr_burst == 2'b00; wr_cache == 4'b0000; wr_lock == 1'b0; wr_prot == 3'b000; rd_req == 1'b1 ; rd_id == 4'd3; rd_addr == 32'd4000; rd_len == 8'd3; rd_size == 3'd2; rd_burst == 2'b10; rd_cache == 4'b0000; rd_lock == 1'b1; rd_prot == 3'b0;};
    finish_item(item);
  endtask
  
  task body();
    reset();
    write();
    read();
    reset();
    read();
  endtask
endclass

// reset during read and write transfer [tc 43 & 49]

class reset_during_transfer_seq extends AXI_sequence;
  `uvm_object_utils(reset_during_transfer_seq)
  
  function new(string name = "reset_during_transfer_seq");
    super.new(name);
  endfunction
  
  task write();
    AXI_sequence_item item;
    
    item = AXI_sequence_item :: type_id :: create("seq");
    
    start_item(item);
    item.aresetn = 1'b1;
    item.randomize() with {wr_req == 1'b1 ; wr_id == 4'd2; wr_addr == 32'd2000; wr_len == 8'd3; wr_size == 3'd2; wr_burst == 2'b01; wr_cache == 4'b0000; wr_lock == 1'b1; wr_prot == 3'b000; rd_req == 1'b0 ; rd_id == 4'd0; rd_addr == 32'd0; rd_len == 8'd0; rd_size == 3'd0; rd_burst == 2'b00; rd_cache == 4'b0000; rd_lock == 1'b0; rd_prot == 3'b0;};
    finish_item(item);
    
    start_item(item);
    item.aresetn = 1'b0;
    item.randomize() with {wr_req == 1'b1 ; wr_id == 4'd3; wr_addr == 32'd4000; wr_len == 8'd3; wr_size == 3'd2; wr_burst == 2'b10; wr_cache == 4'b0000; wr_lock == 1'b0; wr_prot == 3'b000; rd_req == 1'b0 ; rd_id == 4'd0; rd_addr == 32'd0; rd_len == 8'd0; rd_size == 3'd0; rd_burst == 2'b00; rd_cache == 4'b0000; rd_lock == 1'b0; rd_prot == 3'b0;};
    finish_item(item);
  endtask
  
  task read();
     AXI_sequence_item item;
    item = AXI_sequence_item :: type_id :: create("item");
    
    start_item(item);
    item.aresetn  = 1'b1;
    item.randomize() with {wr_req == 1'b0 ; wr_id == 4'd0; wr_addr == 32'd0; wr_len == 8'd0; wr_size == 3'd0; wr_burst == 2'b00; wr_cache == 4'b0000; wr_lock == 1'b0; wr_prot == 3'b000; rd_req == 1'b1 ; rd_id == 4'd2; rd_addr == 32'd2000; rd_len == 8'd3; rd_size == 3'd2; rd_burst == 2'b01; rd_cache == 4'b0000; rd_lock == 1'b0; rd_prot == 3'b0;};
    finish_item(item);
    
    start_item(item);
    item.aresetn  = 1'b0;
    item.randomize() with {wr_req == 1'b0 ; wr_id == 4'd0; wr_addr == 32'd0; wr_len == 8'd0; wr_size == 3'd0; wr_burst == 2'b00; wr_cache == 4'b0000; wr_lock == 1'b0; wr_prot == 3'b000; rd_req == 1'b1 ; rd_id == 4'd3; rd_addr == 32'd4000; rd_len == 8'd3; rd_size == 3'd2; rd_burst == 2'b10; rd_cache == 4'b0000; rd_lock == 1'b0; rd_prot == 3'b0;};
    finish_item(item);
  endtask
  
  task body();
    reset();
    write();
    read();
  endtask
endclass
