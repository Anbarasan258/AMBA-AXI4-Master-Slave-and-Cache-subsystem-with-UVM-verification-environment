class AXI_driver extends uvm_driver#(AXI_sequence_item);
  `uvm_component_utils(AXI_driver)
  
  virtual AXI_interface.DRV vif;
  AXI_agent_config cfg;
  
  function new(string name = "AXI_driver",uvm_component parent);
    super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(AXI_agent_config)::get(this,"","cfg",cfg))
      `uvm_fatal("DRIVER","configuration is not set for driver")
    vif = cfg.vif;
  endfunction
  
  task run_phase(uvm_phase phase);
    AXI_sequence_item item;
    forever
      begin
        @(vif.cb_drv);
        seq_item_port.get_next_item(item);
        if(!item.aresetn)
          begin
            vif.cb_drv.aresetn          <= 1'd0;
            vif.cb_drv.wr_req           <= 1'd0;
            vif.cb_drv.wr_id            <= 4'd0;
            vif.cb_drv.wr_lock          <= 1'b0;
            vif.cb_drv.wr_addr          <= 32'd0;
            vif.cb_drv.wr_len           <= 8'd0;
            vif.cb_drv.wr_size          <= 3'd0;
            vif.cb_drv.wr_burst         <= 2'd0;
            vif.cb_drv.wr_cache         <= 4'd0;
            vif.cb_drv.wr_prot          <= 3'd0;
            vif.cb_drv.rd_req           <= 1'd0;
            vif.cb_drv.rd_id            <= 4'd0;
            vif.cb_drv.rd_lock          <= 1'd0;
            vif.cb_drv.rd_addr          <= 32'd0;
            vif.cb_drv.rd_len           <= 8'd0;
            vif.cb_drv.rd_size          <= 3'd0;
            vif.cb_drv.rd_burst         <= 2'd0;
            vif.cb_drv.rd_cache         <= 4'd0;
            vif.cb_drv.rd_prot          <= 3'd0;
            repeat(2)@(vif.cb_drv);
            seq_item_port.item_done();
          end
        else
          begin
            vif.cb_drv.aresetn          <= item.aresetn;
            if(item.wr_req)
              begin
                vif.cb_drv.wr_req           <= item.wr_req;
                vif.cb_drv.wr_id            <= item.wr_id;
                vif.cb_drv.wr_lock          <= item.wr_lock;
                vif.cb_drv.wr_addr          <= item.wr_addr;
                vif.cb_drv.wr_len           <= item.wr_len;
                vif.cb_drv.wr_size          <= item.wr_size;
                vif.cb_drv.wr_burst         <= item.wr_burst;
                vif.cb_drv.wr_cache         <= item.wr_cache;
                vif.cb_drv.wr_prot          <= item.wr_prot;
                vif.cb_drv.wr_mem           <= item.wr_mem;
                @(vif.cb_drv);
                 vif.cb_drv.wr_req           <= 1'b0;
                wait(vif.cb_drv.bvalid && vif.cb_drv.bready);
//                 if(item.wr_cache[0])
// //                   begin
// //                     do begin
// //                       @(vif.cb_drv);
// //                     end while (!vif.cb_drv.wb_flush);
// //                   end
//                 if(item.wr_cache[3:1] || item.rd_lock || item.wr_prot)
//                   begin
//                     do begin
//                       @(vif.cb_drv);
//                     end while (!(vif.cb_drv.bvalid && vif.cb_drv.bready));
//                   end
              end
            if(item.rd_req)
              begin
                vif.cb_drv.rd_req           <= item.rd_req;
                vif.cb_drv.rd_id            <= item.rd_id;
                vif.cb_drv.rd_lock          <= item.rd_lock;
                vif.cb_drv.rd_addr          <= item.rd_addr;
                vif.cb_drv.rd_len           <= item.rd_len;
                vif.cb_drv.rd_size          <= item.rd_size;
                vif.cb_drv.rd_burst         <= item.rd_burst;
                vif.cb_drv.rd_cache         <= item.rd_cache;
                vif.cb_drv.rd_prot          <= item.rd_prot;
                @(vif.cb_drv);
                 vif.cb_drv.rd_req           <= 1'b0;
                wait(vif.cb_drv.rlast && vif.cb_drv.rvalid && vif.cb_drv.rready);
//                 if(item.rd_lock || item.rd_cache[3:1] || item.rd_prot)
// //                   begin
// //                     do begin
// //                       @(vif.cb_drv);
// //                     end while (!(vif.cb_drv.rlast && vif.cb_drv.rvalid && vif.cb_drv.rready));
// //                   end
              end
             seq_item_port.item_done();
          end
      end
  endtask
endclass
