module tb;


    logic       clock;
    logic       nreset;
    logic [7:0] x_data;
    logic [7:0] y_data;
    logic       ena;

    xtimes uut_xtime(
    .clock (clock ),
    .nreset(nreset),
    .x_data(x_data),
    .y_data(y_data),
    .ena   (ena   ));

    initial begin
        x_data = 8'h57;
        clock = 0;
        nreset = 1;
        #1
        nreset =0;
        #1 
        nreset =1;

        #10 $finish;
    end

    always #1 clock = ~clock;

endmodule