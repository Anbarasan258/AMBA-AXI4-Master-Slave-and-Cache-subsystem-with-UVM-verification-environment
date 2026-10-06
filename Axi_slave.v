module Axi_slave(ACLK,ARESETn,AWID,AWADDR,AWLEN,AWSIZE,AWBURST,AWLOCK,AWCACHE,AWPROT,AWVALID,AWREADY,WDATA,WSTRB,WLAST,WVALID,WREADY,BID,BRESP,BVALID,BREADY,ARID,ARADDR,ARLEN,ARSIZE,ARBURST,ARLOCK,ARCACHE,ARPROT,ARVALID,ARREADY,RID,RDATA,RRESP,RLAST,RVALID,RREADY);

// global signals
  input ACLK,ARESETn;
  
// Write address channel signals
  
  input [3:0] AWID;
  input [31:0] AWADDR;
  input [7:0] AWLEN;
  input [2:0] AWSIZE;
  input [1:0] AWBURST;
  input AWLOCK;
  input [3:0] AWCACHE;
  input [2:0] AWPROT;
  input AWVALID;
  output  AWREADY;
  
// Write data channel signals
  

  input [31:0] WDATA;
  input [3:0] WSTRB;
  input WLAST;
  input WVALID;
  output WREADY;
  
// Write response channel signals
  output  [3:0] BID;
  output  [1:0] BRESP;
  output  BVALID;
  input BREADY;
  
// Read address channel signals
  
  input [3:0] ARID;
  input [31:0] ARADDR;
  input [7:0] ARLEN;
  input [2:0] ARSIZE;
  input [1:0] ARBURST;
  input ARLOCK;
  input [3:0] ARCACHE;
  input [2:0] ARPROT;
  input ARVALID;
  output  ARREADY;
  
//  Read data channel
  output  [3:0] RID;
  output  [31:0] RDATA;
  output  [1:0] RRESP;
  output  RLAST;
  output  RVALID;
  input RREADY;
// internal slave memory
    
  localparam MEM_SIZE = 4096;
  reg [7:0] mem [0:MEM_SIZE-1];
  
  // ---- Exclusive access reservation table ----
  localparam EXCL_DEPTH = 8;

  typedef struct packed {
    logic        valid;
    logic [3:0]  id;
    logic [31:0] addr;
    logic [2:0]  size;
    logic [1:0]  burst;
    logic [7:0]  len;
  } excl_entry_t;

  excl_entry_t excl_table[0:EXCL_DEPTH-1];
  integer ex_i, ex_j, ex_k;
  reg [3:0] excl_alloc_index;
  reg       excl_table_full;
  
// outstanding transaction table for write channels  
   typedef struct packed {
    logic  valid;
    logic  data_done;
    logic [3:0]  id;
    logic [31:0] addr;
    logic [7:0]  len;
    logic [7:0]  beat_count;
    logic [2:0]  size;
    logic [1:0]  burst;
    logic  lock;
    logic [3:0]  cache;
    logic [2:0]  prot;
    logic [1:0] bresp;
    logic protocol_error;
    logic mem_error;  
  } table_info;
  
   localparam STORAGE_SIZE = 16;  // size of out-standing storage memory
  
// ----------------------------------------------------------- Write address channel from slave -------------------------------------------------------------------------
  
  
// ---- NEW: find a free reservation slot ----
  always@(*)
    begin
      excl_alloc_index = 4'd0;
      excl_table_full  = 1'b1;
      for(ex_i = 0; ex_i < EXCL_DEPTH; ex_i = ex_i+1)
        begin
          if(excl_table_full && !excl_table[ex_i].valid)
            begin
              excl_alloc_index = ex_i[3:0];
              excl_table_full  = 1'b0;
            end
        end
    end

  
// variable for searching the free space from the previously location  
  reg [3:0] alloc_index,alloc_ptr;
  reg wr_table_full;
  integer i;
  reg [4:0]idx;
  reg [31:0] wr_last_addr;
  reg wr_protocol_check;
  reg wr_wrap_error;
  reg wr_mem_error;
  reg wr_prot_error;
  table_info wr_table[0:STORAGE_SIZE-1];
  
  assign AWREADY = (ARESETn && !wr_table_full ) ? 1'b1 : 1'b0 ;
  
  always@(*)
    begin
      alloc_index = 4'd0;
      wr_table_full = 1'b1;
      for(i = 0 ; i < STORAGE_SIZE; i = i+1)
        begin
          idx = alloc_ptr + i;
          if(idx >= STORAGE_SIZE )
            idx = idx - STORAGE_SIZE;
          if(wr_table_full && !wr_table[idx].valid)
            begin
              alloc_index = idx[3:0];
              wr_table_full = 1'b0;
            end
        end
    end
  
  always@(*)
    begin
      wr_last_addr = AWADDR + (((AWLEN+1) << AWSIZE)-1);
      wr_wrap_error = ((AWBURST == 2'b10) &&(!((AWLEN == 8'd1)  || (AWLEN == 8'd3)  || (AWLEN == 8'd7)  || (AWLEN == 8'd15)) || (AWADDR % (1 << AWSIZE)!= 0) ));
       wr_prot_error = (AWPROT[2] || AWPROT[1]);
      wr_mem_error  = (wr_wrap_error || wr_prot_error);
     
      if(AWADDR[31:12] != wr_last_addr[31:12]  || AWADDR  > MEM_SIZE-1)
        wr_protocol_check = 1'b1;
      else
        wr_protocol_check = 1'b0;
    end

  
  always@(posedge ACLK)
    begin
      if(!ARESETn)
        begin
          alloc_ptr <= 4'd0;
          for(i=0;i<STORAGE_SIZE;i=i+1)
            begin
              wr_table[i].valid          <= 1'b0;
              wr_table[i].data_done      <= 1'b0;
              wr_table[i].id             <= 4'd0;
              wr_table[i].addr           <= 32'd0;
              wr_table[i].len            <= 8'd0;
              wr_table[i].beat_count     <= 8'd0;
              wr_table[i].size           <= 3'd0;
              wr_table[i].burst          <= 2'd0;
              wr_table[i].lock           <= 1'b0;
              wr_table[i].cache          <= 4'd0;
              wr_table[i].prot           <= 3'd0;
              wr_table[i].bresp          <= 2'd0;
              wr_table[i].protocol_error <= 1'b0;
              wr_table[i].mem_error      <= 1'b0;
            end
        end
      else
        begin
           if(AWVALID && AWREADY)
             begin
               wr_table[alloc_index].valid           <= 1'b1;
               wr_table[alloc_index].data_done       <= 1'b0;
               wr_table[alloc_index].id              <= AWID;
               wr_table[alloc_index].addr            <= AWADDR;
               wr_table[alloc_index].len             <= AWLEN;
               wr_table[alloc_index].beat_count      <= 8'd0;
               wr_table[alloc_index].size            <= AWSIZE;
               wr_table[alloc_index].burst           <= AWBURST;
               wr_table[alloc_index].lock            <= AWLOCK;
               wr_table[alloc_index].cache           <= AWCACHE;
               wr_table[alloc_index].prot            <= AWPROT;
               wr_table[alloc_index].protocol_error  <= wr_protocol_check;
               wr_table[alloc_index].mem_error       <= wr_mem_error;
               if(alloc_index == STORAGE_SIZE-1)
                 alloc_ptr <= 4'd0;
               else
                 alloc_ptr <= alloc_index + 1'b1;
             end
        end
    end
  
//------------------------------------------------------------- Write data channel from slave ---------------------------------------------------------------------------

  reg [3:0] active_index,active_ptr;
  reg [4:0] wd_idx;
  reg data_pending;
  integer j,k;
  reg [31:0] wr_current_addr;
  wire [31:0] wr_addr;
  assign wr_addr = (wr_table[active_index].beat_count == 0) ? wr_table[active_index].addr : wr_current_addr;
  assign WREADY = data_pending;
// for wrap burst address calculation variables
  reg [4:0] wr_bytes_per_beats;
  reg [31:0] wr_wrap_size;
  reg [31:0] wr_wrap_base;
  reg [31:0] wr_wrap_limit;
  reg [31:0] wr_aligned_addr;        // NEW — word/size-aligned base of this transaction
  wire [31:0] wr_word_base; 
  wire wr_last_signal_error; 
  
 assign wr_last_signal_error = ((wr_table[active_index].beat_count == wr_table[active_index].len && ! WLAST) || (wr_table[active_index].beat_count != wr_table[active_index].len && WLAST));
  
  assign wr_word_base = wr_addr & ~32'h3;
  
  always@(*)
    begin
      data_pending = 1'b0;
      active_index = 4'd0;
      for(j = 0; j < STORAGE_SIZE; j = j+1)
        begin
          wd_idx = active_ptr + j;
          if(wd_idx >= STORAGE_SIZE)
            wd_idx = wd_idx - STORAGE_SIZE;
          if(!data_pending && wr_table[wd_idx].valid && !wr_table[wd_idx].data_done)
            begin
              active_index = wd_idx[3:0];
              data_pending = 1'b1;
            end
        end
      end

  always@(*)
    begin
      wr_bytes_per_beats = (1 << wr_table[active_index].size);
      wr_aligned_addr = (wr_table[active_index].addr / wr_bytes_per_beats) * wr_bytes_per_beats;  // NEW
      wr_wrap_size    = wr_bytes_per_beats * (wr_table[active_index].len+1);
      wr_wrap_base    = (wr_aligned_addr / wr_wrap_size) * wr_wrap_size;   // CHANGED: from wr_aligned_addr, not wr_addr
      wr_wrap_limit   = wr_wrap_base + wr_wrap_size;
    end
  
    // ---- NEW: exclusive write match/conflict check ----
  reg        excl_match_found;
  reg [3:0]  excl_match_index;
  reg        excl_conflict_found;
  reg [3:0]  excl_conflict_index;

  always@(*)
    begin
      excl_match_found    = 1'b0;
      excl_match_index    = 4'd0;
      for(ex_j = 0; ex_j < EXCL_DEPTH; ex_j = ex_j+1)
        begin
          if(excl_table[ex_j].valid && (excl_table[ex_j].addr == wr_table[active_index].addr) && (excl_table[ex_j].size == wr_table[active_index].size) && (excl_table[ex_j].len == wr_table[active_index].len) && excl_table[ex_j].id == wr_table[active_index].id && (excl_table[ex_j].burst == wr_table[active_index].burst) )
                begin
                  excl_match_found = 1'b1;
                  excl_match_index = ex_j[3:0];
                end
        end
    end
  
  
  always@(posedge ACLK)
    begin
      if(!ARESETn)
        begin
          wr_current_addr <= 32'd0;
          active_ptr      <= 4'd0;
        end
      else
        begin
          if(WVALID && WREADY)
            begin
              if(wr_last_signal_error) 
                begin
                  wr_table[active_index].data_done      <= 1'b1;
                  wr_table[active_index].bresp     <= 2'b10;
                  active_ptr  <= (active_index == STORAGE_SIZE-1) ? 4'd0 : (active_index + 1'b1);
                end
              else if(wr_table[active_index].beat_count == wr_table[active_index].len && WLAST)
                begin
                  excl_table[excl_match_index].valid   <= (wr_table[active_index].lock) ? 1'b0 : 1'b1;
                  wr_table[active_index].data_done      <= 1'b1;
                  wr_table[active_index].bresp <= (wr_table[active_index].protocol_error) ? 2'b11 :(wr_table[active_index].mem_error) ? 2'b10 :(wr_table[active_index].lock) ? (excl_match_found ? 2'b01 : 2'b00) :2'b00;
                  active_ptr  <= (active_index == STORAGE_SIZE-1) ? 4'd0 : (active_index + 1'b1);
                end
              else
                begin
                  wr_table[active_index].beat_count <= wr_table[active_index].beat_count + 1'b1;
                  case(wr_table[active_index].burst)
                    2'b00 : wr_current_addr   <= wr_addr;
                    2'b01 : wr_current_addr <= (wr_table[active_index].beat_count == 8'd0) ? (wr_aligned_addr + wr_bytes_per_beats) : (wr_addr + wr_bytes_per_beats);
                    2'b10 : 
                      begin
                        if (wr_table[active_index].beat_count == 8'd0)
                          wr_current_addr <= (wr_aligned_addr + wr_bytes_per_beats >= wr_wrap_limit) ? wr_wrap_base : (wr_aligned_addr + wr_bytes_per_beats);
                      else 
                        wr_current_addr <= (wr_addr + wr_bytes_per_beats >= wr_wrap_limit) ? wr_wrap_base : (wr_addr + wr_bytes_per_beats);
                      end
                    default : wr_current_addr <= wr_addr;
                  endcase
                end
            end
        end
    end
  
  
  always@(posedge ACLK)
    begin
      if(!ARESETn)
        begin
          for(k = 0; k < MEM_SIZE; k = k+1)
            mem[k] <= 8'd0;
        end
      else
        begin
          if(WVALID && WREADY)  
            begin
              if(!wr_table[active_index].protocol_error && !wr_last_signal_error && !wr_table[active_index].mem_error && (!wr_table[active_index].lock || excl_match_found))
                begin
                  if(WSTRB[0]) mem[wr_word_base]   <= WDATA[7:0];
                  if(WSTRB[1]) mem[wr_word_base+1] <= WDATA[15:8];
                  if(WSTRB[2]) mem[wr_word_base+2] <= WDATA[23:16];
                  if(WSTRB[3]) mem[wr_word_base+3] <= WDATA[31:24];
                end
            end
        end
    end

  
// --------------------------------------------------------- Write response channel from slave --------------------------------------------------------------------------
 
  reg [3:0] resp_index,resp_ptr;
  reg [4:0] resp_idx;
  reg response_pending;
  integer m;
  assign BID = (!ARESETn) ? 4'd0 : (BVALID) ? wr_table[resp_index].id : 4'bxxxx;
  assign BRESP = (!ARESETn) ? 2'd0 :(BVALID) ? wr_table[resp_index].bresp : 2'bxx;
  assign BVALID = response_pending;
  
  always@(*)
    begin
      resp_index = 4'd0;
      response_pending = 1'b0;
      for(m = 0; m < STORAGE_SIZE; m = m+1)
        begin
          resp_idx = resp_ptr + m;
          if(resp_idx >= STORAGE_SIZE)
            resp_idx = resp_idx - STORAGE_SIZE;
          if(!response_pending && wr_table[resp_idx].valid && wr_table[resp_idx].data_done)
            begin
              resp_index = resp_idx[3:0];
              response_pending = 1'b1;
            end
        end
    end
  always@(posedge ACLK)
    begin
      if(!ARESETn)
        resp_ptr <= 4'd0;
      else
        begin
          if(BVALID && BREADY)
            begin
              wr_table[resp_index].valid          <= 1'b0;
              wr_table[resp_index].data_done      <= 1'b0;
              wr_table[resp_index].id             <= 4'd0;
              wr_table[resp_index].addr           <= 32'd0;
              wr_table[resp_index].len            <= 8'd0;
              wr_table[resp_index].beat_count     <= 8'd0;
              wr_table[resp_index].size           <= 3'd0;
              wr_table[resp_index].burst          <= 2'd0;
              wr_table[resp_index].lock           <= 1'd0;
              wr_table[resp_index].cache          <= 4'd0;
              wr_table[resp_index].prot           <= 3'd0;
              wr_table[resp_index].bresp          <= 2'd0;
              wr_table[resp_index].protocol_error <= 1'b0;
              wr_table[resp_index].mem_error <= 1'b0;
              if(resp_index == STORAGE_SIZE-1)
                resp_ptr <= 4'd0;
              else
                resp_ptr <= resp_index + 1'b1;
            end
        end
    end
  
//------------------------------------------------------------------- Read address channel from slave -------------------------------------------------------------------
// outstanding table for read transaction
  typedef struct packed {
    logic  valid;
    logic [3:0]  id;
    logic [31:0] addr;
    logic [7:0]  len;
    logic [7:0]  beat_count;
    logic [2:0]  size;
    logic [1:0]  burst;
    logic  lock;
    logic [3:0]  cache;
    logic [2:0]  prot;
    logic [1:0] rresp;
    logic protocol_error;
  } rd_table_info;
  
  rd_table_info rd_table[0:STORAGE_SIZE-1];
  
// variables for read address channel
  reg [3:0]rd_alloc_index,rd_ptr;
  reg [4:0] rd_idx;
  reg rd_table_full;
  integer n;
  reg [31:0] rd_last_addr;
  reg rd_protocol_check;
  reg rd_wrap_error;
  reg rd_mem_error;
  reg rd_prot_error;
  reg [31:0] rd_aligned_addr;
  wire [31:0] rd_word_base;
                    
  assign ARREADY =  (ARESETn && !rd_table_full) ? 1'b1 : 1'b0;
  
  always@(*)
    begin
      rd_alloc_index = 4'd0;
      rd_table_full = 1'b1;
      for(n = 0; n< STORAGE_SIZE; n = n +1)
        begin
          rd_idx = rd_ptr + n;
          if(rd_idx >= STORAGE_SIZE)
            rd_idx = rd_idx - STORAGE_SIZE;
          if(rd_table_full && !rd_table[rd_idx].valid)
            begin
              rd_alloc_index = rd_idx[3:0];
              rd_table_full = 1'b0;
            end
        end
    end
  
  always@(*)
    begin
      rd_last_addr   = ARADDR + (((ARLEN+1) << ARSIZE)-1);
      rd_wrap_error  = ((ARBURST == 2'b10) && (!((ARLEN == 8'd1)  || (ARLEN == 8'd3)  || (ARLEN == 8'd7)  || (ARLEN == 8'd15)) || (ARADDR % (1 << ARSIZE))));
      rd_prot_error  = (ARPROT[2] || ARPROT[1]);
      rd_mem_error   = (rd_wrap_error || rd_prot_error);
      
      if(ARADDR[31:12] != rd_last_addr[31:12] || ARADDR > MEM_SIZE-1)
        rd_protocol_check = 1'b1;
      else
        rd_protocol_check = 1'b0;
    end
  
  always@(posedge ACLK)
    begin
      if(!ARESETn)
        begin
          rd_ptr <= 4'd0;
          for(n = 0; n < STORAGE_SIZE; n = n+1)
            begin
              rd_table[n].valid          <= 1'b0;
              rd_table[n].id             <= 4'd0;
              rd_table[n].addr           <= 32'd0;
              rd_table[n].len            <= 8'd0;
              rd_table[n].size           <= 3'd0;
              rd_table[n].beat_count     <= 8'd0;
              rd_table[n].burst          <= 2'd0;
              rd_table[n].lock           <= 1'b0;
              rd_table[n].cache          <= 4'd0;
              rd_table[n].prot           <= 3'd0;
              rd_table[n].rresp          <= 2'd0;
              rd_table[n].protocol_error <= 1'b0;
            end
        end
      else if(ARREADY && ARVALID)
        begin
          rd_table[rd_alloc_index].valid          <= 1'b1;
          rd_table[rd_alloc_index].id             <= ARID;
          rd_table[rd_alloc_index].addr           <= ARADDR;
          rd_table[rd_alloc_index].len            <= ARLEN;
          rd_table[rd_alloc_index].size           <= ARSIZE;
          rd_table[rd_alloc_index].beat_count     <= 8'd0;
          rd_table[rd_alloc_index].burst          <= ARBURST;
          rd_table[rd_alloc_index].lock           <= ARLOCK;
          rd_table[rd_alloc_index].cache          <= ARCACHE;
          rd_table[rd_alloc_index].prot      	  <= ARPROT;
          rd_table[rd_alloc_index].rresp          <= rd_protocol_check ? 2'b11 : (rd_mem_error) ? 2'b10 : ARLOCK ? 2'b01 : 2'b00;
          rd_table[rd_alloc_index].protocol_error <= rd_protocol_check;
          if(rd_alloc_index == STORAGE_SIZE-1)
            rd_ptr <= 4'd0;
          else
            rd_ptr <= rd_alloc_index + 1'b1;
        end
    end
  
//-------------------------------------------------------------- Read data channel from slave --------------------------------------------------------------------------- 
  
// variable for read data channel
  reg [3:0] rd_active_index,rd_active_ptr;
  reg [4:0] rd_search_idx;
  reg rd_pending;
  reg [4:0] rd_bytes_per_beats;
  reg [31:0] rd_wrap_size,rd_wrap_base,rd_wrap_limit;
  reg [31:0] rd_current_addr;
  wire [31:0] rd_addr;
  integer p;
 assign rd_word_base = rd_addr & ~32'h3;
 assign RVALID = rd_pending;
 assign RLAST =(RVALID && (rd_table[rd_active_index].beat_count == rd_table[rd_active_index].len));
 assign rd_addr = (rd_table[rd_active_index].beat_count == 0) ? rd_table[rd_active_index].addr : rd_current_addr;
  always@(*)
    begin
      rd_pending = 1'b0;
      rd_active_index = 4'd0;
      for(p = 0; p < STORAGE_SIZE; p = p+1)
        begin
          rd_search_idx = rd_active_ptr + p;
          if(rd_search_idx >= STORAGE_SIZE)
            rd_search_idx = rd_search_idx - STORAGE_SIZE;
          if(!rd_pending && rd_table[rd_search_idx].valid)
            begin
              rd_active_index = rd_search_idx[3:0];
              rd_pending = 1'b1;
            end
        end
    end
  
  always@(*)
    begin
      rd_bytes_per_beats = (1 << rd_table[rd_active_index].size);
      rd_aligned_addr = (rd_table[rd_active_index].addr / rd_bytes_per_beats) * rd_bytes_per_beats; 
      rd_wrap_size = rd_bytes_per_beats * (rd_table[rd_active_index].len+1);
      rd_wrap_base = (rd_aligned_addr / rd_wrap_size) * rd_wrap_size;
      rd_wrap_limit = rd_wrap_base + rd_wrap_size;
    end
  
 
  always@(posedge ACLK)
    begin
      if(!ARESETn)
        begin
          rd_current_addr <= 32'd0;
          rd_active_ptr   <= 4'd0;
          for(ex_k = 0; ex_k < EXCL_DEPTH; ex_k = ex_k+1)
            begin
              excl_table[ex_k].valid <= 1'b0;
              excl_table[ex_k].id    <= 4'd0;
              excl_table[ex_k].addr  <= 32'd0;
              excl_table[ex_k].size  <= 3'd0;
              excl_table[ex_k].burst  <= 2'd0;
              excl_table[ex_k].len  <= 8'd0;
            end
        end
          else
            begin
              if(RVALID && RREADY)
                begin
                  if(rd_table[rd_active_index].beat_count == rd_table[rd_active_index].len) 
                    begin
                      if(rd_table[rd_active_index].lock && !excl_table_full)
                        begin
                          excl_table[excl_alloc_index].valid <= 1'b1;
                          excl_table[excl_alloc_index].id    <= rd_table[rd_active_index].id;
                          excl_table[excl_alloc_index].addr  <= rd_table[rd_active_index].addr;
                          excl_table[excl_alloc_index].size  <= rd_table[rd_active_index].size;
                          excl_table[excl_alloc_index].burst  <= rd_table[rd_active_index].burst;
                          excl_table[excl_alloc_index].len  <= rd_table[rd_active_index].len;
                        end
                      rd_table[rd_active_index].valid          <= 1'b0;
                      rd_table[rd_active_index].id             <= 4'd0;
                      rd_table[rd_active_index].addr           <= 32'd0;
                      rd_table[rd_active_index].len            <= 8'd0;
                      rd_table[rd_active_index].beat_count     <= 8'd0;
                      rd_table[rd_active_index].size           <= 3'd0;
                      rd_table[rd_active_index].burst          <= 2'd0;
                      rd_table[rd_active_index].lock           <= 1'b0;
                      rd_table[rd_active_index].cache          <= 4'd0;
                      rd_table[rd_active_index].prot           <= 3'd0;
                      rd_table[rd_active_index].rresp          <= 2'b00;
                      rd_table[rd_active_index].protocol_error <= 1'b0;
                      rd_active_ptr <= (rd_active_index == STORAGE_SIZE-1) ? 4'd0 : rd_active_index + 1'b1;
                    end
                  else
                    begin
                      rd_table[rd_active_index].beat_count <= rd_table[rd_active_index].beat_count + 1'b1;
                       case(rd_table[rd_active_index].burst)
                         2'b00 : rd_current_addr   <= rd_addr;
                         2'b01 : rd_current_addr <= (rd_table[rd_active_index].beat_count == 8'd0) ? (rd_aligned_addr + rd_bytes_per_beats) : (rd_addr + rd_bytes_per_beats);
                         2'b10 :
                           begin
                             if (rd_table[rd_active_index].beat_count == 8'd0)
                                 rd_current_addr <= (rd_aligned_addr + rd_bytes_per_beats >= rd_wrap_limit) ? rd_wrap_base : (rd_aligned_addr + rd_bytes_per_beats);
                             else 
                               rd_current_addr <= (rd_addr + rd_bytes_per_beats >= rd_wrap_limit) ? rd_wrap_base : (rd_addr + rd_bytes_per_beats);
                           end
                         default : rd_current_addr <= rd_addr;
                       endcase
                    end
                end
            end
    end
 
// choosing the read data according to the size 
  wire [1:0] rd_byte_offset;
  reg [31:0] rdata_masked;
  
  assign rd_byte_offset = rd_addr[1:0];
  
  always @(*) 
    begin
      rdata_masked = 32'd0;
      case (rd_table[rd_active_index].size)
        3'd0: 
          begin 
            case (rd_byte_offset)
              2'd0: rdata_masked[7:0]   = mem[rd_word_base];
              2'd1: rdata_masked[15:8]  = mem[rd_word_base+1];
              2'd2: rdata_masked[23:16] = mem[rd_word_base+2];
              2'd3: rdata_masked[31:24] = mem[rd_word_base+3];
            endcase
          end
        3'd1: 
          begin
            case (rd_byte_offset[1])
              1'b0: rdata_masked[15:0]  = {mem[rd_word_base+1], mem[rd_word_base]};
              1'b1: rdata_masked[31:16] = {mem[rd_word_base+3], mem[rd_word_base+2]};
            endcase
          end
        
        default:rdata_masked = {mem[rd_word_base+3], mem[rd_word_base+2], mem[rd_word_base+1], mem[rd_word_base]};
      endcase
    end

  assign RDATA = (RVALID && (rd_table[rd_active_index].rresp == 2'b00)) ? rdata_masked : 32'd0;
  assign RID = (!ARESETn) ? 4'd0 : (RVALID) ? rd_table[rd_active_index].id : 4'bxxxx;
  assign RRESP = (!ARESETn) ? 2'd0 :(RVALID) ? rd_table[rd_active_index].rresp : 2'bxx;
  

endmodule
