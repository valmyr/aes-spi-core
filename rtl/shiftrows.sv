module shiftrows#(
    parameter MATRIX_LEN=4
)(
    input  logic [7:0] input_data[3:0][3:0],
    output logic [7:0] output_data[3:0][3:0]
);
generate
    genvar i,j;
    for(i =0; i < MATRIX_LEN; i++)begin
        for(j=0; j < MATRIX_LEN; j++)begin
            //(i+j)%MATRIZ_LEN é desenrolado na etapa de compilação
            assign output_data[i][(i+j)%MATRIX_LEN]  = input_data[i][j];
        end
    end
endgenerate
endmodule
