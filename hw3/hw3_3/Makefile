SOURCES := $(wildcard *.v)

test: proc.asm
	wsrun.pl -prog proc.asm proc_hier_bench ${SOURCES}

clean:
	rm -rf *.img *.wlf *.vcd *.fst *.vcheck.out __work

%.vcheck.out: %.v
	vcheck.sh $< $@

check: adder16.vcheck.out alu.vcheck.out cla4.vcheck.out cla_fulladder.vcheck.out proc.vcheck.out fetch.vcheck.out rf.vcheck.out register.vcheck.out
	name-convention-check
	cat *.vcheck.out
