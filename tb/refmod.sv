//import "DPI-C" context function string codifica(dt_i);

class refmod extends uvm_component;
	`uvm_component_utils(refmod)

	transaction_in tr_in;
	transaction_out tr_out;

	uvm_analysis_imp #(transaction_in, refmod) ref_req;
	uvm_analysis_port #(transaction_out) ref_resp;

	event begin_reftask, begin_rec, end_rec;
	bit [16:0] dt_o;
	bit [7:0] sum;
	int count;
	int c;
	int i;
	int size;

	function new(string name = "refmod", uvm_component parent);
		super.new(name, parent);
		ref_req  = new("ref_req", this);
		ref_resp = new("ref_resp", this);
		count = 8;
		c = 7;
	endfunction : new

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
	endfunction : build_phase

	virtual task run_phase(uvm_phase phase);
		super.run_phase(phase);
		refmod_task();
	endtask : run_phase


	virtual function write(transaction_in t);
		tr_in = transaction_in#()::type_id::create("tr_in", this);
		tr_in.copy(t);
		->begin_reftask;
	endfunction : write

	task refmod_task();
		forever begin​
			@begin_reftask;
			tr_out = transaction_out::type_id::create("tr_out", this);
			codifica();
			//$display("Codificado: %b", dt_o);
			begin_tr(tr_out, "ref_resp");
			tr_out.dt_o = dt_o;
			ref_resp.write(tr_out);
			#10;
			end_tr(tr_out);
		end
	endtask : refmod_task


	virtual function void codifica();
		sum = tr_in.dt_i + 1;
		while(sum[c] == 0 && c >= 0)begin 
			count -= 1;
			c -=1;
		end
		if(count === 0)
			count = 9;
		//$display("cont = %d", count);
		size = (count -1)*2 + 1;
		c = size -1;
		while(c > (size/2))begin
			dt_o[c] = 1'b0;
			c -= 1;
		end
		dt_o[size/2] = 1'b1;
		c-=1;
		while(c >= 0)begin
			dt_o[c] = sum[c];
			c -= 1;
		end

		c = 7;
		count = 8;
	endfunction




endclass : refmod
​
