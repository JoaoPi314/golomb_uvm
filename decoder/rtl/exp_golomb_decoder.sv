// +PEMHDR----------------------------------------------------------------------
// Copyright (c) 2019 PEM-UFCG. All rights reserved
// PEM-UFCG Confidential Proprietary
//------------------------------------------------------------------------------
// FILE NAME            : exp_golomb_decoder.v
// AUTHOR               : Vinícius Nóbrega
// AUTHOR'S E-MAIL      : vinicius.nobrega@embedded.ufcg.edu.br
// -----------------------------------------------------------------------------
// RELEASE HISTORY
// VERSION  DATE          AUTHOR              DESCRIPTION
// 0.1      20aa-mm-dd    vinicius.nobrega    Initial version
// -----------------------------------------------------------------------------
// KEYWORDS: RTL
// -----------------------------------------------------------------------------
// PURPOSE: 
// -----------------------------------------------------------------------------
// REUSE ISSUES
//   Other: N/A
// -PEMHDR----------------------------------------------------------------------

module exp_golomb_decoder(
    dft_tm_i,
    clk_i,
    rstn_i,
    dt_i,
    valid_i,
    dt_o,
    valid_o 
);
// ========================================================================================
// Parameters
// ========================================================================================
parameter DATA_WIDTH = 8;
parameter ADDR_WIDTH = 4;
// ========================================================================================
// STATES
// ========================================================================================
parameter COUNT      = 3'b000;
parameter GET_DT     = 3'b001;
parameter STABLE     = 3'b011;
parameter DONE       = 3'b111;
parameter RESET      = 3'b010;
// ========================================================================================
// Interface
// ========================================================================================
input  logic                  dft_tm_i;
input  logic                  clk_i;
input  logic                  rstn_i;
input  logic                  dt_i;
input  logic                  valid_i;
output logic [DATA_WIDTH-1:0] dt_o;
output logic                  valid_o;
// ========================================================================================
// Internal signals
// ========================================================================================
logic                         enb_cg_w;
logic                         rstn_b_w;
logic [DATA_WIDTH:0]          reg_dt_w;
logic [ADDR_WIDTH-1:0]        addr_rd_w;
logic                         incr_flg;
logic                         last_flg;
logic [2:0]                   state, next_state;
// ========================================================================================
// Main Logic
// ========================================================================================
assign enb_cg_w = valid_i && !state[1];
assign rstn_b_w = (dft_tm_i == 1'b0) ?rstn_i :1'b1;
assign last_flg = !addr_rd_w;
assign dt_o     = reg_dt_w - 1;
// ========================================================================================
// Registers
// ========================================================================================
always_ff @(posedge clk_i or negedge rstn_b_w) begin
    if(~rstn_b_w)
        addr_rd_w <= {ADDR_WIDTH{1'b0}};
    else begin
        if(enb_cg_w) begin
            if(incr_flg)
                addr_rd_w <= addr_rd_w + 1;
            else
                addr_rd_w <= addr_rd_w - 1;
        end else if(state == RESET)
                addr_rd_w <= {ADDR_WIDTH{1'b0}};
            else
                addr_rd_w <= addr_rd_w;
    end
end

always_ff @(posedge clk_i or negedge rstn_b_w) begin
    if(~rstn_b_w)
        reg_dt_w <= {DATA_WIDTH{1'b0}};
    else begin
        if(enb_cg_w) begin
            if(state == COUNT) begin
                if(dt_i)
                    reg_dt_w[addr_rd_w] <= dt_i;
                else
                    reg_dt_w[addr_rd_w] <= reg_dt_w[addr_rd_w];
            end else
                reg_dt_w[addr_rd_w] <= dt_i;
        end else begin
            if(state == RESET)
                reg_dt_w <= {ADDR_WIDTH{1'b0}};
            else
                reg_dt_w <= reg_dt_w;
        end
    end
end

// ========================================================================================
// FSM
// ========================================================================================
always_ff @(posedge clk_i or negedge rstn_b_w) begin
    if(~rstn_b_w) begin
        state <= COUNT;
    end else begin
        state <= next_state;
    end
end

always_comb begin
    case(state)
        COUNT:  begin
                if(dt_i && valid_i) begin
                    if(last_flg)
                        next_state = STABLE;
                    else
                        next_state = GET_DT;
                end else
                    next_state = COUNT;
                end

        GET_DT: begin
                if(last_flg)
                    next_state = STABLE;
                else
                    next_state = GET_DT;
                end

        STABLE: begin
                next_state = DONE;
                end

        //DONE = default

        RESET:  begin
                    next_state = COUNT;
                end

        default: next_state = RESET;
    endcase
end

always_comb begin
    case(state)
        COUNT:  begin
                if(valid_i && !dt_i)
                    incr_flg = 1'b1;
                else
                    incr_flg = 1'b0;
                valid_o = 1'b0;
                end

        DONE:   begin
                if(!valid_i)
                    valid_o = 1'b1;
                else
                    valid_o = 1'b0;
                incr_flg = 1'b0;
                end

        default: begin
                valid_o = 1'b0;
                incr_flg = 1'b0;
                end
    endcase
end

endmodule
