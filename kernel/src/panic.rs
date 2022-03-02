/*
 * Author: Dylan Turner
 * Description: Replacement panic function for Rust
 */

use core::panic::PanicInfo;
use crate::text_print::{
    Terminal, Cursor
};

#[no_mangle]
#[panic_handler]
fn panic(info: &PanicInfo) -> ! {
    Cursor::set_pos(0, 0);

    match info.message() {
        None => Terminal::print_str("An unknown panic error occured :("),
        Some(msg) => Terminal::print_str(msg.as_str().unwrap())
    }

    loop {
    }
}
