class dec_sequence_in extends uvm_sequence #(dec_transaction_in);
	`uvm_object_utils(dec_sequence_in)


	function new(string name="dec_sequence_in");
		super.new(name);
	endfunction : new


	task body();
		dec_transaction_in tr;
		forever begin
			tr = dec_transaction_in::type_id::create("tr");
			start_item(tr);
			assert(tr.randomize());
			finish_item(tr);
		end
	endtask : body


endclass : dec_sequence_in
