class dec_monitor extends uvm_monitor;
	`uvm_component_utils(dec_monitor)

	interface_vif vif;
	event begin_rec_in, begin_rec_out, end_rec_in, end_rec_out;
	dec_transaction_in tr_in;
	dec_transaction_out tr_out;

	int index;
	int cont;
	int cont2;
	bit [0:16] dt_i;
	bit timeOut;

	uvm_analysis_port #(dec_transaction_in)  req_port;
	uvm_analysis_port #(dec_transaction_out) resp_port;

	function new(string name, uvm_component parent);
		super.new(name, parent);
		req_port = new ("req_port", this);
		resp_port = new("resp_port", this);
		index = 0;
	endfunction : new

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db#(interface_vif)::get(this, "", "vif", vif)) begin 
			`uvm_fatal("NOVIF", "failed to get virtual interface")
		end
		tr_in = dec_transaction_in::type_id::create("tr_in", this);
		tr_out = dec_transaction_out::type_id::create("tr_out", this);
	endfunction : build_phase

	virtual task run_phase(uvm_phase phase);
		super.run_phase(phase);	
			collect_tr(phase);
	endtask : run_phase

	virtual task record_in();
		@(begin_rec_in);
		begin_tr(tr_in, "req");
		@(end_rec_in);
		end_tr(tr_in);
	endtask : record_in


	virtual task collect_tr(uvm_phase phase);
		forever begin 
			fork
				record_in();
				collect_tr_in(phase);
				collect_tr_out(phase);
				contaTimeOut();
			join

		end 
	endtask : collect_tr



	virtual task collect_tr_in(uvm_phase phase);
			dt_i = '0;
			index = 0;
			@(posedge vif.clk iff vif.valid_i) begin
				while(vif.valid_i)begin
					dt_i[index] = vif.dt_i;
					index += 1;
					@(posedge vif.clk);
				end
				tr_in.dt_i = dt_i >> (17 - index);
				->begin_rec_in;
				req_port.write(tr_in);
				@(negedge vif.clk);
				->end_rec_in;
			end
	endtask : collect_tr_in

	virtual task collect_tr_out(uvm_phase phase);
		@(posedge vif.clk iff vif.valid_o or timeOut);
		begin_tr(tr_out, "resp");
		tr_out.dt_o = vif.dt_o;
		resp_port.write(tr_out);
		@(negedge vif.clk);
		end_tr(tr_out); 
	endtask : collect_tr_out


	virtual task contaTimeOut();
		@(posedge vif.valid_i);
		@(negedge vif.valid_i);
		cont2 = 0;
		while(~timeOut)begin 
			cont2 += 1;		
			if(cont2 >= 10)
				timeOut = 1'b1;
			else
				timeOut = 1'b0;
			$display("TimeOut = %b; contador = %d", timeOut, cont2);
			if(vif.valid_o)
				break;
		end 
	endtask : contaTimeOut


endclass : dec_monitor

