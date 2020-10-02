`timescale 1ns/10ps

/* Clock Card
 * Generates the main clock for the system */

module clock_card(
/* Data Bus (unused) */
    input  [(`DATAWIDTH - 1):0] data,
/* Address Bus (unused) */
    input  [(`DATAWIDTH - 1):0] address,
/* Control Bus (unused) */
    input  [(`CTRLWIDTH - 1):0] ctrl,
/* Clock output */
    output reg                  clk);

    parameter period  = 10;

    initial clk = 0;

    always begin
        clk = ~clk;
        #(period/2);
    end

endmodule
