// variety of types into one compound type
// once declared, they cannot grow or shrink in size

use debug::PrintTrait;

fn main() {
    let tup: (u32, u64, bool) = (10, 20, true);
    tup.print();

    // Destructure tuple
    let (x, y, z) = tup;

    if y == 6 {
        'y is six!'.print();
    }

    // Declare value and type at the same time
    let (x, y): (felt252, felt252) = (2, 3);
    x.print();
    y.print();
}

impl TuplePrintImpl<
    E0,
    E1,
    E2,
    impl E0Print: PrintTrait<E0>,
    impl E1Print: PrintTrait<E1>,
    impl E2Print: PrintTrait<E2>,
    impl E0Drop: Drop<E0>,
    impl E1Drop: Drop<E1>,
    impl E2Drop: Drop<E2>
> of PrintTrait<(E0, E1, E2)> {
    fn print(self: (E0, E1, E2)) {
        let (e0, e1, e2) = self;
        e0.print();
        e1.print();
        e2.print();
    }
}
