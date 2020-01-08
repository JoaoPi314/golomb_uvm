class scoreboard extends uvm_scoreboard;
	`uvm_component_utils(scoreboard)

	typedef cod_transaction_out T1;
	typedef dec_transaction_out T2;	
	typedef uvm_in_order_class_comparator #(T1) comp_type_cod;
	typedef uvm_in_order_class_comparator #(T2) comp_type_dec;
	
	comp_type_cod cod_comp;
	comp_type_dec dec_comp;
	cod_refmod cod_rfm;
	dec_refmod dec_rfm;
	
	uvm_analysis_port #(T1) cod_ap_comp;
	uvm_analysis_port #(cod_transaction_in) cod_ap_rfm;
	uvm_analysis_port #(T2) dec_ap_comp;
	uvm_analysis_port #(T1) dec_ap_rfm;

	function new(string name = "scoreboard", uvm_component parent = null);
		super.new(name, parent);
		cod_ap_comp = new("cod_ap_comp", this);
		cod_ap_rfm  = new("cod_ap_rfm", this);
		dec_ap_comp = new("dec_ap_comp", this);
		dec_ap_rfm  = new("dec_ap_rfm", this);
	endfunction : new

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		cod_rfm  = cod_refmod::type_id::create("cod_rfm", this);
		cod_comp = comp_type_dec::type_id::create("cod_comp", this);
		dec_rfm  = dec_refmod::type_id::create("dec_rfm", this);
		dec_comp = comp_type_dec::type_id::create("dec_comp", this);
	endfunction : build_phase

	virtual function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		cod_ap_comp.connect(cod_comp.before_export);
		cod_ap_rfm.connect(cod_rfm.ref_req);
		rfm.ref_resp.connect(cod_comp.after_export);
		dec_ap_comp.connect(dec_comp.before_export);
		dec_ap_rfm.connect(dec_rfm.ref_req);
		rfm.ref_resp.connect(dec_comp.after_export);
	endfunction : connect_phase

endclass : scoreboard