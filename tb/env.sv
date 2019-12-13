class env extend uvm_env;
	`uvm_component_utils(env)

	agent mst;
	scoreboard sb;
	coverage cov;

	function new(string name = "env", uvm_component parent = null);
		super.new(name, parent);
	endfunction : new

	virtual function void build_phase(uvm_phase phase);
	super.build_phase(phase);
		mst = agent::type_id::create("mst", this);
		sb  = scoreboard::type_id::create("sb", this);
		cov = coverage:: type_id::create("cov", this);
	endfunction : build_phase

	virtual function  void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		mst.agt_resp_port(cov.resp_port);
		mst.agt_resp_port(sb.ap_comp);
		mst.agt_req_port(sb.ap_rfm);
	endfunction : connect_phase

endclass : env
