perftests = $(addsuffix .perftest, $(basename $(wildcard mem-*.addr)))

perftests: $(perftests)

%.perftest: %.addr
	wsrun.pl -addr $< mem_system_perfbench *.v
	cachesim 1 2048 8 $<

# perfbench:
# # 	wsrun.pl -addr mem.addr mem_system_perfbench *.v
# 	wsrun.pl -addr mem-1.addr mem_system_perfbench *.v

randbench:
	wsrun.pl mem_system_randbench *.v

fsm.svg: fsm.dot
	dot -Tsvg $^ > $@
