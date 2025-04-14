`include "spike.v"         // Include state mashine for spike genation

module top (
    output wire trig,            // 10us spike output
    input wire hw_clk            // Hardware clock input (unused, using internal oscillator)
);

// Clock generation
wire int_osc;                    // Internal oscillator signal

// Instantiate spike genarator
spike spike_inst (
    .clk(int_osc),               // Connect to internal oscillator
    .trig(trig)                 // Connect to trigger output pin
);

// Instantiate internal oscillator (6 MHz)
SB_HFOSC #(.CLKHF_DIV ("0b11")) u_SB_HFOSC (
    .CLKHFPU(1'b1),              // Power up high-frequency oscillator
    .CLKHFEN(1'b1),              // Enable high-frequency oscillator
    .CLKHF(int_osc)              // Output clock signal
);

endmodule
