WIDTH=16

def shift_layer(bus_in, bus_out, shift, ctrl, rotate_net, pad_net):
	# generate internal wiring
	infill_net = f's{shift}_infill'
	print(f'wire [{shift-1}:0] {infill_net};')

	# generate main shift muxes
	print('// shift muxes')
	for i in range(WIDTH):
		if i + shift > WIDTH - 1:
			shift_wire = f'{infill_net}[{i+shift-WIDTH}]'
		else:
			shift_wire = f'{bus_in}[{i + shift}]'
		print(f'mux2_1 s{shift}_mux{i} ( .s({ctrl}), .in0({bus_in}[{i}]), .in1({shift_wire}), .out({bus_out}[{i}]) );')

	# generate infill muxes
	print('// infill muxes')
	for iidx in range(shift):
		print(f'mux2_1 s{shift}_fillmux{iidx} ( .s({rotate_net}), .in0({pad_net}), .in1({bus_in}[{iidx}]), .out({infill_net}[{iidx}]) );')

print(f'/* ---------------- {WIDTH}-bit right barrel shifter and rotator ----------------*/\n')

print('\n//// shift layer 2^0 = 1 ////')
print(f'wire [{WIDTH-1}:0] shifted1;')
shift_layer('reversed', 'shifted1', 1, 'Cnt[0]', 'rot', 'pad')
print('\n//// shift layer 2^1 = 2 ////')
print(f'wire [{WIDTH-1}:0] shifted2;')
shift_layer('shifted1', 'shifted2', 2, 'Cnt[1]', 'rot', 'pad')
print('\n//// shift layer 2^2 = 4 ////')
print(f'wire [{WIDTH-1}:0] shifted4;')
shift_layer('shifted2', 'shifted4', 4, 'Cnt[2]', 'rot', 'pad')
print('\n//// shift layer 2^3 = 8 ////')
print(f'wire [{WIDTH-1}:0] shifted8;')
shift_layer('shifted4', 'shifted8', 8, 'Cnt[3]', 'rot', 'pad')