use super::geometry::ShapeGeometry;

#[derive(Copy, Drop)]
struct Rectangle {
    height: u64,
    width: u64,
}

mod rectangle_shape {
    use super::Rectangle;
    use super::ShapeGeometry;

    // Implementation RectangleGeometry passes in <Rectangle>
    // to implement the trait for that type
    impl RectangleGeometry of ShapeGeometry<Rectangle> {
        fn boundary(self: Rectangle) -> u64 {
            2 * (self.height + self.width)
        }
        fn area(self: Rectangle) -> u64 {
            self.height * self.width
        }
    }
}
