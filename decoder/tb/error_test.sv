class error_test extends uvm_test;
	`uvm_component_utils(error_test)

	dec_env env_h;
	dec_sequence_in_err seq;

	function new(string name = "error_test", uvm_component parent = null);
		super.new(name, parent);
	endfunction : new

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		env_h = dec_env::type_id::create("env", this);
		seq   = dec_sequence_in_err::type_id::create("seq", this);
	endfunction : build_phase

	task run_phase(uvm_phase phase);
		seq.start(env_h.mst.sqr);
	endtask : run_phase

endclass : error_test