module matrix2vec#(parameter MATRIX_LEN = 4)(
    input logic [7:0] data_in[0:3][0:3],
    output logic [127:0]  data_out
);


generate
    genvar i, j;
    for(i =0;i < MATRIX_LEN; i++)
        for(j =0;j < MATRIX_LEN; j++)
        //    print(i,j,"->",(i*4+j)*8+7,(i*4+j)*8)
            assign data_out[(i*MATRIX_LEN+j)*8+7:(i*MATRIX_LEN+j)*8] = data_in[i][j];
        /*
            assign uut_subbytes_input_data[0][0]= data_input[07:00];
            assign uut_subbytes_input_data[0][1]= data_input[15:08];
            assign uut_subbytes_input_data[0][2]= data_input[23:16];
            assign uut_subbytes_input_data[0][3]= data_input[31:24];

            assign uut_subbytes_input_data[1][0]= data_input[39:32];
            assign uut_subbytes_input_data[1][1]= data_input[47:40];
            assign uut_subbytes_input_data[1][2]= data_input[55:48];
            assign uut_subbytes_input_data[1][3]= data_input[63:56];

            assign uut_subbytes_input_data[2][0]= data_input[39:32];
            assign uut_subbytes_input_data[2][1]= data_input[47:40];
            assign uut_subbytes_input_data[2][2]= data_input[55:48];
            assign uut_subbytes_input_data[2][3]= data_input[63:56];
        */
endgenerate
endmodule 