`timescale 1ns/10ps

/* Register Card
 * Contains Instruction Pointer and temporary pointer registers */

module register_card(
/* Data Bus */
    inout [(`DATAWIDTH - 1):0] data,
/* Address Bus */
    input [(`DATAWIDTH - 1):0] address,
/* Control Bus */
    input [(`CTRLWIDTH - 1):0] ctrl,
/* Clock input */
    input        clk);

    reg [(`DATAWIDTH - 1):0] IP;
    reg [(`DATAWIDTH - 1):0] A;
    reg [(`DATAWIDTH - 1):0] B;
    reg [(`DATAWIDTH - 1):0] T;

    reg [(`DATAWIDTH - 1):0] dataOut;

    assign data = ctrl[9] ? dataOut : (`DATAWIDTH)'bz;

    always @(negedge clk) begin
        if(ctrl[6]) begin // Write select
            case(ctrl[5:4])
                0: IP <= data;
                1: B  <= data;
                2: A  <= data;
                3: T  <= data;
            endcase
        end

        if(ctrl[9]) begin // Read select
            assign dataOut = (ctrl[8:7] == 0) ? IP :
                             (ctrl[8:7] == 1) ? B  :
                             (ctrl[8:7] == 2) ? A  :
                             (ctrl[8:7] == 3) ? T  : (`DATAWIDTH)'bz;
        end
    end

endmodule
