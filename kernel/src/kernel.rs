/*
 * Author: Dylan Turner
 * Description: Entry point for the Cyub OS kernel
 */

use crate::terminal::{
    set_cursor_pos, print_str
};

#[no_mangle]
pub extern "C" fn kernel_start() {
    set_cursor_pos(3, 4);
    print_str("Hello from rust kernel!\n");
    print_str("  Hello from rust kernel!\r");
    print_str("Goodbye\n");
    //print_str(35.to_string());
}
