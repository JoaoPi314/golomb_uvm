class dec_refmod extends uvm_component;
	`uvm_component_utils(dec_refmod)

	dec_transaction_in tr_in;
	dec_transaction_out tr_out;

	uvm_analysis_imp #(dec_transaction_in, dec_refmod) ref_req;
	uvm_analysis_port #(dec_transaction_out) ref_resp;

	event begin_reftask, begin_rec, end_rec;
	bit [7:0] decod;
	bit [16:0] auxiliar;
	int count, c;


	function new(string name = "refmod", uvm_component parent);
		super.new(name, parent);
		ref_req  = new("ref_req", this);
		ref_resp = new("ref_resp", this);
	endfunction : new

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
	endfunction : build_phase

	virtual task run_phase(uvm_phase phase);
		super.run_phase(phase);
		refmod_task();
	endtask : run_phase


	virtual function write(dec_transaction_in t);
		tr_in = dec_transaction_in#()::type_id::create("tr_in", this);
		tr_in.copy(t);
		->begin_reftask;
	endfunction : write

	task refmod_task();
		forever begin
			@begin_reftask;
			$display("Cheguei aki?");
			tr_out = dec_transaction_out::type_id::create("tr_out", this);
			decodifica();
			begin_tr(tr_out, "ref_resp");
			tr_out.dt_o = decod;
			$display("tr_out = 8'b%b", tr_out.dt_o);
			ref_resp.write(tr_out);
			#10;
			end_tr(tr_out);
		end
	endtask : refmod_task


	virtual function void decodifica();
		count = 0;
		auxiliar = tr_in.dt_i;
		while(auxiliar[16] === 0 && count < 17)begin​
			auxiliar = auxiliar << 1;
			count += 1;
			$display("To aki ainda, %b, %d", auxiliar, count);
		end
		if(count < 8)
			decod = '0;
		else begin​
			c = 16 - count;
			while(c >= 0)begin
				decod[c] = tr_in.dt_i[c];
				$display("To aki ainda 2, %b", decod[c]);
				c-=1;
			end
			decod -= 1;
			$display("decod = 8'b%b", decod);
		end
	endfunction




endclass : dec_refmod
​
