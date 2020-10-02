`timescale 1ns/10ps

module driver;
    wire [0:15] data;
    wire [0:15] addr;
    wire [0:13] ctrl;
    wire        clk;

    clock_card    clock    (data, addr, ctrl, clk);
    address_card  address  (data, addr, ctrl, clk);
    register_card registers(data, addr, ctrl, clk);

    reg i;

    initial begin
        repeat (20) begin
            $display("clk: %d", clk);
            #2.5;
        end
        $finish;
    end

endmodule
