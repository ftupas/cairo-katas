use super::parse_u8::parse_u8;
use debug::PrintTrait;

fn do_something_with_parse_u8(input: felt252) -> Result<u8, felt252> {
    let input_to_u8: u8 = parse_u8(input)?;
    // DO SOMETHING
    let res = input_to_u8 - 1;
    Result::Ok(res)
}

#[test]
fn test_function_2() {
    let number: felt252 = 258_felt252;
    match do_something_with_parse_u8(number) {
        Result::Ok(value) => value.print(),
        Result::Err(e) => e.print()
    }
}
