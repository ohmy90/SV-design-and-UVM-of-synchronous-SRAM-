class sram_monitor extends uvm_monitor;

  `uvm_component_utils(sram_monitor)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  // Code for rest of the steps come here
  
  virtual sram_if vif;

uvm_analysis_port #(reg_transaction) mon_analysis_port;
  
  virtual function void build_phase(uvm_phase phase);
  super.build_phase(phase);

  mon_analysis_port = new("mon_analysis_port", this);

  if (!uvm_config_db #(virtual sram_if)::get(this, "", "vif", vif)) begin
    `uvm_error(get_type_name(), "Didn't get handle to virtual interface reg_if")
  end
endfunction
  
  virtual task run_phase(uvm_phase phase);
  reg_transaction tr;

  forever begin
    @(posedge vif.clk);

    if (vif.wr_en) begin
      tr = reg_transaction::type_id::create("tr", this);
      tr.wr_en = 1;
      tr.addr  = vif.addr;
      tr.wdata = vif.wdata;
      mon_analysis_port.write(tr);
    end
    else if (vif.rd_en) begin
      tr = reg_transaction::type_id::create("tr", this);
      tr.rd_en = 1;
      tr.addr  = vif.addr;

      // rdata isn't valid until one cycle after rd_en, same as the driver waits
      @(posedge vif.clk);
      tr.rdata = vif.rdata;

      mon_analysis_port.write(tr);
    end
  end
endtask
  
endclass