package pkg;
	`include "uvm_macros.svh"
	import uvm_pkg::*;

	`include "./dec_transaction_in.sv"
	`include "./dec_transaction_out.sv"
	`include "./dec_sequence_in.sv"
	`include "./dec_driver.sv"
	`include "./dec_monitor.sv"
	`include "./dec_agent.sv"

	`include "./dec_coverage.sv"
	`include "./dec_refmod.sv"
	`include "./dec_scoreboard.sv"

	`include "./dec_env.sv"
	`include "./simple_test.sv"
	`include "./error_test.sv"

endpackage : pkg