IVCOMP = iverilog
IVSIM  = vvp
IVCOMPFLAGS = -g2005-sv -Wall -DICARUS
IVSIMFLAGS = -fst
TARGET_BIN = hw1_1.out
SOURCES := fulladder_bench.v fulladder1.v fulladder4.v fulladder16.v not1.v nor2.v nand2.v xor2.v clkrst.v

test:
	wsrun.pl fulladder_bench ${SOURCES}

$(TARGET_BIN): $(SOURCES)
	$(IVCOMP) $(IVCOMPFLAGS) -o $@ $^

sim: $(TARGET_BIN)
	$(IVSIM) $< $(IVSIMFLAGS)

clean:
	rm -f $(TARGET_BIN) $(SIM_WAVE)