/*
 * Author: Dylan Turner
 * Description: Handle text-mode printing
 */

use core::ptr::write;
use crate::io::{
    outb, inb
};

const VGA_MEMORY: u64 = 0xB8000;
const VGA_WIDTH: u8 = 80;

static mut CURSOR_X: u8 = 0;
static mut CURSOR_Y: u8 = 0;

pub struct Cursor {
}

impl Cursor {
    pub fn get_pos() -> (u8, u8) {
        unsafe {
            (CURSOR_X, CURSOR_Y)
        }
    }

    pub fn set_pos(x: u8, y: u8) {
        let pos = y as u16 * VGA_WIDTH as u16 + x as u16;

        // Actually update the cursor pos:
        outb(0x3D4, 0x0F);
        outb(0x3D5, (pos & 0x00FF) as u8);
        outb(0x3D4, 0x0E);
        outb(0x3D5, (pos >> 8) as u8);

        // Then update our copy
        unsafe {
            CURSOR_X = x;
            CURSOR_Y = y;
        }
    }
}

pub struct Terminal {
}

impl Terminal {
    pub fn print_str(msg: &str) {
        // Get references to the data we need
        let (mut crsr_x, mut crsr_y) = Cursor::get_pos();
        let video_mem = VGA_MEMORY as *mut u8;

        for c in msg.chars() {
            let offset = crsr_y as u16 * VGA_WIDTH as u16 + crsr_x as u16;
            match c {
                '\n' => {
                    crsr_y += 1;
                    crsr_x = 0;
                }, '\r' => {
                    crsr_x = 0;
                }, _ => {
                    unsafe {
                        let pos =
                            video_mem.add(((offset as u16) * 2) as usize);
                        write(pos, c as u8);
                    }
                    crsr_x += 1;
                }
            }
        }

        // Update cursor
        let mut new_crsr_x = crsr_x;
        let new_crsr_y = if new_crsr_x >= VGA_WIDTH {
            new_crsr_x -= VGA_WIDTH;
            crsr_y + 1
        } else {
            crsr_y
        };
        Cursor::set_pos(new_crsr_x, new_crsr_y);
    }
}
