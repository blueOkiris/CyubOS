# Cyub OS

## Description

A Rust-based 64-bit OS

## Build

Dependencies:
- Cargo w/ rust nightly
- nasm
- Linux
- make
- gcc (for ld)

Run `make`

## Running with Qemu

~Mount the bootloader: `sudo mkdir /mnt/cyubosboot; mount -oloop=boot/boot.flp /mnt/cyubosboot`~

Run with `qemu-system-x86_64 -fda boot/boot.flp`
