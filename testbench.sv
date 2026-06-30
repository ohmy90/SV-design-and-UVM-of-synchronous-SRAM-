// Code your testbench here
// or browse Examples



module tb_top;
  import uvm_pkg::*;
  `include "uvm_macros.svh"
  `include "reg_transaction.sv"
  `include "sram_sequencer.sv"
  `include "sram_driver.sv"
  `include "sram_monitor.sv"
  `include "sram_coverage.sv"
  `include "sram_agent.sv"
  `include "sram_scoreboard.sv"
  `include "sram_env.sv"
  `include "sram_sequence.sv"
  `include "sram_test.sv"

  bit clk;
  always #10 clk = ~clk;

  sram_if   sram_if0 (clk);
  sram dut0   (sram_if0);

  initial begin
    uvm_config_db #(virtual sram_if)::set(null, "uvm_test_top.*", "vif", sram_if0);
    run_test("sram_test");
  end

endmodule