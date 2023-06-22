// Integer Types
//
// 8-bit	u8
// 16-bit	u16
// 32-bit	u32
// 64-bit	u64
// 128-bit	u128
// 256-bit	u256
// 32-bit	usize

// Numeric literals
// Decimal	98222
// Hex	    0xff
// Octal	0o04321
// Binary	0b01

use debug::PrintTrait;

fn sub_u8s(x: u8, y: u8) -> u8 {
    x - y
}

fn main() {
    sub_u8s(3, 1).print();
    // sub_u8s(1, 3); // This will panic since it is negative (u8_sub Overflow)

    0xff.print();
    0o1234.print();
    0b010101.print();

    /// Numeric Operations

    // addition
    let sum = 5_u128 + 10_u128;
    sum.print();

    // subtraction
    let difference = 95_u128 - 4_u128;
    difference.print();

    // multiplication
    let product = 4_u128 * 30_u128;
    product.print();

    // division
    let quotient = 56_u128 / 32_u128; //result is 1
    quotient.print();
    let quotient = 64_u128 / 32_u128; //result is 2
    quotient.print();

    // remainder
    let remainder = 43_u128 % 5_u128; // result is 3
    remainder.print();
}
