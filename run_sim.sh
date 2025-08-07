#!/bin/bash

# Compile the Verilog design and testbench
echo "Compiling Verilog files..."

iverilog -o fifo_sim fifo.v fifo_tb.v

# Run the simulation
echo "Running simulation..."

vvp fifo_sim

# Open the waveform with GTKWave
echo "Launching GTKWave..."

gtkwave fifo_tb.vcd
