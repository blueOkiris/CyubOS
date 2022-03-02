/*
 * Author: Dylan Turner
 * Description: Entry point for the Cyub OS kernel
 */

use crate::text_print::{
    Cursor, Terminal
};

#[no_mangle]
pub extern "C" fn kernel_start() {
    Cursor::set_pos(3, 4);
    Terminal::print_str("Hello from rust kernel!\n");
    Terminal::print_str("  Hello from rust kernel!\r");
    Terminal::print_str("Goodbye\n");
}
