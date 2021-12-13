# initial

```
# Using trace file                                                                                                                                                                                                                                                         mem.addr
# LOG: ReQNum    1 Cycle       20 ReqCycle        3 Wr Addr 0x015c Value 0x0018 ValueRef 0x0018 HIT 0
#
# LOG: ReqNum    2 Cycle       22 ReqCycle       21 Rd Addr 0x015c Value 0x0018 ValueRef 0x0018 HIT 1
#
# LOG: Done all Requests:          2 Replies:          2 Cycles:         23 Hits:          1
# Test status: SUCCESS
# ** Note: $finish    : mem_system_perfbench.v(200)
#    Time: 2287 ns  Iteration: 0  Instance: /mem_system_perfbench
# End time: 16:09:31 on Dec 11,2021, Elapsed time: 0:00:01
# Errors: 0, Warnings: 0
```

```
# LOG: Done two_sets_addr Requests:       8001, Cycles:      98360 Hits:          0
# LOG: Done Requests:       8001 Replies:       8001 Cycles:      98361 Hits:       1764
# Test status: SUCCESS
```


# after removing STATE_RD_MISS and STATE_WR_MISS
```
# LOG: Done two_sets_addr Requests:       8001, Cycles:      92103 Hits:          0
# LOG: Done Requests:       8001 Replies:       8001 Cycles:      92104 Hits:       1764
# Test status: SUCCESS
```
