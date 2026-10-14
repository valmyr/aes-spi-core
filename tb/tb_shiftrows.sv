module tb;


    logic       clock;
    logic       nreset;


  
    logic [7:0] uut_shiftrows_input_data[3:0][3:0];
    logic [7:0] uut_shiftrows_output_data[3:0][3:0];

    localparam MATRIX_LEN = 4;

    shiftrows #(.MATRIX_LEN(MATRIX_LEN))uut_shiftrows(
        .input_data(uut_shiftrows_input_data),
        .output_data(uut_shiftrows_output_data)
    );

    initial begin
        // Basic: dump all signals from tb_top downward, all hierarchy
        $fsdbDumpfile("waves.fsdb");
        $fsdbDumpvars(0, tb);         // 0 = all levels of hierarchy
        
        // Dump multi-dimensional arrays (memories, packed arrays)
        $fsdbDumpMDA();
        clock = 0;
        nreset = 1;
        #1
        nreset =0;
        #1 
        nreset =1;
        //Exemple
        uut_shiftrows_input_data = '{
            '{8'hEA, 8'h04, 8'h65, 8'h85},  // Linha 0[cite: 1]
            '{8'h83, 8'h45, 8'h5D, 8'h96},  // Linha 1[cite: 1]
            '{8'h5C, 8'h33, 8'h98, 8'hB0},  // Linha 2[cite: 1]
            '{8'hF0, 8'h2D, 8'hAD, 8'hc5}   // Linha 3[cite: 1]
        };

        // Optional: stop dumping after N ns to limit file size
        #(40);
        $fsdbDumpoff;
        $finish;

    end

    always #1 clock = ~clock;
    


endmodule