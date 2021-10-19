SOURCES := $(wildcard *.v)

test:
	wsrun.pl rf_bench ${SOURCES}

clean:
	rm -rf *.img *.lst *.wlf *.vcd *.fst *.vcheck.out *.img *.img.dmem *.img.reg *.log *.trace transcript archsim.* __work

%.vcheck.out: %.v
	vcheck.sh $< $@

check: register.vcheck.out rf.vcheck.out
	name-convention-check
	cat *.vcheck.out