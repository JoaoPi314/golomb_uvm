class agent extends uvm_agent;
	`uvm_component_utils(agent)

	typedef uvm_sequencer#(transaction_in) sequencer;

	uvm_analysis_port #(transaction_in) agt_req_port;
	uvm_analysis_port #(transaction_out) agt_resp_port;

	sequencer sqr;
	driver drv;
	monitor mon;

	function new(string name = "agent", uvm_component parent = null);
		super.new(name, parent);
		agt_req_port  = new("agt_req_port", this);
		agt_resp_port = new("agt_resp_port", this);
	endfunction : new

	virtual function build_phase(uvm_phase phase);
		super.build_phase(phase);
		mon = monitor::type_id::create("mon", this);
		sqr = sequencer::type_id::create("sqr", this);
		drv = driver::type_id::create("drv", this);
	endfunction : build_phase

	virtual function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		mon.req_port.connect(agt_req_port);
		mon.resp_port.connect(agt_resp_port);
		drv.seq_item_port.connect(sqr.seq_item_export);
	endfunction : connect_phase

endclass : agent