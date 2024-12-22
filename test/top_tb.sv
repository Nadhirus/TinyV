module top_tb;

  // Clock and reset signals
  logic clk;
  logic reset;

  // Clock generation using an always block (no # delay operator)
  initial begin
    clk = 0;  // Ensure it starts at a defined value
    forever #5 clk = ~clk;  // Toggle clock every 5 time units
  end

  // Reset logic
  initial begin
    reset = 1;
    #10 reset = 0;  // De-assert reset after 20 time units
  end

  // Instantiate the core
  core uut (
    .clk  (clk),
    .reset(reset)
  );

  // Dump waveforms to a VCD file for GTKWave
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, top_tb);  // Captures the entire top module
  end

  // End simulation after a specific time
  initial begin
    #500 $finish;  // Stop simulation after 1000 time units
  end

endmodule
