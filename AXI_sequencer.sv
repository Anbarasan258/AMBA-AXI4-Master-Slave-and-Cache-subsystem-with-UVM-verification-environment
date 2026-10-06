class AXI_sequencer extends uvm_sequencer#(AXI_sequence_item);
  `uvm_component_utils(AXI_sequencer)
  function new(string name = "AXI_sequencer",uvm_component parent);
    super.new(name,parent);
  endfunction
endclass
