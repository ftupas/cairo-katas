use super::geometry::ShapeGeometry;

#[derive(Copy, Drop)]
struct Circle {
    radius: u64, 
}

mod circle_shape {
    use super::Circle;
    use super::ShapeGeometry;

    // We might have another struct Circle
    // which can use the same trait spec
    impl CircleGeometry of ShapeGeometry<Circle> {
        fn boundary(self: Circle) -> u64 {
            (2 * 314 * self.radius) / 100
        }
        fn area(self: Circle) -> u64 {
            (314 * self.radius * self.radius) / 100
        }
    }
}
