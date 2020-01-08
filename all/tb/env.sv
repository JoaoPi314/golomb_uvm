class env extends uvm_env;
	`uvm_component_utils(env)

	cod_agent cod_mst;
	dec_agent dec_mst;
	scoreboard sb;
	coverage cov;

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
		dec_mst.agt_resp_port.connect(cov.resp_port);
		dec_mst.agt_resp_port.connect(sb.dec_ap_comp);
		dec_mst.agt_req_port.connect(sb.dec_ap_rfm);
		cod_mst.agt_resp_port.connect(dec_mst.agt_cod_resp_port);
		cod_mst.agt_req_port.connect(sb.cod_ap_rfm);
	endfunction : connect_phase

endclass : env
