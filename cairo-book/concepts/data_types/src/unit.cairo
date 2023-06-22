// unit type is a type which has only one value ()
// it is represented by a tuple with no elements
// Its size is always zero, and it is guaranteed to not exist in the compiled code.

struct MyStruct {
    x: (),
    y: (),
}

fn main() {
    let x = ();
}
