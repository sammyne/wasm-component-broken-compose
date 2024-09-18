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
    wasm-tools compose _out/calculator-component.wasm -d _out/adder-component.wasm -o _out/calculator-composed.wasm
    ```
    Log outputs as follow
    ```bash
    WARNING: `wasm-tools compose` has been deprecated.

    Please use `wac` instead. You can find more information about `wac` at https://github.com/bytecodealliance/wac.
    [2024-09-18T02:46:09Z WARN ] instance `docs:adder/types@0.1.0` will be imported because a dependency named `docs:adder/types@0.1.0` could not be found
    [2024-09-18T02:46:09Z WARN ] instance `wasi:cli/environment@0.2.0` will be imported because a dependency named `wasi:cli/environment@0.2.0` could not be found
    [2024-09-18T02:46:09Z WARN ] instance `wasi:cli/exit@0.2.0` will be imported because a dependency named `wasi:cli/exit@0.2.0` could not be found
    [2024-09-18T02:46:09Z WARN ] instance `wasi:io/error@0.2.0` will be imported because a dependency named `wasi:io/error@0.2.0` could not be found
    [2024-09-18T02:46:09Z WARN ] instance `wasi:io/streams@0.2.0` will be imported because a dependency named `wasi:io/streams@0.2.0` could not be found
    [2024-09-18T02:46:09Z WARN ] instance `wasi:cli/stdin@0.2.0` will be imported because a dependency named `wasi:cli/stdin@0.2.0` could not be found
    [2024-09-18T02:46:09Z WARN ] instance `wasi:cli/stdout@0.2.0` will be imported because a dependency named `wasi:cli/stdout@0.2.0` could not be found
    [2024-09-18T02:46:09Z WARN ] instance `wasi:cli/stderr@0.2.0` will be imported because a dependency named `wasi:cli/stderr@0.2.0` could not be found
    [2024-09-18T02:46:09Z WARN ] instance `wasi:clocks/wall-clock@0.2.0` will be imported because a dependency named `wasi:clocks/wall-clock@0.2.0` could not be found
    [2024-09-18T02:46:09Z WARN ] instance `wasi:filesystem/types@0.2.0` will be imported because a dependency named `wasi:filesystem/types@0.2.0` could not be found
    [2024-09-18T02:46:09Z WARN ] instance `wasi:filesystem/preopens@0.2.0` will be imported because a dependency named `wasi:filesystem/preopens@0.2.0` could not be found
    error: failed to validate output component `_out/calculator-composed.wasm`

    Caused by:
        0: instance not valid to be used as export (at offset 0x2a8b7)
    ```
    **INDICATING THE COMPOSED COMPONENT IS INVALID.**

## References
- [The WebAssembly Component Model/Components in Rust](https://component-model.bytecodealliance.org/language-support/rust.html)
