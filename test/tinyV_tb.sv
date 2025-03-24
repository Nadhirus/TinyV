`timescale 1ns / 1ps
`default_nettype none

module tinyV_tb;
  // Clock and reset signals
  logic        clk;
  logic        reset;

  // Memory interfaces
  logic [31:0] d_address;
  logic [31:0] d_data_read;
  logic [31:0] d_data_write;
  logic [ 3:0] d_data_wstrb;
  logic        d_write_enable;
  logic        d_data_valid;

  logic [31:0] i_address;
  logic [31:0] i_data_read;
  logic        i_data_valid;

  // Memory model with initialization
  logic [31:0] instr_memory   [1023] = '{default: 32'h0};  // 4KB instruction memory
  logic [31:0] data_memory    [1023] = '{default: 32'h0};  // 4KB data memory

  // Instantiate the core
  tinyV dut (
          .clk  (clk),
          .reset(reset),

          .d_address(d_address),
          .d_data_read(d_data_read),
          .d_data_write(d_data_write),
          .d_data_wstrb(d_data_wstrb),
          .d_write_enable(d_write_enable),
          .d_data_valid(d_data_valid),

          .i_address(i_address),
          .i_data_read(i_data_read),
          .i_data_valid(i_data_valid)
        );

  // Clock generation
  initial
  begin
    clk = 0;
    forever
      #5 clk = ~clk;  // 100MHz clock
  end

  // Instruction memory model
  always_ff @(posedge clk)
  begin
    i_data_read  <= instr_memory[i_address[11:2]];  // Word-aligned access
    i_data_valid <= 1'b1;  // Always valid for simplicity
  end

  // Data memory model (Write Operations)
  always_ff @(posedge clk)
  begin
    if (d_write_enable)
    begin
      // Handle byte-level writes
      if (d_data_wstrb[0])
        data_memory[d_address[11:2]][7:0] <= d_data_write[7:0];
      if (d_data_wstrb[1])
        data_memory[d_address[11:2]][15:8] <= d_data_write[15:8];
      if (d_data_wstrb[2])
        data_memory[d_address[11:2]][23:16] <= d_data_write[23:16];
      if (d_data_wstrb[3])
        data_memory[d_address[11:2]][31:24] <= d_data_write[31:24];
      $display("Memory write: addr=0x%h, data=0x%h, strobe=0x%h", d_address, d_data_write,
               d_data_wstrb);
    end
  end

  // Data memory model (Read Operations)
  always_comb
  begin
    d_data_read  = data_memory[d_address[11:2]];
    d_data_valid = 1'b1;
  end

  // Run test
  initial
  begin
    // Load instructions - no longer initializing memories here
    instr_memory[0] = 32'h01900093;  // addi x1, x0, 25
    instr_memory[1] = 32'h02C00113;  // addi x2, x0, 44
    instr_memory[2] = 32'h002081B3;  // add x3, x1, x2
    instr_memory[3] = 32'h00300023;  // sb x3, 0(x0)
    instr_memory[4] = 32'hFFFFFFF6;  // Illegal instruction

    // Apply reset
    reset = 1;
    #20;
    reset = 0;

    // Run simulation for enough cycles to complete all instructions
    #350;

    // Check results
    if (data_memory[0][7:0] == 8'd69)
    begin
      $display("TEST PASSED! Memory[0] = %d (Expected: 69)", data_memory[0][7:0]);
    end
    else
    begin
      $display("TEST FAILED! Memory[0] = %d (Expected: 69)", data_memory[0][7:0]);
    end

    // Display register values
    $display("Register values from simulation (from memory):");
    $display("x1 = 25 (should be)");
    $display("x2 = 44 (should be)");
    $display("x3 = 69 (should be)");
    $display("Memory[0] = %d", data_memory[0][7:0]);

  end

  // Debug and trace
  integer cycle_count = 0;
  always @(posedge clk)
  begin
    if (reset)
    begin
      cycle_count <= 0;
    end
    else
    begin
      cycle_count <= cycle_count + 1;
      $display("Cycle %0d: PC=0x%h, Instr=0x%h", cycle_count, i_address, i_data_read);

      // Detect illegal instruction (optional)
      if (i_data_read == 32'hFFFFFFF6 && cycle_count > 5)
      begin
        $display("Reached illegal instruction at cycle %0d", cycle_count);
      end
    end
  end

endmodule
