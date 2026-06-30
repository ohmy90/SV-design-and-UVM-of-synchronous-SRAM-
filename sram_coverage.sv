class sram_coverage extends uvm_subscriber #(reg_transaction);

  `uvm_component_utils(sram_coverage)

  covergroup cg_reg_transaction;
    coverpoint trans.addr;
    coverpoint trans.wr_en;
  endgroup

  reg_transaction trans;

  function new(string name, uvm_component parent);
    super.new(name, parent);
    cg_reg_transaction = new();
  endfunction

  virtual function void write(reg_transaction t);
    trans = t;
    cg_reg_transaction.sample();
  endfunction

endclass