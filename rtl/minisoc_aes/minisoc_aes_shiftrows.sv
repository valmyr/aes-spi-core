module shiftrows#(
    parameter MATRIX_LEN=4
)(
    input  logic [7:0] input_data[0:3][0:3],
    output logic [7:0] output_data[0:3][0:3]
);

logic [7:0] temp_data[0:3][0:3];

generate
    genvar i,j;
    for(i =0; i < MATRIX_LEN; i++)begin
        for(j=0; j < MATRIX_LEN; j++)begin
            //(i+j)%MATRIZ_LEN é desenrolado na etapa de compilação
            assign output_data[(i+j)%MATRIX_LEN][MATRIX_LEN-1-i] = input_data[j][MATRIX_LEN-1-i];
           // assign output_data[i][j] = temp_data[i][j];
        end
    end
endgenerate
endmodule
