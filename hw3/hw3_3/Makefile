IVCOMP = iverilog
IVSIM  = vvp
IVCOMPFLAGS = -g2005-sv -Wall -DICARUS
IVSIMFLAGS = -fst
TARGET_BIN = hw3_3.out
SOURCES := $(wildcard *.v)

test: proc.asm
	wsrun.pl -prog proc.asm proc_hier_bench ${SOURCES}

$(TARGET_BIN): $(SOURCES)
	$(IVCOMP) $(IVCOMPFLAGS) -o $@ $^

sim: $(TARGET_BIN)
	$(IVSIM) $< $(IVSIMFLAGS)

clean:
	rm -rf $(TARGET_BIN) *.wlf *.vcd *.fst *.vcheck.out __work

%.vcheck.out: %.v
	vcheck.sh $< $@

check: adder16.vcheck.out alu.vcheck.out cla4.vcheck.out cla_fulladder.vcheck.out proc.vcheck.out fetch.vcheck.out rf.vcheck.out register.vcheck.out sext.vcheck.out
	name-convention-check
	cat *.vcheck.out
