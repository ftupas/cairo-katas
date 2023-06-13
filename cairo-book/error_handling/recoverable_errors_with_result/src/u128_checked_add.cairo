use debug::PrintTrait;
use option::OptionTrait;
use integer::BoundedInt;

fn u128_overflowing_add(a: u128, b: u128) -> Result<u128, u128> {
    if a > a + b {
        Result::Err(a + b)
    } else {
        Result::Ok(a + b)
    }
}

fn u128_checked_add(a: u128, b: u128) -> Option<u128> {
    match u128_overflowing_add(a, b) {
        Result::Ok(r) => Option::Some(r),
        Result::Err(r) => Option::None(()),
    }
}

fn main() {
    u128_checked_add(1, 2).unwrap().print(); // 3
    u128_checked_add(BoundedInt::max(), 1).unwrap().print(); // panic
}
