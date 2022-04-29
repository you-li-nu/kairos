module gcd_fast_m (clk,reset,start,Ain,Bin,Out,valid);
    input clk,reset,start;
    input [5:0] Ain,Bin;
    output reg [5:0] Out;
    output reg valid;

    reg [5:0] A,B;

    always @ (posedge clk)
        begin
            if (start)
                begin
                    A <= Ain; B <= Bin; valid <= 0;
                end
            else if (reset)
                begin
                    A <= 6'b000000; B <= 6'b000000; valid <= 0;
                end
            else if (A > B)
                begin
                    A <= A - B;
                end
            else if (A < B)
                begin
                    B <= B - A;
                end
            else
                begin
                    Out <= A;
                    valid <= 1;
                end
        end
endmodule