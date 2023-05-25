#[cfg(test)]
mod tests {
    #[test]
    fn it_works() {
        let result = 2 + 2;
        assert(result == 4, 'result is not 4');
    }
}

#[cfg(test)]
mod tests1 {
    #[test]
    fn exploration() {
        let result = 2 + 2;
        assert(result == 4, 'result is not 4');
    }
}

#[cfg(test)]
mod tests2 {
    #[test]
    fn another() {
        let result = 2 + 2;
        assert(result == 6, 'Make this test fail');
    }
}
