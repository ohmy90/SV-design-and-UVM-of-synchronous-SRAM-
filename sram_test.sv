class sram_test extends uvm_test;

  `uvm_component_utils(sram_test)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  // Code for rest of the steps come here
  sram_env m_top_env;

virtual function void build_phase(uvm_phase phase);
  super.build_phase(phase);
  m_top_env = sram_env::type_id::create("m_top_env", this);
endfunction
  
  virtual function void end_of_elaboration_phase(uvm_phase phase);
  uvm_top.print_topology();
endfunction
  
  virtual task run_phase(uvm_phase phase);
  sram_sequence m_seq = sram_sequence::type_id::create("m_seq");

  phase.raise_objection(this);
  m_seq.start(m_top_env.m_agent.m_sequencer);
  phase.drop_objection(this);
endtask
  
  function void start_of_simulation_phase(uvm_phase phase);
  super.start_of_simulation_phase(phase);

  uvm_config_db #(uvm_object_wrapper)::set(this, "m_top_env.m_agent.m_sequencer.run_phase",
                                            "default_sequence", sram_sequence::type_id::get());
endfunction
  
endclass