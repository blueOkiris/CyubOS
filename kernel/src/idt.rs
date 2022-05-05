/*
 * Author: Dylan Turner
 * Description: Handle kernel interrupts
 */

use crate::{
    io::{
        inb, outb
    }, terminal::{
        print_str, ForegroundColor, BackgroundColor, set_cursor_pos
    }
};

#[no_mangle]
pub static mut IDT: [IdtGate64; 256] = [
    IdtGate64 {
        offset_low: 0,
        selector: 0x08,
        ist: 0,
        types_attr: 0x8E,
        offset_mid: 0,
        offset_high: 0,
        zero: 0
    }; 256
];
static mut IDT_REG: IdtReg = IdtReg {
    limit: 0,
    base: 0
};

// Make sure for IDT stuff that structs are layed out w/out optimization
#[derive(Clone, Copy)]
#[repr(C)]
pub struct IdtGate64 {
    offset_low: u16,
    selector: u16,
    ist: u8,
    types_attr: u8,
    offset_mid: u16,
    offset_high: u32,
    zero: u32
}

#[repr(C)]
struct IdtReg {
    limit: u16,
    base: u64
}

fn isr1() {
    unsafe {
        asm!("cli");
    }

    set_cursor_pos(0, 0);
    print_str("Here!", ForegroundColor::White, BackgroundColor::Black);

    let _key = inb(0x50);

    outb(0x20, 0x20);
    outb(0xA0, 0x20);

    unsafe {
        asm!("iretq");
    }
}

pub fn idt_init() {
    for table in 0..256 {
        unsafe {
            let isr_ptr = isr1 as fn() as u64;
            IDT[table].offset_low = ((isr_ptr as u64) & 0x000000000000FFFF) as u16;
            IDT[table].offset_mid = (((isr_ptr as u64) & 0x00000000FFFF0000) >> 16) as u16;
            IDT[table].offset_high = (((isr_ptr as u64) & 0xFFFFFFFF00000000) >> 32) as u32;
        }
    }

    outb(0x21, 0xFD);
    outb(0xA1, 0xFF);

    load_idt();
}

fn load_idt() {
    unsafe {
        let idt_ptr: *const [IdtGate64; 256] = &IDT;
        IDT_REG = IdtReg {
            limit: 256 * 16 - 1,
            base: idt_ptr as u64,
        };
        let idt_reg_ptr: *const IdtReg = &IDT_REG;

        asm!(
            "lidt [eax]
            sti",
            in("eax") idt_reg_ptr as u64
        );
    }
}
