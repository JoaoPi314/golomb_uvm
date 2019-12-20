//import "DPI-C" context function string codifica(dt_i);

class cod_refmod extends uvm_component;
	`uvm_component_utils(cod_refmod)

	cod_transaction_in tr_in;
	cod_transaction_out tr_out;

	uvm_analysis_imp #(cod_transaction_in, cod_refmod) ref_req;
	uvm_analysis_port #(cod_transaction_out) ref_resp;

	event begin_reftask, begin_rec, end_rec;
	bit [16:0] dt_o;
	bit [7:0] sum;
	int count;
	int count2;
	int size;

	function new(string name = "cod_refmod", uvm_component parent);
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


	virtual function write(cod_transaction_in t);
		tr_in = cod_transaction_in#()::type_id::create("tr_in", this);
		tr_in.copy(t);
		->begin_reftask;
	endfunction : write

	task refmod_task();
		forever begin​
			@begin_reftask;
			tr_out = cod_transaction_out::type_id::create("tr_out", this);
			codifica();
			begin_tr(tr_out, "ref_resp");
			tr_out.dt_o = dt_o;
			ref_resp.write(tr_out);
			#10;
			end_tr(tr_out);
		end
	endtask : refmod_task
//********************************************************************************
// O código exp-golomb segue a seguinte lógica:									 *
// . Escreva o número a ser codificado + 1 (Ex. 00000100 -> 00000101)			 *
// . Conte quantos bits até o bit '1' mais significativo (Ex. 3)				 *
// . Escreva esse número -1 de zeros (Ex. 00)									 *
// . Escreva o em seguida o número a ser codificado adicionado de 1 (Ex. 00+101) *
// . Obtenha a saída (Ex. 00101)												 *
//********************************************************************************
	virtual function void codifica();
		count2 = 7;
		count = 8;
		sum = tr_in.dt_i + 1;
		//***************************************
		//*****Conta quantos bits até o '1'*****
		//***************************************
		while(sum[count2] == 0 && count2 >= 0)begin 
			count -= 1;
			count2 -=1;
		end
		//Se zerar é porque o dado é 255, logo o tamanho é 9 (255 + 1)
		if(count === 0)
			count = 9;
		size = (count -1)*2 + 1; //Define o tamanho da saída
		count2 = size -1;
		//***************************************
		//********Define os '0' da saída ********
		//***************************************
		while(count2 > (size/2))begin
			dt_o[count2] = 1'b0;
			count2 -= 1;
		end
		dt_o[size/2] = 1'b1; //Define o bit 1 que sempre aparece no meio
		count2 -= 1;
		//***************************************
		//*****Define o restante dos bits *******
		//***************************************
		while(count2 >= 0)begin
			dt_o[count2] = sum[count2];
			count2 -= 1;
		end
	endfunction




endclass : cod_refmod
​
