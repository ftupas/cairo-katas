use debug::PrintTrait;

#[derive(Copy, Drop)]
struct Rectangle {
    height: u64,
    width: u64,
}

// Define a trait
trait ShapeGeometry {
    fn boundary(self: Rectangle) -> u64;
    fn area(self: Rectangle) -> u64;
}

// Define an implementation of the ShapeGeometry trait
impl RectangleGeometry of ShapeGeometry {
    fn boundary(self: Rectangle) -> u64 {
        2 * (self.height + self.width)
    }

    fn area(self: Rectangle) -> u64 {
        self.height * self.width
    }
}

fn main() {
    let rect = Rectangle { height: 4, width: 2 }; // Rectangle instantiation

    // First way, as a method on the struct instance
    let area1 = rect.area();
    // Second way, from the implementation
    let area2 = RectangleGeometry::area(rect);
    // `area1` has same value as `area2`
    area1.print();
    area2.print();
}
