class reg_transaction extends uvm_sequence_item;

  rand bit       wr_en;
  rand bit       rd_en;
  rand bit [3:0] addr;
  rand bit [7:0] wdata;
       bit [7:0] rdata;

  constraint wr_xor_rd_c {
    wr_en != rd_en;
  }

  `uvm_object_utils_begin(reg_transaction)
    `uvm_field_int(wr_en,  UVM_ALL_ON)
    `uvm_field_int(rd_en,  UVM_ALL_ON)
    `uvm_field_int(addr,   UVM_ALL_ON)
    `uvm_field_int(wdata,  UVM_ALL_ON)
    `uvm_field_int(rdata,  UVM_ALL_ON)
  `uvm_object_utils_end

  function new(string name = "reg_transaction");
    super.new(name);
  endfunction

endclass