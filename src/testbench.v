`include "src/config.v"

module driver;
    wire [(`DATAWIDTH-1):0] data;
    wire [(`DATAWIDTH-1):0] addr;
    wire [(`CTRLWIDTH-1):0] ctrl;
    wire                    clk;

    control_card  control  (data, addr, ctrl, clk);
    clock_card    clock    (data, addr, ctrl, clk);
    register_card registers(data, addr, ctrl, clk);
    alu_card      alu      (data, addr, ctrl, clk);
    ram_card      ram      (data, addr, ctrl, clk);

    reg i;

    initial begin
            $display("ADDR, DATA,           CTRL, CLK");
        repeat (128) begin
            $display("%04X, %04X, %014B, %d",
                     addr, data, ctrl, clk);
            #5;
        end
        $finish;
    end

endmodule
