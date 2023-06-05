use array::ArrayTrait;
use debug::PrintTrait;

fn main() {
    let mut data = ArrayTrait::new();
    data.append(2);
    panic(data);

    // idiomatic
    // not reached as well
    panic_with_felt252(2);
    'This line isn't reached'.print();
}
