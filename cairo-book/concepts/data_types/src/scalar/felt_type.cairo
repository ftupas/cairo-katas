// P = 2^{251} + 17 * 2^{192}+1

use debug::PrintTrait;
fn main() {
    let x: felt252 = 3;
    x.print();
// x / y != 0 or 0.5
// must satisfy (x / y) * y == x
// 2 * ((P+1)/2) = P + 1 = 1 mod P
// (1 / 2) mod P = (P + 1) / 2
}
