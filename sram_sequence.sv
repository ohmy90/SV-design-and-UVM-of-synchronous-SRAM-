class sram_sequence extends uvm_sequence #(reg_transaction);

  // [Recommended] Registers with the factory using uvm_object_utils,
  // not uvm_component_utils, since a sequence is a uvm_object, not a uvm_component
  `uvm_object_utils(sram_sequence)

  function new(string name = "sram_sequence");
    super.new(name);
  endfunction

  // body() comes next
  virtual task body();
reg_transaction tr;

 // directed writes first — cover every address 
  for (int i = 0; i < 16; i++) begin
    tr = reg_transaction::type_id::create("tr");
    start_item(tr);
    assert(tr.randomize() with { wr_en == 1; rd_en == 0; addr == i; });
    finish_item(tr);
  end

  // random reads and writes after memory is fully populated
  repeat(16) begin
    tr = reg_transaction::type_id::create("tr");
    start_item(tr);
    assert(tr.randomize());
    finish_item(tr);
  end
endtask
  
endclass
