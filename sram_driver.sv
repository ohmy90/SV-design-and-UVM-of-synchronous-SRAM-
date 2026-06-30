class sram_driver extends uvm_driver #(reg_transaction);

  `uvm_component_utils(sram_driver)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual sram_if vif;

virtual function void build_phase(uvm_phase phase);
  super.build_phase(phase);
  if (!uvm_config_db #(virtual sram_if)::get(this, "", "vif", vif)) begin
    `uvm_fatal(get_type_name(), "Didn't get handle to virtual interface sram_if")
  end
endfunction
  
  virtual task run_phase(uvm_phase phase);
  reg_transaction tr;

  forever begin
    // 1. Get next item from the sequencer
    seq_item_port.get_next_item(tr);

    // 2. Drive request signals, then wait for the DUT to act on them
    @(posedge vif.clk);
    vif.wr_en <= tr.wr_en;
    vif.rd_en <= tr.rd_en;
    vif.addr  <= tr.addr;
    vif.wdata <= tr.wdata;
    @(posedge vif.clk);

    // 3. For a read, rdata isn't valid until one cycle later
    if (tr.rd_en) begin
      @(posedge vif.clk);
      tr.rdata = vif.rdata;
    end

    // 4. Tell the sequencer this item is done
    seq_item_port.item_done();
  end
endtask
endclass