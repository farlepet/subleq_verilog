/* Register Card
 * Contains Instruction Pointer and temporary pointer registers */

`include "src/config.v"

module register_card
#(
    parameter DATAWIDTH = `DATAWIDTH,
    parameter CTRLWIDTH = `CTRLWIDTH
)
(
/* Data Bus */
    input  [DATAWIDTH-1:0] data,
/* Address Bus */
    output [DATAWIDTH-1:0] addr,
/* Control Bus */
    input  [CTRLWIDTH-1:0] ctrl,
/* Clock input */
    input                  clk
);

    reg [DATAWIDTH-1:0] PC = 1;
    reg [DATAWIDTH-1:0] A  = 0;
    reg [DATAWIDTH-1:0] B  = 0;

    reg [DATAWIDTH-1:0] dataOut = 0;

    assign addr = (|ctrl[`CTRL_REG_RD+1:`CTRL_REG_RD]) ? dataOut : {DATAWIDTH{1'bz}};

    always @(negedge clk) begin
        case(ctrl[(`CTRL_REG_WR+1):`CTRL_REG_WR])
            `REG_PC: PC <= data;
            `REG_A:  A  <= data;
            `REG_B:  B  <= data;
        endcase

        case(ctrl[(`CTRL_REG_RD+1):`CTRL_REG_RD])
            `REG_NONE: dataOut <= {DATAWIDTH{1'b0}};
            `REG_PC:   dataOut <= PC;
            `REG_A:    dataOut <= A;
            `REG_B:    dataOut <= B;
        endcase

        $display("PC: %04X, A: %04X, B: %04X", PC, A, B);
    end

endmodule
