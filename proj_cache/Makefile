SOURCES = mem_system.v register.v
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

cache_controller_fsm.pdf: fsm.svg
	inkscape $< --export-pdf=$@

%.vcheck.out: %.v
	vcheck.sh $< $@

check: $(SOURCES:.v=.vcheck.out)
	name-convention-check
	cat *.vcheck.out

project-cache.tar:
	tar cf $@ *.v *.vcheck.out Makefile *.py *.addr
