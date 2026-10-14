module shiftrows(
    input  logic [7:0] input_data[3:0][3:0],
    output logic [7:0] output_data[3:0][3:0]
);

assign output_data[0][0] = input_data[0][0];
assign output_data[0][1] = input_data[0][1];
assign output_data[0][2] = input_data[0][2];
assign output_data[0][3] = input_data[0][3];

assign output_data[1][0] = input_data[1][1];
assign output_data[1][1] = input_data[1][2];
assign output_data[1][2] = input_data[1][3];
assign output_data[1][3] = input_data[1][0];

assign output_data[2][0] = input_data[2][2];
assign output_data[2][1] = input_data[2][3];
assign output_data[2][2] = input_data[2][0];
assign output_data[2][3] = input_data[2][1];

assign output_data[3][0] = input_data[3][3];
assign output_data[3][1] = input_data[3][0];
assign output_data[3][2] = input_data[3][1];
assign output_data[3][3] = input_data[3][2];

endmodule
