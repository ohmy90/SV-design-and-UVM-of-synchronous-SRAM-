interface sram_if #(parameter int DEPTH = 16, parameter int WIDTH = 8) (input logic clk);
  logic wr_en;
  logic rd_en;
  logic rst_n;
  logic [$clog2(DEPTH)-1:0] addr;
  logic [WIDTH-1:0] wdata;
  logic [WIDTH-1:0] rdata;

endinterface


module sram #(parameter int DEPTH = 16, parameter int WIDTH = 8) (
  sram_if vif
);
  logic [WIDTH-1:0] mem [0:DEPTH-1];

  always_ff @(posedge vif.clk or negedge vif.rst_n) begin
    if (!vif.rst_n) vif.rdata <= '0;
    else begin
      if (vif.wr_en) mem[vif.addr] <= vif.wdata;
      if (vif.rd_en) vif.rdata <= mem[vif.addr];
    end
  end
endmodule
