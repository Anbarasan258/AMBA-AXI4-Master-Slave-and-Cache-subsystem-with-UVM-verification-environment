class AXI_write_monitor extends uvm_monitor;
  `uvm_component_utils(AXI_write_monitor)
  
  virtual AXI_interface.WR_MON vif;
  AXI_agent_config cfg;
  
  uvm_analysis_port#(AXI_sequence_item) wr_analysis_port;
  
  AXI_sequence_item item_q[$];
  AXI_sequence_item w_payload_q[$];
  
  logic [31:0] wr_data_q[$];
  logic [3:0] wr_strobe_q[$];
  function new(string name = "AXI_write_monitor",uvm_component parent);
    super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
     wr_analysis_port = new("wr_analysis_port",this);
    if(!uvm_config_db#(AXI_agent_config) :: get(this,"","cfg",cfg))
      `uvm_fatal("WRITE MONITOR","configuration is not set for write monitor")
    vif = cfg.vif;
  endfunction
  
  task run_phase(uvm_phase phase);
    fork
      monitor_reset();
      monitor_aw();
      monitor_w();
      monitor_b();
    join
  endtask
  
  task monitor_reset();
    AXI_sequence_item rest_item;
    forever
      begin
        @(vif.cb_wr_mon);
        if(!vif.cb_wr_mon.aresetn)
          begin
            rest_item = AXI_sequence_item :: type_id :: create("item");
            rest_item.aresetn    = vif.cb_wr_mon.aresetn;
            rest_item.wr_req     = vif.cb_wr_mon.wr_req;
            rest_item.wr_id      = vif.cb_wr_mon.wr_id;
            rest_item.wr_addr    = vif.cb_wr_mon.wr_addr;
            rest_item.wr_len     = vif.cb_wr_mon.wr_len;
            rest_item.wr_size    = vif.cb_wr_mon.wr_size;
            rest_item.wr_burst   = vif.cb_wr_mon.wr_burst;
            rest_item.wr_lock    = vif.cb_wr_mon.wr_lock;
            rest_item.wr_cache   = vif.cb_wr_mon.wr_cache;
            rest_item.wr_prot    = vif.cb_wr_mon.wr_prot;
            rest_item.awvalid    = vif.cb_wr_mon.awvalid;
            rest_item.awready    = vif.cb_wr_mon.awready;
            rest_item.bvalid     = vif.cb_wr_mon.bvalid;
            rest_item.bready     = vif.cb_wr_mon.bready;
            wr_analysis_port.write(rest_item);
            wr_data_q.delete();
            wr_strobe_q.delete();
            item_q.delete();
            w_payload_q.delete();
            wait(vif.cb_wr_mon.aresetn === 1'b1);
          end
      end
  endtask
  
  task monitor_aw();
    AXI_sequence_item item;
    forever
      begin
        @(vif.cb_wr_mon);
        if(vif.cb_wr_mon.aresetn && vif.cb_wr_mon.awready && vif.cb_wr_mon.awvalid)
          begin
            item = AXI_sequence_item :: type_id :: create("item");
            item.aresetn    = vif.cb_wr_mon.aresetn;
            item.wr_req     = vif.cb_wr_mon.wr_req;
            item.wr_id      = vif.cb_wr_mon.wr_id;
            item.wr_addr    = vif.cb_wr_mon.wr_addr;
            item.wr_len     = vif.cb_wr_mon.wr_len;
            item.wr_size    = vif.cb_wr_mon.wr_size;
            item.wr_burst   = vif.cb_wr_mon.wr_burst;
            item.wr_lock    = vif.cb_wr_mon.wr_lock;
            item.wr_cache   = vif.cb_wr_mon.wr_cache;
            item.wr_prot    = vif.cb_wr_mon.wr_prot;
            item.awvalid    = vif.cb_wr_mon.awvalid;
            item.awready    = vif.cb_wr_mon.awready;
            item_q.push_back(item);
//             $display("[MON_AW] Captured AW: id=%0d addr=0x%0h len=%0d at %0t (item_q size=%0d)",
//            item.wr_id, item.wr_addr, item.wr_len, $time, item_q.size());
          end
      end
  endtask
  
  task monitor_w();
    AXI_sequence_item item_p;
    forever
      begin
        @(vif.cb_wr_mon);
        if(vif.cb_wr_mon.aresetn && vif.cb_wr_mon.wvalid && vif.cb_wr_mon.wready)
          begin
            wr_data_q.push_back(vif.cb_wr_mon.write_data);
            wr_strobe_q.push_back(vif.cb_wr_mon.wr_strb);
            
            if(vif.cb_wr_mon.wlast)
              begin
                wait(item_q.size() > 0);
                
                item_p = item_q.pop_front();
                item_p.write_data = new[wr_data_q.size()](wr_data_q);
                item_p.wr_strb    = new[wr_strobe_q.size()](wr_strobe_q);
                item_p.wlast      = 1'b1;
                w_payload_q.push_back(item_p);
                wr_data_q.delete();
                wr_strobe_q.delete();
//                 $display("[MON_W] Captured WLAST: beats=%0d at %0t (w_payload_q size=%0d)",
//            item_p.write_data.size(), $time, w_payload_q.size());
              end
          end
      end
  endtask
  
  task monitor_b();
    AXI_sequence_item final_item,payload_item;
    logic [3:0] b_id_temp;
    logic [1:0] b_resp_temp;
    logic       bvalid_temp;
    logic       bready_temp;
    int match_index;
    forever
      begin
       @(vif.cb_wr_mon); 
        if(vif.cb_wr_mon.aresetn && vif.cb_wr_mon.bvalid && vif.cb_wr_mon.bready)
          begin
            b_id_temp   = vif.cb_wr_mon.b_id ;
            b_resp_temp = vif.cb_wr_mon.b_resp;
            bvalid_temp = vif.cb_wr_mon.bvalid;
            bready_temp = vif.cb_wr_mon.bready;
             
            match_index = -1;
//             $display("inside moitor_b");
            while(match_index == -1 )
              begin
//                 match_index = -1;
//                 $display("inside moitor_b's while loop");
                foreach(w_payload_q[idx])
                  begin
//                     $display("inside moitor_b's foreachloop");
                    if(w_payload_q[idx].wr_id == b_id_temp)
                      begin
//                         $display("inside moitor_b's match loop");
                        match_index = idx;
                        break;
                      end
                  end
                if(match_index == -1)
                  @(vif.cb_wr_mon);
              end
            
            final_item = w_payload_q[match_index];
            w_payload_q.delete(match_index);
            
            final_item.b_id   = b_id_temp;
            final_item.b_resp = b_resp_temp;
            final_item.bvalid = bvalid_temp;
            final_item.bready = bready_temp;
//             $display("[MON_B_SENT] Sent to Scoreboard: id=%0d addr=0x%0h beats=%0d at %0t",
//            final_item.b_id, final_item.wr_addr, final_item.write_data.size(), $time);
            wr_analysis_port.write(final_item);

          end
      end
  endtask
endclass
