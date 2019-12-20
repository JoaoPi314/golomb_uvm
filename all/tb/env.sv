class env extends uvm_env;
	`uvm_component_utils(env)

	cod_agent mst;
	scoreboard sb;
	cod_coverage cov;

	function new(string name = "env", uvm_component parent = null);
		super.new(name, parent);
	endfunction : new

	virtual function void build_phase(uvm_phase phase);
	super.build_phase(phase);
		mst = cod_agent::type_id::create("mst", this);
		sb  = scoreboard::type_id::create("sb", this);
		cov = cod_coverage:: type_id::create("cov", this);
	endfunction : build_phase

	virtual function  void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		mst.agt_resp_port.connect(cov.resp_port);
		mst.agt_resp_port.connect(sb.ap_comp);
		mst.agt_req_port.connect(sb.ap_rfm);
	endfunction : connect_phase

endclass : env
