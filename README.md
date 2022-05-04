# Cyub OS

## Description

A Rust-based 64-bit OS with a modular kernel.

## Build

Dependencies:
- Cargo w/ rust nightly
- nasm
- Linux
- make
- gcc (for ld)

Run `make`

## Running with Qemu

Run with `qemu-system-x86_64 -fda cyubos.flp`

## Architecture

There is a bootloader written in assembly which initializes the system, sets up paging and interrupts, jumps to 64-bit mode, and then calls into the kernel.

Then the kernel, written in Rust, uses a service model to perform the following tasks:
- interface with hardware like network and pci devices via modules
- manage system memory
- device management
- file management

Finally, an init system, also in Rust, will launch after the kernel and will launch various services necessary for the operating system, including the Desktop Environment (also part of this project).
