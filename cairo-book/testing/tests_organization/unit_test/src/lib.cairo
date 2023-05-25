fn internal_adder(a: u32, b: u32) -> u32 {
    a + b
}

// Unit tests are written inside the same file as the code
// #[cfg(test)] annotation on the tests module tells Cairo to compile
// and run the test code only when you run cairo-test
// not when you run cairo-run
#[cfg(test)]
mod tests {
    use super::internal_adder;
    #[test]
    fn it_works() {
        let result = internal_adder(2, 2);
        assert(result == 4, 'result is not 4');
    }
}

#[cfg(test)]
mod tests1 {
    use super::internal_adder;
    #[test]
    fn exploration() {
        let result = internal_adder(2, 2);
        assert(result == 4, 'result is not 4');
    }
}

#[cfg(test)]
mod tests2 {
    use super::internal_adder;
    #[test]
    #[should_panic(expected: ('Make this test fail', ))]
    fn another() {
        let result = internal_adder(2, 2);
        assert(result == 6, 'Make this test fail');
    }
}
