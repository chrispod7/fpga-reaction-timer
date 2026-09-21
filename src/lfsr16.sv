module lfsr16 (
    input  logic        clk,
    input  logic        reset,
    input  logic        enable,
    output logic [15:0] value
);
    logic feedback;

    assign feedback = value[15] ^ value[13] ^ value[12] ^ value[10];

    always_ff @(posedge clk) begin
        if (reset)
            value <= 16'h1ACE;
        else if (enable)
            value <= {value[14:0], feedback};
    end
endmodule
