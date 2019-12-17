// +PEMHDR----------------------------------------------------------------------
// Copyright (c) 2019 PEM-UFCG. All rights reserved
// PEM-UFCG Confidential Proprietary
//------------------------------------------------------------------------------
// FILE NAME            : exp_golomb_coder.v
// AUTHOR               : Vinícius Nóbrega
// AUTHOR'S E-MAIL      : vinicius.nobrega@embedded.ufcg.edu.br
// -----------------------------------------------------------------------------
// RELEASE HISTORY
// VERSION  DATE          AUTHOR              DESCRIPTION
// 0.1      20aa-mm-dd  vinicius.nobrega    Initial version
// -----------------------------------------------------------------------------
// KEYWORDS: RTL
// -----------------------------------------------------------------------------
// PURPOSE: 
// -----------------------------------------------------------------------------
// REUSE ISSUES
//   Other: N/A
// -PEMHDR----------------------------------------------------------------------

module exp_golomb_coder(
    dft_tm_i,
    clk_i,
    rstn_i,
    dt_i,
    valid_i,
    dt_o,
    valid_o,
    busy_o 
);
// ========================================================================================
// Parameters
// ========================================================================================
parameter DATA_WIDTH = 8;
parameter ADDR_WIDTH = 4;
// ========================================================================================
// STATES
// ========================================================================================
parameter IDLE       = 2'b00;
parameter GET_X      = 2'b01;
parameter FIND       = 2'b11;
parameter CODE       = 2'b10;
// ========================================================================================
// Interface
// ========================================================================================
input  logic                  dft_tm_i;
input  logic                  clk_i;
input  logic                  rstn_i;
input  logic [DATA_WIDTH-1:0] dt_i;
input  logic                  valid_i;
output logic                  dt_o;
output logic                  valid_o;
output logic                  busy_o;
// ========================================================================================
// Internal signals
// ========================================================================================
logic                         rstn_b_w;
logic        [DATA_WIDTH:0]   reg_dt_w;
logic                         enb_dt_w;
logic                         found_flag;
logic        [ADDR_WIDTH-1:0] fnd_pos_w;
logic        [ADDR_WIDTH:0]   addr_wr_w;
logic                         coding_flag;
logic                         last_flag;
logic        [1:0]            state, next_state;

// ========================================================================================
// Main Logic
// ========================================================================================

assign rstn_b_w = (dft_tm_i == 1'b0) ?rstn_i :1'b1;

// ========================================================================================
// Registers
// ========================================================================================

always_ff @(posedge clk_i or negedge rstn_b_w) begin
    if(~rstn_b_w) begin
        reg_dt_w <= {{DATA_WIDTH{1'b0}},1'b1};
    end else begin
        if(valid_i && enb_dt_w)
            reg_dt_w <= (dt_i+1);
        else
            reg_dt_w <= reg_dt_w;
    end
end

always_ff @(posedge clk_i or negedge rstn_b_w) begin
    if(~rstn_b_w) begin
        fnd_pos_w <= {ADDR_WIDTH{1'b0}};
    end else begin
        if (valid_i && enb_dt_w)
            fnd_pos_w <= DATA_WIDTH;
        else if(!found_flag)
            fnd_pos_w <= fnd_pos_w - 1;
        else
            fnd_pos_w <= fnd_pos_w;
    end
end

always_ff @(posedge clk_i or negedge rstn_b_w) begin
    if(~rstn_b_w) begin
        addr_wr_w <= {ADDR_WIDTH{1'b0}};
    end else begin
        if(busy_o) begin
            if(coding_flag) begin 
                if(!last_flag)
                    addr_wr_w <= addr_wr_w - 1;
                else
                    addr_wr_w <= addr_wr_w;
            end
            else if(found_flag)
                addr_wr_w <= ((fnd_pos_w)<<1);
            else
                addr_wr_w <= addr_wr_w;
        end else
            addr_wr_w <= addr_wr_w;
    end
end

/*
always_ff @(posedge clk_i or negedge rstn_b_w) begin
    if(~rstn_b_w) begin
        dt_o <= 1'b0;
    end else begin
        if(coding_flag) begin
            if(addr_wr_w > fnd_pos_w)
                dt_o <= 1'b0;
            else
                dt_o <= reg_dt_w[addr_wr_w];
        end
    end
end*/

always_comb begin
    if(addr_wr_w > fnd_pos_w)
        dt_o = 1'b0;
    else
        dt_o = reg_dt_w[addr_wr_w];
end

// ========================================================================================
// Flags logic
// ========================================================================================
always_comb begin
    begin
        if(!reg_dt_w[fnd_pos_w])
            found_flag <= 1'b0;
        else
            found_flag <= 1'b1;
    end
end

assign last_flag = !addr_wr_w;  //check if this works!
// ========================================================================================
// FSM
// ========================================================================================
always_ff @(posedge clk_i or negedge rstn_b_w) begin
    if(~rstn_b_w) begin
        state <= IDLE;
    end else begin
        state <= next_state;
    end
end

always_comb begin
    case(state)
        IDLE:   begin
                if(valid_i)
                    next_state = GET_X;
                else
                    next_state = IDLE;
                end

        GET_X:  begin
                if(valid_i)
                    next_state = FIND;
                else
                    next_state = IDLE;
                end

        FIND:   begin
                if(found_flag)
                    next_state = CODE;
                else
                    next_state = FIND;
                end

        CODE:   begin
                if(last_flag)
                    next_state = IDLE;
                else
                    next_state = CODE;
                end

        default: next_state = IDLE;
    endcase // state
end

always_comb begin
    case(state)
        IDLE:   begin
                valid_o = 1'b0;
                busy_o  = 1'b0;
                enb_dt_w = 1'b0;
                coding_flag = 1'b0;
                end

        GET_X:  begin
                valid_o = 1'b0;
                busy_o  = 1'b0;
                enb_dt_w = 1'b1;
                coding_flag = 1'b0;
                end
                
        //FIND = default

        CODE:   begin
                valid_o = 1'b1;
                busy_o  = 1'b1;
                enb_dt_w = 1'b0;
                coding_flag = 1'b1;
                end

        default: begin
                valid_o = 1'b0;
                busy_o  = 1'b1;
                enb_dt_w = 1'b0;
                coding_flag = 1'b0;
                end
    endcase // state
end


endmodule
