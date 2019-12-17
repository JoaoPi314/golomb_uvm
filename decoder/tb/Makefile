IFS = ./dec_interface_if.sv

PKGS = ./pkg.sv

RTL = ../rtl/exp_golomb_decoder.sv

RUN_ARGS_COMMON = -access +r -input ./shm.tcl \
								+uvm_set_config_int=*,recording_detail,1 -coverage all -covoverwrite

sim: clean
	xrun -64bit -uvm $(PKGS) $(IFS) $(RTL) top.sv \
		+UVM_TESTNAME=simple_test -covtest simple_test $(RUN_ARGS_COMMON)

clean:
	@rm -rf INCA_libs waves.shm cov_work/ *.history *.log *.key mdv.log imc.log imc.key ncvlog_*.err *.trn *.dsn .simvision/ simvision* xcelium.d simv.daidir *.so *.o *.err

view_waves:
	simvision waves.shm &

view_cover:
	imc &