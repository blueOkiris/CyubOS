# Author: Dylan Turner
# Description: Build the executable

# Options

## Assembly Build options
AS :=				nasm

## Cargo build options
RUSTC :=			cargo
RUSTC_FLAGS :=		+nightly \
					rustc --release --target=x86_64-unknown-linux-gnu \
					-- -C code-model=kernel -Z plt=y

## Stage 1 bootloader options
STG1_SRC :=			$(wildcard boot/stage1/*.asm)
STG1_INC :=			-Iboot/stage1
STG1_AS_FLAGS :=	-f bin

## Stage 2 bootloader options
STG2_SRC :=			$(wildcard boot/stage2/*.asm)
STG2_INC :=			-Iboot/stage2
STG2_AS_FLAGS :=	-f elf64

## Rust kernel options
RUST_SRC :=			$(wildcard kernel/src/*.rs)

## Main binary
OBJNAME :=			cyubos.flp

# Targets

## Helper targets

.PHONY: all
all: $(OBJNAME)

.PHONY: clean
clean:
	rm -rf *.bin
	rm -rf *.o
	rm -rf kernel/target
	rm -rf kernel/Cargo.lock
	rm -rf *.tmp
	rm -rf *.flp

### The binaries making up the final thing

stage1.bin: $(STG1_SRC)
	$(AS) $(STG1_AS_FLAGS) $(STG1_INC) -o $@ boot/stage1/stage1.asm

stage2.o: $(STG2_SRC)
	$(AS) $(STG2_AS_FLAGS) $(STG2_INC) -o $@ boot/stage2/stage2.asm

kernel.o: $(RUST_SRC)
	cd kernel; cargo $(RUSTC_FLAGS)
	cp kernel/target/x86_64-unknown-linux-gnu/release/libcyub_os_kernel.a $@

kernel.bin: stage2.o kernel.o
	ld -Tlink.ld

## Main targets
$(OBJNAME): stage1.bin kernel.bin
	rm -rf $@
	cat $^ >> $@
