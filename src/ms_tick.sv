module ms_tick #(
    parameter integer CLK_HZ = 100_000_000
) (
    input  logic clk,
    input  logic reset,
    output logic tick
);
    localparam integer COUNT_MAX = (CLK_HZ / 1000) - 1;
    localparam integer WIDTH = (COUNT_MAX < 1) ? 1 : $clog2(COUNT_MAX + 1);

    logic [WIDTH-1:0] count;

    always_ff @(posedge clk) begin
        if (reset) begin
            count <= '0;
            tick  <= 1'b0;
        end else if (count == COUNT_MAX) begin
            count <= '0;
            tick  <= 1'b1;
        end else begin
            count <= count + 1'b1;
            tick  <= 1'b0;
        end
    end
endmodule
