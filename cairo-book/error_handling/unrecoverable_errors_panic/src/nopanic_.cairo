// Correct
fn function_never_panic() -> felt252 nopanic {
    42
}

// Wrong
fn function_never_panic_() nopanic {
    assert(1 == 1, 'what');
}

fn main() {
    function_never_panic();
    function_never_panic_();

}
