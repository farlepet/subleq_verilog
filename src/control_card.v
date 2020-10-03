/* Control Card
 * Main control logic of the CPU, controls control lines */

`include "src/config.v"

/* State machine states: */
`define CSTATE_INIT   0 /* Power-on state */
`define CSTATE_ROMCPY 1 /* Copy ROM to RAM */
`define CSTATE_READA  2 /* Read A, increment PC */
`define CSTATE_READB  3 /* Read B, increment PC */
`define CSTATE_PTRA   4 /* Read *A */
`define CSTATE_PTRB   5 /* Read *B */
`define CSTATE_SUB    6 /* *B = *B - *A */
`define CSTATE_BRANCH 7 /* PC = C */
`define CSTATE_NEXTI  8 /* PC++ */

module control_card
#(
    parameter DATAWIDTH = `DATAWIDTH,
    parameter CTRLWIDTH = `CTRLWIDTH
)
(
/* Data Bus (unused) */
    input [DATAWIDTH-1:0] data,
/* Address Bus (unused) */
    input [DATAWIDTH-1:0] address,
/* Control Bus */
    inout [CTRLWIDTH-1:0] ctrl,
/* Clock input */
    input        clk
);

    reg [3:0] cstate = `CSTATE_INIT; /* Control State */
    reg [2:0] sstate = 0;            /* Sub-State */

    /* Control output registers */
    reg       rd_req   = 0;
    reg       wr_req   = 0;
    reg [1:0] reg_rd   = 0;
    reg [1:0] reg_wr   = 0;
    reg [1:0] alu_ld   = 0;
    reg       alu_mode = 0;
    reg       alu_read = 0;

    assign ctrl[`CTRL_RD_REQ]                = rd_req;
    assign ctrl[`CTRL_WR_REQ]                = wr_req;
    assign ctrl[`CTRL_REG_RD+1:`CTRL_REG_RD] = reg_rd;
    assign ctrl[`CTRL_REG_WR+1:`CTRL_REG_WR] = reg_wr;
    assign ctrl[`CTRL_ALU_LD+1:`CTRL_ALU_LD] = alu_ld;
    assign ctrl[`CTRL_ALU_MODE]              = alu_mode;
    assign ctrl[`CTRL_ALU_READ]              = alu_read;

    always @(negedge clk) begin
        $display("[CTL] CSTATE: %d, SSTATE: %d", cstate, sstate);
        case(cstate)
            `CSTATE_INIT: begin
                cstate <= `CSTATE_ROMCPY;
                sstate <= 0;
            end
            `CSTATE_ROMCPY: begin
                /* TODO */
                cstate <= `CSTATE_READA;
                sstate <= 0;
            end
            `CSTATE_READA,`CSTATE_READB: begin
                case(sstate)
                    0: begin
                        /* Load PC to ADDR */
                        alu_read <= 0;
                        reg_wr   <= `REG_NONE;
                        reg_rd   <= `REG_PC;
                        sstate   <= 1;
                    end
                    1: begin
                        /* Read from memory */
                        rd_req <= 1;
                        sstate <= 2;
                    end
                    2: begin
                        /* Store DATA to A */
                        if(ctrl[`CTRL_RD_READY]) begin
                            reg_wr <= (cstate == `CSTATE_READA) ? `REG_A : `REG_B;
                            sstate <= 3;
                        end
                    end
                    3: begin
                        /* Load ADDR to ALU A */
                        reg_wr   <= `REG_NONE;
                        rd_req   <= 0;
                        alu_mode <= 0;
                        alu_ld   <= 1;
                        sstate   <= 4;
                    end
                    4: begin
                        /* Increment A */
                        reg_wr   <= `REG_NONE;
                        alu_read <= 1;
                        sstate   <= 5;
                    end
                    5: begin
                        /* Store DATA to PC */
                        if(ctrl[`CTRL_ALU_DONE]) begin
                            reg_wr <= `REG_PC;
                            reg_rd <= `REG_NONE;
                            sstate <= 0;
                            cstate <= cstate + 1;
                        end
                    end
                endcase
            end
            `CSTATE_PTRA,`CSTATE_PTRB: begin
                case(sstate)
                    0: begin
                        /* Load A to ADDR */
                        alu_read <= 0;
                        alu_ld   <= 0;
                        rd_req   <= 0;
                        reg_wr   <= `REG_NONE;
                        reg_rd   <= (cstate == `CSTATE_PTRA) ? `REG_A : `REG_B;
                        sstate   <= 1;
                    end
                    1: begin
                        /* Read from memory */
                        rd_req <= 1;
                        sstate <= 2;
                    end
                    2: begin
                        /* Store DATA to ALU A */
                        if(ctrl[`CTRL_RD_READY]) begin
                            alu_mode <= 1;
                            alu_ld   <= (cstate == `CSTATE_PTRA) ? 2'b01 : 2'b10;
                            sstate   <= 0;
                            cstate   <= cstate + 1;
                        end
                    end
                endcase
            end
            `CSTATE_SUB: begin
                case(sstate)
                    0: begin
                        /* Initiate subtraction */
                        alu_ld <= 0;
                        reg_rd <= 0;
                        rd_req <= 0;
                        sstate <= 1;
                    end
                endcase
            end
        endcase
    end
endmodule
