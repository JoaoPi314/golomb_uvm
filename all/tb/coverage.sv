class coverage extends uvm_component;
	`uvm_component_utils(coverage)

	dec_transaction_in req;
	dec_transaction_out resp;
	uvm_analysis_imp#(dec_transaction_out, coverage) resp_port;

	int min_tr;
	int n_tr = 0;
	event end_coverage;

	function new(string name = "dec_coverage", uvm_component parent = null);
		super.new(name, parent);
		resp_port = new("resp_port", this);
		req = new;
		resp = new;
		min_tr = 10000;
	endfunction : new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
	endfunction

	task run_phase(uvm_phase phase);
		phase.raise_objection(this);
		@(end_coverage);
		phase.drop_objection(this);
	endtask : run_phase

	function void write(dec_transaction_out t);
		resp.copy(t);
		if(t.invalid_output)
			`uvm_warning("INVALID OUTPUT", "Valid_out subiu com uma sequência de entrada inválida.")
		if(n_tr == min_tr - 1)
			->end_coverage;
		else
			n_tr += 1;
	endfunction

endclass : coverage
