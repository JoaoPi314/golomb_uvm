import "DPI-C" context function void codifica(dt_i, &dt_o);

class refmod extends uvm_component;
	`uvm_component_utils(refmod)

	transaction_in tr_in;
	transaction_out tr_out;

	int dt_o[0:17];
	uvm_analysis_imp #(transaction_in, refmod) ref_req;
	uvm_analysis_port #(transaction_out, refmod) ref_resp;

	event begin_reftask, begin_rec, end_rec;


	function new(string gname = "refmod", uvm_component parent);
		super.new(name, parent);
		ref_req  = new("ref_req", this);
		ref_resp = new("ref_resp", this);
	endfunction : new

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
	endfunction : build_phase

	virtual task run_phase(uvm_phase phase);
		super.run_phase(phase);
		fork
			refmod_task();
			record_tr();
		join
	endtask : run_phase


	virtual function write(transaction_in t);
		tr_in = transaction_in#()::type_id::create("tr_in", this);
		tr_in.copy(t);
		->begin_reftask;
	endfunction : write

	virtual task record_tr();​
		forever begin​
			@(begin_record);​
	      	begin_tr(ULA_tr_out, "refmod");​
	      	@(end_record);​
	      	end_tr(ULA_tr_out);​
	    end​
	endtask​	

	task refmod_task();
		forever begin​
			@begin_reftask;
			tr_out = transaction_out::type_id::create("tr_out", this);
			->begin_rec;
			codifica(tr_in.dt_i, &dt_o);
			tr_out.dt_o = dt_o[tr_out.index];
			#10;
			->end_rec;
			ref_resp.write(tr_out);
		end
	endtask : refmod_task

endclass : refmod
​
