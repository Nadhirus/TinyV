module top;

  // Clock and reset signals
  logic clk;
  logic reset;

  // Clock generation using an always block (no # delay operator)
  always begin
    clk = 0;
    #5 clk = 1;  // Toggle clock every 5 time units
    #5 clk = 0;  // Toggle clock every 5 time units
  end

  // Reset logic
  initial begin
    reset = 1;
    #20 reset = 0; // De-assert reset after 20 time units
  end

  // Instantiate the core
  core uut (
    .clk(clk),
    .reset(reset)
  );

  // Dump waveforms to a VCD file for GTKWave
  initial begin
    $dumpfile("dump.vcd");  // Specify the VCD file name
    $dumpvars(0, top);      // Dump all signals in the top module
  end

  // Optional: Monitor output signals
  initial begin
    $monitor("Time: %0t | Reset: %b | Clock: %b", $time, reset, clk);
  end

  // End simulation after a specific time
  initial begin
    #100 $finish; // Stop simulation after 1000 time units
  end

endmodule
