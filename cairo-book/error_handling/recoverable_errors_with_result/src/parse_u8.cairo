use traits::Into;
use traits::TryInto;
use option::OptionTrait;
use result::ResultTrait;
use result::ResultTraitImpl;

fn parse_u8(s: felt252) -> Result<u8, felt252> {
    match s.try_into() {
        Option::Some(value) => Result::Ok(value),
        Option::None(_) => Result::Err('Invalid integer'),
    }
}

#[test]
fn test_felt252_to_u8() {
    let number: felt252 = 5_felt252;
    // should not panic
    let res = parse_u8(number).unwrap();
}

#[test]
#[should_panic]
fn test_felt252_to_u8_panic() {
    let number: felt252 = 256_felt252;
    // should panic
    let res = parse_u8(number).unwrap();
}
