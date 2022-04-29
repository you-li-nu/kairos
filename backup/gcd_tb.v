module gcd_dest_m_tb;

  reg clk;
  reg reset;
  reg start;
  reg [5:0] Ain,Bin;
  wire equiv;
  wire [5:0] A1, B1, A2, B2;
  
  gcd_dest_m gcd_dest_m(.clk(clk), .reset(reset), .start(start),
                        .Ain(Ain), .Bin(Bin), .equiv(equiv), .ao1(A1), .bo1(B1), .ao2(A2), .bo2(B2));
          
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(1);
    
    $display("Reset.");
    clk = 0;
    reset = 1;
    start = 0;
    Ain = 6'b000000;
    Bin = 6'b000000;
    display;
    
    $display("Toggle clk.");
    clk = 1;
    display;
    
    $display("Start");
    clk = 0;
    reset = 0;
    start = 1;
    Ain = 6'b101010;
    Bin = 6'b000000;
    display;
    
    $display("Toggle clk.");
    clk = 1;
    display;

    $display("Run");
    clk = 0;
    reset = 0;
    start = 0;
    Ain = 6'b101010;
    Bin = 6'b000000;
    display;

    $display("Toggle clk 0.");
    clk = 1;
    display;

    $display("Toggle clk.");
    clk = 0;
    display;

    $display("Toggle clk 1.");
    clk = 1;
    display;
    
    $display("Toggle clk.");
    clk = 0;
    display;

    $display("Toggle clk 2.");
    clk = 1;
    display;

    $display("Toggle clk.");
    clk = 0;
    display;

    $display("Toggle clk 3.");
    clk = 1;
    display;

  end
  
  task display;
    #1 $display("equiv:%0b, A1:%0b, B1:%0b, A2:%0b, B2:%0b",equiv, A1, B1, A2, B2);
  endtask

endmodule