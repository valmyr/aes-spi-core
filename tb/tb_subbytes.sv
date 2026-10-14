module tb;


    logic       clock;
    logic       nreset;


    logic       uut_subbytes_clock;
    logic       uut_subbytes_nreset;
    logic [7:0] uut_subbytes_input_data[3:0][3:0];
    logic [7:0] uut_subbytes_output_data[3:0][3:0];
    logic       uut_subbytes_valid_i;
    logic       uut_subbytes_ready_o ;
    logic       uut_subbytes_rvalid_o;
    logic       uut_subbytes_rready_i;


    subbytes uut_subbytes(
        .clock(uut_subbytes_clock),
        .nreset(uut_subbytes_nreset),
        .input_data(uut_subbytes_input_data),
        .output_data(uut_subbytes_output_data),
        .valid_i(uut_subbytes_valid_i),
        .ready_o(uut_subbytes_ready_o),
        .rvalid_o(uut_subbytes_rvalid_o),
        .rready_i(uut_subbytes_rready_i)
    );
    assign uut_subbytes_clock=clock;
    assign uut_subbytes_nreset=nreset;

    assign uut_subbytes_rready_i =0; //Always Downstream...
    assign uut_subbytes_valid_i=1; //Always Upstream...
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
        uut_subbytes_input_data = '{
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