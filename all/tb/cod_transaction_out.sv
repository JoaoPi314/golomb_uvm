class cod_transaction_out extends uvm_sequence_item;

	rand bit [16:0] dt_o;

	function new(string name = "");
		super.new(name);
	endfunction : new


	`uvm_object_param_utils_begin(cod_transaction_out)
		`uvm_field_int(dt_o , UVM_UNSIGNED)
	`uvm_object_utils_end


	function string convert2string();
		return $sformatf("dt_o = %b", dt_o);
	endfunction

endclass : cod_transaction_out
