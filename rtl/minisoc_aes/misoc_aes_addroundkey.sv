module addroundkey(
    input  logic clock,
    input  logic nreset,
    input  logic [127:0]data_in,
    input  logic [127:0]key,
    output logic [127:0]data_out,
    input  logic ena
);

logic [127:0] comb_data;
assign comb_data = data_in ^ key;
always_ff@(posedge clock, negedge nreset)begin
    if(!nreset)begin
        data_out <= '{default:0};
    end else begin
        if(ena) data_out <= comb_data;
    end
end
endmodule