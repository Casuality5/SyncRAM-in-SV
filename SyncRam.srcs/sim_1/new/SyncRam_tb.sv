`timescale 1ns / 1ps

module SyncRam_tb;

  // --- Parameters ---
  parameter DATA_WIDTH = 8;
  parameter ADDR_WIDTH = 4;
  parameter CLK_PERIOD = 10;

  // --- Signal Declarations ---
  logic clk;
  logic wr_en;
  logic [DATA_WIDTH-1:0] wr_data;
  logic [ADDR_WIDTH-1:0] addr;
  wire  [DATA_WIDTH-1:0] rd_data;

  // --- Instantiation ---
  SyncRam #(
    .DATA_WIDTH(DATA_WIDTH),
    .ADDR_WIDTH(ADDR_WIDTH)
  ) dut (
    .clk(clk),
    .wr_en(wr_en),
    .wr_data(wr_data),
    .addr(addr),
    .rd_data(rd_data)
  );

  // --- Clock Generation ---
  initial begin
    clk = 0;
    forever #(CLK_PERIOD/2) clk = ~clk;
  end

  // --- Test Sequence ---
  initial begin
    $display("--- Starting SyncRAM Test ---");
    
    // Initialize signals
    wr_en = 1'b0;
    addr = '0;
    wr_data = '0;
    @(posedge clk);

    // Write 8'hAA to address 4'h1
    $display("[%0t] Writing 0xAA to address 1...", $time);
    wr_en   = 1'b1;
    addr    = 4'h1;
    wr_data = 8'hAA;
    @(posedge clk);

    // Write 8'hBB to address 4'h2
    $display("[%0t] Writing 0xBB to address 2...", $time);
    addr    = 4'h2;
    wr_data = 8'hBB;
    @(posedge clk);

    // Read from address 4'h1
    $display("[%0t] Reading from address 1...", $time);
    wr_en = 1'b0;
    addr  = 4'h1;
    @(posedge clk);

    // Check the read data (after one cycle of latency)
    $display("[%0t] Checking read data from address 1. Got: %h", $time, rd_data);
    assert (rd_data == 8'hAA) else $error("Read data mismatch! Expected 0xAA");

    // Read from address 4'h2
    $display("[%0t] Reading from address 2...", $time);
    addr = 4'h2;
    @(posedge clk);

    // Check the read data
    $display("[%0t] Checking read data from address 2. Got: %h", $time, rd_data);
    assert (rd_data == 8'hBB) else $error("Read data mismatch! Expected 0xBB");

    $display("--- Test Complete ---");
    $finish;
  end

endmodule
