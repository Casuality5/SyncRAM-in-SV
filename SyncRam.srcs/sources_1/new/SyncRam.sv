module SyncRam #(
  parameter DATA_WIDTH = 8,
  parameter ADDR_WIDTH = 4
) (
  input clk,
  input logic wr_en,
  input logic [DATA_WIDTH-1:0] wr_data,
  input logic [ADDR_WIDTH-1:0] addr,
  output logic [DATA_WIDTH-1:0] rd_data
);

  localparam DEPTH = 1 << ADDR_WIDTH;

  logic [DATA_WIDTH-1:0] memory [DEPTH-1:0];

  always_ff @(posedge clk) begin
    if (wr_en) begin
      memory[addr] <= wr_data;
    end else begin
      rd_data <= memory[addr];
    end
  end

endmodule
