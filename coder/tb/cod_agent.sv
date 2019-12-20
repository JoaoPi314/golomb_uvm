class cod_agent extends uvm_agent;
	`uvm_component_utils(cod_agent)

	typedef uvm_sequencer#(cod_transaction_in) sequencer;

	uvm_analysis_port #(cod_transaction_in) agt_req_port;
	uvm_analysis_port #(cod_transaction_out) agt_resp_port;

	sequencer sqr;
	cod_driver drv;
	cod_monitor mon;

	function new(string name = "cod_agent", uvm_component parent = null);
		super.new(name, parent);
		agt_req_port  = new("agt_req_port", this);
		agt_resp_port = new("agt_resp_port", this);
	endfunction : new

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		mon = cod_monitor::type_id::create("mon", this);
		sqr = sequencer::type_id::create("sqr", this);
		drv = cod_driver::type_id::create("drv", this);
	endfunction : build_phase

	virtual function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		mon.req_port.connect(agt_req_port);
		mon.resp_port.connect(agt_resp_port);
		drv.seq_item_port.connect(sqr.seq_item_export);
	endfunction : connect_phase

endclass : cod_agent