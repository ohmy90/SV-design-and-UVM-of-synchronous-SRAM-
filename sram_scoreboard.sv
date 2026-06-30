class sram_scoreboard extends uvm_scoreboard;

  `uvm_component_utils(sram_scoreboard)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  // Code for rest of the steps come here
  
  uvm_analysis_imp #(reg_transaction, sram_scoreboard) ap_imp;

function void build_phase(uvm_phase phase);
  super.build_phase(phase);
  ap_imp = new("ap_imp", this);
endfunction
  
  bit [7:0] expected_mem [16];
bit       written [16];

virtual function void write(reg_transaction tr);
  if (tr.wr_en) begin
    expected_mem[tr.addr] = tr.wdata;
    written[tr.addr]      = 1;
  end
  else if (tr.rd_en) begin
    if (!written[tr.addr]) begin
      `uvm_info(get_type_name(), $sformatf("addr=%0d read before any write, skipping check", tr.addr), UVM_LOW)
    end
    else if (tr.rdata != expected_mem[tr.addr]) begin
      `uvm_error(get_type_name(), $sformatf("Mismatch at addr=%0d: expected=0x%0h actual=0x%0h", tr.addr, expected_mem[tr.addr], tr.rdata))
    end
    else begin
      `uvm_info(get_type_name(), $sformatf("addr=%0d matched: 0x%0h", tr.addr, tr.rdata), UVM_HIGH)
    end
  end
endfunction
  
endclass