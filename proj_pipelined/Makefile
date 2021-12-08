SOURCES := adder16.v alu.v branch_controller.v cla4.v cla_fulladder.v control.v decode.v execute.v fcu.v fetch.v flop_ex2mem.v flop_id2ex.v flop_if2id.v flop_mem2wb.v forwarder.v hazard.v memory.v mux2_1.v proc.v register.v reverser.v rf_bypassed.v rf.v shifter.v writeback.v

%.vcheck.out: %.v
	vcheck.sh $< $@

check: $(SOURCES:.v=.vcheck.out)
	name-convention-check
	cat *.vcheck.out

project-pipelined.tar:
	tar cf $@ *.v *.vh *.vcheck.out *.summary.log Makefile

clean:
	rm -rf *.img *.lst *.wlf *.vcd *.fst *.vcheck.out *.img *.img.dmem *.img.reg *.trace transcript archsim.* __work

### TESTING ###

tests_my:
	wsrun.pl -pipe -list my.list proc_hier_pbench *.v

tests_jumps:
	wsrun.pl -pipe -list jumps.list proc_hier_pbench *.v


## course provided
test_suite: tests_simple tests_complex tests_rand_simple tests_rand_complex tests_rand_ctrl tests_rand_mem tests_complex_pipelined tests_extra_credits

tests_simple:
	wsrun.pl -pipe -list simple.list proc_hier_pbench *.v
	mv summary.log simple.summary.log

tests_complex:
	wsrun.pl -pipe -list complex.list proc_hier_pbench *.v
	mv summary.log complex.summary.log

tests_rand_simple:
	wsrun.pl -pipe -list rand_simple.list proc_hier_pbench *.v
	mv summary.log rand_simple.summary.log

tests_rand_complex:
	wsrun.pl -pipe -list rand_complex.list proc_hier_pbench *.v
	mv summary.log rand_complex.summary.log

tests_rand_ctrl:
	wsrun.pl -pipe -list rand_ctrl.list proc_hier_pbench *.v
	mv summary.log rand_ctrl.summary.log

tests_rand_mem:
	wsrun.pl -pipe -list rand_mem.list proc_hier_pbench *.v
	mv summary.log rand_mem.summary.log

tests_complex_pipelined:
	wsrun.pl -pipe -list complex_pipelined.list proc_hier_pbench *.v
	mv summary.log complex_pipelined.summary.log

tests_extra_credits:
	wsrun.pl -pipe -list extra_credits.list proc_hier_pbench *.v
	mv summary.log extra_credits.summary.log
