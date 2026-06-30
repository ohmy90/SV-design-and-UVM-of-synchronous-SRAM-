
class sram_agent extends uvm_agent;

  `uvm_component_utils(sram_agent)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  // Code for rest of the steps come here
  
  sram_driver    m_driver;
  sram_monitor   m_monitor;
  sram_sequencer m_sequencer;
  sram_coverage  m_coverage;
  
  virtual function void build_phase(uvm_phase phase);
  super.build_phase(phase);

  if (get_is_active()) begin
    m_sequencer = sram_sequencer::type_id::create("m_sequencer", this);
    m_driver    = sram_driver::type_id::create("m_driver", this);
  end

  // A monitor and coverage are useful whether the agent is active or passive
  m_monitor  = sram_monitor::type_id::create("m_monitor", this);
  m_coverage = sram_coverage::type_id::create("m_coverage", this);
endfunction
  
  virtual function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);

  if (get_is_active())
    m_driver.seq_item_port.connect(m_sequencer.seq_item_export);

  m_monitor.mon_analysis_port.connect(m_coverage.analysis_export);
endfunction

endclass