class cod_coverage extends uvm_component;
	`uvm_component_utils(cod_coverage)

	cod_transaction_in req;
	cod_transaction_out resp;
	uvm_analysis_imp#(cod_transaction_out, cod_coverage) resp_port;

	int min_tr;
	int n_tr = 0;
	event end_coverage;

	function new(string name = "cod_coverage", uvm_component parent = null);
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

	function void write(cod_transaction_out t);
		resp.copy(t);
		if(n_tr == min_tr - 1)
			->end_coverage;
		else
			n_tr += 1;
	endfunction

endclass : cod_coverage
