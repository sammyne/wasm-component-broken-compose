WORKDIR := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))

OUT_DIR := $(WORKDIR)/_out

TARGET_DIR := $(WORKDIR)/target

.PHONY: all
all: $(OUT_DIR)/adder-component.wasm $(OUT_DIR)/calculator-component.wasm $(OUT_DIR)/calculator-composed.wasm

$(OUT_DIR):
	mkdir -p $@

$(OUT_DIR)/%.wasm: % $(OUT_DIR)
	@cargo build -p $< --release
	@cp $(TARGET_DIR)/wasm32-wasip1/release/`grep '^name = ' $</Cargo.toml | awk -F'"' '{print $$2}' | sed 's/-/_/g'`.wasm $@

$(OUT_DIR)/adder-component.wasm: $(OUT_DIR)/adder.wasm
	@wasm-tools component new $< -o $@ --adapt /opt/wasmtime/adapter-modules/wasi_snapshot_preview1.reactor.wasm

$(OUT_DIR)/calculator-component.wasm: $(OUT_DIR)/calculator.wasm
	@wasm-tools component new $< -o $@ --adapt /opt/wasmtime/adapter-modules/wasi_snapshot_preview1.reactor.wasm

$(OUT_DIR)/calculator-composed.wasm: $(OUT_DIR)/calculator-component.wasm $(OUT_DIR)/adder-component.wasm
	@wasm-tools compose $(word 1, $^) -d $(word 2, $^) -o $@

$(OUT_DIR)/calculator.wasm: calculator/wit/deps/adder

calculator/wit/deps/adder: adder/wit
	@rm -rf $@
	@mkdir -p `dirname $@`
	@cp -r $< $@

fmt:
	@cd adder && cargo fmt	
	@cd calculator && cargo fmt	

run: $(OUT_DIR)/app.wasm
	@wasmtime run $<

.PHONY: clean
clean:
	@rm -rf $(OUT_DIR)
	@rm -rf adder/wit/deps
	@rm -rf calculator/wit/deps
	@cargo clean
