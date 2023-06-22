use debug::PrintTrait;
fn main() {
    let x = 5;
    x.print();
    x = 6; // error: Cannot assign to an immutable variable.
    x.print();
}
