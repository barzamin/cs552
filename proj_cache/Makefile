perfbench:
	wsrun.pl -addr mem.addr mem_system_perfbench *.v

randbench:
	wsrun.pl mem_system_randbench *.v

fsm.svg: fsm.dot
	dot -Tsvg $^ > $@
