IVCOMP = iverilog
IVSIM  = vvp
IVCOMPFLAGS = -g2005-sv -Wall -DICARUS
IVSIMFLAGS = -fst
TARGET_BIN = hw1_1.out
SOURCES := seqdec_26_bench.v clkrst.v seqdec_26.v dff.v

test:
	wsrun.pl seqdec_26_bench ${SOURCES}

$(TARGET_BIN): $(SOURCES)
	$(IVCOMP) $(IVCOMPFLAGS) -o $@ $^

sim: $(TARGET_BIN)
	$(IVSIM) $< $(IVSIMFLAGS)

clean:
	rm -rf $(TARGET_BIN) *.wlf *.vcd *.fst *.vcheck.out __work

%.vcheck.out: %.v
	vcheck.sh $< $@

check: seqdec_26.vcheck.out
	name-convention-check
	cat *.vcheck.out