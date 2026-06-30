class sram_env extends uvm_env;

  `uvm_component_utils(sram_env)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  // Code for rest of the steps come here
  
  sram_agent      m_agent;
sram_scoreboard m_scoreboard;

virtual function void build_phase(uvm_phase phase);
  super.build_phase(phase);

  m_agent      = sram_agent::type_id::create("m_agent", this);
  m_scoreboard = sram_scoreboard::type_id::create("m_scoreboard", this);
endfunction
  
  virtual function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  m_agent.m_monitor.mon_analysis_port.connect(m_scoreboard.ap_imp);
endfunction
  
endclass