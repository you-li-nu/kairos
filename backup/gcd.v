module gcd_fast_m (clk,reset,start,Ain,Bin,ao,bo,Out,valid);
    input clk,reset,start;
    input [5:0] Ain,Bin;
    output reg [5:0] Out;
    output reg valid;

    reg [5:0] A,B;
    output [5:0] ao, bo;
  
  	assign ao = A;
  	assign bo = B;

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

module gcd_slow_m (clk,reset,start,Ain,Bin,Out,ao,bo,valid);
    input clk,reset,start;
    input [5:0] Ain,Bin;
    output reg [5:0] Out;
    output reg valid;

    reg [5:0] A,B;
    output [5:0] ao, bo;
  
  	assign ao = A;
  	assign bo = B;

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

module gcd_dest_m (clk,reset,start,Ain,Bin,ao1,bo1,ao2,bo2,equiv);
	input clk;
	wire clk_1;
	wire clk_2;
	input reset;
	input start;
	input [5:0] Ain;
	input [5:0] Bin;
	wire [5:0] Out_1;
	wire [5:0] Out_2;
	wire valid_1;
	wire valid_2;
	wire clk_en_1;
	wire clk_en_2;
  	output [5:0] ao1, ao2, bo1, bo2;
	output equiv;

	assign clk_en_1 = ~(valid_1 & ~ valid_2);

	assign clk_en_2 = ~(valid_2 & ~ valid_1);

	assign clk_1 = clk & clk_en_1;

	assign clk_2 = clk & clk_en_2;

	assign equiv = ~valid_1 | ~valid_2 | Out_1 == Out_2;

	gcd_fast_m fast_m (
		.clk(clk_1),
		.reset(reset),
		.start(start),
		.Ain(Ain),
		.Bin(Bin),
		.Out(Out_1),
		.ao(ao1),
		.bo(bo1),
		.valid(valid_1)
	);

	gcd_slow_m slow_m (
		.clk(clk_2),
		.reset(reset),
		.start(start),
		.Ain(Ain),
		.Bin(Bin),
		.Out(Out_2),
		.ao(ao2),
		.bo(bo2),
		.valid(valid_2)
	);

endmodule