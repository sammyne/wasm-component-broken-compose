# broken compose

This repository demonstrates a broken composition of WASM components.


## Requirement
- Rust 1.80.1 (376290515 2024-07-16)
- wasm-tools 1.216.0
- wasmtime adapter modules 20.0.0 (9e1084ffa 2024-04-22)

## Reproduction

1. Setup WIT dependencies
    ```bash
    mkdir -p calculator/wit/deps
    cp -r adder/wit calculator/wit/deps/adder
    ```
1. Build the WASM modules
    ```bash
    cargo build --release -p adder

    cargo build --release -p calculator
    ```
1. Componentize
    > Assume wasmtime adapter modules is at path /opt/wasmtime/adapter-modules/wasi_snapshot_preview1.reactor.wasm.

    ```bash
    rm -rf _out && mkdir _out

    wasm-tools component new target/wasm32-wasip1/release/adder.wasm -o _out/adder-component.wasm \
      --adapt /opt/wasmtime/adapter-modules/wasi_snapshot_preview1.reactor.wasm

    wasm-tools component new target/wasm32-wasip1/release/calculator.wasm -o _out/calculator-component.wasm \
      --adapt /opt/wasmtime/adapter-modules/wasi_snapshot_preview1.reactor.wasm
    ```
1. Compose
    ```bash
    wac plug _out/calculator-component.wasm --plug _out/adder-component.wasm -o _out/calculator-composed.wasm
    ```
    Log outputs as follow
    ```bash
    error: encoding produced a component that failed validation

    Caused by:
        instance not valid to be used as export (at offset 0x19310)
    make: *** [Makefile:25: /github.com/sammyne/wasm-component-broken-compose/_out/calculator-composed.wasm] Error 1
    ```
    **INDICATING THE COMPOSED COMPONENT IS INVALID.**

## References
- [The WebAssembly Component Model/Components in Rust](https://component-model.bytecodealliance.org/language-support/rust.html)
