use debug::PrintTrait;
use traits::Into;

fn main() {
    let x = 5;
    let x = x + 1; // Here x is 6
    {
        let x = x * 2; // Here x is 12
        'Inner scope x value is:'.print();
        x.print()
    }
    'Outer scope x value is:'.print();
    x.print(); // x is back to 6

    // Cariable shadowing and mutable variables are equivalent at the lower level.
    // The only difference is that by shadowing a variable, the compiler will not complain if you change its type.

    let x: u64 = 2;
    x.print();
    let x: felt252 = x.into(); // converts x to a felt, type annotation is required.
    x.print()
}
