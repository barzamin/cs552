tests_my:
	wsrun.pl -pipe -list my.list proc_hier_pbench *.v

tests_jumps:
	wsrun.pl -pipe -list jumps.list proc_hier_pbench *.v


## course provided
test_suite: tests_simple tests_complex tests_rand_simple tests_rand_complex tests_rand_ctrl tests_rand_mem tests_complex_pipelined

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
