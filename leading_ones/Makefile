MODULE:=leading_ones
IMPL:='-GIMPL="UNIQUE_CASE"'


.PHONY: sim
sim: waveform.vcd
.PHONY: verilate
verilate: .stamp.verilate

.PHONY: build
build: obj_dir/V$(MODULE)

.PHONY: waves
waves:waveform.vcd
	@echo
	@echo "### WAVES ###"
	gtkwave waveform.vcd
	#gtkwave waveform.vcd -a waves.gtkw ## load signals

waveform.vcd: ./obj_dir/V$(MODULE)
	@echo
	@echo "### SIMULATING ###"
	@./obj_dir/V$(MODULE) +verilator+rand+reset+2

./obj_dir/V$(MODULE): .stamp.verilate
	@echo
	@echo "### BUILDING SIM ###"
	make -C obj_dir -f V$(MODULE).mk V$(MODULE)

.stamp.verilate: $(MODULE).sv tb_$(MODULE).cpp
	@echo
	@echo "### VERILATING ###"
	verilator -Wall --trace --x-assign unique --x-initial unique -cc $(MODULE).sv --exe tb_$(MODULE).cpp $(IMPL)
	@touch .stamp.verilate

.PHONY: lint
lint: $(MODULE).sv
	verilator --lint-only $(MODULE).sv $(IMPL)

.PHONY: clean
clean:
	rm -rf .stamp.*;
	rm -rf ./obj_dir
	rm -rf waveform.vcd
