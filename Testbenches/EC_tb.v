`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:39:32 03/21/2017 
// Design Name: 
// Module Name:    discussion_tb 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////
module EC_tb;

   // Inputs
   reg clk;
   reg Reset;
   reg LoadInstructions;
   reg [31:0] Instruction;
   
   // Outputs
   wire [31:0] out;
   
   // Instantiate the Unit Under Test (UUT)
   CPU uut (
            .out(out), 
            .clk(clk), 
            .Reset(Reset), 
            .LoadInstructions(LoadInstructions), 
            .Instruction(Instruction)
            );
   
   task check_output;
      input [31:0] out;
      input [31:0] EXPECTED_VALUE_AT_TIME;
      begin
         // Expected value at 170 ns
         if (out !== EXPECTED_VALUE_AT_TIME) begin
            $display("FAIL at time %t ns: out = %h, expected %h", $time, out, EXPECTED_VALUE_AT_TIME);
            $finish;
         end else begin
            $display("PASS at time %t ns: out = %h", $time, out);
         end
      end
   endtask

   initial begin
      // Initialize Inputs
      clk = 0;
      Reset = 1;
      LoadInstructions = 0;
      Instruction = 0;
      #10;
      
      Reset = 0;
      LoadInstructions = 1;
      // #10;
      // 0
      Instruction = 32'b001000_00000_00001_0000000110100111; // addi $R1, $0, 423
      #10; // 1                                              // -> 423
      Instruction = 32'b001000_00000_00010_0000000001011100; // addi $R2, $0, 92
      #10; // 2                                              // -> 92

      // test sw to address 4 with value of r1
      Instruction = 32'b101011_00000_00001_0000000000000100; // sw $R1, 4($0)

      #50
      // now we should have 423 in address 4
      // to test for RAW hazard, we will sw r2 to address 4
      Instruction = 32'b101011_00000_00010_0000000000000100; // sw $R2, 4($0)
      #10
      // right after the sw, we will have 423 in address 4, 92 in on it's way to address 4
      // to test for RAW hazard, we will lw r3 from address 4
      Instruction = 32'b100011_00000_00011_0000000000000100; // lw $R3, 4($0)
      // r3 should have 92 now

      #10
      // addi r3, r3, 1
      Instruction = 32'b001000_00011_00011_0000000000000001; // addi $R3, $R3, 1

      #10
    
      LoadInstructions = 0;
      Reset = 1;
      #10;
		
      Reset = 0;

      #130
      // Expected value after execution of instructions
      check_output(out, 32'd93); // 93 is the expected value of r3 after the last instruction, incorrect value is 1


      $finish;
      

   end
	
   always begin
      #5;
      clk = ~clk;
   end
   
endmodule
