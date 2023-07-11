use array::ArrayTrait;
use ownable::{Ownable, IOwnableDispatcher, IOwnableDispatcherTrait};
use option::OptionTrait;
use result::ResultTrait;
use starknet::class_hash::Felt252TryIntoClassHash;
use starknet::{ContractAddress, contract_address_const};
use starknet::syscalls::deploy_syscall;
use starknet::testing::set_contract_address;
use traits::{TryInto, Into};

//
// Constants
//

fn OWNER() -> ContractAddress {
    contract_address_const::<'owner'>()
}

fn ANOTHER_OWNER() -> ContractAddress {
    contract_address_const::<'another_owner'>()
}

fn NOT_OWNER() -> ContractAddress {
    contract_address_const::<'not_owner'>()
}

//
// Setup
//

fn setup() -> IOwnableDispatcher {
    let mut calldata: Array<felt252> = Default::default();
    Serde::<ContractAddress>::serialize(@OWNER(), ref calldata);
    let (contract_address, _) = deploy_syscall(
        Ownable::TEST_CLASS_HASH.try_into().unwrap(), 0, calldata.span(), false
    )
        .unwrap();
    IOwnableDispatcher { contract_address }
}


//
// Tests
//

#[test]
#[available_gas(2000000)]
fn test_get_owner() {
    let ownable = setup();
    let owner = ownable.get_owner();
    assert(owner == OWNER(), 'Wrong owner');
}

#[test]
#[available_gas(2000000)]
fn test_transfer_ownership() {
    let ownable = setup();
    set_contract_address(OWNER());
    ownable.transfer_ownership(ANOTHER_OWNER());
    let owner = ownable.get_owner();
    assert(owner == ANOTHER_OWNER(), 'Wrong owner');
}

#[test]
#[available_gas(2000000)]
#[should_panic(expected: ('Caller is not the owner', 'ENTRYPOINT_FAILED'))]
fn test_transfer_ownership_not_owner() {
    let ownable = setup();
    set_contract_address(NOT_OWNER());
    ownable.transfer_ownership(ANOTHER_OWNER());
}
