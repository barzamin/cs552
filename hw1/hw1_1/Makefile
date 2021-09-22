IVCOMP = iverilog
IVSIM  = vvp
IVCOMPFLAGS = -g2005-sv -Wall -DICARUS
IVSIMFLAGS = -fst
TARGET_BIN = hw1_1.out
SOURCES := $(wildcard *.v)

test:
	wsrun.pl quaddemux1_4_bench ${SOURCES}

$(TARGET_BIN): $(SOURCES)
	$(IVCOMP) $(IVCOMPFLAGS) -o $@ $^

sim: $(TARGET_BIN)
	$(IVSIM) $< $(IVSIMFLAGS)

clean:
	rm -rf $(TARGET_BIN) *.wlf *.vcd *.fst *.vcheck.out __work transcript

%.vcheck.out: %.v
	vcheck.sh $< $@

check: demux1_2.vcheck.out demux1_4.vcheck.out quaddemux1_4.vcheck.out
	name-convention-check
	cat *.vcheck.out
