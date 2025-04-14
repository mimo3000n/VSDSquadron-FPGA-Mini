module spike #(
    parameter TRIGGER_CYCLES = 60,                // Duration of trigger pulse (60 clock cycles)
)(
    input clk,                                    // System clock input
    output reg trig                              // Trigger signal to ultrasonic sensor
);
 reg [1:0] state = 0;                             // FSM state register (4 states: 0-3)
 reg [7:0] trig_counter = 0;                      // Counter for trigger pulse duration

always @(posedge clk) begin                       // Main state machine, runs on every clock edge
    case(state)
        0: begin  // Idle state - Initialize all counters
            trig <= 0;                            // Ensure trigger is low
            trig_counter <= 0;                    // Reset trigger counter
            state <= 1;                           // Move to trigger generation state
        end
        
        1: begin  // Generate trigger pulse state
            trig <= 1;                            // Set trigger high
            trig_counter <= trig_counter + 1;     // Increment trigger duration counter
            if(trig_counter == TRIGGER_CYCLES-1) begin  // Check if trigger pulse is complete
                trig <= 0;                        // Set trigger low
                state <= 0;                       // Move to echo measurement state
            end
        end
        
        default: state <= 0;                      // Safety default to return to idle state
    endcase
end
endmodule
