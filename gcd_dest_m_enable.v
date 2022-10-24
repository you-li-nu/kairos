module gcd_fast_m (clk,enable,nstart,Ain,Bin,Out,valid);
    input clk,enable,nstart;
    input [5:0] Ain,Bin;
    output reg [5:0] Out;
    output reg valid;

    reg [5:0] A,B;

    always @ (posedge clk)
        begin
            if (~nstart)
                begin
                    A <= Ain; B <= Bin; valid <= 0;
                end
            else if (~enable)
                begin
                    A <= A; B <= B; valid <= valid;
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

module gcd_slow_m (clk,enable,nstart,Ain,Bin,Out,valid);
    input clk,enable,nstart;
    input [5:0] Ain,Bin;
    output reg [5:0] Out;
    output reg valid;

    reg [5:0] A,B;

    always @ (posedge clk)
        begin
            if (~nstart)
                begin
                    A <= Ain; B <= Bin; valid <= 0;
                end
          	else if (~enable)
                begin
                    A <= A; B <= B; valid <= valid;
                end
            else if (A > B)
                begin
                    A <= A - B;
                end
            else if (A < B)
                begin
                    A <= B;
                    B <= A;
                end
            else
                begin
                    Out <= A;
                    valid <= 1;
                end
        end
endmodule

module gcd_dest_m (clk,Ain,Bin,nequiv);
	input clk;
	reg nstart;
	input [5:0] Ain;
	input [5:0] Bin;
	wire [5:0] Out_1;
	wire [5:0] Out_2;
	wire valid_1;
	wire valid_2;
	wire en_1;
	wire en_2;
	output nequiv;
  
  	initial begin
      nstart = 0;
    end
  
  	always @ (posedge clk)
        begin
          nstart <= 1;
        end

	assign en_1 = ~(valid_1 & ~ valid_2);

	assign en_2 = ~(valid_2 & ~ valid_1);

	assign nequiv = ~(~valid_1 | ~valid_2 | Out_1 == Out_2);

	gcd_fast_m fast_m (
		.clk(clk),
      	.enable(en_1),
		.nstart(nstart),
		.Ain(Ain),
		.Bin(Bin),
		.Out(Out_1),
		.valid(valid_1)
	);

	gcd_slow_m slow_m (
		.clk(clk),
      	.enable(en_2),
		.nstart(nstart),
		.Ain(Ain),
		.Bin(Bin),
		.Out(Out_2),
		.valid(valid_2)
	);

endmodule
