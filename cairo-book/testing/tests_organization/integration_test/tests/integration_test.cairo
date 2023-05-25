use adder::main;

#[test]
fn internal() {
    assert(main::internal_adder(2, 2) == 4, 'internal_adder failed');
}
