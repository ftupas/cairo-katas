use array::ArrayTrait;

#[derive(Copy, Drop)]
struct Guess {
    value: u64, 
}

trait GuessTrait {
    fn new(value: u64) -> Guess;
}

impl GuessImpl of GuessTrait {
    fn new(value: u64) -> Guess {
        if value < 1 {
            let mut data = ArrayTrait::new();
            data.append('Guess must be >= 1');
            panic(data);
        } else if value > 100 {
            let mut data = ArrayTrait::new();
            data.append('Guess must be <= 100');
            panic(data);
        }

        Guess { value,  }
    }
}

#[cfg(test)]
mod tests {
    use super::Guess;
    use super::GuessTrait;

    #[test]
    #[should_panic(expected: ('Guess must be <= 100', ))]
    fn greater_than_100() {
        GuessTrait::new(200);
    }
}


#[cfg(test)]
mod tests_filter {
    #[test]
    fn add_two_and_two() {
        let result = 2 + 2;
        assert(result == 4, 'result is not 4');
    }

    #[test]
    fn add_three_and_two() {
        let result = 3 + 2;
        assert(result == 5, 'result is not 5');
    }
}


#[cfg(test)]
mod tests_ignore {
    #[test]
    fn it_works() {
        let result = 2 + 2;
        assert(result == 4, 'result is not 4');
    }

    #[test]
    #[ignore]
    fn expensive_test() { // code that takes an hour to run
    }
}
