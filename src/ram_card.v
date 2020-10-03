/* RAM Card
 * Contains RAM for access by the CPU */

`include "src/config.v"

module ram_card
#(
    parameter DATAWIDTH = `DATAWIDTH,
    parameter CTRLWIDTH = `CTRLWIDTH,
    parameter RAMSIZE   = 512
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

    reg [DATAWIDTH-1:0] ram [RAMSIZE-1:0];
    reg [DATAWIDTH-1:0] read_result       = 0;

    initial ram[0] = 6;
    initial ram[1] = 7;
    initial ram[2] = 3;
    initial ram[3] = 8;
    initial ram[4] = 8;
    initial ram[5] = 0;
    initial ram[6] = 1111;
    initial ram[7] = 4444;

    reg read_ready = 0;
    reg write_done = 0;

    /* Any read/write below 0x8000 is considered directed to this module
     * TODO: Make configurable as a parameter, or using RAMSIZE (with RAMBASE?) */
    wire read  = ctrl[`CTRL_RD_REQ] && !(addr[DATAWIDTH-1]);
    wire write = ctrl[`CTRL_WR_REQ] && !(addr[DATAWIDTH-1]);

    /* TODO: Should this be instantaneous or clock-gated? */
    assign data                 = read  ? read_result : {DATAWIDTH{1'bz}};
    assign ctrl[`CTRL_RD_READY] = read  ? read_ready  : 1'bz;
    assign ctrl[`CTRL_WR_DONE]  = write ? write_done  : 1'bz;

    always @(posedge clk) begin
        if(read) begin
            read_result <= ram[addr];
            read_ready  <= 1;
        end
        if(write) begin
            ram[addr]  <= data;
            write_done <= 1;
        end
    end

    always @(posedge read)  read_ready <= 0;
    always @(negedge read)  read_ready <= 0;

    always @(posedge write) write_done <= 0;
    always @(negedge write) write_done <= 0;
endmodule
