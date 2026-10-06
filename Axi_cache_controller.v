module cache_controller(ACLK,ARESETn,S_AWID,S_AWADDR,S_AWLEN,S_AWSIZE,S_AWBURST,S_AWLOCK,S_AWCACHE,S_AWPROT,S_AWVALID,S_AWREADY,S_WDATA,S_WSTRB,S_WLAST,S_WVALID,S_WREADY,S_BID,S_BRESP,S_BREADY,S_BVALID,S_ARID,S_ARADDR,S_ARLEN,S_ARSIZE,S_ARBURST,S_ARLOCK,S_ARCACHE,S_ARPROT,S_ARVALID,S_ARREADY,S_RID,S_RDATA,S_RRESP,S_RLAST,S_RVALID,S_RREADY,M_AWID,M_AWADDR,M_AWLEN,M_AWSIZE,M_AWBURST,M_AWLOCK,M_AWCACHE,M_AWPROT,M_AWVALID,M_AWREADY,M_WDATA,M_WSTRB,M_WLAST,M_WVALID,M_WREADY,M_BID,M_BRESP,M_BREADY,M_BVALID,M_ARID,M_ARADDR,M_ARLEN,M_ARSIZE,M_ARBURST,M_ARLOCK,M_ARCACHE,M_ARPROT,M_ARVALID,M_ARREADY,M_RID,M_RDATA,M_RRESP,M_RLAST,M_RVALID,M_RREADY);
  
// Global signals
  
  input ACLK,ARESETn;

// slave side of cache signal which is connected to the master
  
  input [3:0] S_AWID;
  input [31:0]S_AWADDR;
  input [7:0] S_AWLEN; 
  input [2:0] S_AWSIZE;
  input [1:0] S_AWBURST;
  input  S_AWLOCK;
  input [3:0] S_AWCACHE;
  input [2:0] S_AWPROT;
  input S_AWVALID;
  output S_AWREADY;
  input [31:0] S_WDATA;
  input [3:0] S_WSTRB;
  input S_WLAST;
  input S_WVALID;
  output S_WREADY;
  output [3:0] S_BID;
  output [1:0] S_BRESP;
  output S_BVALID;
  input S_BREADY;
  input [3:0] S_ARID;
  input [31:0]S_ARADDR;
  input [7:0]S_ARLEN;
  input [2:0] S_ARSIZE;
  input [1:0]S_ARBURST;
  input S_ARLOCK;
  input [3:0] S_ARCACHE;
  input [2:0] S_ARPROT;
  input S_ARVALID;
  output S_ARREADY;
  output [3:0] S_RID;
  output [31:0] S_RDATA;
  output [1:0] S_RRESP;
  output S_RLAST;
  output S_RVALID;
  input S_RREADY;
  
//  master side of cache signal which is connected to the slave  
  
  output [3:0] M_AWID;
  output [31:0] M_AWADDR;
  output [7:0] M_AWLEN;
  output [2:0] M_AWSIZE;
  output [1:0] M_AWBURST;
  output  M_AWLOCK;
  output [3:0] M_AWCACHE;
  output [2:0] M_AWPROT;
  output M_AWVALID;
  input M_AWREADY;
  output reg [31:0] M_WDATA;
  output [3:0] M_WSTRB;
  output M_WLAST;
  output M_WVALID;
  input M_WREADY;
  input [3:0] M_BID;
  input [1:0] M_BRESP;
  output M_BREADY;
  input M_BVALID;
  output [3:0] M_ARID;
  output [31:0] M_ARADDR;
  output [7:0] M_ARLEN;
  output [2:0] M_ARSIZE;
  output [1:0] M_ARBURST;
  output M_ARLOCK;
  output [3:0] M_ARCACHE;
  output [2:0] M_ARPROT;
  output M_ARVALID;
  input M_ARREADY;
  input [3:0] M_RID;
  input [31:0] M_RDATA;
  input [1:0]M_RRESP;
  input M_RLAST;
  input M_RVALID;
  output M_RREADY;

  // write back registers
  logic [3:0]  wb_awid;
  logic [31:0] wb_awaddr;
  logic [7:0]  wb_awlen;
  logic [2:0]  wb_awsize;
  logic [1:0]  wb_awburst;
  logic        wb_awvalid; 
  
// cache variables
  
  localparam CACHE_LINE = 64;
  localparam LINE_BYTES = 16;
  localparam INDEX_BITS = 6;
  localparam OFFSET_BITs = 4;
  localparam TAG_BITS = 22;

  logic [31:0] cache_data [0:CACHE_LINE-1][0:3];
  logic [21:0] cache_tag [0:CACHE_LINE-1];
  logic cache_valid [0:CACHE_LINE-1];
  logic cache_dirty [0:CACHE_LINE-1];
  
//output [31:0]
  logic [21:0] lookup_tag;
  logic [5:0]  lookup_index;
  logic [3:0]  lookup_offset;
  logic [1:0]  word_offset;
  logic [31:0] current_line_base;
  logic [21:0] current_line_tag;
  logic [5:0]  current_line_index;
  logic [3:0]  current_byte_offset;
  logic [1:0]  current_word_offset;
  logic [31:0] burst_next_addr;
  logic        line_boundary_cross;
  logic [31:0] byte_addr0;
  logic [31:0] byte_addr1;
  logic [31:0] byte_addr2;
  logic [31:0] byte_addr3;

// Write transaction registers  
  logic [3:0]  wr_id;
  logic [31:0] wr_addr;
  logic [7:0]  wr_len;
  logic [2:0]  wr_size;
  logic [1:0]  wr_burst;
  logic        wr_lock;
  logic [3:0]  wr_cache;
  logic [2:0]  wr_prot;

  logic [31:0] wr_current_addr;
  logic [7:0]  wr_beat_count;
  logic [31:0] wr_aligned_addr;
  logic [31:0] wrap_base_addr;
  logic [31:0] wrap_limit_addr;
  
  logic [31:0] wr_last_addr;
  logic [31:0] wrap_last_addr;
  logic [31:0] burst_bytes;
  logic [31:0] beat_bytes;
  logic        wr_bvalid;
  logic [3:0]  wr_bid;
  logic [1:0]  wr_bresp;
  logic wr_protection_error;
  logic [31:0] pending_wdata;
  logic [3:0] pending_wstrb;
  logic pending_wlast;
  logic [31:0] pending_beat_addr;
  
  logic [31:0] beat_start_addr;
  logic [31:0] beat_end_addr;
  logic  beat_cross_line;
  
  logic [5:0] beat_first_index;
  logic [5:0] beat_second_index;
  logic [21:0] second_line_tag;
  
  logic [5:0] pending_first_index;
  logic [5:0] pending_second_index;
  logic [31:0] pending_next_addr;
  
  logic [5:0] cross_index;
  logic [21:0] cross_tag;
  logic [31:0] cross_line_base;

 
// Hit/miss signals  
  logic cache_hit;
  logic cache_miss;
  logic victim_dirty;
  logic victim_valid;

// Cache-line transfer variables  
  logic [1:0] line_beat_count;
  logic [31:0] refill_data [0:3];
  logic [31:0] writeback_data [0:3];
  logic [31:0] victim_addr;
  logic [31:0] line_base_addr;
  logic [31:0] victim_line_base;
  logic [1:0] wb_beat_count;
  logic       wb_aw_done;
  logic       wb_b_done;
  
  logic       refill_ar_done;
  logic       refill_r_done;
  logic       refill_error;
  logic [1:0] refill_error_resp;
  logic       cross_refill_pending;
// write cache logic
  logic wr_bufferable;
  logic wr_bypassable;
  logic wr_other_allocate;
  logic wr_write_allocate;
  logic wr_bypass_active;
  
  logic wr_burst_error;
  logic wr_narrow_error;
  logic wr_4kb_error;
  logic wr_size_error;
  logic wr_wrap_len_error;
  logic wr_fixed_len_error;
  
 
// buffer memory

  localparam buffer_storage = 16;
  typedef struct {
    logic [31:0] buffer_memory [0:255];
    logic [3:0] id;
    logic [31:0] addr;
    logic [7:0] beat_count;
    logic [2:0] awsize;
    logic [1:0] burst;
    logic lock_access;
    logic [2:0] prot;
    logic [3:0] buffer_strobe [0:255];
  } buffer_info;
  
// buffer registers
  logic [3:0] wr_buf_wr_ptr,wr_buf_rd_ptr;
  logic [3:0] wr_buf_count;
  logic [7:0] wr_buf_beat_idx;
  logic wr_buf_active;
  logic rd_bufferable;
  
  buffer_info buffer_mem[0:buffer_storage-1];
  
  typedef enum logic [4:0] {
    WR_IDLE,
    WR_VALIDATE,
    WR_LOOKUP,
    WR_HIT,
    WR_MISS,
    WR_WRITEBACK,
    WR_REFILL,
    WR_UPDATE,
    WR_BEAT_CROSS,
    WR_CROSS_LOOKUP,
    WR_CROSS_APPLY,
    WR_BYPASS,
    WR_BUFFER_CAPTURE,
    WR_BUFFER_DRAIN,
    WR_PROTECTION,
    WR_RESPONSE
} wr_state_t;

wr_state_t wr_state;
  
 integer cache_i,cache_j,buffer_i,buffer_j;
  
  always@(posedge ACLK)
    begin
      if(!ARESETn)
        begin
          wb_beat_count  <= 2'd0;
          wb_aw_done <= 1'b0;
          wb_b_done  <= 1'b0;
          refill_ar_done <= 1'b0;
          refill_r_done  <= 1'b0;
          line_beat_count <= 2'd0;
          wr_bvalid       <= 1'b0;
          wr_bid          <= 4'd0;
          wr_bresp        <= 2'd0;
          refill_error   <= 1'b0;
          refill_error_resp <= 2'b00;
          cross_refill_pending <= 1'b0;
          for(cache_i = 0; cache_i < CACHE_LINE; cache_i = cache_i+1)
            begin
              cache_tag[cache_i] <= 22'd0;
              cache_valid[cache_i] <= 1'b0;
              cache_dirty[cache_i] <= 1'b0;
              for(cache_j = 0; cache_j < 4; cache_j = cache_j+1)
                cache_data[cache_i][cache_j] <= 32'd0;
            end
          wb_aw_done  <= 1'b0;
          wb_b_done <= 1'b0;
          for(buffer_i = 0 ; buffer_i < buffer_storage ; buffer_i = buffer_i + 1'b1)
            begin
              buffer_mem[buffer_i].id <= 4'd0;
              buffer_mem[buffer_i].addr <= 32'd0;
              buffer_mem[buffer_i].beat_count <= 8'd0;
              buffer_mem[buffer_i].awsize <= 3'd0;
              buffer_mem[buffer_i]. burst<= 2'd0;
              buffer_mem[buffer_i].lock_access <= 1'd0;
              buffer_mem[buffer_i]. prot<= 3'd0;
              for(buffer_j = 0 ; buffer_j < 256 ;buffer_j = buffer_j + 1'b1)
                begin
                  buffer_mem[buffer_i].buffer_memory[buffer_j] <= 32'd0;
                  buffer_mem[buffer_i].buffer_strobe[buffer_j] <= 4'd0;
                end
            end
        end
    end
  
  assign wr_size_error = (wr_size > 3'd2) ? 1'b1 :1'b0;
  assign wr_wrap_len_error = (wr_burst == 2'b10) && !((wr_len == 8'd1) || (wr_len == 8'd3) ||(wr_len == 8'd7) || (wr_len == 8'd15));
  assign wrap_last_addr = wrap_limit_addr - 32'd1;
  assign wr_fixed_len_error = (wr_burst == 2'b00) && (wr_len > 8'd15);
  assign wr_burst_error = ((wr_burst == 2'b11) || wr_wrap_len_error || wr_fixed_len_error) ? 1'b1 : 1'b0;
  assign wr_last_addr   = wr_addr + ((wr_len + 1) * beat_bytes) - 1;
  assign wr_4kb_error   =  (wr_burst == 2'b01) ? (wr_addr[31:12] != wr_last_addr[31:12] || wr_last_addr > 4095) :(wr_burst == 2'b10) ? (wrap_base_addr[31:12] != wrap_last_addr[31:12] || wr_last_addr > 4095 ) : 1'b0;
  
  assign beat_start_addr = wr_current_addr;
  assign beat_end_addr   = wr_current_addr + beat_bytes-1;
  assign beat_cross_line = (wr_current_addr[31:4] != beat_end_addr[31:4]);
  assign beat_first_index = beat_start_addr[9:4];
  assign beat_second_index = beat_end_addr[9:4];
  assign second_line_tag  = beat_end_addr[31:10];
    
  assign wr_bufferable = (S_AWCACHE == 4'b0001) ? 1'b1 : 1'b0;
  assign wr_bypassable = (S_AWCACHE == 4'b0000) ? 1'b1 : 1'b0;
  assign wr_other_allocate = wr_cache[2];
  assign wr_write_allocate = wr_cache[3];
  assign wr_protection_error = (wr_prot[2] || wr_prot[1]);
  
  assign current_line_base = wr_current_addr & 32'hFFFFFFF0;
  assign current_line_tag  = wr_current_addr[31:10];
  assign current_line_index = wr_current_addr[9:4];
  assign current_byte_offset = wr_current_addr[3:0];
  assign current_word_offset = wr_current_addr[3:2];
  
//   assign victim_line_base = {cache_tag[current_line_index],current_line_index,4'b0000};
    
  assign lookup_tag    = current_line_tag;
  assign lookup_index  = current_line_index;
  assign lookup_offset = current_byte_offset;
  assign word_offset   = current_word_offset;
  
  assign beat_bytes  = (1 << wr_size);
  assign burst_bytes = (wr_len + 1) * beat_bytes;
  assign wr_aligned_addr = (wr_addr/beat_bytes)*beat_bytes;
  assign wrap_base_addr = (wr_aligned_addr / burst_bytes) * burst_bytes;
  assign wrap_limit_addr = wrap_base_addr + burst_bytes;
//   assign line_boundary_cross = (beat_start_addr[31:4] != beat_end_addr[31:4]);
  
// write back state output logic
  assign S_WREADY = (wr_state == WR_BYPASS) ? M_WREADY : (wr_state == WR_BUFFER_CAPTURE && S_WVALID ) ? 1'b1 : (wr_state == WR_HIT) ? 1'b1 : (wr_state == WR_PROTECTION) ? 1'b1 : 1'b0;
  assign S_BVALID  = (wr_state == WR_BYPASS) ? M_BVALID  : wr_bvalid;
  assign S_BID     = (wr_state == WR_BYPASS) ? M_BID     : wr_bid;
  assign S_BRESP = (wr_state == WR_BYPASS) ? M_BRESP : (wr_state == WR_RESPONSE || wr_state == WR_BUFFER_DRAIN) ? wr_bresp : 2'bxx;
  assign S_AWREADY = (wr_state == WR_IDLE && wr_bypassable) ? M_AWREADY :
                   (wr_state == WR_IDLE && wr_bufferable) ? 1'b1 :
                   (wr_state == WR_IDLE && !wr_bypassable && (S_AWCACHE[2] || S_AWCACHE[3])) ? 1'b1 : 1'b0;

  
// write back data calculation  
  always@(*)
    begin
      if(wr_state == WR_BYPASS)
        M_WDATA = S_WDATA;
      else if(wr_state == WR_BUFFER_DRAIN && M_WVALID && M_WREADY)
        M_WDATA = buffer_mem[0].buffer_memory[wr_buf_beat_idx];
      else
        begin
          case(wb_beat_count)
            2'd0: M_WDATA = cache_data[current_line_index][0];
            2'd1: M_WDATA = cache_data[current_line_index][1];
            2'd2: M_WDATA = cache_data[current_line_index][2];
            2'd3: M_WDATA = cache_data[current_line_index][3];
            default: M_WDATA = 32'd0;
          endcase
        end
    end
  
  
// next address calculation
  always@(*)
    begin
      case(wr_burst)
        2'b00 : burst_next_addr = wr_current_addr;
        2'b01 : burst_next_addr = wr_current_addr + beat_bytes;
        2'b10 :
          begin
            if((wr_current_addr + beat_bytes) >= wrap_limit_addr)
              burst_next_addr = wrap_base_addr;
            else
              burst_next_addr = wr_current_addr + beat_bytes;
          end
        default : burst_next_addr = wr_current_addr;
      endcase
    end
// address for narrow transfer 
 // address for narrow transfer / unaligned beats
  always @(*) 
    begin
      byte_addr0 = wr_current_addr;
      byte_addr1 = wr_current_addr + 32'd1;
      byte_addr2 = wr_current_addr + 32'd2;
      byte_addr3 = wr_current_addr + 32'd3;
    end
  
  always@(posedge ACLK)
    begin
      if(!ARESETn)
        wr_state <= WR_IDLE;
      else
        begin
          case(wr_state)
            WR_IDLE :
              begin
                if(S_AWVALID && S_AWREADY)
                  begin
                    if(S_AWCACHE == 4'b0000)
                      wr_state <= WR_BYPASS;
                    else if(S_AWCACHE == 4'b0001)
                      begin
                        buffer_mem[0].id          <= S_AWID;
                        buffer_mem[0].addr        <= S_AWADDR;
                        buffer_mem[0].beat_count  <= S_AWLEN;
                        buffer_mem[0].burst       <= S_AWBURST;
                        buffer_mem[0].prot        <= S_AWPROT;
                        buffer_mem[0].awsize      <= S_AWSIZE;
                        buffer_mem[0].lock_access <= S_AWLOCK;
                        wr_id                     <= S_AWID;
                        wr_addr                   <= S_AWADDR;
                        wr_len                    <= S_AWLEN;
                        wr_size                   <= S_AWSIZE;
                        wr_burst                  <= S_AWBURST;
                        wr_prot                   <= S_AWPROT;
                        wr_lock                   <= S_AWLOCK;
                        wr_state                  <= WR_BUFFER_CAPTURE;
                        wr_beat_count             <= 8'd0;
                      end
                    else
                      begin
                        wr_id           <= S_AWID;
                        wr_addr         <= S_AWADDR;
                        wr_len          <= S_AWLEN;
                        wr_size         <= S_AWSIZE;
                        wr_burst        <= S_AWBURST;
                        wr_lock         <= S_AWLOCK;
                        wr_cache        <= S_AWCACHE;
                        wr_prot         <= S_AWPROT;
                        wr_current_addr <= S_AWADDR;
                        wr_beat_count   <= 8'd0;
                    
                        wr_state <= WR_VALIDATE;
                      end
                  end
              end
            
            WR_VALIDATE :
              begin
                if(wr_protection_error)
                  wr_state <= WR_PROTECTION;
                else if(wr_size_error)
                  begin
                    wr_bid    <= wr_id;
                    wr_bresp  <= 2'b10;
                    wr_bvalid <= 1'b1;
                    wr_state  <= WR_RESPONSE; 
                  end
                else if(wr_burst_error)
                  begin
                    wr_bid    <= wr_id;
                    wr_bresp  <= 2'b10;
                    wr_bvalid <= 1'b1;
                    wr_state  <= WR_RESPONSE; 
                  end
                else if(wr_4kb_error)
                  begin
                    wr_bid    <= wr_id;
                    wr_bresp  <= 2'b10;
                    wr_bvalid <= 1'b1;
                    wr_state  <= WR_RESPONSE; 
                  end
                else if (wr_write_allocate || wr_other_allocate)
                  wr_state <= WR_LOOKUP;
              end
            
            WR_LOOKUP :
              begin
                if(cache_valid[current_line_index] && cache_tag[current_line_index] == current_line_tag)
                  begin
                    cache_hit  <= 1'b1;
                    cache_miss <= 1'b0;
                    wr_state   <= WR_HIT;
                  end
                else
                  begin
                    cache_hit  <= 1'b0;
                    cache_miss <= 1'b1;
                    wr_state   <= WR_MISS;
                  end
              end
           WR_HIT :
              begin
                if(S_WVALID && S_WREADY)
                  begin
                    if(beat_cross_line)
                      begin
                        if(S_WLAST && (wr_beat_count != wr_len))
                          begin
                            wr_bid    <= wr_id;
                            wr_bresp  <= 2'b10;
                            wr_bvalid <= 1'b1;
                            wr_state  <= WR_RESPONSE;
                          end
                        else
                          begin
                            pending_wdata        <= S_WDATA;
                            pending_wstrb        <= S_WSTRB;
                            pending_wlast        <= S_WLAST;
                            pending_beat_addr    <= wr_current_addr;
                            pending_next_addr    <= burst_next_addr;
                            
                            cross_index          <= beat_second_index;
                            cross_tag            <= second_line_tag;
                            cross_line_base      <= {beat_end_addr[31:4],4'b0000};
                            cross_refill_pending <= 1'b0;
                            pending_first_index  <= beat_start_addr[9:4];
                            pending_second_index <= beat_end_addr[9:4];
                            wr_state             <= WR_BEAT_CROSS;
                          end
                      end
                    else
                      begin
                        // case 1 : WLAST arrived too early
                        if(S_WLAST && (wr_beat_count != wr_len))
                          begin
                            wr_bid    <= wr_id;
                            wr_bresp  <= 2'b10;
                            wr_bvalid <= 1'b1;
                            wr_state  <= WR_RESPONSE;
                          end
                        
                   // Case 2 : Expected final beat
                        else if (wr_beat_count == wr_len) 
                          begin
                            if (S_WLAST)
                              begin
                                if (S_WSTRB[0]) cache_data[current_line_index][current_word_offset][7:0]   <= S_WDATA[7:0];
                                if (S_WSTRB[1]) cache_data[current_line_index][current_word_offset][15:8]  <= S_WDATA[15:8];
                                if (S_WSTRB[2]) cache_data[current_line_index][current_word_offset][23:16] <= S_WDATA[23:16];
                                if (S_WSTRB[3]) cache_data[current_line_index][current_word_offset][31:24] <= S_WDATA[31:24];
                                cache_dirty[current_line_index] <= 1'b1;
                                wr_bid    <= wr_id;
                                wr_bresp  <= 2'b00;
                                wr_bvalid <= 1'b1;
                                wr_state  <= WR_RESPONSE;
                              end 
                            else 
                              begin
                                wr_bid    <= wr_id;
                                wr_bresp  <= 2'b10;
                                wr_bvalid <= 1'b1;
                                wr_state  <= WR_RESPONSE;
                              end
                          end
                        // Case 3 : Normal non-final beat
                        else 
                          begin
                            if (S_WSTRB[0]) cache_data[current_line_index][current_word_offset][7:0]   <= S_WDATA[7:0];
                            if (S_WSTRB[1]) cache_data[current_line_index][current_word_offset][15:8]  <= S_WDATA[15:8];
                            if (S_WSTRB[2]) cache_data[current_line_index][current_word_offset][23:16] <= S_WDATA[23:16];
                            if (S_WSTRB[3]) cache_data[current_line_index][current_word_offset][31:24] <= S_WDATA[31:24];
                            cache_dirty[current_line_index] <= 1'b1;
                            wr_beat_count   <= wr_beat_count + 1'b1;
                            wr_current_addr <= burst_next_addr;
                            wr_state        <= WR_LOOKUP;
                          end
                      end
                  end
              end

            WR_MISS :
              begin
                if(cache_valid[current_line_index] && cache_dirty[current_line_index])
                  begin
                    victim_valid <= 1'b1;
                    victim_dirty <= 1'b1;
                    wb_awid       <= wr_id;
                    wb_awlen      <= 8'd3;
                    wb_awsize     <= 3'd2;
                    wb_awburst    <= 2'b01;
                    victim_addr  <= {cache_tag[current_line_index],current_line_index,4'b0000};

                    wb_beat_count <= 2'd0;
                    wb_aw_done    <= 1'b0;
                    wb_b_done     <= 1'b0;
                    wr_state     <= WR_WRITEBACK;
                  end
                else
                  begin
                    victim_valid  <= cache_valid[current_line_index];
                    victim_dirty <= 1'b0;
                    victim_addr  <= {cache_tag[current_line_index],current_line_index,4'b0000};;
                    refill_ar_done  <= 1'b0;
                    refill_r_done   <= 1'b0;
                    refill_error    <= 1'b0;
                    line_beat_count <= 2'd0;

                    wr_state     <= WR_REFILL;
                  end
              end
            WR_WRITEBACK :
              begin
                $display("[%0t] WRITEBACK: wb_aw_done=%b wb_b_done=%b wb_beat_count=%0d M_AWVALID=%b M_AWREADY=%b M_WVALID=%b M_WREADY=%b M_BVALID=%b M_BREADY=%b",$time,wb_aw_done,wb_b_done,wb_beat_count,M_AWVALID,M_AWREADY,M_WVALID,M_WREADY,M_BVALID,M_BREADY);
                $display("[%0t] writebach AWID : %d, AWLEN : %d,AWSIZE : %d ,BURST : %b , addr :%b",$time,M_AWID,M_AWLEN,M_AWSIZE,M_AWBURST,victim_addr);
                // AW channel handshake
                if(!wb_aw_done)
                  begin
                    if(M_AWVALID && M_AWREADY)
                      begin
                        wb_aw_done <= 1'b1;
                        wb_beat_count <= 2'd0;
                      end
                  end
                // W channel handshake
                if(wb_aw_done && !wb_b_done)
                  begin
                    if(M_WVALID && M_WREADY)
                      begin
                        if(wb_beat_count == 2'd3)
                          wb_b_done <= 1'b1;
                        else
                          wb_beat_count <= wb_beat_count + 1'b1;
                      end
                  end
                // B channel handshake
                if(wb_b_done)
                  begin
                    if(M_BVALID && M_BREADY)
                      begin
                        if(M_BID != wr_id)
                          begin
                            wr_bid     <= wr_id;
                            wr_bresp   <= 2'b10;
                            wr_bvalid  <= 1'b1;
                            wr_state   <= WR_RESPONSE;
                          end
                        else if(M_BRESP != 2'b00)
                          begin
                            wr_bid    <= wr_id;
                            wr_bresp  <= M_BRESP;
                            wr_bvalid <= 1'b1;
                            
                            wr_state  <= WR_RESPONSE;
                          end
                        
                        else
                          begin
                            cache_dirty[current_line_index] <= 1'b0;
                            wb_aw_done <= 1'b0;
                            wb_b_done  <= 1'b0;
                            wb_beat_count <= 2'd0;
                            refill_ar_done  <= 1'b0;
                            refill_r_done   <= 1'b0;
                            refill_error    <= 1'b0;
                            line_beat_count <= 2'd0;
                            
                            wr_state <= WR_REFILL;
                          end
                      end
                  end
              end
            WR_REFILL :
              begin
                // AR channel handshake
                if(!refill_ar_done)
                  begin
                    if(M_ARVALID && M_ARREADY)
                      begin
                        refill_ar_done  <= 1'b1;
                        line_beat_count <= 2'd0;
                      end
                  end
                // R channel
               else if(refill_ar_done && !refill_r_done)
                  begin
                    if(M_RVALID && M_RREADY)
                      begin
                        refill_data[line_beat_count] <= M_RDATA;
                        
                        if(M_RID != wr_id)
                          begin
                            refill_error      <= 1'b1;
                            refill_error_resp <= 2'b10;
                          end
                        if(M_RRESP != 2'b00)
                          begin
                            refill_error      <= 1'b1;
                            refill_error_resp <= M_RRESP;
                          end
                        
                        if(line_beat_count == 2'd3)
                          begin
                            if(M_RLAST)
                              refill_r_done <= 1'b1;
                            else
                              begin
                                refill_error      <= 1'b1;
                                refill_error_resp <= 2'b10;
                                refill_r_done     <= 1'b1;
                              end
                          end
                        else
                          begin
                            if(M_RLAST)
                              begin
                                refill_error      <= 1'b1;
                                refill_error_resp <= 2'b10;
                                refill_r_done     <= 1'b1;
                              end
                            
                            else
                              line_beat_count <= line_beat_count + 1'b1;
                          end
                      end
                  end
                
                // Refill complete
                
                if(refill_r_done)
                  begin
                    refill_ar_done <= 1'b0;
                    refill_r_done  <= 1'd0;
                    line_beat_count <= 2'd0;
                    wr_state <= WR_UPDATE;
                  end
              end
            
            WR_UPDATE :
              begin
                if(!refill_error)
                  begin
                    if(cross_refill_pending)
                      begin
                        cache_tag[cross_index]        <= cross_tag;
                        cache_valid[cross_index]      <= 1'b1;
                        
                        cache_data[cross_index][0]    <= refill_data[0];
                        cache_data[cross_index][1]    <= refill_data[1];
                        cache_data[cross_index][2]    <= refill_data[2];
                        cache_data[cross_index][3]    <= refill_data[3];
                        
                        cache_dirty[cross_index]      <= 1'b0;

                        cross_refill_pending          <= 1'b0;
                        wr_current_addr               <= pending_beat_addr;
                        wr_state                      <= WR_CROSS_APPLY;
                      end
                    else
                      begin
                        cache_tag[current_line_index]    <= current_line_tag;
                        cache_valid[current_line_index]  <= 1'b1;
                        
                        cache_data[current_line_index][0] <= refill_data[0];
                        cache_data[current_line_index][1] <= refill_data[1];
                        cache_data[current_line_index][2] <= refill_data[2];
                        cache_data[current_line_index][3] <= refill_data[3];
                        
                        cache_dirty[current_line_index]   <= 1'b0;
                        
                        wr_state <= WR_HIT;
                      end
                  end
                else
                  begin
                    wr_bid               <= wr_id;
                    wr_bresp             <= refill_error_resp;
                    wr_bvalid            <= 1'b1;
                    wr_state             <= WR_RESPONSE;
                    cross_refill_pending <= 1'b0;
                  end
              end
                
            WR_BEAT_CROSS:
                begin
                  if(cache_valid[beat_second_index] && cache_tag[beat_second_index] == second_line_tag)
                    begin
                      cross_refill_pending <= 1'b0;
                      wr_state <= WR_CROSS_APPLY;
                    end
                  else
                    begin
                      cross_refill_pending <= 1'b1;
                      wr_current_addr <= cross_line_base;
                      wr_state <= WR_MISS;
                    end
                end
                
            WR_CROSS_APPLY:
              begin
                // Byte Lane 0 (S_WDATA[7:0], S_WSTRB[0])
                if (pending_wstrb[0]) begin
                  if (pending_beat_addr[1:0] == 2'd0)
                    cache_data[pending_first_index][2'd3][7:0]   <= pending_wdata[7:0];
                  else
                    cache_data[pending_second_index][2'd0][7:0]  <= pending_wdata[7:0];
                end

                // Byte Lane 1 (S_WDATA[15:8], S_WSTRB[1])
                if (pending_wstrb[1]) begin
                  if (pending_beat_addr[1:0] <= 2'd1)
                    cache_data[pending_first_index][2'd3][15:8]  <= pending_wdata[15:8];
                  else
                    cache_data[pending_second_index][2'd0][15:8] <= pending_wdata[15:8];
                end

                // Byte Lane 2 (S_WDATA[23:16], S_WSTRB[2])
                if (pending_wstrb[2]) begin
                  if (pending_beat_addr[1:0] <= 2'd2)
                    cache_data[pending_first_index][2'd3][23:16] <= pending_wdata[23:16];
                  else
                    cache_data[pending_second_index][2'd0][23:16] <= pending_wdata[23:16];
                end

                // Byte Lane 3 (S_WDATA[31:24], S_WSTRB[3])
                if (pending_wstrb[3]) begin
                  cache_data[pending_first_index][2'd3][31:24] <= pending_wdata[31:24];
                end

                cache_dirty[pending_first_index]  <= 1'b1;
                cache_dirty[pending_second_index] <= 1'b1;
                wr_beat_count   <= wr_beat_count + 1'b1;
                wr_current_addr <= pending_next_addr;

                if (pending_wlast)
                  begin
                    wr_bid    <= wr_id;
                    wr_bresp  <= (wr_beat_count == wr_len) ? 2'b00 : 2'b10;
                    wr_bvalid <= 1'b1;
                    wr_state  <= WR_RESPONSE;
                  end 
                else 
                  begin
                    if (wr_beat_count == wr_len)
                      begin
                        wr_bid    <= wr_id;
                        wr_bresp  <= 2'b10;
                        wr_bvalid <= 1'b1;
                        wr_state  <= WR_RESPONSE;
                      end
                    else 
                      begin
                        wr_state  <= WR_LOOKUP;
                      end
                  end
              end
            
            WR_BUFFER_CAPTURE:
              begin
                if (S_WVALID && S_WREADY)
                  begin
                    buffer_mem[0].buffer_memory[wr_beat_count] <= S_WDATA;
                    buffer_mem[0].buffer_strobe[wr_beat_count] <= S_WSTRB;
                    if (S_WLAST || (wr_beat_count == wr_len))
                      begin
                        // Early AXI B-Channel response to master
                        wr_bid          <= wr_id;
                        wr_bresp        <= 2'b00; // OKAY
                        wr_bvalid       <= 1'b1;
                        wb_aw_done      <= 1'b0;
                        wb_b_done       <= 1'b0;
                        wr_buf_beat_idx <= 8'd0;
                        wr_beat_count   <= 8'd0;
                        wr_state        <= WR_BUFFER_DRAIN;
                      end 
                    else 
                      wr_beat_count   <= wr_beat_count + 1'b1;
                  end
              end
            
            WR_BUFFER_DRAIN:
              begin
                // Clear early BVALID once Master completes handshake
                if (S_BREADY)
                  wr_bvalid <= 1'b0;
                // Drain AW handshake to slave memory
                if (!wb_aw_done) 
                  begin
                    if (M_AWVALID && M_AWREADY)
                      wb_aw_done <= 1'b1;
                  end
                // Drain W beats to slave memory
                if(!wb_b_done && wb_aw_done)
                  begin
                    if(M_WVALID && M_WREADY)
                      begin
                        if(wr_buf_beat_idx == buffer_mem[0].beat_count)
                          wb_b_done <= 1'b1;
                        else
                          wr_buf_beat_idx <= wr_buf_beat_idx + 1'b1;
                      end
                  end
                // Complete memory write
                if (wb_b_done && M_BVALID && M_BREADY)
                  begin
                    wb_aw_done      <= 1'b0;
                    wb_b_done       <= 1'b0;
                    wr_buf_beat_idx <= 8'd0;
                    if (!wr_bvalid || S_BREADY) // If master handshake is already done
                      begin
                        wr_bvalid <= 1'b0;
                        wr_state <= WR_IDLE;
                      end
                    else
                      wr_state <= WR_RESPONSE;
                  end
              end
            
            WR_BYPASS:
              begin
                if(M_BVALID && M_BREADY)
                  wr_state <= WR_IDLE;
                else
                  wr_state <= WR_BYPASS;
              end
            
            WR_PROTECTION :
              begin
                if(S_WVALID && S_WREADY)
                  begin
                    if(wr_beat_count == wr_len)
                      begin
                        if(S_WLAST)
                          begin
                            wr_bresp  <= 2'b11;
                            wr_bvalid <= 1'b1;
                            wr_state  <= WR_RESPONSE;
                          end
                      end
                        else
                          begin
                            if(S_WLAST)
                              begin
                                wr_bresp  <= 2'b10;
                                wr_bvalid <= 1'b1;
                                wr_state  <= WR_RESPONSE;
                              end
                            else
                              wr_beat_count <= wr_beat_count + 1'b1;
                          end
                  end
              end
            
            
            WR_RESPONSE :
              begin
                if(S_BREADY && S_BVALID)
                  begin
                    wr_bvalid <= 1'b0;
                    wr_state <= WR_IDLE;
                  end
              end
            default :
              begin
                wr_state <= WR_IDLE;
              end
          endcase
        end
    end

 
// read side cache FSM
  
  typedef enum logic [4:0] {
    RD_IDLE,
    RD_VALIDATE,
    RD_LOOKUP,
    RD_HIT,
    RD_MISS,
    RD_WRITEBACK,
    RD_CROSS_MISS,
    RD_REFILL,
    RD_UPDATE,
    RD_RETURN,
    RD_BYPASS,
    RD_BUF_FETCH,
    RD_BUF_STREAM,
    RD_RESPONSE
} rd_state_t;

rd_state_t rd_state; 
  
// Read transaction registers
  logic [3:0]  rd_id;
  logic [31:0] rd_addr;
  logic [7:0]  rd_len;
  logic [2:0]  rd_size;
  logic [1:0]  rd_burst;
  logic        rd_lock;
  logic [3:0]  rd_cache;
  logic [2:0]  rd_prot;
  
// for address calculation  
  logic [7:0]  rd_beat_count;
  logic [31:0] rd_current_addr;
  logic [31:0] rd_burst_next_addr;
  logic [31:0] rd_word_data;
  logic [31:0] rd_exctract_data;
  logic [31:0] rd_cross_extract_data;
// read burst calculation registers
  logic [31:0] rd_aligned_addr;
  logic [31:0] rd_wrap_base_addr;
  logic [31:0] rd_wrap_limit_addr;
  logic [31:0] rd_last_addr;
  logic [31:0] rd_burst_bytes;
  logic [31:0] rd_beats_bytes;
  logic [31:0] rd_wrap_last_addr;
// read validation errors
  logic rd_size_error;
  logic rd_burst_error;
  logic rd_wrap_len_error;
  logic rd_fixed_len_error;
  logic rd_4kb_error;
// read bufferable register
  logic [7:0] rd_buf_beat_count;
  logic [7:0] rd_buf_send_count;
  logic rd_buf_ar_done;

// read cache lookup registers
  logic [21:0] rd_lookup_tag;
  logic [5:0] rd_lookup_index;
  logic [3:0] rd_lookup_offset;
  logic [1:0] rd_word_offset;
  
  logic [31:0] rd_current_line_base;
  logic [21:0] rd_current_line_tag;
  logic [5:0] rd_current_line_index;
  logic [3:0] rd_current_byte_offset;
  logic [1:0] rd_current_word_offset;
  
// cache hit miss registers
  logic rd_cache_hit;
  logic rd_cache_miss;
  logic rd_victim_dirty;
  logic rd_victim_valid;
  
// read data reponse registers
  
  logic [31:0] rd_rdata;
  logic [3:0] rd_rid;
  logic [1:0] rd_rresp;
  logic       rd_rvalid;
  logic       rd_rlast;
  
// read refill registers
  logic [1:0]  rd_refill_beat_count;
  logic [31:0] rd_refill_data [0:3];
  
  logic       rd_cross_refill_pending;
  logic       rd_refill_ar_done;
  logic       rd_refill_r_done;
  logic       rd_refill_error;
  logic [1:0] rd_refill_error_resp;
  
// read write-back registers
  
  logic [3:0]  rd_wb_awid;
  logic [31:0] rd_wb_awaddr;
  logic [7:0]  rd_wb_awlen;
  logic [2:0]  rd_wb_awsize;
  logic [1:0]  rd_wb_awburst;
  
  logic [1:0] rd_wb_beat_count;
  logic       rd_wb_aw_done;
  logic       rd_wb_b_done;
  
// read bypass and cache register
  logic rd_bypassable;
  logic rd_read_allocate;
  logic rd_other_allocate;
  logic rd_protection_error;
  logic rd_bypass_active;
// read cross-word/cross-line support register
  logic [31:0] rd_beat_end_addr;
  logic        rd_beat_cross_word;
  logic        rd_beat_cross_line;
  
  logic [5:0]  rd_second_index;
  logic [31:0] rd_second_line_base;
  
  logic [31:0] rd_cross_first_data;
  logic [31:0] rd_cross_second_data;
  
  logic [31:0] rd_pending_data;
  logic [31:0] rd_pending_addr;
  logic [7:0]  rd_pending_beat_count;
  
  logic [31:0] rd_cross_first_addr;
  logic [31:0] rd_cross_second_addr;
  
  logic [31:0] rd_saved_addr;
  logic [31:0] rd_extract_data;
  // need to check whether it is used or not
  
  logic [5:0] rd_miss_index;
  logic [21:0] rd_miss_tag;
  logic [1:0] rd_first_word_offset;
  logic [31:0] rd_victim_addr;
// need to check  
  logic [31:0] rd_beat_start_addr;
  logic [5:0]  rd_first_index;
  logic [21:0] rd_second_line_tag;
  logic [31:0] rd_cross_line_base;
  logic [5:0]  rd_cross_index;
  logic [21:0] rd_cross_tag;
  logic [31:0] rd_pending_next_addr;
  
// read write signals
  assign wr_bypass_active = (wr_state == WR_IDLE && wr_bypassable && S_AWVALID);
  assign M_AWID    = wr_bypass_active  ? S_AWID : (wr_state == WR_BUFFER_DRAIN) ? buffer_mem[0].id :  (wr_state == WR_WRITEBACK) ? wb_awid :
                   (rd_state == RD_WRITEBACK) ? rd_wb_awid : wr_id;

assign M_AWADDR  = wr_bypass_active ? S_AWADDR : (wr_state == WR_BUFFER_DRAIN) ? buffer_mem[0].addr :
                   (wr_state == WR_WRITEBACK) ? victim_addr :
                   (rd_state == RD_WRITEBACK) ? rd_victim_addr : wr_addr;

assign M_AWLEN   = wr_bypass_active ? S_AWLEN : (wr_state == WR_BUFFER_DRAIN) ? buffer_mem[0].beat_count : (wr_state == WR_WRITEBACK) ? wb_awlen :
                   (rd_state == RD_WRITEBACK) ? rd_wb_awlen : wr_len;

  assign M_AWSIZE  = wr_bypass_active ? S_AWSIZE : (wr_state == WR_BUFFER_DRAIN) ?buffer_mem[0].awsize :
                   (wr_state == WR_WRITEBACK) ? wb_awsize :
                   (rd_state == RD_WRITEBACK) ? rd_wb_awsize : wr_size;

assign M_AWBURST = wr_bypass_active ? S_AWBURST : (wr_state == WR_BUFFER_DRAIN) ? buffer_mem[0].burst : (wr_state == WR_WRITEBACK) ? wb_awburst :
                   (rd_state == RD_WRITEBACK) ? rd_wb_awburst : wr_burst;

  assign M_AWLOCK  = wr_bypass_active ? S_AWLOCK : (wr_state == WR_BUFFER_DRAIN) ? buffer_mem[0].lock_access : 1'b0;

  assign M_AWCACHE = wr_bypass_active ? S_AWCACHE : (wr_state == WR_BUFFER_DRAIN) ? 4'd0 : (rd_state == RD_WRITEBACK) ? rd_cache : wr_cache;

  assign M_AWPROT  = wr_bypass_active ? S_AWPROT : (wr_state == WR_BUFFER_DRAIN) ? buffer_mem[0].prot :
                   (rd_state == RD_WRITEBACK) ? rd_prot : wr_prot;

assign M_AWVALID = wr_bypass_active ? S_AWVALID : 
                   (wr_state == WR_BUFFER_DRAIN && !wb_aw_done) ? 1'b1 : 
                   (wr_state == WR_WRITEBACK    && !wb_aw_done) ? 1'b1 :
                   (rd_state == RD_WRITEBACK    && !rd_wb_aw_done) ? 1'b1 : 1'b0;
  
  assign M_WSTRB = (wr_state == WR_BYPASS) ? S_WSTRB :(wr_state == WR_BUFFER_DRAIN) ? buffer_mem[0].buffer_strobe[wr_buf_beat_idx]:(rd_state == RD_WRITEBACK) ? 4'b1111 : 4'b1111;
  
 assign M_WVALID = (wr_state == WR_BYPASS) ? S_WVALID : 
                  (wr_state == WR_BUFFER_DRAIN && !wb_b_done) ? 1'b1 : 
                  ((wr_state == WR_WRITEBACK) && wb_aw_done && !wb_b_done) ? 1'b1 : 
                  ((rd_state == RD_WRITEBACK) && rd_wb_aw_done && !rd_wb_b_done) ? 1'b1 : 1'b0;
  
  assign M_WLAST = (wr_state == WR_BYPASS) ? S_WLAST : 
                 (wr_state == WR_BUFFER_DRAIN) ? (M_WVALID && (wr_buf_beat_idx == buffer_mem[0].beat_count)) : 
                 (rd_state == RD_WRITEBACK && M_WVALID && rd_wb_beat_count == 2'd3) ? 1'b1 : 
                 (wr_state == WR_WRITEBACK && M_WVALID && wb_beat_count == 2'd3) ? 1'b1 : 1'b0;
  
  assign M_BREADY = (wr_state == WR_BYPASS) ? S_BREADY : 
                  (wr_state == WR_BUFFER_DRAIN || wr_state == WR_RESPONSE) ? 1'b1 : 
                  (wr_state == WR_WRITEBACK && wb_b_done) ? 1'b1 : 
                  (rd_state == RD_WRITEBACK && rd_wb_b_done) ? 1'b1 : 1'b0;
// Master AR Channel Controls
  assign rd_bypass_active = (rd_state == RD_IDLE && rd_bypassable && S_ARVALID);
  assign M_ARID    = rd_bypass_active ? S_ARID : (rd_state == RD_BUF_FETCH) ? rd_id :
                   (wr_state == WR_REFILL) ? wr_id :
                   (rd_state == RD_REFILL) ? rd_id : 4'd0;

  assign M_ARADDR  = rd_bypass_active ? S_ARADDR : (rd_state == RD_BUF_FETCH) ? rd_addr :
                   (wr_state == WR_REFILL) ? (cross_refill_pending ? cross_line_base : current_line_base) :
                   (rd_state == RD_REFILL) ? (rd_cross_refill_pending ? rd_cross_line_base : rd_current_line_base) : 32'd0;

  assign M_ARLEN   = rd_bypass_active ? S_ARLEN : (rd_state == RD_BUF_FETCH) ? rd_len :
                   (wr_state == WR_REFILL || rd_state == RD_REFILL) ? 8'd3 : 8'd0;

  assign M_ARSIZE  = rd_bypass_active ? S_ARSIZE : (rd_state == RD_BUF_FETCH) ? rd_size :
                   (wr_state == WR_REFILL || rd_state == RD_REFILL) ? 3'd2 : 3'd0;

  assign M_ARBURST = rd_bypass_active ? S_ARBURST : (rd_state == RD_BUF_FETCH) ? rd_burst :
                   (wr_state == WR_REFILL || rd_state == RD_REFILL) ? 2'b01 : 2'b00;

  assign M_ARLOCK  = rd_bypass_active ? S_ARLOCK : (rd_state == RD_BUF_FETCH) ? rd_lock :1'b0;

  assign M_ARCACHE = rd_bypass_active ? S_ARCACHE : (rd_state == RD_BUF_FETCH) ? rd_cache :
                   (wr_state == WR_REFILL) ? wr_cache :
                   (rd_state == RD_REFILL) ? rd_cache : 4'd0;

  assign M_ARPROT  = rd_bypass_active ? S_ARPROT : (rd_state == RD_BUF_FETCH) ? rd_prot :
                   (wr_state == WR_REFILL) ? wr_prot :
                   (rd_state == RD_REFILL) ? rd_prot : 3'd0;

  assign M_ARVALID = rd_bypass_active ? S_ARVALID :
                     (rd_state == RD_BUF_FETCH && !rd_buf_ar_done) ? 1'b1 :
                     (wr_state == WR_REFILL    && !refill_ar_done) ? 1'b1 : 
                     (rd_state == RD_REFILL    && !rd_refill_ar_done) ? 1'b1 : 1'b0;

  assign S_ARREADY = (rd_state == RD_IDLE && rd_bypassable) ? M_ARREADY :
                   (rd_state == RD_IDLE && S_ARCACHE == 4'b0001) ? 1'b1 :
                   (rd_state == RD_IDLE && !rd_bypassable && (S_ARCACHE[2] || S_ARCACHE[3])) ? 1'b1 : 1'b0;

  assign M_RREADY  = (rd_state == RD_BYPASS || rd_bypass_active) ? S_RREADY : 
                     (rd_state == RD_BUF_FETCH && rd_buf_ar_done) ? 1'b1 :
                     ((wr_state == WR_REFILL && refill_ar_done && !refill_r_done) || 
                      (rd_state == RD_REFILL && rd_refill_ar_done && !rd_refill_r_done));
  
// bufferable transfer
  assign rd_bufferable = (S_ARCACHE == 4'b0001) ? 1'b1 : 1'b0;
// read validation 

  assign rd_size_error     = (rd_size > 3'd2) ? 1'b1 : 1'b0;
  assign rd_wrap_len_error = (rd_burst == 2'b10) && !((rd_len == 8'd1) || (rd_len == 8'd3) || (rd_len == 8'd7) || (rd_len == 8'd15));
  assign rd_fixed_len_error = (rd_burst == 2'b00) && (rd_len > 8'd15);
  assign rd_burst_error     = (rd_burst == 2'b11) || rd_wrap_len_error || rd_fixed_len_error;
  assign rd_4kb_error       = (rd_burst == 2'b01) ? (rd_addr[31:12] != rd_last_addr[31:12] || rd_last_addr > 4095) : (rd_burst == 2'b10) ? (rd_wrap_base_addr[31:12] != rd_wrap_last_addr[31:12] || rd_last_addr > 4095) : 1'b0;
  assign rd_protection_error = (rd_prot[1] || rd_prot[2]) ? 1'b1 : 1'b0;
// read cache lookup
  assign rd_current_line_base  = rd_current_addr & 32'hFFFFFFF0;
  assign rd_current_line_tag   = rd_current_addr[31:10];
  assign rd_current_line_index = rd_current_addr[9:4];
  assign rd_current_byte_offset = rd_current_addr[3:0];
  assign rd_current_word_offset = rd_current_addr[3:2];
  assign rd_lookup_tag = rd_current_line_tag;
  assign rd_lookup_index = rd_current_line_index;
  assign rd_lookup_offset = rd_current_byte_offset;
  assign rd_word_offset  = rd_current_word_offset;
  assign rd_first_word_offset = rd_beat_start_addr[3:2];

  assign rd_cross_first_data = cache_data[rd_first_index][rd_first_word_offset];
  assign rd_cross_second_data = rd_beat_cross_line ? cache_data[rd_second_index][2'd0] : cache_data[rd_first_index][rd_first_word_offset + 1'b1];
  
// cacheable declaration
  assign rd_bypassable = (S_ARCACHE == 4'b0000) ? 1'b1 : 1'b0;
  assign rd_read_allocate = rd_cache[2];
  assign rd_other_allocate = rd_cache[3];
  
// read burst address calculation

  assign rd_beats_bytes  = (1 << rd_size);
  assign rd_burst_bytes  = (rd_len + 1) * rd_beats_bytes;
  assign rd_aligned_addr = (rd_addr / rd_beats_bytes) * rd_beats_bytes;
  assign rd_wrap_base_addr = (rd_aligned_addr / rd_burst_bytes) * rd_burst_bytes;
  assign rd_wrap_limit_addr = rd_wrap_base_addr + rd_burst_bytes;
  assign rd_last_addr   = rd_addr + rd_burst_bytes-1;
  assign rd_wrap_last_addr = rd_wrap_limit_addr-1;
//calculation of end address of the current read beat and detect word and line crossing 
  assign rd_beat_cross_word = (rd_current_addr[31:2] != rd_beat_end_addr[31:2]);
  assign rd_second_line_base = rd_beat_end_addr & 32'hFFFFFFF0;
  
  assign rd_beat_start_addr = rd_current_addr;
  assign rd_beat_end_addr = rd_current_addr + rd_beats_bytes - 1;
  assign rd_beat_cross_line = (rd_beat_start_addr[31:4] != rd_beat_end_addr[31:4]);
  assign rd_first_index = rd_beat_start_addr[9:4];
  assign rd_second_index = rd_beat_end_addr[9:4];
  assign rd_second_line_tag = rd_beat_end_addr[31:10];
  assign rd_cross_line_base = {rd_beat_end_addr[31:4],4'b0000};
    
//read signal

  
 assign S_RID    = (rd_state == RD_BYPASS)     ? M_RID : rd_id;
assign S_RDATA  = (rd_state == RD_BYPASS)     ? M_RDATA : 
                  (rd_state == RD_BUF_STREAM) ? buffer_mem[0].buffer_memory[rd_buf_send_count]:rd_rdata;
assign S_RRESP  = (rd_state == RD_BYPASS)     ? M_RRESP : 
                    (rd_state == RD_BUF_STREAM) ? 2'b00 : 
                    rd_rresp;
assign S_RVALID = (rd_state == RD_BYPASS)     ? M_RVALID : 
                  (rd_state == RD_BUF_STREAM) ? 1'b1 : rd_rvalid;
assign S_RLAST  = (rd_state == RD_BYPASS)     ? M_RLAST : (rd_state == RD_BUF_STREAM) ? (rd_buf_send_count == rd_len) : rd_rlast;
//read burst address assigning
  always@(*)
    begin
      case(rd_burst)
        2'b00 : rd_burst_next_addr = rd_current_addr;
        2'b01 : rd_burst_next_addr = rd_current_addr + rd_beats_bytes;
        2'b10 :
          begin
            if((rd_current_addr + rd_beats_bytes) >= rd_wrap_limit_addr)
              rd_burst_next_addr = rd_wrap_base_addr;
            else
              rd_burst_next_addr = rd_current_addr + rd_beats_bytes;
          end
        default : rd_burst_next_addr = rd_current_addr;
      endcase
    end
  
// read don't cross a word
  
  always@(*)
    begin
      rd_extract_data = 32'd0;
      case(rd_size)
        // 1 BYTE
        3'd0:
          begin
            case(rd_current_addr[1:0])
              2'd0: rd_extract_data[7:0] = rd_cross_first_data[7:0];
              2'd1: rd_extract_data[15:8] = rd_cross_first_data[15:8];
              2'd2: rd_extract_data[23:16] = rd_cross_first_data[23:16];
              2'd3: rd_extract_data[31:24] = rd_cross_first_data[31:24];
            endcase
          end
        
        // 2 BYTE
        3'd1:
          begin
            case(rd_current_addr[1:0])
              2'd0: rd_extract_data[15:0] = rd_cross_first_data[15:0];
              2'd1: rd_extract_data[23:8] = rd_cross_first_data[23:8];
              2'd2: rd_extract_data[31:16] = rd_cross_first_data[31:16];
              default: rd_extract_data = 32'd0;
            endcase
          end

        // 4 BYTE
        3'd2:
          begin
            if(rd_current_addr[1:0] == 2'd0)
              rd_extract_data = rd_cross_first_data;
            else
              rd_extract_data = 32'd0;
          end
        default:rd_extract_data = 32'd0;
      endcase
    end
  
// cross word extraction
  
 // Cross-word / Cross-line extraction keeping native bus byte lanes
always @(*) 
  begin
    rd_cross_extract_data = 32'd0;
    case (rd_size)
      // 2-Byte Transfer
      3'd1: 
        begin
          if (rd_current_addr[1:0] == 2'd3) 
            begin
              rd_cross_extract_data[31:24] = rd_cross_first_data[31:24];
        rd_cross_extract_data[7:0]   = rd_cross_second_data[7:0];
            end
        end
      // 4-Byte Transfer (Unaligned)
      3'd2:
        begin
          case (rd_current_addr[1:0])
            2'd1:
              begin
                rd_cross_extract_data[7:0]   = rd_cross_second_data[7:0];  // Byte 0 in next word
                rd_cross_extract_data[15:8]  = rd_cross_first_data[15:8];  // Byte 1
                rd_cross_extract_data[23:16] = rd_cross_first_data[23:16]; // Byte 2
                rd_cross_extract_data[31:24] = rd_cross_first_data[31:24]; // Byte 3
              end
            2'd2:
              begin
                rd_cross_extract_data[7:0]   = rd_cross_second_data[7:0];
                rd_cross_extract_data[15:8]  = rd_cross_second_data[15:8];
                rd_cross_extract_data[23:16] = rd_cross_first_data[23:16];
                rd_cross_extract_data[31:24] = rd_cross_first_data[31:24];
              end
            2'd3:
              begin
                rd_cross_extract_data[7:0]   = rd_cross_second_data[7:0];
                rd_cross_extract_data[15:8]  = rd_cross_second_data[15:8];
                rd_cross_extract_data[23:16] = rd_cross_second_data[23:16];
                rd_cross_extract_data[31:24] = rd_cross_first_data[31:24];
              end
            default: rd_cross_extract_data = 32'd0;
          endcase
        end
      default: rd_cross_extract_data = 32'd0;
    endcase
  end
  
  always@(*)
    begin
      if(rd_state == RD_WRITEBACK)
        begin
          case(rd_wb_beat_count)
            2'd0 : M_WDATA = cache_data[rd_miss_index][0];
            2'd1 : M_WDATA = cache_data[rd_miss_index][1];
            2'd2 : M_WDATA = cache_data[rd_miss_index][2];
            2'd3 : M_WDATA = cache_data[rd_miss_index][3];
            default : M_WDATA  = 32'd0;
          endcase
        end
      else if(wr_state == WR_BYPASS)
        M_WDATA = S_WDATA;
      else
        M_WDATA = 32'd0;
    end
  
  always@(posedge ACLK)
    begin
      if(!ARESETn)
        begin
          rd_state <= RD_IDLE;
          
          rd_id       <= 4'd0;
          rd_addr     <= 32'd0;
          rd_len      <= 8'd0;
          rd_size     <= 3'd0;
          rd_burst    <= 2'd0;
          rd_lock     <= 1'b0;
          rd_cache    <= 4'd0;
          rd_prot     <= 3'd0;
          
          rd_beat_count   <= 8'd0;
          rd_current_addr <= 32'd0;
          
          rd_cache_hit    <= 1'b0;
          rd_cache_miss <= 1'b0;
          
          rd_rdata  <= 32'd0;
          rd_rid    <= 4'd0;
          rd_rresp  <= 2'b00;
          rd_rvalid <= 1'b0;
          rd_rlast  <= 1'b0;
          
          rd_refill_ar_done    <= 1'b0;
          rd_refill_r_done     <= 1'b0;
          rd_refill_beat_count <= 2'd0;
          rd_refill_error      <= 1'b0;
          rd_refill_error_resp <= 2'b00;
          
          rd_cross_refill_pending <= 1'b0;
          rd_buf_ar_done     <= 1'b0;
          rd_buf_beat_count  <= 8'd0;
          rd_buf_send_count  <= 8'd0;
        end
      else
        begin
          case(rd_state)
            RD_IDLE :
              begin
                if(S_ARVALID && S_ARREADY)
                  begin
                    if(S_ARCACHE == 4'b0000)
                      rd_state <= RD_BYPASS;
                    else if(S_ARCACHE == 4'b0001)
                      begin
                        rd_id            <= S_ARID;
                        rd_addr          <= S_ARADDR;
                        rd_len           <= S_ARLEN;
                        rd_size          <= S_ARSIZE;
                        rd_burst         <= S_ARBURST;
                        rd_lock          <= S_ARLOCK;
                        rd_cache         <= S_ARCACHE;
                        rd_prot          <= S_ARPROT;
                        rd_buf_ar_done   <= 1'b0;
                        rd_buf_beat_count<= 8'd0;
                        rd_buf_send_count<= 8'd0;
                        rd_state         <= RD_BUF_FETCH;
                      end
                    else
                      begin
                        rd_id     <= S_ARID;
                        rd_addr   <= S_ARADDR;
                        rd_len    <= S_ARLEN;
                        rd_size   <= S_ARSIZE;
                        rd_burst  <= S_ARBURST;
                        rd_lock   <= S_ARLOCK;
                        rd_cache  <= S_ARCACHE;
                        rd_prot   <= S_ARPROT;
                        rd_current_addr <= S_ARADDR;
                        rd_beat_count   <= 8'd0;
                        rd_state        <= RD_VALIDATE;
                      end
                  end
              end
            
            RD_VALIDATE :
              begin
                if(rd_protection_error)
                  begin
                    rd_rid    <= rd_id;
                    rd_rresp  <= 2'b11;
                    rd_rvalid <= 1'b1;
                    rd_rlast  <= 1'b1;
                    
                    rd_state  <= RD_RESPONSE;
                  end
                else if(rd_size_error)
                  begin
                    rd_rid    <= rd_id;
                    rd_rresp  <= 2'b10;
                    rd_rvalid <= 1'b1;
                    rd_rlast  <= 1'b1;
                    
                    rd_state  <= RD_RESPONSE;
                  end
                else if(rd_burst_error)
                  begin
                    rd_rid    <= rd_id;
                    rd_rresp  <= 2'b10;
                    rd_rvalid <= 1'b1;
                    rd_rlast  <= 1'b1;
                    
                    rd_state  <= RD_RESPONSE;
                  end
                else if(rd_4kb_error)
                  begin
                    rd_rid    <= rd_id;
                    rd_rresp  <= 2'b10;
                    rd_rvalid <= 1'b1;
                    rd_rlast  <= 1'b1;
                    
                    rd_state  <= RD_RESPONSE;
                  end
                else if(rd_read_allocate || rd_other_allocate)
                  rd_state <= RD_LOOKUP;
              end
            RD_LOOKUP :
              begin
                if(cache_valid[rd_current_line_index] && cache_tag[rd_current_line_index] == rd_current_line_tag)
                  begin
                    rd_cache_hit  <= 1'b1;
                    rd_cache_miss <= 1'b0;
                    
                    rd_state  <= RD_HIT;
                  end
                else
                  begin
                    rd_cache_hit  <= 1'b0;
                    rd_cache_miss <= 1'b1;
                    
                    rd_state  <= RD_MISS;
                  end
              end
            
            RD_HIT :
              begin
                if(rd_beat_cross_line)
                  begin
                    rd_pending_addr  <= rd_current_addr;
                    rd_pending_beat_count <= rd_beat_count;
                    rd_state  <= RD_CROSS_MISS;
                  end
                else
                  begin
                    rd_rid    <= rd_id;
                    rd_rdata  <= rd_beat_cross_word ? rd_cross_extract_data : rd_extract_data;
                    rd_rresp  <= 2'b00;
                    rd_rvalid <= 1'b1;
                    
                    if(rd_beat_count == rd_len)
                      rd_rlast <= 1'b1;
                    else
                      rd_rlast <= 1'b0;
                    
                    rd_state <= RD_RETURN;
                  end
              end
            
            RD_MISS :
              begin
                rd_miss_index <= rd_current_line_index;
                rd_miss_tag   <= rd_current_line_tag;
                if(cache_valid[rd_current_line_index] && cache_dirty[rd_current_line_index])
                  begin
                    rd_victim_valid  <= 1'b1;
                    rd_victim_dirty  <= 1'b1;
                    rd_victim_addr   <= {cache_tag[rd_current_line_index],rd_current_line_index, 4'b0000};
                    rd_wb_awid    <= rd_id;
                    rd_wb_awlen   <= 8'd3;
                    rd_wb_awburst <= 2'b01;
                    rd_wb_awsize  <= 3'd2;
                    
                    
                    rd_wb_beat_count  <= 2'd0;
                    rd_wb_aw_done     <= 1'b0;
                    rd_wb_b_done      <= 1'b0;
                    
                    rd_state  <= RD_WRITEBACK;
                  end
                else
                  begin
                    rd_victim_valid  <= cache_valid[rd_current_line_index];
                    rd_victim_dirty  <= 1'b0;
                    rd_victim_addr       <= {cache_tag[rd_current_line_index], rd_current_line_index, 4'b0000};
                    
                    rd_refill_ar_done    <= 1'b0;
                    rd_refill_r_done     <= 1'b0;
                    rd_refill_error      <= 1'b0;
                    rd_refill_error_resp <= 2'b00;
                    rd_refill_beat_count <= 2'd0;
                    
                    rd_state <= RD_REFILL;
                  end
              end
                 
            RD_CROSS_MISS :
              begin
                if(cache_valid[rd_second_index] && cache_tag[rd_second_index] == rd_second_line_tag)
                  begin
                    rd_cross_refill_pending <= 1'b0;
                    
                    rd_rid    <= rd_id;
                    rd_rdata  <= rd_cross_extract_data;
                    rd_rresp  <= 2'b00;
                    rd_rvalid <= 1'b1;
                    if(rd_beat_count == rd_len)
                      rd_rlast <= 1'b1;
                    else
                      rd_rlast <= 1'b0;
                    
                    rd_state <= RD_RETURN;
                    
                  end
                else
                  begin
                    rd_cross_refill_pending <= 1'b1;
                    
                    rd_cross_index  <= rd_second_index;
                    rd_cross_tag    <= rd_second_line_tag;
                    rd_saved_addr   <= rd_current_addr;
                    rd_current_addr <= rd_cross_line_base;
                    
                    rd_state  <= RD_MISS;
                  end
              end
            
            RD_REFILL :
              begin
                // AR channel
                if(!rd_refill_ar_done)
                  begin
                    if(M_ARVALID && M_ARREADY)
                      begin
                        rd_refill_ar_done <= 1'b1;
                        rd_refill_beat_count <= 2'd0;
                      end
                  end
                // R channel
                else if(rd_refill_ar_done && !rd_refill_r_done)
                  begin
                    if(M_RVALID && M_RREADY)
                      begin
                        rd_refill_data[rd_refill_beat_count] <= M_RDATA;
                        //RID check
                        if(M_RID != rd_id)
                          begin
                            rd_refill_error  <= 1'b1;
                            rd_refill_error_resp <= 2'b10;
                          end
                        // slave response check
                        if(M_RRESP != 2'b00)
                          begin
                            rd_refill_error       <= 1'b1;
                            rd_refill_error_resp  <= M_RRESP;
                          end
                        // last expected refill beat
                        if(rd_refill_beat_count == 2'd3)
                          begin
                            if(M_RLAST)
                              rd_refill_r_done <= 1'b1;
                            else
                              begin
                                rd_refill_error       <= 1'b1;
                                rd_refill_error_resp  <= 2'b10;
                                rd_refill_r_done      <= 1'b1;
                              end
                          end
                        //non-final refill beat
                        else
                          begin
                            if(M_RLAST)
                              begin
                                rd_refill_error       <= 1'b1;
                                rd_refill_error_resp  <= 2'b10;
                                rd_refill_r_done      <= 1'b1;
                              end
                            else
                             rd_refill_beat_count  <= rd_refill_beat_count + 1'b1;
                          end
                      end
                  end
                // Refill complete
                if(rd_refill_r_done)
                  begin
                    rd_refill_ar_done    <= 1'b0;
                    rd_refill_r_done     <= 1'b0;
                    rd_refill_beat_count <= 2'd0;
                    
                    rd_state <= RD_UPDATE;
                  end
              end
            
            RD_UPDATE :
              begin
                if(!rd_refill_error)
                  begin
                    // refill was for second line
                    if(rd_cross_refill_pending)
                      begin
                        cache_tag[rd_cross_index]   <= rd_cross_tag;
                        cache_valid[rd_cross_index] <= 1'b1;
                        
                        cache_data[rd_cross_index][0] <= rd_refill_data[0];
                        cache_data[rd_cross_index][1] <= rd_refill_data[1];
                        cache_data[rd_cross_index][2] <= rd_refill_data[2];
                        cache_data[rd_cross_index][3] <= rd_refill_data[3];
                        
                        cache_dirty[rd_cross_index] <= 1'b0;
                        rd_cross_refill_pending     <= 1'b0;
                        
                        rd_current_addr <= rd_saved_addr;
                        
                        rd_state <= RD_LOOKUP;
                      end
                    else
                      begin
                        cache_tag[rd_miss_index]    <= rd_miss_tag;
                        cache_valid[rd_miss_index]  <= 1'b1;
                        
                        cache_data[rd_miss_index][0] <= rd_refill_data[0];
                        cache_data[rd_miss_index][1] <= rd_refill_data[1];
                        cache_data[rd_miss_index][2] <= rd_refill_data[2];
                        cache_data[rd_miss_index][3] <= rd_refill_data[3];
                        
                        cache_dirty[rd_miss_index] <= 1'b0;
                        
                        rd_state <= RD_HIT;
                      end
                  end
                
                //refill error
                else
                  begin
                    rd_rid     <= rd_id;
                    rd_rresp   <= rd_refill_error_resp;
                    rd_rvalid  <= 1'b1;
                    rd_rlast   <= 1'b1;
                    
                    rd_cross_refill_pending <= 1'b0;
                    
                    rd_refill_ar_done    <= 1'b0;
                    rd_refill_r_done     <= 1'b0;
                    rd_refill_beat_count <= 2'd0;
                    rd_refill_error      <= 1'b0;
                    rd_refill_error_resp <= 2'b00;
                    
                    rd_state <= RD_RESPONSE;
                  end
              end
            
            RD_RETURN :
              begin
                if(rd_rvalid && S_RREADY)
                  begin
                    rd_rvalid <= 1'b0;
                    rd_rlast  <= 1'b0;
                    
                    if(rd_beat_count == rd_len)
                      begin
                        rd_beat_count <= 8'd0;
                        rd_current_addr <= rd_addr;
                        rd_state <= RD_IDLE;
                      end
                    else
                      begin
                        rd_beat_count   <= rd_beat_count + 1'b1;
                        rd_current_addr <= rd_burst_next_addr;
                        rd_state <= RD_LOOKUP;
                      end
                  end
              end
            
          RD_WRITEBACK :
            begin
              // AW CHANNEL
              if(!rd_wb_aw_done)
                begin
                  if(M_AWVALID && M_AWREADY)
                    begin
                      rd_wb_aw_done <= 1'b1;
                      rd_wb_beat_count <= 2'd0;
                    end
                end
              // W CHANNEL

              if(rd_wb_aw_done && !rd_wb_b_done)
                begin
                  if(M_WVALID && M_WREADY)
                    begin
                      if(rd_wb_beat_count == 2'd3)
                        rd_wb_b_done <= 1'b1;
                      else
                          rd_wb_beat_count <= rd_wb_beat_count + 1'b1;
                    end
                end
              // B CHANNEL
              if(rd_wb_b_done)
                begin
                  if(M_BVALID && M_BREADY)
                    begin
                      // Check BID
                      if(M_BID != rd_id)
                        begin
                          rd_rid    <= rd_id;
                          rd_rresp  <= 2'b10;
                          rd_rvalid <= 1'b1;
                          rd_rlast  <= 1'b1;
                          rd_state <= RD_RESPONSE;
                        end
                      
                      // Check BRESP
                      else if(M_BRESP != 2'b00)
                        begin
                          rd_rid    <= rd_id;
                          rd_rresp  <= M_BRESP;
                          rd_rvalid <= 1'b1;
                          rd_rlast  <= 1'b1;
                          rd_state <= RD_RESPONSE;
                        end

                      // Writeback successful
                      else
                        begin
                          // Victim is now clean
                          cache_dirty[rd_miss_index] <= 1'b0;
                          // Reset writeback control
                          rd_wb_aw_done <= 1'b0;
                          rd_wb_b_done  <= 1'b0;
                          rd_wb_beat_count <= 2'd0;
                          // Start refill
                          rd_refill_ar_done <= 1'b0;
                          rd_refill_r_done  <= 1'b0;
                          rd_refill_error   <= 1'b0;
                          rd_refill_error_resp <= 2'b00;
                          rd_refill_beat_count <= 2'd0;
                          rd_state <= RD_REFILL;
                        end
                    end
                end
            end
          RD_BYPASS :
            begin
              if(M_RVALID && M_RREADY)
                begin
                  if(M_RLAST)
                    rd_state <= RD_IDLE;
                end
            end
            
            RD_BUF_FETCH:
              begin
                // AR Channel handshake to memory
                if(!rd_buf_ar_done)
                  begin
                    if(M_ARVALID && M_ARREADY)
                      begin
                        rd_buf_ar_done    <= 1'b1;
                        rd_buf_beat_count <= 8'd0;
                      end
                  end
                // Collect read beats from memory into buffer_mem
                if(rd_buf_ar_done && M_RVALID && M_RREADY)
                  begin
                    buffer_mem[0].buffer_memory[rd_buf_beat_count] <= M_RDATA;
                    if(M_RLAST || (rd_buf_beat_count == rd_len))
                      begin
                        rd_buf_ar_done    <= 1'b0;
                        rd_buf_send_count <= 8'd0;
                        rd_state          <= RD_BUF_STREAM;
                      end
                    else
                      rd_buf_beat_count  <= rd_buf_beat_count + 1'b1;
                  end
              end
            
            RD_BUF_STREAM:
              begin
                if(S_RREADY && S_RVALID)
                  begin
                    if(rd_buf_send_count == rd_len)
                      begin
                        rd_buf_send_count <= 8'd0;
                        rd_state          <= RD_IDLE;
                      end
                    else
                      rd_buf_send_count <= rd_buf_send_count + 1'b1;
                  end
              end
            
         RD_RESPONSE :
           begin
             if(rd_rvalid && S_RREADY)
               begin
                 rd_rvalid   <= 1'b0;
                 rd_rlast    <= 1'b0;
                 
                 rd_beat_count <= 8'd0;
                 rd_current_addr <= rd_addr;
                 
                 rd_state <= RD_IDLE;
               end
           end
          endcase
        end
    end
endmodule
