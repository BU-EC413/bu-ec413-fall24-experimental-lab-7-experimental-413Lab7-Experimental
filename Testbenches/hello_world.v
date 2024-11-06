// Testbenches/hello_world.v
`timescale 1ns / 1ps

module hello_world;
  reg signal;  // Declare a register to act as our "Hello World" signal

  initial begin
    // Print a simple message to indicate the start of the simulation
    $display("Starting Hello World Simulation...");

    // Initialize the signal
    signal = 0;
    $display("Time=%0t | signal=%b", $time, signal);

    // Change the signal after 10 time units
    #10 signal = 1;
    $display("Time=%0t | signal=%b", $time, signal);

    // End the simulation
    #10 $finish;
  end
endmodule
