class AXI_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(AXI_scoreboard)
  
  uvm_analysis_imp_wr#(AXI_sequence_item,AXI_scoreboard) wrmon_imp_port;
  uvm_analysis_imp_rd#(AXI_sequence_item,AXI_scoreboard) rdmon_imp_port;
  
  virtual AXI_interface vif;
  AXI_agent_config cfg;
  
  logic [7:0]mem[4095:0];
  
  logic [7:0] wr_beat_count;
  logic [7:0] rd_beat_count;
  logic [1:0] rd_byte_offset;
  logic [31:0] rdata_masked;
  integer next_addr,wr_current_addr,wr_word_addr;
  
  integer wr_bytes_per_beats,rd_bytes_per_beats;
  integer wr_aligned_addr,rd_aligned_addr;
  integer wr_wrap_size,rd_wrap_size;
  integer wr_wrap_base,rd_wrap_base;
  integer wr_wrap_limit,rd_wrap_limit;
  
     
  
  function new(string name = "AXI_scoreboard",uvm_component parent);
    super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    wrmon_imp_port = new("wrmon_imp_port",this);
    rdmon_imp_port = new("rdmon_imp_port",this);
    
//     if(!uvm_config_db#(AXI_agent_config)::get(this,"","cfg",cfg))
//       `uvm_fatal("SCOREBOARD","configuration is not set for scoreboard")
  endfunction

 function void write_wr(AXI_sequence_item item);
    if(!item.aresetn)
      begin
        foreach(mem[i])
          mem[i] = 8'd0;
        if(!item.awvalid && !item.awready && !item.bvalid && !item.bready)
          `uvm_info(get_type_name(),"RESET is happend properly in the write side",UVM_LOW)
          else
            `uvm_error(get_type_name(),"RESET is not happend properly")
      end
   else if(item.bvalid && item.bready)
     begin
       if(item.b_resp == 2'b00 || item.b_resp == 2'b01)
         begin
           wr_bytes_per_beats  = (1 << item.wr_size);
           wr_aligned_addr     = (item.wr_addr / wr_bytes_per_beats) * wr_bytes_per_beats;
           wr_wrap_size        = wr_bytes_per_beats * (item.wr_len + 1);
           wr_wrap_base        = (wr_aligned_addr/wr_wrap_size) * wr_wrap_size;
           wr_wrap_limit       = wr_wrap_base + wr_wrap_size;
           
           wr_beat_count = 8'd0;
           for(int i = 0; i < item.wr_len+1 ; i = i+1)
             begin
               case(item.wr_burst)
                 2'b00 : next_addr = item.wr_addr;
                 2'b01 : next_addr = (wr_beat_count == 8'd0) ? item.wr_addr : wr_current_addr;
                 2'b10 : 
                   begin
                     if(wr_beat_count == 8'd0)
                       next_addr = item.wr_addr;
                     else 
                       next_addr = (wr_current_addr  >=  wr_wrap_limit) ?  wr_wrap_base : wr_current_addr;
                   end
               endcase
               
               wr_current_addr = (i == 0) ? (wr_aligned_addr + wr_bytes_per_beats) : (next_addr+ wr_bytes_per_beats);
               wr_word_addr = next_addr & ~32'h3;
               if(item.wr_strb[i][0]) mem[wr_word_addr]  = item.write_data[i][7:0];
               if(item.wr_strb[i][1]) mem[wr_word_addr + 1]  = item.write_data[i][15:8];
               if(item.wr_strb[i][2]) mem[wr_word_addr + 2]  = item.write_data[i][23:16];
               if(item.wr_strb[i][3]) mem[wr_word_addr + 3]  = item.write_data[i][31:24];
               
               `uvm_info(get_type_name(),$sformatf("for the ID : %0d || Burst type : %0d || size : %0d || length : %0d || the BEAT : %0d is store on the ADDRESS : %0d, with DATA %0d and WSTRB : %0b",item.wr_id,item.wr_burst,item.wr_size,item.wr_len,wr_beat_count,next_addr,item.write_data[i],item.wr_strb[i]),UVM_LOW)
             
               if(wr_beat_count == item.wr_len)
                 begin
                   if(item.wr_lock == 1'b1)
                     begin
                       if(item.b_resp == 2'b01)
                         `uvm_info(get_type_name(),$sformatf("the exclusive access is successful for the write transfer with id : %0d and address : %0d",item.wr_id,item.wr_addr),UVM_LOW)
                         else
                           `uvm_error(get_type_name(),$sformatf("the exclusive access is failed for the write transfer with id : %0d and address : %0d",item.wr_id,item.wr_addr))  
                           end
                   `uvm_info(get_type_name(),$sformatf("The write transfer for id : %0d has been completed successfully",item.wr_id),UVM_LOW)
                   $display("");
                 end
               else
                    wr_beat_count = wr_beat_count + 1;
             end 
         end
       else
         `uvm_error(get_type_name(),$sformatf("there is an error in this write transaction resp : %0b ,id : %0d ,address : %0d",item.b_resp,item.b_id,item.wr_addr))
     end
              
  endfunction 
  
  function void write_rd(AXI_sequence_item item);
   integer rd_next_addr,rd_current_addr,rd_word_addr;
   logic [31:0] expected_read_data;
   integer exclusive_count;
    if(!item.aresetn)
       begin
         foreach(mem[i])
          mem[i] = 8'd0;
         if(!item.arvalid && !item.rready && !item.rvalid)
           `uvm_info(get_type_name(),"RESET is happend properly in the read side",UVM_LOW)
          else
            `uvm_error(get_type_name(),"RESET is not happend properly")
       end
            
    else if(item.rlast)
       begin
         rd_bytes_per_beats  = (1 << item.rd_size);
         rd_aligned_addr     = (item.rd_addr / rd_bytes_per_beats) * rd_bytes_per_beats;
         rd_wrap_size        = rd_bytes_per_beats * (item.rd_len + 1);
         rd_wrap_base        = (rd_aligned_addr/rd_wrap_size) * rd_wrap_size;
         rd_wrap_limit       = rd_wrap_base + rd_wrap_size;
         
         rd_beat_count       = 8'd0;
         exclusive_count     = 0;
         for(int j = 0 ; j < item.rd_len+1 ; j = j + 1)
           begin
             case(item.rd_burst)
               2'b00 : rd_next_addr = item.rd_addr;
               2'b01 : rd_next_addr = (rd_beat_count == 8'd0) ? item.rd_addr : rd_current_addr;
               2'b10 : 
                 begin
                   if(rd_beat_count == 8'd0)
                     rd_next_addr = item.rd_addr;
                   else
                     rd_next_addr = (rd_current_addr >= rd_wrap_limit) ? rd_wrap_base : rd_current_addr;
                 end
               default : rd_next_addr = 32'd0;
             endcase
             
             rd_current_addr = (j == 0) ? (rd_aligned_addr + rd_bytes_per_beats) : (rd_next_addr+ rd_bytes_per_beats);
             rd_word_addr = rd_next_addr & ~32'h3;
             rd_byte_offset = rd_next_addr[1:0];
             
             rdata_masked = 32'd0;
             case(item.rd_size)
               3'd0:
                 begin
                   case(rd_byte_offset)
                     2'd0: rdata_masked[7:0]   = mem[rd_word_addr];
                     2'd1: rdata_masked[15:8]  = mem[rd_word_addr+1];
                     2'd2: rdata_masked[23:16] = mem[rd_word_addr+2];
                     2'd3: rdata_masked[31:24] = mem[rd_word_addr+3];
                   endcase
                 end
               3'd1:
                 begin
                   case(rd_byte_offset[1])
                     1'b0: rdata_masked[15:0]   = {mem[rd_word_addr+1],mem[rd_word_addr]};
                     1'b1: rdata_masked[31:16]  = {mem[rd_word_addr+3],mem[rd_word_addr+2]};
                   endcase
                 end
               default : rdata_masked = {mem[rd_word_addr+3],mem[rd_word_addr+2],mem[rd_word_addr+1],mem[rd_word_addr]};
             endcase
             
             expected_read_data = rdata_masked;
             
             
             if(item.rd_response_out[j] == 2'b00 || item.rd_response_out[j] == 2'b01)
               begin
                 if(item.rdata_out[j] == expected_read_data)
                   begin
                     `uvm_info(get_type_name(),$sformatf("For ID : %0d || burst type : %0d || size : %0d || length : %0d || Address : %0d,the read data for beat %0d is matched with expected data ((read data) %0d = %0d (expected data ))",item.rd_id_out,item.rd_burst,item.rd_size,item.rd_len,rd_next_addr,rd_beat_count,item.rdata_out[j],expected_read_data),UVM_LOW)
                     if(item.rd_lock)
                       begin
                         if(item.rd_response_out[j] == 2'b01)
                           exclusive_count = exclusive_count + 1;
                  else
                    exclusive_count = exclusive_count;
                       end
                    if(rd_beat_count == item.rd_len)
                       begin
                         if(item.rd_lock)
                           begin
                             if(exclusive_count == item.rd_len + 1)
                               `uvm_info(get_type_name(),$sformatf("the exclusive access for read transfer is successful for the id : %0d and address : %0d : exclusive pass count : %0d",item.rd_id_out,item.rd_addr,exclusive_count),UVM_LOW)
                               else
                                 `uvm_error(get_type_name(),$sformatf("the exclusive access for read transfer is failed for the id : %0d and address : %0d and response : %0d",item.rd_id_out,item.rd_addr,item.rd_response_out[j]))
                           end
                         `uvm_info(get_type_name(),$sformatf("The read transfer for id : %0d has been completed successfully",item.rd_id),UVM_LOW)
                   $display("");
                       end
                   end
                 else
                   `uvm_error(get_type_name(),$sformatf("For ID : %0d and Address : %0d,the read data for beat %0d is mismatched with expected data || ((read data) %0d = %0d (expected data ))",item.rd_id_out,rd_next_addr,rd_beat_count,item.rdata_out[j],expected_read_data))
               end
             else
               `uvm_error(get_type_name(),$sformatf("For ID : %0d,error in the read reposne for the beat %0d",item.rd_id_out,rd_beat_count))
               
              rd_beat_count = rd_beat_count + 1;
           end
         
       end
  endfunction 
         
endclass
