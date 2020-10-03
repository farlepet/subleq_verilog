/* Clock Card
 * Generates the main clock for the system */

`include "src/config.v"

module clock_card
#(
    parameter DATAWIDTH=`DATAWIDTH,
    parameter CTRLWIDTH=`CTRLWIDTH
)
(
/* Data Bus (unused) */
    input  [DATAWIDTH - 1:0] data,
/* Address Bus (unused) */
    input  [DATAWIDTH - 1:0] address,
/* Control Bus (unused) */
    input  [CTRLWIDTH - 1:0] ctrl,
/* Clock output */
    output reg                  clk);

    parameter period  = 10;

    initial clk = 0;

    always begin
        clk = ~clk;
        #(period/2);
    end

endmodule
