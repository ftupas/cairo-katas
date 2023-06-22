use debug::PrintTrait;
fn main() {
    let t = true;
    t.print();

    let t = bool::True(());
    t.print();

    let f: bool = false; // with explicit type annotation
    f.print();

    let f = bool::False(());
    f.print();
}
