/*
 * Author: Dylan Turner
 * Description: Entry point for the Cyub OS kernel
 */

use core::ptr::write;

const TEST_MSG: &'static str = "Hello from the Rust kernel!";

fn test_print() {
    let vid_mem = 0xB8000 as *mut u8;
    for i in 0..TEST_MSG.len() {
        unsafe {
            write(vid_mem.add(160 + i * 2), TEST_MSG.as_bytes()[i]);
            write(vid_mem.add(160 + i * 2 + 1), 0x50);
        }
    }
}

#[no_mangle]
pub extern "C" fn kernel_start() {
    test_print();
}
