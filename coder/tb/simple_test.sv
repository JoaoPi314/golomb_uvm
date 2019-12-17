class simple_test extends uvm_test;
	`uvm_component_utils(simple_test)

	env env_h;
	sequence_in seq;

	function new(string name = "simple_test", uvm_component parent = null);
		super.new(name, parent);
	endfunction : new

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		env_h = env::type_id::create("env", this);
		seq   = sequence_in::type_id::create("seq", this);
	endfunction : build_phase

	task run_phase(uvm_phase phase);
		seq.start(env_h.mst.sqr);
	endtask : run_phase

endclass : simple_test
