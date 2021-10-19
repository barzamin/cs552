SOURCES := $(wildcard *.v)

test:
	wsrun.pl rf_bench ${SOURCES}

clean:
	rm -rf $(TARGET_BIN) *.wlf *.vcd *.fst *.vcheck.out __work

%.vcheck.out: %.v
	vcheck.sh $< $@

check: register.vcheck.out rf.vcheck.out
	name-convention-check
	cat *.vcheck.out