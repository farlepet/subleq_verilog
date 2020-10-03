/* ALU Card
 * Calculates A+1 and B - A */

`include "src/config.v"

module alu_card
#(
    parameter DATAWIDTH = `DATAWIDTH,
    parameter CTRLWIDTH = `CTRLWIDTH
)
(
/* Data Bus */
    inout [DATAWIDTH-1:0] data,
/* Address Bus */
    input [DATAWIDTH-1:0] addr,
/* Control Bus */
    inout [CTRLWIDTH-1:0] ctrl,
/* Clock input */
    input        clk
);

    reg [DATAWIDTH-1:0] A      = 0;
    reg [DATAWIDTH-1:0] B      = 0;
    reg [DATAWIDTH-1:0] result = 0;

    reg result_clean = 1;
    reg result_lez   = 0;

    wire [DATAWIDTH-1:0] src = ctrl[`CTRL_ALU_MODE] ? data : addr;

    /* TODO: Should this be instantaneous or clock-gated? */
    assign data = ctrl[`CTRL_ALU_READ] ? result : {DATAWIDTH{1'bz}};

    assign ctrl[`CTRL_ALU_DONE] = result_clean;
    assign ctrl[`CTRL_ALU_LEZ]  = result_lez;

    always @(negedge clk) begin
        if(ctrl[`CTRL_ALU_LD+1:`CTRL_ALU_LD]) begin
            if(ctrl[`CTRL_ALU_LD]) begin
                A <= src;
            end
            if(ctrl[`CTRL_ALU_LD+1]) begin
                B <= src;
            end
            result_clean <= 0;
        end
        
        $display("[ALU] A: %04X, B: %04X", A, B);
    end

    always @(negedge result_clean) begin
        if(ctrl[`CTRL_ALU_MODE]) begin
            /* TODO: Make the logic behind the operation explicit */
            result       <= (B - A);
            result_lez   <= ((result[DATAWIDTH-1] == 1) || (result == 0));
            result_clean <= 1;
        end else begin
            /* TODO: Make the logic behind the operation explicit */
            result       <= A + 1;
            result_lez   <= 0;
            result_clean <= 1;
        end
    end
endmodule
