use array::ArrayTrait;
use erc20::{ERC20, IERC20Dispatcher, IERC20DispatcherTrait};
use integer::BoundedInt;
use integer::u256;
use integer::u256_from_felt252;
use option::OptionTrait;
use result::ResultTrait;
use starknet::{ContractAddress, contract_address_const};
use starknet::class_hash::Felt252TryIntoClassHash;
use starknet::syscalls::deploy_syscall;
use starknet::testing::set_contract_address;
use serde::Serde;
use traits::{TryInto, Into};
use zeroable::Zeroable;

//
// Constants
//

const NAME: felt252 = 111;
const SYMBOL: felt252 = 222;
const DECIMALS: u8 = 18;
const SUPPLY: u256 = 2000;
const VALUE: u256 = 300;

fn OWNER() -> ContractAddress {
    contract_address_const::<'owner'>()
}

fn SPENDER() -> ContractAddress {
    contract_address_const::<'spender'>()
}

fn RECIPIENT() -> ContractAddress {
    contract_address_const::<'recipient'>()
}

fn ZERO() -> ContractAddress {
    contract_address_const::<0>()
}

//
// Setup
//

fn setup() -> IERC20Dispatcher {
    let mut calldata: Array<felt252> = Default::default();
    Serde::serialize(@NAME, ref calldata);
    Serde::serialize(@SYMBOL, ref calldata);
    Serde::<u256>::serialize(@SUPPLY, ref calldata);
    Serde::<ContractAddress>::serialize(@OWNER(), ref calldata);

    let (contract_address, _) = deploy_syscall(
        ERC20::TEST_CLASS_HASH.try_into().unwrap(), 0, calldata.span(), false
    )
        .unwrap();
    IERC20Dispatcher { contract_address }
}

//
// constructor
//

#[test]
#[available_gas(2000000)]
fn test_constructor() {
    let erc20 = setup();

    assert(erc20.balance_of(OWNER()) == SUPPLY, 'Should eq inital_supply');
    assert(erc20.total_supply() == SUPPLY, 'Should eq inital_supply');
    assert(erc20.name() == NAME, 'Name should be NAME');
    assert(erc20.symbol() == SYMBOL, 'Symbol should be SYMBOL');
    assert(erc20.decimals() == DECIMALS, 'Decimals should be 18');
}

//
// Getters
//

#[test]
#[available_gas(2000000)]
fn test_total_supply() {
    let erc20 = setup();
    assert(erc20.total_supply() == SUPPLY, 'Should eq SUPPLY');
}

#[test]
#[available_gas(2000000)]
fn test_balance_of() {
    let erc20 = setup();
    assert(erc20.balance_of(OWNER()) == SUPPLY, 'Should eq SUPPLY');
}

#[test]
#[available_gas(2000000)]
fn test_allowance() {
    let erc20 = setup();
    set_contract_address(OWNER());
    erc20.approve(SPENDER(), VALUE);
    assert(erc20.allowance(OWNER(), SPENDER()) == VALUE, 'Should eq VALUE');
}

//
// approve
//

#[test]
#[available_gas(2000000)]
fn test_approve() {
    let erc20 = setup();
    set_contract_address(OWNER());
    assert(erc20.approve(SPENDER(), VALUE), 'Should return true');
    assert(erc20.allowance(OWNER(), SPENDER()) == VALUE, 'Spender not approved correctly');
}

#[test]
#[available_gas(2000000)]
#[should_panic(expected: ('ERC20: approve from 0', 'ENTRYPOINT_FAILED'))]
fn test_approve_from_zero() {
    let erc20 = setup();
    erc20.approve(SPENDER(), VALUE);
}

#[test]
#[available_gas(2000000)]
#[should_panic(expected: ('ERC20: approve to 0', 'ENTRYPOINT_FAILED'))]
fn test_approve_to_zero() {
    let erc20 = setup();
    set_contract_address(OWNER());
    erc20.approve(Zeroable::zero(), VALUE);
}


//
// transfer
//

#[test]
#[available_gas(2000000)]
fn test_transfer() {
    let erc20 = setup();
    set_contract_address(OWNER());
    assert(erc20.transfer(RECIPIENT(), VALUE), 'Should return true');

    assert(erc20.balance_of(RECIPIENT()) == VALUE, 'Balance should eq VALUE');
    assert(erc20.balance_of(OWNER()) == SUPPLY - VALUE, 'Should eq supply - VALUE');
    assert(erc20.total_supply() == SUPPLY, 'Total supply should not change');
}

#[test]
#[available_gas(2000000)]
#[should_panic(expected: ('u256_sub Overflow', 'ENTRYPOINT_FAILED'))]
fn test_transfer_not_enough_balance() {
    let erc20 = setup();
    set_contract_address(OWNER());

    let balance_plus_one = SUPPLY + 1;
    erc20.transfer(RECIPIENT(), balance_plus_one);
}

#[test]
#[available_gas(2000000)]
#[should_panic(expected: ('ERC20: transfer from 0', 'ENTRYPOINT_FAILED'))]
fn test_transfer_from_zero() {
    let erc20 = setup();
    set_contract_address(ZERO());
    erc20.transfer(RECIPIENT(), VALUE);
}

#[test]
#[available_gas(2000000)]
#[should_panic(expected: ('ERC20: transfer to 0', 'ENTRYPOINT_FAILED'))]
fn test_transfer_to_zero() {
    let erc20 = setup();
    set_contract_address(OWNER());
    erc20.transfer(ZERO(), VALUE);
}

//
// transfer_from
//

#[test]
#[available_gas(2000000)]
fn test_transfer_from() {
    let erc20 = setup();
    set_contract_address(OWNER());
    erc20.approve(SPENDER(), VALUE);

    set_contract_address(SPENDER());
    assert(erc20.transfer_from(OWNER(), RECIPIENT(), VALUE), 'Should return true');

    assert(erc20.balance_of(RECIPIENT()) == VALUE, 'Should eq amount');
    assert(erc20.balance_of(OWNER()) == SUPPLY - VALUE, 'Should eq suppy - amount');
    assert(erc20.allowance(OWNER(), SPENDER()) == 0, 'Should eq 0');
    assert(erc20.total_supply() == SUPPLY, 'Total supply should not change');
}

#[test]
#[available_gas(2000000)]
fn test_transfer_from_doesnt_consume_infinite_allowance() {
    let erc20 = setup();
    set_contract_address(OWNER());
    erc20.approve(SPENDER(), BoundedInt::max());
    assert(erc20.allowance(OWNER(), SPENDER()) == BoundedInt::max(), 'Allowance should be max');

    set_contract_address(SPENDER());
    erc20.transfer_from(OWNER(), RECIPIENT(), VALUE);

    assert(erc20.allowance(OWNER(), SPENDER()) == BoundedInt::max(), 'Allowance should not change');
}

#[test]
#[available_gas(2000000)]
#[should_panic(expected: ('u256_sub Overflow', 'ENTRYPOINT_FAILED'))]
fn test_transfer_from_greater_than_allowance() {
    let erc20 = setup();
    set_contract_address(OWNER());
    erc20.approve(SPENDER(), VALUE);

    set_contract_address(SPENDER());
    let allowance_plus_one = VALUE + 1;
    erc20.transfer_from(OWNER(), RECIPIENT(), allowance_plus_one);
}

#[test]
#[available_gas(2000000)]
#[should_panic(expected: ('ERC20: transfer to 0', 'ENTRYPOINT_FAILED'))]
fn test_transfer_from_to_zero_address() {
    let erc20 = setup();
    set_contract_address(OWNER());
    erc20.approve(SPENDER(), VALUE);

    set_contract_address(SPENDER());
    erc20.transfer_from(OWNER(), Zeroable::zero(), VALUE);
}

#[test]
#[available_gas(2000000)]
#[should_panic(expected: ('u256_sub Overflow', 'ENTRYPOINT_FAILED'))]
fn test_transfer_from_from_zero_address() {
    let erc20 = setup();
    erc20.transfer_from(Zeroable::zero(), RECIPIENT(), VALUE);
}


//
// increase_allowance
//

#[test]
#[available_gas(2000000)]
fn test_increase_allowance() {
    let erc20 = setup();
    set_contract_address(OWNER());
    erc20.approve(SPENDER(), VALUE);

    assert(erc20.increase_allowance(SPENDER(), VALUE), 'Should return true');
    assert(erc20.allowance(OWNER(), SPENDER()) == VALUE * 2, 'Should be amount * 2');
}

#[test]
#[available_gas(2000000)]
#[should_panic(expected: ('ERC20: approve to 0', 'ENTRYPOINT_FAILED'))]
fn test_increase_allowance_to_zero_address() {
    let erc20 = setup();
    set_contract_address(OWNER());
    erc20.increase_allowance(Zeroable::zero(), VALUE);
}

#[test]
#[available_gas(2000000)]
#[should_panic(expected: ('ERC20: approve from 0', 'ENTRYPOINT_FAILED'))]
fn test_increase_allowance_from_zero_address() {
    let erc20 = setup();
    erc20.increase_allowance(SPENDER(), VALUE);
}

//
// decrease_allowance
//

#[test]
#[available_gas(2000000)]
fn test_decrease_allowance() {
    let erc20 = setup();
    set_contract_address(OWNER());
    erc20.approve(SPENDER(), VALUE);

    assert(erc20.decrease_allowance(SPENDER(), VALUE), 'Should return true');
    assert(erc20.allowance(OWNER(), SPENDER()) == VALUE - VALUE, 'Should be 0');
}

#[test]
#[available_gas(2000000)]
#[should_panic(expected: ('u256_sub Overflow', 'ENTRYPOINT_FAILED'))]
fn test_decrease_allowance_to_zero_address() {
    let erc20 = setup();
    set_contract_address(OWNER());
    erc20.decrease_allowance(Zeroable::zero(), VALUE);
}

#[test]
#[available_gas(2000000)]
#[should_panic(expected: ('u256_sub Overflow', 'ENTRYPOINT_FAILED'))]
fn test_decrease_allowance_from_zero_address() {
    let erc20 = setup();
    erc20.decrease_allowance(SPENDER(), VALUE);
}
