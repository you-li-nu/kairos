module gcd_dest_m_tb;

  reg clk;
  reg reset;
  reg start;
  reg [5:0] Ain,Bin;
  wire equiv;
  
  gcd_dest_m gcd_dest_m(.clk(clk), .reset(reset), .start(start),
          .Ain(Ain), .Bin(Bin), .equiv(equiv));
          
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
    Ain = 6'b000010;
    Bin = 6'b000100;
    display;
    
    $display("Toggle clk.");
    clk = 1;
    display;

    $display("Run");
    clk = 0;
    reset = 0;
    start = 0;
    Ain = 6'b000100;
    Bin = 6'b000010;
    display;

    $display("Toggle clk.");
    clk = 1;
    display;

    $display("Toggle clk.");
    clk = 0;
    display;

    $display("Toggle clk.");
    clk = 1;
    display;
    
    $display("Toggle clk.");
    clk = 0;
    display;

    $display("Toggle clk.");
    clk = 1;
    display;

    $display("Toggle clk.");
    clk = 0;
    display;

    $display("Toggle clk.");
    clk = 1;
    display;

  end
  
  task display;
    #1 $display("equiv:%0b",equiv);
  endtask

endmodule