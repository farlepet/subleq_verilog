`timescale 1ns/10ps

module address_card(
    input      [15:0] data,
    output reg [15:0] address,
    input      [13:0] ctrl,
    input             clk);

    always @(negedge clk)
        if(ctrl[12])
            address <= data;

endmodule
