SOURCES := adder16.v alu.v cla4.v cla_fulladder.v decode.v execute.v fcu.v fetch.v memory.v mux2_1.v pccomputer.v proc.v register.v reverser.v rf.v shifter.v writeback.v control.v
VCHECKS := $(SOURCES:.v=.vcheck.out)

test_suite: tests_simple tests_complex tests_rand_simple tests_rand_complex tests_rand_ctrl tests_rand_mem

tests_simple:
	wsrun.pl -list simple.list proc_hier_bench *.v
	mv summary.log simple.summary.log

tests_complex:
	wsrun.pl -list complex.list proc_hier_bench *.v
	mv summary.log complex.summary.log

tests_rand_simple:
	wsrun.pl -list rand_simple.list proc_hier_bench *.v
	mv summary.log rand_simple.summary.log

tests_rand_complex:
	wsrun.pl -list rand_complex.list proc_hier_bench *.v
	mv summary.log rand_complex.summary.log

tests_rand_ctrl:
	wsrun.pl -list rand_ctrl.list proc_hier_bench *.v
	mv summary.log rand_ctrl.summary.log

tests_rand_mem:
	wsrun.pl -list rand_mem.list proc_hier_bench *.v
	mv summary.log rand_mem.summary.log

test_alu:
	wsrun.pl tb_alu *.v

test_fcu:
	wsrun.pl tb_fcu *.v

%.vcheck.out: %.v
	vcheck.sh $< $@

check: $(VCHECKS)
	name-convention-check
	cat *.vcheck.out

clean:
	rm -rf *.img *.lst *.wlf *.vcd *.fst *.vcheck.out *.img *.img.dmem *.img.reg *.trace transcript archsim.* __work