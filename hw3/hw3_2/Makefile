SOURCES := $(wildcard *.v)

test: loadfile_all.img
	wsrun.pl fetch_hier_bench ${SOURCES}

loadfile_all.img: fetch.asm
	assemble.sh $<

clean:
	rm -rf *.img *.lst *.wlf *.vcd *.fst *.vcheck.out *.img *.img.dmem *.img.reg *.log *.trace transcript archsim.* __work

%.vcheck.out: %.v
	vcheck.sh $< $@

check: adder16.vcheck.out cla4.vcheck.out cla_fulladder.vcheck.out fetch.vcheck.out
	name-convention-check
	cat *.vcheck.out