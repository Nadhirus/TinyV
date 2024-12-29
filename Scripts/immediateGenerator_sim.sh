#!/bin/bash

# Paths to source files and testbench
SRC_DIR="../src"
TEST_DIR="../test"
IMM_FILE="$SRC_DIR/core/immediateGenerator.sv"
TB_FILE="$TEST_DIR/immediateGenerator_tb.sv"
VCD_FILE="immediateGenerator_dump.vcd"
SIMULATION_FILE="immediateGenerator_simulation.vvp"

# Simulation setup message
echo "Starting simulation for immediateGenerator..."

# Step 1: Compile Verilog files with Icarus Verilog (iverilog)
iverilog -g2012 \
    -I$SRC_DIR/core -I$SRC_DIR/memory -I$TEST_DIR \
    -o $SIMULATION_FILE \
    $IMM_FILE $TB_FILE

# Check for compilation errors
if [ $? -ne 0 ]; then
    echo "Error: Compilation failed!"
    exit 1
fi

# Check if the simulation file was generated
if [ ! -f "$SIMULATION_FILE" ]; then
    echo "Error: $SIMULATION_FILE not found."
    exit 1
fi

# Step 2: Run the simulation using vvp (Icarus Verilog simulator)
vvp $SIMULATION_FILE

# Check if vvp run was successful
if [ $? -ne 0 ]; then
    echo "Error: Simulation failed!"
    exit 1
fi

# Step 3: Generate the VCD waveform for GTKWave
echo "Generating waveform dump..."

# Check if the VCD file exists, then launch GTKWave
if [ -f "$VCD_FILE" ]; then
    echo "VCD file generated: $VCD_FILE"
    # Launch GTKWave for visualization of the waveform
    gtkwave $VCD_FILE
else
    echo "Error: VCD file not found. Please check the simulation."
    exit 1
fi

echo "Simulation complete. Check GTKWave for the results."
