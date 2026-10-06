module Axi_master(ACLK,RESETn,wr_start,wid,wr_address_in,wr_burst_length,wr_burst_type,wr_burst_size,wr_lock_access,wr_cache,wr_protect,wr_response,wr_burst_data,rep_id,rd_start,rdid,rd_address_in,rd_burst_length,rd_burst_type,rd_burst_size,rd_lock_access,rd_cache,rd_protect,rd_data_out,rd_response,AWID,AWADDR,AWLEN,AWSIZE,AWBURST,AWLOCK,AWCACHE,AWPROT,AWVALID,AWREADY,WDATA,WSTRB,WLAST,WVALID,WREADY,BID,BRESP,BVALID,BREADY,ARID,ARADDR,ARLEN,ARSIZE,ARBURST,ARLOCK,ARCACHE,ARPROT,ARVALID,ARREADY,RID,RDATA,RRESP,RLAST,RVALID,RREADY);

// global signals
  input ACLK,RESETn;
  
// signals from tb
  input wr_start,rd_start;
  input [3:0] wid;
  input [31:0] wr_address_in;
  input [7:0] wr_burst_length;
  input [1:0] wr_burst_type;
  input [2:0] wr_burst_size;
  input wr_lock_access;
  input [3:0] wr_cache;
  input [2:0] wr_protect;
  input [31:0] wr_burst_data [255:0];
  output  [1:0] wr_response;
  output  [3:0] rep_id;
 
  input [3:0] rdid;
  input [31:0] rd_address_in;
  input [7:0] rd_burst_length;
  input [1:0] rd_burst_type;
  input [2:0] rd_burst_size;
  input rd_lock_access;
  input [3:0] rd_cache;
  input [2:0] rd_protect;
  output reg [31:0] rd_data_out;
  output  reg [1:0] rd_response;
// Write address channel signals
  
  output  [3:0] AWID;
  output  [31:0] AWADDR;
  output  [7:0] AWLEN;
  output  [2:0] AWSIZE;
  output  [1:0] AWBURST;
  output  AWLOCK;
  output  [3:0] AWCACHE;
  output  [2:0] AWPROT;
  output  AWVALID;
  input  AWREADY;
  
// Write data channel signals
  

  output reg [31:0] WDATA;
  output reg [3:0] WSTRB;
  output reg WLAST;
  output reg WVALID;
  input WREADY;
  
// Write response channel signals
  input [3:0] BID;
  input [1:0] BRESP;
  input BVALID;
  output reg BREADY;
  
// Read address channel signals

  output  [3:0] ARID;
  output  [31:0] ARADDR;
  output  [7:0] ARLEN;
  output  [2:0] ARSIZE;
  output  [1:0] ARBURST;
  output  ARLOCK;
  output  [3:0] ARCACHE;
  output  [2:0] ARPROT;
  output  ARVALID;
  input ARREADY;
  
//  Read data channel
  input [3:0] RID;
  input [31:0] RDATA;
  input [1:0] RRESP;
  input RLAST;
  input RVALID;
  output reg RREADY;

   
//outstanding transaction table size
   localparam storage_size = 16;
  
//outstanding transaction table
  typedef struct  {
    logic valid;
    logic aw_sent;
    logic write_done;
    logic [3:0] id;
    logic [31:0] data [255:0];
    logic [7:0]  len;
    logic [7:0]  beat_count;
    logic [2:0]  size;
    logic [31:0] addr;
    logic [1:0]  burst;
    logic lock;
    logic [3:0]  cache;
    logic [2:0]  prot;
  } wr_trans_info;
  
  wr_trans_info wr_table[0:storage_size-1];
  
  
  integer i,j;
 // for calculating free slots in the out-standing-transfer table 
  reg [3:0] aw_alloc_index,aw_ptr,aw_send_index,aw_send_ptr;
  reg [4:0] aw_idx,aw_send_idx;
  reg table_full;
  reg aw_pending;
  integer aw_i,aw_j,r;
// ----------------------------------------------------------------- Write address channel ------------------------------------------------------------------------------
  assign AWID    = (aw_pending) ? wr_table[aw_send_index].id     : 4'd0;
  assign AWADDR  = (aw_pending) ? wr_table[aw_send_index].addr   : 32'd0;
  assign AWLEN   = (aw_pending) ? wr_table[aw_send_index].len    : 8'd0;
  assign AWSIZE  = (aw_pending) ? wr_table[aw_send_index].size   : 3'd0;
  assign AWBURST = (aw_pending) ? wr_table[aw_send_index].burst  : 2'd0;
  assign AWLOCK  = (aw_pending) ? wr_table[aw_send_index].lock   : 1'b0;
  assign AWCACHE = (aw_pending) ? wr_table[aw_send_index].cache  : 4'd0;
  assign AWPROT  = (aw_pending) ? wr_table[aw_send_index].prot   : 3'd0;
   
  
  assign AWVALID  = (aw_pending) ? 1'b1 : 1'b0;
  
  always @(*)
    begin
      table_full     = 1'b1;
      aw_alloc_index = 4'd0;
      for (aw_i = 0; aw_i < storage_size; aw_i = aw_i + 1) 
        begin
          aw_idx = aw_ptr + aw_i;
          if(aw_idx >= storage_size)
            aw_idx = aw_idx - storage_size;
          if (!wr_table[aw_idx].valid && table_full)
            begin
              table_full = 1'b0;
              aw_alloc_index = aw_idx[3:0];
            end
        end
    end
  
  always@(*)
    begin
      aw_pending = 1'b0;
      aw_send_index = 4'd0;
      for(aw_j = 0; aw_j < storage_size ; aw_j = aw_j +1)
        begin
          aw_send_idx = aw_send_ptr + aw_j;
          if(aw_send_idx >= storage_size)
            aw_send_idx = aw_send_idx - storage_size;
          if(!aw_pending && wr_table[aw_send_idx].valid && !wr_table[aw_send_idx].aw_sent)
            begin
              aw_pending = 1'b1;
              aw_send_index = aw_send_idx[3:0];
            end
        end
    end
  
  always@(posedge ACLK)
    begin
      if(!RESETn)
        begin
          aw_ptr <= 4'd0;
          aw_send_ptr <= 4'd0;
          for(i = 0 ; i < storage_size; i = i+1)
            begin
              wr_table[i].valid      <= 1'b0;
              wr_table[i].aw_sent    <= 1'b0;
              wr_table[i].write_done <= 1'b0;
              wr_table[i].id         <= 4'd0;
              wr_table[i].addr       <= 32'd0;
              wr_table[i].len        <= 8'd0;
              wr_table[i].burst      <= 2'd0;
              wr_table[i].beat_count <= 8'd0;
              wr_table[i].size       <= 3'd0;
              wr_table[i].lock       <= 1'd0;
              wr_table[i].cache      <= 4'd0;
              wr_table[i].prot       <= 3'd0;
              for(j = 0; j < 256; j = j + 1)
                wr_table[i].data[j] <= 32'd0;
            end
        end
      else
        begin
          if (wr_start && !table_full)
          begin
            wr_table[aw_alloc_index].valid      <= 1'b1;
            wr_table[aw_alloc_index].aw_sent    <= 1'b0;
            wr_table[aw_alloc_index].write_done <= 1'b0;
            wr_table[aw_alloc_index].id         <= wid;
            wr_table[aw_alloc_index].addr       <= wr_address_in;
            wr_table[aw_alloc_index].len        <= wr_burst_length;
            wr_table[aw_alloc_index].beat_count <= 8'd0;
            wr_table[aw_alloc_index].burst      <= wr_burst_type;
            wr_table[aw_alloc_index].size       <= wr_burst_size;
            wr_table[aw_alloc_index].lock       <= wr_lock_access;
            wr_table[aw_alloc_index].cache      <= wr_cache;
            wr_table[aw_alloc_index].prot       <= wr_protect;
            for(r = 0; r < 256; r = r + 1)
              wr_table[aw_alloc_index].data[r] <= wr_burst_data[r];
            aw_ptr                               <= (aw_alloc_index == storage_size-1) ? 4'd0 : (aw_alloc_index+1'b1); 
          end
          if(AWREADY && AWVALID)
             begin
               wr_table[aw_send_index].aw_sent <= 1'b1;
               aw_send_ptr <= (aw_send_index == storage_size-1) ? 4'd0 : (aw_send_index + 1'b1);
             end
        end
    end
             

// ---------------------------------------------------------------- write data channel ----------------------------------------------------------------------------------
             
//finding the out-standing data transfer
  reg [31:0] start_addr, aligned_addr, beat_bytes, wrap_size, wrap_boundary;
  reg [31:0] curr_addr, next_addr;
  reg [31:0] next_beat_addr;
  reg [1:0]  addr_offset;
  reg [1:0]  next_addr_offset;
  reg [3:0] wd_alloc_index, wd_ptr;
  reg [4:0] wd_idx;
  logic data_pending;
  integer wd_i;
  typedef enum {WD_IDLE,WD_READY} write_data_state;
  write_data_state wd_state,wd_next_state;
  
  always@(*)
    begin
      data_pending = 1'b0;
      wd_alloc_index = 4'd0;
      for(wd_i = 0 ; wd_i < storage_size; wd_i = wd_i+1)
        begin
          wd_idx = wd_ptr + wd_i;
          if(wd_idx >= storage_size)
            wd_idx = wd_idx - storage_size;
          if(wr_table[wd_idx].valid && wr_table[wd_idx].aw_sent && !wr_table[wd_idx].write_done && !data_pending)
            begin
              data_pending = 1'b1;
              wd_alloc_index = wd_idx[3:0];
            end
        end
    end
  
  always @(*)
    begin
      start_addr   = wr_table[wd_alloc_index].addr;
      beat_bytes   = (32'd1 << wr_table[wd_alloc_index].size);
      aligned_addr = (start_addr / beat_bytes) * beat_bytes;
      
      // ---- current beat (beat_count) ----
      case (wr_table[wd_alloc_index].burst)
        2'b00:curr_addr = start_addr;
        2'b01:
          begin
            if (wr_table[wd_alloc_index].beat_count == 8'd0)
              curr_addr = start_addr;
            else
              curr_addr = aligned_addr + (wr_table[wd_alloc_index].beat_count * beat_bytes);
          end
        
        2'b10:
          begin
            wrap_size     = (wr_table[wd_alloc_index].len + 1) * beat_bytes;
            wrap_boundary = (aligned_addr / wrap_size) * wrap_size;
            if (wr_table[wd_alloc_index].beat_count == 8'd0)
              next_addr = start_addr;
            else
              next_addr = aligned_addr + (wr_table[wd_alloc_index].beat_count * beat_bytes);
            if (next_addr >= (wrap_boundary + wrap_size))
              curr_addr = next_addr - wrap_size;
            else
              curr_addr = next_addr;
          end
        default: curr_addr = start_addr;
      endcase
      
      addr_offset = curr_addr[1:0];
      
      // ---- next beat (beat_count + 1) ----
      case (wr_table[wd_alloc_index].burst)
        2'b00:next_beat_addr = start_addr;
        2'b01:next_beat_addr = aligned_addr +((wr_table[wd_alloc_index].beat_count + 8'd1) * beat_bytes);
        2'b10: 
          begin
            next_addr = aligned_addr + ((wr_table[wd_alloc_index].beat_count + 8'd1) * beat_bytes);
            if (next_addr >= (wrap_boundary + wrap_size))
              next_beat_addr = next_addr - wrap_size;
            else 
              next_beat_addr = next_addr;
          end 
        default: next_beat_addr = start_addr;
      endcase
      next_addr_offset = next_beat_addr[1:0];
    end
  
  always@(posedge ACLK)
    begin
      if(!RESETn)
        begin
          wd_state <= WD_IDLE;
          WLAST <= 1'b0;
          WSTRB <= 4'd0;
          WDATA <= 32'd0;
          wd_ptr <= 4'd0;
          WVALID <= 1'b0;
        end
      else
        begin
          wd_state <= wd_next_state;
          if(wd_state == WD_IDLE)
            begin
              if(data_pending)
                begin
                  WVALID <= 1'b1;
                  WLAST  <= (wr_table[wd_alloc_index].beat_count == wr_table[wd_alloc_index].len);
                  if (wr_table[wd_alloc_index].size == 3'd2)
                    WDATA <= wr_table[wd_alloc_index].data[wr_table[wd_alloc_index].beat_count];
                  else
                    WDATA <= wr_table[wd_alloc_index].data[wr_table[wd_alloc_index].beat_count] << (addr_offset * 8);
                  case(wr_table[wd_alloc_index].size)
                    3'd0: WSTRB <= (4'b0001 << addr_offset);
                    3'd1: begin
                      case (addr_offset)
                        2'd0: WSTRB <= 4'b0011; 
                        2'd1: WSTRB <= 4'b0010; 
                        2'd2: WSTRB <= 4'b1100; 
                        2'd3: WSTRB <= 4'b1000; 
                      endcase
                    end
                    3'd2:begin
                      case(addr_offset)
                        2'd0: WSTRB <= 4'b1111;
                        2'd1: WSTRB <= 4'b1110;
                        2'd2: WSTRB <= 4'b1100;
                        2'd3: WSTRB <= 4'b1000;
                      endcase
                    end
                    default: WSTRB <= 4'b1111;
                  endcase
                end
              else
                WVALID <= 1'b0;
            end
          else if(wd_state == WD_READY)
            begin
              if(WVALID && WREADY)
                begin
                  if(wr_table[wd_alloc_index].len == wr_table[wd_alloc_index].beat_count)
                    begin
                      wr_table[wd_alloc_index].write_done <= 1'b1;
                      wr_table[wd_alloc_index].beat_count <= 0;
                      WLAST <= 1'b0;
                      WVALID <= 1'b0;
                      wd_ptr <= (wd_alloc_index == storage_size-1) ? 4'd0 : (wd_alloc_index +1'b1);
                    end
                  else
                    begin
                      wr_table[wd_alloc_index].beat_count <= wr_table[wd_alloc_index].beat_count +1'b1;
                      WLAST <= ((wr_table[wd_alloc_index].beat_count+1'b1) == wr_table[wd_alloc_index].len);
                      if (wr_table[wd_alloc_index].size == 3'd2)
                        WDATA <= wr_table[wd_alloc_index].data[wr_table[wd_alloc_index].beat_count + 1'b1];
                      else
                        WDATA <= wr_table[wd_alloc_index].data[wr_table[wd_alloc_index].beat_count + 1'b1] << (next_addr_offset * 8);
                      case(wr_table[wd_alloc_index].size)
                        3'd0: WSTRB <= (4'b0001 << next_addr_offset);
                        3'd1: begin
                          case (next_addr_offset)
                            2'd0: WSTRB <= 4'b0011; 
                            2'd1: WSTRB <= 4'b0010; 
                            2'd2: WSTRB <= 4'b1100; 
                            2'd3: WSTRB <= 4'b1000; 
                          endcase
                        end
                        3'd2:begin
                          case(next_addr_offset)
                            2'd0: WSTRB <= 4'b1111;
                            2'd1: WSTRB <= 4'b1110;
                            2'd2: WSTRB <= 4'b1100;
                            2'd3: WSTRB <= 4'b1000;
                          endcase
                        end
                        default: WSTRB <= 4'b1111;
                      endcase
                    end
                end
            end
        end
    end
 
  always@(*)
    begin
      case(wd_state)
        WD_IDLE:
          begin
            if(data_pending)
              begin
                wd_next_state = WD_READY;
              end
            else
              wd_next_state = WD_IDLE;
          end
        WD_READY:
          begin
            if(WVALID && WREADY && (wr_table[wd_alloc_index].beat_count == wr_table[wd_alloc_index].len))
              begin
                wd_next_state = WD_IDLE;
              end
            else
              wd_next_state = WD_READY;
          end
        default :
          begin
            wd_next_state = WD_IDLE;
          end
      endcase
    end
  
//  --------------------------------------- WRITE RESPONSE CHANNEL -------------------------------------------------------------
  reg [3:0] wr_alloc_index,wr_ptr;
  reg [4:0] wr_idx;
  reg resp_found;
  integer wr_i,l;
  
  assign wr_response = BRESP;
  assign rep_id      = BID;
  
  always@(*)
    begin
      wr_alloc_index = 4'd0;
      resp_found = 1'b0;
      
      for(wr_i = 0; wr_i < storage_size; wr_i = wr_i+1)
        begin
          wr_idx = wr_ptr + wr_i;
          if(wr_idx >= storage_size)
            wr_idx = wr_idx - storage_size;
          if(!resp_found && wr_table[wr_idx].valid && wr_table[wr_idx].write_done && (wr_table[wr_idx].id == BID))
            begin
              wr_alloc_index = wr_idx[3:0];
              resp_found = 1'b1;
            end
        end
    end
  
  always@(posedge ACLK)
    begin
      if(!RESETn)
        begin
          BREADY      <= 1'b0;
          wr_ptr      <= 4'd0;
        end
      else
        begin
          BREADY <= 1'b1;
          if(BVALID && BREADY && resp_found)
            begin
              wr_table[wr_alloc_index].valid      <= 1'b0;
              wr_table[wr_alloc_index].aw_sent    <= 1'b0;
              wr_table[wr_alloc_index].write_done <= 1'b0;
              wr_table[wr_alloc_index].id         <= 4'd0;
              wr_table[wr_alloc_index].addr       <= 32'd0;
              wr_table[wr_alloc_index].len        <= 8'd0;
              wr_table[wr_alloc_index].beat_count <= 8'd0;
              wr_table[wr_alloc_index].burst      <= 2'd0;
              wr_table[wr_alloc_index].size       <= 3'd0;
              wr_table[wr_alloc_index].lock       <= 1'b0;
              wr_table[wr_alloc_index].cache      <= 4'd0;
              wr_table[wr_alloc_index].prot       <= 3'd0;
              for(l = 0 ; l < 256 ; l = l+1 )
                wr_table[wr_alloc_index].data[l]  <= 32'd0;
              wr_ptr                              <= (wr_alloc_index == storage_size-1) ? 4'd0 : (wr_alloc_index + 1'b1);
            end
        end
    end

//--------------------------------------------------------- READ ADDRESS CHANNEL ----------------------------------------------------------------------------------------
  
  
 
 
  typedef struct packed {
    logic rd_valid;
    logic rd_send;
    logic [3:0] rd_id;
    logic [31:0] rd_addr;
    logic [7:0] rd_len;
    logic [1:0] rd_burst;
    logic [7:0] rd_beat_count;
    logic [2:0] rd_size;
    logic rd_lock_access;
    logic [3:0] rd_cache;
    logic [2:0] rd_prot;
  } rd_table_info;
  
  rd_table_info rd_table[0:storage_size-1];
  
  reg[3:0] ra_ptr,ra_send_ptr,ra_alloc_index,ra_send_index;
  reg [4:0] ra_idx,ra_send_idx;
  reg rd_table_full,ra_pending;
  integer ra_i,ra_j,e;
  
  assign ARID    = (ra_pending) ? rd_table[ra_send_index].rd_id           : 4'd0;
  assign ARADDR  = (ra_pending) ? rd_table[ra_send_index].rd_addr         : 32'd0;
  assign ARLEN   = (ra_pending) ? rd_table[ra_send_index].rd_len          : 8'd0;
  assign ARSIZE  = (ra_pending) ? rd_table[ra_send_index].rd_size         : 3'd0;
  assign ARBURST = (ra_pending) ? rd_table[ra_send_index].rd_burst        : 2'd0;
  assign ARLOCK  = (ra_pending) ? rd_table[ra_send_index].rd_lock_access  : 1'b0;
  assign ARCACHE = (ra_pending) ? rd_table[ra_send_index].rd_cache        : 4'd0;
  assign ARPROT  = (ra_pending) ? rd_table[ra_send_index].rd_prot         : 3'd0;
  assign ARVALID = (ra_pending) ? 1'b1 : 1'b0;
  
  always@(*)
    begin 
      rd_table_full = 1'b1;
      ra_alloc_index = 4'd0;
      for(ra_i = 0; ra_i < storage_size ; ra_i = ra_i+1)
        begin
          ra_idx = ra_ptr + ra_i;
          if(ra_idx >= storage_size)
            ra_idx = ra_idx - storage_size;
          if(!rd_table[ra_idx].rd_valid && rd_table_full)
            begin
              rd_table_full = 1'b0;
              ra_alloc_index = ra_idx[3:0];
            end
        end
    end
  always@(*)
    begin
      ra_pending = 1'b0;
      ra_send_index = 4'd0;
      for(ra_j = 0; ra_j < storage_size; ra_j = ra_j+1)
        begin
          ra_send_idx = ra_send_ptr + ra_j;
          if(ra_send_idx >= storage_size)
            ra_send_idx = ra_send_idx - storage_size;
          if(!ra_pending && rd_table[ra_send_idx].rd_valid && !rd_table[ra_send_idx].rd_send)
            begin
              ra_send_index = ra_send_idx[3:0];
              ra_pending    = 1'b1; 
            end
        end
    end
    
  always@(posedge ACLK)
    begin
      if(!RESETn)
        begin 
          ra_send_ptr <= 4'd0;
          ra_ptr      <= 4'd0;
          for(e=0;e<storage_size;e=e+1)
            begin
              rd_table[e].rd_valid       <= 1'b0;
              rd_table[e].rd_send        <= 1'b0;
              rd_table[e].rd_id          <= 4'd0;
              rd_table[e].rd_addr        <= 32'd0;
              rd_table[e].rd_len         <= 8'd0;
              rd_table[e].rd_burst       <= 2'd0;
              rd_table[e].rd_beat_count  <= 8'd0;
              rd_table[e]. rd_size       <= 3'd0;
              rd_table[e].rd_lock_access <= 1'd0;
              rd_table[e].rd_cache       <= 4'd0;
              rd_table[e].rd_prot        <= 3'd0;
            end
        end
      else
        begin
          if(rd_start && !rd_table_full)
            begin
              rd_table[ra_alloc_index].rd_valid       <= 1'b1;
              rd_table[ra_alloc_index].rd_send        <= 1'b0;
              rd_table[ra_alloc_index].rd_id          <= rdid;
              rd_table[ra_alloc_index].rd_addr        <= rd_address_in;
              rd_table[ra_alloc_index].rd_len         <= rd_burst_length;
              rd_table[ra_alloc_index].rd_burst       <= rd_burst_type;
              rd_table[ra_alloc_index].rd_beat_count  <= 8'd0;
              rd_table[ra_alloc_index]. rd_size       <= rd_burst_size;
              rd_table[ra_alloc_index].rd_lock_access <= rd_lock_access;
              rd_table[ra_alloc_index].rd_cache       <= rd_cache;
              rd_table[ra_alloc_index].rd_prot        <= rd_protect;
              ra_ptr <= (ra_alloc_index == storage_size-1) ? 4'd0 : (ra_alloc_index + 1'b1);
            end
          if(ARVALID && ARREADY)
            begin
              rd_table[ra_send_index].rd_send   <= 1'b1;
              ra_send_ptr                       <= (ra_send_index == storage_size-1) ? 4'd0 : (ra_send_index + 1'b1);
            end
        end
    end 
  
//  --------------------------------------- read data CHANNEL -------------------------------------------------------------
  reg [3:0] rd_alloc_index,rd_ptr;
  reg [4:0] rd_idx;
  reg rd_resp_found;
  integer rd_i;
 
  // ---- address/offset calculation for the CURRENT beat being received ---- 
  reg [31:0] rd_start_addr, rd_aligned_addr, rd_beat_bytes;
  reg [31:0] rd_wrap_size, rd_wrap_boundary;
  reg [31:0] rd_curr_addr, rd_next_addr;
  reg [1:0]  rd_addr_offset;

  
 always@(*)
    begin
      rd_alloc_index = 4'd0;
      rd_resp_found = 1'b0;
      
      for(rd_i = 0; rd_i < storage_size; rd_i = rd_i+1)
        begin
          rd_idx = rd_ptr + rd_i;
          if(rd_idx >= storage_size)
            rd_idx = rd_idx - storage_size;
          if(!rd_resp_found && rd_table[rd_idx].rd_valid && rd_table[rd_idx].rd_send &&(rd_table[rd_idx].rd_id == RID))
            begin
              rd_alloc_index = rd_idx[3:0];
              rd_resp_found = 1'b1;
            end
        end
    end
  
  
    // ---- compute this beat's address and low-2-bit offset (mirrors write side) ----
  always@(*)
    begin
      rd_start_addr   = rd_table[rd_alloc_index].rd_addr;
      rd_beat_bytes   = (32'd1 << rd_table[rd_alloc_index].rd_size);
      rd_aligned_addr = (rd_start_addr / rd_beat_bytes) * rd_beat_bytes;
      
      case (rd_table[rd_alloc_index].rd_burst)
        2'b00: rd_curr_addr = rd_start_addr;                                   // FIXED
        2'b01: 
          begin                                                          // INCR
            if (rd_table[rd_alloc_index].rd_beat_count == 8'd0)
              rd_curr_addr = rd_start_addr;
            else
              rd_curr_addr = rd_aligned_addr + (rd_table[rd_alloc_index].rd_beat_count * rd_beat_bytes);
          end

        2'b10:
          begin                                                         // WRAP
            rd_wrap_size     = (rd_table[rd_alloc_index].rd_len + 1) * rd_beat_bytes;
            rd_wrap_boundary = (rd_aligned_addr / rd_wrap_size) * rd_wrap_size;
            if (rd_table[rd_alloc_index].rd_beat_count == 8'd0)
              rd_next_addr = rd_start_addr;
            else
              rd_next_addr = rd_aligned_addr + (rd_table[rd_alloc_index].rd_beat_count * rd_beat_bytes);
            
            if (rd_next_addr >= (rd_wrap_boundary + rd_wrap_size))
              rd_curr_addr = rd_next_addr - rd_wrap_size;
            else
              rd_curr_addr = rd_next_addr;
          end
        default: rd_curr_addr = rd_start_addr;
      endcase
      rd_addr_offset = rd_curr_addr[1:0];
    end
  
  
  always@(posedge ACLK)
    begin
      if(!RESETn)
        begin
          RREADY      <= 1'b0;
          rd_ptr      <= 4'd0;
          rd_data_out <= 32'd0;
          rd_response <= 2'd0;
        end
      else
        begin
          RREADY <= 1'b1;
          if(RREADY && RVALID && rd_resp_found)
            begin
              rd_response = RRESP;
              case (rd_table[rd_alloc_index].rd_size)
                3'd0: rd_data_out <= (RDATA >> (rd_addr_offset * 8)) & 32'h0000_00FF;
                3'd1: rd_data_out <= (RDATA >> (rd_addr_offset * 8)) & 32'h0000_FFFF;
                3'd2: rd_data_out <= RDATA;
                default: rd_data_out <= RDATA;
              endcase
              if(RLAST && (rd_table[rd_alloc_index].rd_len == rd_table[rd_alloc_index].rd_beat_count))
                begin
                  rd_table[rd_alloc_index].rd_valid       <= 1'b0;
                  rd_table[rd_alloc_index].rd_send        <= 1'b0;
                  rd_table[rd_alloc_index].rd_id          <= 4'd0;
                  rd_table[rd_alloc_index].rd_addr        <= 32'd0;
                  rd_table[rd_alloc_index].rd_len         <= 8'd0;
                  rd_table[rd_alloc_index].rd_burst       <= 2'd0;
                  rd_table[rd_alloc_index].rd_beat_count  <= 8'd0;
                  rd_table[rd_alloc_index]. rd_size       <= 3'd0;
                  rd_table[rd_alloc_index].rd_lock_access <= 1'd0;
                  rd_table[rd_alloc_index].rd_cache       <= 4'd0;
                  rd_table[rd_alloc_index].rd_prot        <= 3'd0;
                  rd_ptr <= (rd_alloc_index == storage_size-1) ? 4'd0 : rd_alloc_index + 1'b1;
                end
              else
                begin
                  rd_table[rd_alloc_index].rd_beat_count <= rd_table[rd_alloc_index].rd_beat_count + 1'b1;
                end
            end
        end
    end
//   assign rd_data_out = RDATA;
//  assign rd_response = RRESP;
              
endmodule
