package pkg;
	`include "uvm_macros.svh"
	import uvm_pkg::*;

	`include "./cod_transaction_in.sv"
	`include "./cod_transaction_out.sv"
	`include "./sequence_in.sv"
	`include "./cod_driver.sv"
	`include "./cod_monitor.sv"
	`include "./cod_agent.sv"

	`include "./cod_coverage.sv"
	`include "./cod_refmod.sv"
	`include "./scoreboard.sv"

	`include "./env.sv"
	`include "./simple_test.sv"

endpackage : pkg