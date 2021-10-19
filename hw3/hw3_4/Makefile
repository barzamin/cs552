SOURCES := $(wildcard *.v)

test: proc_beqz_added.asm
	wsrun.pl -prog proc_beqz_added.asm proc_hier_bench ${SOURCES}

clean:
	rm -rf *.img *.lst *.wlf *.vcd *.fst *.vcheck.out *.img *.img.dmem *.img.reg *.log *.trace transcript archsim.* __work

%.vcheck.out: %.v
	vcheck.sh $< $@

check: adder16.vcheck.out alu.vcheck.out cla4.vcheck.out cla_fulladder.vcheck.out proc_beqz_added.vcheck.out fetch.vcheck.out rf.vcheck.out register.vcheck.out
	name-convention-check
	cat *.vcheck.out
