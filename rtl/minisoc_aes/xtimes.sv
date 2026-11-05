//////////////////////////////////////////////////////////////////////////////////
// Company: CI-Expert
// Engineer: Valmir
// 
// Create Date: 23/01/2026 03:23:32 PM
// Design Name: 
// Module Name: xtimes
// Project Name: AES SPI CORE
// Target Devices: 
// Tool Versions: Vivado 2025.1
// Description: 
// 
// Dependencies: None
// 
// Revision:
// Revision 0.01 - File created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module xtimes(
    input  logic       clock,
    input  logic       nreset,
    input  logic [7:0] x_data,
    output logic [7:0] y_data,
    input  logic       ena
);
    logic [7:0]y_s0;
    logic [7:0]y_s1;
    logic top_bit;
    always_ff@(posedge clock, negedge nreset)begin
        if(!nreset)begin
            y_s0 <=0;
            y_s1 <=0;
        end else begin
            if(ena)begin
                y_s0 <= x_data;
                y_s1 <= (x_data << 1);
            end
        end
    end
    assign top_bit = y_s0[7];
    assign y_data =  y_s0[7] ? y_s1 ^ 8'h1b :  y_s1;
endmodule
