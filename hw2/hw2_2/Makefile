IVCOMP = iverilog
IVSIM  = vvp
IVCOMPFLAGS = -g2005-sv -Wall -DICARUS
IVSIMFLAGS = -fst
TARGET_BIN = hw1_1.out
SOURCES := $(wildcard *.v)

test:
	wsrun.pl shifter_hier_bench ${SOURCES}

$(TARGET_BIN): $(SOURCES)
	$(IVCOMP) $(IVCOMPFLAGS) -o $@ $^

sim: $(TARGET_BIN)
	$(IVSIM) $< $(IVSIMFLAGS)

clean:
	rm -rf $(TARGET_BIN) *.wlf *.vcd *.fst *.vcheck.out __work

%.vcheck.out: %.v
	vcheck.sh $< $@

check: alu.vcheck.out
	name-convention-check
	cat *.vcheck.out