class dec_agent extends uvm_agent;
	`uvm_component_utils(dec_agent)

	uvm_analysis_port #(cod_transaction_out) agt_req_port;
	uvm_analysis_port #(dec_transaction_out) agt_resp_port;
	uvm_analysis_port #(cod_transaction_out) agt_cod_resp_port;

	dec_driver drv;
	dec_monitor mon;

	function new(string name = "dec_agent", uvm_component parent = null);
		super.new(name, parent);
		agt_req_port  = new("agt_req_port", this);
		agt_resp_port = new("agt_resp_port", this);
	endfunction : new

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		mon = dec_monitor::type_id::create("mon", this);
		drv = dec_driver::type_id::create("drv", this);
	endfunction : build_phase

	virtual function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		mon.req_port.connect(agt_req_port);
		mon.resp_port.connect(agt_resp_port);
		drv.dec_driver_port.connect(agt_cod_resp_port);
	endfunction : connect_phase

endclass : dec_agent