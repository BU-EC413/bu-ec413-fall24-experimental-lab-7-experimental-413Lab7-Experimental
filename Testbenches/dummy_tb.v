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
module dummy_tb;

   // Inputs
   reg clk;
   reg Reset;
   reg LoadInstructions;
   reg [31:0] Instruction;
   
   // Outputs
   wire [31:0] out;
   
   // Instantiate the Unit Under Test (UUT)
   CPU_original uut (
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
      Instruction = 32'b001000_00000_00011_0000000000001101; // addi $R3, $0, 13
      #10; // 3                                              // -> 13
      Instruction = 32'b001000_00000_00100_0000000010010010; // addi $R4, $0, 146
      #10; // 4                                              // -> 146
      Instruction = 32'b001000_00000_00101_0000000000000101; // addi $R5, $0, 5
      #10; // 5                                              // -> 5
      Instruction = 32'b000000_00001_00100_00101_00000_100000; // add $R5, $R1, $R4
      #10; // 6                                             // -> 569 (423 if wrong)
      Instruction = 32'b000000_00011_00101_00110_00000_101010; // slt $R6, $R3, $R5
      #10; // 7                                                // -> 1 (0 if wrong)
      Instruction = 32'b100011_00000_00100_0000000000000100;   // LW $R4, 4(R0)
      #10; // 8                                                // -> 4
      Instruction = 32'b000000_00100_00110_00111_00000_100010; // sub $R7, $R4, $R6
      #10; // 9                                         // -> 3 (146 or 145 if wrong)
      Instruction = 32'b101011_00000_00111_0000000000000000;   // SW $R7, 0(R0)
      #10; // 10                                            
      Instruction = 32'b000000_00111_00010_01000_00000_100000; // add R8, R7, R2
      #10; //                                                  // 95 (92 if wrong)
		
      LoadInstructions = 0;
      Reset = 1;
      #10;
		
      Reset = 0;

      // Wait for simulation time to reach 170 ns
      // check for instruction addi $R1, $0, 423
      #40;
      check_output(out, 32'd423);

      // check for instruction addi $R2, $0, 92
      #10;
      check_output(out, 32'd92);

      // check for instruction addi $R3, $0, 13
      #10;
      check_output(out, 32'd13);

      // check for instruction addi $R4, $0, 146
      #10;
      check_output(out, 32'd146);

      // check for instruction addi $R5, $0, 5
      #10;
      check_output(out, 32'd5);

      // check for instruction add $R5, $R1, $R4
      #10;
      check_output(out, 32'd423);

      // check for instruction slt $R6, $R3, $R5
      #10;
      check_output(out, 32'd0);

      // check for instruction LW $R4, 4(R0)
      #10;
      check_output(out, 32'd4);

      // check for instruction sub $R7, $R4, $R6
      #10;
      check_output(out, 32'd146);

      // No check for instruction SW $R7, 0(R0)
      #10;

      // check for instruction add R8, R7, R2
      #10;
      check_output(out, 32'd92);


      // Wait for simulation time to reach 170 ns

      // #100;
      
      // // stop simulation after 1000 ns
      // #1000;
      $finish;
      

   end
	
   always begin
      #5;
      clk = ~clk;
   end
   
endmodule
