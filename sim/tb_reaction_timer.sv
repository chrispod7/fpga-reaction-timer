`timescale 1ns/1ps

module tb_reaction_timer;
    localparam logic [1:0] IDLE   = 2'd0;
    localparam logic [1:0] WAIT_S = 2'd1;
    localparam logic [1:0] GO     = 2'd2;
    localparam logic [1:0] RESULT = 2'd3;

    logic clk = 1'b0;
    logic reset = 1'b1;
    logic ms_tick = 1'b0;
    logic button_pressed = 1'b0;
    logic [15:0] random_value = 16'd2;
    logic [1:0] state;
    logic [13:0] reaction_ms;
    logic false_start;

    reaction_timer_core #(
        .MIN_WAIT_MS(5),
        .MAX_WAIT_MS(8)
    ) dut (
        .clk(clk),
        .reset(reset),
        .ms_tick(ms_tick),
        .button_pressed(button_pressed),
        .random_value(random_value),
        .state(state),
        .reaction_ms(reaction_ms),
        .false_start(false_start)
    );

    always #5 clk = ~clk;

    task automatic pulse_ms(input integer count);
        integer i;
        begin
            for (i = 0; i < count; i = i + 1) begin
                @(negedge clk);
                ms_tick = 1'b1;
                @(negedge clk);
                ms_tick = 1'b0;
            end
        end
    endtask

    task automatic press_button;
        begin
            @(negedge clk);
            button_pressed = 1'b1;
            @(negedge clk);
            button_pressed = 1'b0;
        end
    endtask

    initial begin
        repeat (2) @(negedge clk);
        reset = 1'b0;

        if (state !== IDLE) $fatal(1, "Expected IDLE after reset");

        // Normal reaction test. random_value=2 => 5 + (2 %% 4) = 7 ms wait.
        press_button();
        if (state !== WAIT_S) $fatal(1, "Expected WAIT after start press");

        pulse_ms(7);
        if (state !== GO) $fatal(1, "Expected GO after random wait");

        pulse_ms(123);
        press_button();
        if (state !== RESULT) $fatal(1, "Expected RESULT after reaction press");
        if (reaction_ms !== 14'd123) $fatal(1, "Expected 123 ms, got %0d", reaction_ms);
        if (false_start !== 1'b0) $fatal(1, "Normal reaction incorrectly marked false start");

        press_button();
        if (state !== IDLE) $fatal(1, "Expected return to IDLE from RESULT");

        // False-start test.
        random_value = 16'd1;
        press_button();
        if (state !== WAIT_S) $fatal(1, "Expected WAIT before false-start test");
        pulse_ms(2);
        press_button();
        if (state !== RESULT) $fatal(1, "False start should move to RESULT");
        if (false_start !== 1'b1) $fatal(1, "False start flag was not set");

        $display("All reaction timer core tests passed.");
        $finish;
    end
endmodule
