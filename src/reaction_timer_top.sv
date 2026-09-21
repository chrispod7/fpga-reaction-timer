module reaction_timer_top #(
    parameter integer CLK_HZ = 100_000_000,
    parameter integer MIN_WAIT_MS = 1000,
    parameter integer MAX_WAIT_MS = 4000
) (
    input  logic       clk,
    input  logic       reset,
    input  logic       button,
    output logic [6:0] seg,
    output logic [3:0] an,
    output logic       go_led
);
    logic ms_pulse;
    logic button_clean;
    logic button_pressed;
    logic [15:0] random_value;
    logic [1:0] state;
    logic [13:0] reaction_ms;
    logic false_start;

    ms_tick #(.CLK_HZ(CLK_HZ)) tick_gen (
        .clk(clk),
        .reset(reset),
        .tick(ms_pulse)
    );

    debounce #(.STABLE_SAMPLES(4)) button_filter (
        .clk(clk),
        .reset(reset),
        .sample_tick(ms_pulse),
        .noisy_in(button),
        .clean(button_clean),
        .pressed(button_pressed)
    );

    lfsr16 random_delay_source (
        .clk(clk),
        .reset(reset),
        .enable(ms_pulse),
        .value(random_value)
    );

    reaction_timer_core #(
        .MIN_WAIT_MS(MIN_WAIT_MS),
        .MAX_WAIT_MS(MAX_WAIT_MS)
    ) core (
        .clk(clk),
        .reset(reset),
        .ms_tick(ms_pulse),
        .button_pressed(button_pressed),
        .random_value(random_value),
        .state(state),
        .reaction_ms(reaction_ms),
        .false_start(false_start)
    );

    sevenseg_driver #(.CLK_HZ(CLK_HZ)) display (
        .clk(clk),
        .reset(reset),
        .state(state),
        .reaction_ms(reaction_ms),
        .false_start(false_start),
        .seg(seg),
        .an(an)
    );

    assign go_led = (state == 2'd2);
endmodule
