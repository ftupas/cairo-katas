#[derive(Copy, Drop)]
struct Rectangle {
    height: u64,
    width: u64,
}

// Define trait for Rectangle
trait RectangleTrait {
    fn area(self: @Rectangle) -> u64;
    fn can_hold(self: @Rectangle, other: @Rectangle) -> bool;
}

// Define impl for RectangleTrait
impl RectangleImpl of RectangleTrait {
    fn area(self: @Rectangle) -> u64 {
        *self.width * *self.height
    }
    fn can_hold(self: @Rectangle, other: @Rectangle) -> bool {
        *self.width > *other.width & *self.height > *other.height
    }
}

// Add tests
#[cfg(test)]
mod tests {
    use super::Rectangle;
    use super::RectangleTrait;

    #[test]
    fn larger_can_hold_smaller() {
        let larger = Rectangle { height: 7, width: 8,  };
        let smaller = Rectangle { height: 1, width: 5,  };

        assert(larger.can_hold(@smaller), 'rectangle cannot hold');
    }

    #[test]
    fn smaller_cannot_hold_larger() {
        let larger = Rectangle { height: 7_u64, width: 8_u64,  };
        let smaller = Rectangle { height: 1_u64, width: 5_u64,  };

        assert(!smaller.can_hold(@larger), 'rectangle cannot hold');
    }
}
