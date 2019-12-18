class dec_refmod extends uvm_component;
	`uvm_component_utils(dec_refmod)

	dec_transaction_in tr_in;
	dec_transaction_out tr_out;

	uvm_analysis_imp #(dec_transaction_in, dec_refmod) ref_req;
	uvm_analysis_port #(dec_transaction_out) ref_resp;

	event begin_reftask, begin_rec, end_rec;
	bit [7:0] decod;
	int count;


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
			tr_out = dec_transaction_out::type_id::create("tr_out", this);
			decodifica();
			begin_tr(tr_out, "ref_resp");
			tr_out.dt_o = decod;
			ref_resp.write(tr_out);
			#10;
			end_tr(tr_out);
		end
	endtask : refmod_task

//********************************************************************************
//********A lógica de decodificação segue  alógica inversa da codificação ********
//********************************************************************************
	virtual function void decodifica();
		decod = 'b0;
		count = 16;
		//***************************************
		//*****Conta quantos bits até o '1'******
		//***************************************
		while(tr_in.dt_i[count] != 1'b1 && count >= 0)begin​
			count -= 1;
		end
		//***************************************
		//*****Saída inválida caso seja > 8******
		//***************************************
		if(count > 8)begin
 			decod = '1;
 			return;
 		end 
		else begin​
			count += 1; // Incremento no contador para que conte também o 1
		//***************************************
		//*****Armazena o valor a partir do '1'**
		//***************************************
			while(count >= 0)begin
				decod[count] = tr_in.dt_i[count];
				count -= 1;
			end
			decod -= 1; // Dado decodificado é esse valor decrementado
		end
	endfunction




endclass : dec_refmod
​
