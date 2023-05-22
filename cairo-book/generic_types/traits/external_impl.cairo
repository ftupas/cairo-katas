mod circle;
mod geometry;
mod rectangle;

use debug::PrintTrait;
use geometry::ShapeGeometry;
use circle::Circle;
// Need to import implementation if declared in separate modules
use circle::circle_shape::CircleGeometry;
use rectangle::Rectangle;
// Need to import implementation if declared in separate modules
use rectangle::rectangle_shape::RectangleGeometry;

fn main() {
    let rect = rectangle::Rectangle { height: 5, width: 7 };
    let circ = circle::Circle { radius: 5 };

    rect.area().print();
    circ.area().print();
}
