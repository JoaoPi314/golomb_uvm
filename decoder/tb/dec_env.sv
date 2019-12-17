class dec_env extends uvm_env;
	`uvm_component_utils(dec_env)

	dec_agent mst;
	dec_scoreboard sb;
	dec_coverage cov;

	function new(string name = "dec_env", uvm_component parent = null);
		super.new(name, parent);
	endfunction : new

	virtual function void build_phase(uvm_phase phase);
	super.build_phase(phase);
		mst = dec_agent::type_id::create("mst", this);
		sb  = dec_scoreboard::type_id::create("sb", this);
		cov = dec_coverage:: type_id::create("cov", this);
	endfunction : build_phase

	virtual function  void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		mst.agt_resp_port.connect(cov.resp_port);
		mst.agt_resp_port.connect(sb.ap_comp);
		mst.agt_req_port.connect(sb.ap_rfm);
	endfunction : connect_phase

endclass : dec_env
