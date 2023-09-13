.PHONY: all
all: clippy test

.PHONY: check
check:
	cargo check

.PHONY: clippy
clippy:
	cargo clippy

.PHONY: test
test: unit-test

.PHONY: unit-test
unit-test:
	cargo test

# This is a build suitable for uploading to mainnet.
# Calls to `debug_print` get removed by the compiler.
.PHONY: build-mainnet _build-mainnet
build-mainnet: _build-mainnet compress-wasm
_build-mainnet:
	RUSTFLAGS='-C link-arg=-s' cargo build --release --target wasm32-unknown-unknown

.PHONY: compress-wasm
compress-wasm:
	cp ./target/wasm32-unknown-unknown/release/*.wasm ./contract.wasm
	@## The following line is not necessary, may work only on linux (extra size optimization)
	@# wasm-opt -Os ./contract.wasm -o ./contract.wasm
	cat ./contract.wasm | gzip -9 > ./contract.wasm.gz


.PHONY: compile _compile
compile: _compile contract.wasm.gz
_compile:
	cargo build --target wasm32-unknown-unknown
	cp ./target/wasm32-unknown-unknown/debug/*.wasm ./contract.wasm

.PHONY: compile-optimized _compile-optimized
compile-optimized: _compile-optimized contract.wasm.gz
_compile-optimized:
	RUSTFLAGS='-C link-arg=-s' cargo build --release --target wasm32-unknown-unknown
	@# The following line is not necessary, may work only on linux (extra size optimization)
	wasm-opt -Os ./target/wasm32-unknown-unknown/release/*.wasm -o ./contract.wasm

.PHONY: compile-optimized-reproducible
compile-optimized-reproducible:
	docker run --rm -v "$$(pwd)":/contract \
		--mount type=volume,source="$$(basename "$$(pwd)")_cache",target=/code/target \
		--mount type=volume,source=registry_cache,target=/usr/local/cargo/registry \
		enigmampc/secret-contract-optimizer

contract.wasm.gz: contract.wasm
	cat ./contract.wasm | gzip -9 > ./contract.wasm.gz

contract.wasm:
	cp ./target/wasm32-unknown-unknown/release/receiver_contract.wasm ./contract.wasm

.PHONY: schema
schema:
	cargo run --example schema

.PHONY: clean
clean:
	cargo clean
	rm -f ./contract.wasm ./contract.wasm.gz
