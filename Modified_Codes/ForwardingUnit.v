`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/10/2021 01:06:00 PM
// Design Name: 
// Module Name: ForwardingUnit
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module ForwardingUnit(
input [4:0] Rs,
input [4:0] Rt,
input [4:0] EXMemDest,
input EXMemRegWrite,
input [4:0] MemWBDest,
input MemWBRegWrite,
output reg[1:0] ForwardA,
output reg[1:0] ForwardB);


always @(*)begin
    ForwardA = EXMemRegWrite && (EXMemDest!= 0) &&(EXMemDest == Rs)? 10:
    MemWBRegWrite && (MemWBDest != 0) && (MemWBDest == Rs) ? 01:
    00;
    
    ForwardB = EXMemRegWrite && (EXMemDest!= 0) &&(EXMemDest == Rt)? 10:
    MemWBRegWrite && (MemWBDest != 0) && (MemWBDest == Rt) ? 01:
    00;    

end

endmodule
