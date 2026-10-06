class AXI_read_monitor extends uvm_monitor;
  `uvm_component_utils(AXI_read_monitor)
  
  virtual AXI_interface.RD_MON vif;
  AXI_agent_config cfg;
  
  AXI_sequence_item item_q[$];
  AXI_sequence_item r_payload_q[$];
  
  logic [31:0] q_rdata[$];
  logic [1:0] q_rresp[$];
  
  uvm_analysis_port#(AXI_sequence_item) rd_analysis_port;
  
  function new(string name = "AXI_read_monitor",uvm_component parent);
    super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    rd_analysis_port = new("rd_analysis_port",this);
    if(!uvm_config_db#(AXI_agent_config) :: get(this,"","cfg",cfg))
      `uvm_fatal("READ MONITOR","configuration is not set for write monitor")
    vif = cfg.vif;
  endfunction
  
  task run_phase(uvm_phase phase);
    fork
      monitor_reset();
      monitor_ar();
      monitor_rd();
      send_to_sb_cov();
    join
  endtask
  
  task monitor_reset();
    AXI_sequence_item reset_item;
    forever
      begin
        @(vif.cb_rd_mon);
        if(!vif.cb_rd_mon.aresetn)
          begin
            reset_item = AXI_sequence_item :: type_id :: create("item");
            reset_item.aresetn            = vif.cb_rd_mon.aresetn;
            reset_item.rd_req             = vif.cb_rd_mon.rd_req;
            reset_item.rd_id              = vif.cb_rd_mon.rd_id;
            reset_item.rd_lock            = vif.cb_rd_mon.rd_lock;
            reset_item.rd_addr            = vif.cb_rd_mon.rd_addr;
            reset_item.rd_len             = vif.cb_rd_mon.rd_len;
            reset_item.rd_size            = vif.cb_rd_mon.rd_size;
            reset_item.rd_burst           = vif.cb_rd_mon.rd_burst;
            reset_item.rd_cache           = vif.cb_rd_mon.rd_cache;
            reset_item.rd_prot            = vif.cb_rd_mon.rd_prot;
            reset_item.rd_id_out          = vif.cb_rd_mon.rd_id_out;
            reset_item.arvalid            = vif.cb_rd_mon.arvalid;
            reset_item.arready            = vif.cb_rd_mon.arready;
            reset_item.rvalid             = vif.cb_rd_mon.rvalid;
            reset_item.rready             = vif.cb_rd_mon.rready;
            rd_analysis_port.write(reset_item);
           
            q_rdata.delete();
            q_rresp.delete();
            item_q.delete();
            r_payload_q.delete();
            wait(vif.cb_rd_mon.aresetn);
          end
      end
  endtask
  
  task monitor_ar();
    AXI_sequence_item item;
    forever
      begin
        @(vif.cb_rd_mon);
        if(vif.cb_rd_mon.aresetn && vif.cb_rd_mon.arvalid && vif.cb_rd_mon.arready)
          begin
            item = AXI_sequence_item :: type_id :: create("item");
            item.aresetn            = vif.cb_rd_mon.aresetn;
            item.rd_req             = vif.cb_rd_mon.rd_req;
            item.rd_id              = vif.cb_rd_mon.rd_id;
            item.rd_lock            = vif.cb_rd_mon.rd_lock;
            item.rd_addr            = vif.cb_rd_mon.rd_addr;
            item.rd_len             = vif.cb_rd_mon.rd_len;
            item.rd_size            = vif.cb_rd_mon.rd_size;
            item.rd_burst           = vif.cb_rd_mon.rd_burst;
            item.rd_cache           = vif.cb_rd_mon.rd_cache;
            item.rd_prot            = vif.cb_rd_mon.rd_prot;
            item.arvalid            = vif.cb_rd_mon.arvalid;
            item.arready            = vif.cb_rd_mon.arready;
            
            item_q.push_back(item);

          end
      end
  endtask
  
  task monitor_rd();
    AXI_sequence_item item_p;
    logic [3:0] r_id_temp;
    int match_idx;
    int count = 0;
    forever
      begin
        @(vif.cb_rd_mon);
        if(vif.cb_rd_mon.aresetn && vif.cb_rd_mon.rvalid && vif.cb_rd_mon.rready)
          begin
            q_rdata.push_back(vif.cb_rd_mon.rdata_out);
            q_rresp.push_back(vif.cb_rd_mon.rd_response_out);
            
            if(vif.cb_rd_mon.rlast)
              begin
                r_id_temp               = vif.cb_rd_mon.rd_id_out;
                match_idx               = -1;
                while(match_idx == -1)
                  begin
                    foreach(item_q[idx])
                      begin
                        if(item_q[idx].rd_id == r_id_temp)
                          begin
                            match_idx = idx;
                            break;
                          end
                      end
                    if(match_idx == -1)
                      @(vif.cb_rd_mon);
                  end
                
                item_p                  = item_q[match_idx];
                item_p.rd_id_out        = r_id_temp;
                item_p.rdata_out        = new[q_rdata.size()](q_rdata);
                item_p.rd_response_out  = new[q_rresp.size()](q_rresp);
                item_p.rlast            = 1'b1;
                
                r_payload_q.push_back(item_p);
                item_q.delete(match_idx);
                q_rdata.delete();
                q_rresp.delete();
              end
          end
      end
  endtask
 
  task send_to_sb_cov();
    AXI_sequence_item final_item;
    forever
      begin
        @(vif.cb_rd_mon);
        if(r_payload_q.size() > 0)
          begin
            final_item = r_payload_q.pop_front();
            rd_analysis_port.write(final_item);
          end
      end
  endtask
          
endclass
