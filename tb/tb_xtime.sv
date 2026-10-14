module tb;


    logic       clock;
    logic       nreset;
    logic       ena;
    logic [7:0] output_xor;
    logic [7:0] y_data [4:0];
    
    logic [7:0] b;
    generate
        genvar  i;
        for(i = 1; i < 5; i++)begin
            xtimes uut_xtime1(
                .clock (clock ),
                .nreset(nreset),
                .x_data(y_data[i-1]),
                .y_data(y_data[i]),
                .ena   (ena   )
            );

        end 
    endgenerate
    assign b = 8'h13;
assign output_xor = ({8{b[0]}} & y_data[0]) ^
                   ({8{b[1]}} & y_data[1]) ^
                   ({8{b[2]}} & y_data[2]) ^
                   ({8{b[3]}} & y_data[3]) ^
                   ({8{b[4]}} & y_data[4]) ^
                   ({8{b[5]}} & y_data[5]);
   assign y_data[0] =  8'h57;
    initial begin
        ena =1;
        
        clock = 0;
        nreset = 1;
        #1
        nreset =0;
        #1 
        nreset =1;

        #0 $finish;
    end

    always #1 clock = ~clock;
    


endmodule