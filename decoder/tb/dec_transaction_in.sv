class dec_transaction_in extends uvm_sequence_item;

	rand bit [16:0] dt_i;

	function new(string name = "");
		super.new(name);
	endfunction : new


	`uvm_object_param_utils_begin(dec_transaction_in)
		`uvm_field_int(dt_i, UVM_UNSIGNED)
	`uvm_object_utils_end


	function string convert2string();
		return $sformatf("dt_i = %b", dt_i);
	endfunction

endclass : dec_transaction_in