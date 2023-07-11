use starknet::ContractAddress;

#[starknet::interface]
trait IERC20<T> {
    #[view]
    fn name(self: @T) -> felt252;

    #[view]
    fn symbol(self: @T) -> felt252;

    #[view]
    fn decimals(self: @T) -> u8;

    #[view]
    fn total_supply(self: @T) -> u256;

    #[view]
    fn balance_of(self: @T, account: ContractAddress) -> u256;

    #[view]
    fn allowance(self: @T, owner: ContractAddress, spender: ContractAddress) -> u256;

    #[external]
    fn transfer(ref self: T, recipient: ContractAddress, amount: u256) -> bool;

    #[external]
    fn transfer_from(
        ref self: T, sender: ContractAddress, recipient: ContractAddress, amount: u256
    ) -> bool;

    #[external]
    fn approve(ref self: T, spender: ContractAddress, amount: u256) -> bool;

    #[external]
    fn increase_allowance(ref self: T, spender: ContractAddress, amount: u256) -> bool;

    #[external]
    fn decrease_allowance(ref self: T, spender: ContractAddress, amount: u256) -> bool;
}

#[starknet::contract]
mod ERC20 {
    use integer::BoundedInt;
    use zeroable::Zeroable;
    use starknet::{ContractAddress, get_caller_address};
    use super::IERC20;

    ////////////////////
    // Storage
    ////////////////////
    #[storage]
    struct Storage {
        _name: felt252,
        _symbol: felt252,
        _total_supply: u256,
        _balances: LegacyMap<ContractAddress, u256>,
        _allowances: LegacyMap<(ContractAddress, ContractAddress), u256>,
    }

    ////////////////////
    // Events
    ////////////////////
    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        Transfer: Transfer,
        Approval: Approval,
    }

    #[derive(Drop, starknet::Event)]
    struct Transfer {
        from: ContractAddress,
        to: ContractAddress,
        value: u256,
    }

    #[derive(Drop, starknet::Event)]
    struct Approval {
        owner: ContractAddress,
        spender: ContractAddress,
        value: u256
    }

    ////////////////////
    // Constructor
    ////////////////////
    #[constructor]
    fn constructor(
        ref self: ContractState,
        name: felt252,
        symbol: felt252,
        initial_supply: u256,
        recipient: ContractAddress
    ) {
        self.initializer(name, symbol);
        self._mint(recipient, initial_supply);
    }

    ////////////////////
    // Externals
    ////////////////////
    #[external(v0)]
    impl ERC20Impl of IERC20<ContractState> {
        /// The name of the token.
        fn name(self: @ContractState) -> felt252 {
            self._name.read()
        }

        /// The symbol of the token.
        fn symbol(self: @ContractState) -> felt252 {
            self._symbol.read()
        }

        /// The number of decimals of the token.
        fn decimals(self: @ContractState) -> u8 {
            18
        }

        /// The total supply of the token.
        fn total_supply(self: @ContractState) -> u256 {
            self._total_supply.read()
        }

        /// The balance of the account.
        fn balance_of(self: @ContractState, account: ContractAddress) -> u256 {
            self._balances.read(account)
        }

        /// The allowance of the owner to the spender.
        fn allowance(
            self: @ContractState, owner: ContractAddress, spender: ContractAddress
        ) -> u256 {
            self._allowances.read((owner, spender))
        }

        /// Transfer the amount to the recipient.
        fn transfer(ref self: ContractState, recipient: ContractAddress, amount: u256) -> bool {
            let sender = get_caller_address();
            self._transfer(sender, recipient, amount);
            true
        }

        /// Transfer the amount from the sender to the recipient.
        fn transfer_from(
            ref self: ContractState,
            sender: ContractAddress,
            recipient: ContractAddress,
            amount: u256
        ) -> bool {
            let caller = get_caller_address();
            self._spend_allowance(sender, caller, amount);
            self._transfer(sender, recipient, amount);
            true
        }

        /// Approve the spender to spend the amount.
        fn approve(ref self: ContractState, spender: ContractAddress, amount: u256) -> bool {
            let caller = get_caller_address();
            self._approve(caller, spender, amount);
            true
        }

        /// Increase the allowance of the spender by the amount.
        fn increase_allowance(
            ref self: ContractState, spender: ContractAddress, amount: u256
        ) -> bool {
            self._increase_allowance(spender, amount)
        }

        /// Decrease the allowance of the spender by the amount.
        fn decrease_allowance(
            ref self: ContractState, spender: ContractAddress, amount: u256
        ) -> bool {
            self._decrease_allowance(spender, amount)
        }
    }

    ////////////////////
    // Internals
    ////////////////////
    #[generate_trait]
    impl InternalImpl of InternalTrait {
        fn initializer(ref self: ContractState, name: felt252, symbol: felt252) {
            self._name.write(name);
            self._symbol.write(symbol);
        }

        fn _mint(ref self: ContractState, recipient: ContractAddress, amount: u256) {
            assert(!recipient.is_zero(), 'ERC20: mint to 0');
            self._total_supply.write(self._total_supply.read() + amount);
            self._balances.write(recipient, self._balances.read(recipient) + amount);
            EventEmitter::emit(
                ref self, Transfer { from: Zeroable::zero(), to: recipient, value: amount,  }
            );
        }

        fn _burn(ref self: ContractState, account: ContractAddress, amount: u256) {
            assert(!account.is_zero(), 'ERC20: burn from 0');
            self._total_supply.write(self._total_supply.read() - amount);
            self._balances.write(account, self._balances.read(account) - amount);
            EventEmitter::emit(
                ref self, Transfer { from: account, to: Zeroable::zero(), value: amount,  }
            );
        }

        fn _transfer(
            ref self: ContractState,
            sender: ContractAddress,
            recipient: ContractAddress,
            amount: u256
        ) {
            assert(!sender.is_zero(), 'ERC20: transfer from 0');
            assert(!recipient.is_zero(), 'ERC20: transfer to 0');
            self._balances.write(sender, self._balances.read(sender) - amount);
            self._balances.write(recipient, self._balances.read(recipient) + amount);
            EventEmitter::emit(ref self, Transfer { from: sender, to: recipient, value: amount });
        }

        fn _approve(
            ref self: ContractState, owner: ContractAddress, spender: ContractAddress, amount: u256, 
        ) {
            assert(!owner.is_zero(), 'ERC20: approve from 0');
            assert(!spender.is_zero(), 'ERC20: approve to 0');
            self._allowances.write((owner, spender), amount);
            EventEmitter::emit(ref self, Approval { owner, spender, value: amount });
        }

        fn _spend_allowance(
            ref self: ContractState, owner: ContractAddress, spender: ContractAddress, amount: u256
        ) {
            let current_allowance = self._allowances.read((owner, spender));
            if current_allowance != BoundedInt::max() {
                self._approve(owner, spender, current_allowance - amount);
            }
        }

        fn _increase_allowance(
            ref self: ContractState, spender: ContractAddress, amount: u256
        ) -> bool {
            let caller = get_caller_address();

            self._approve(caller, spender, self._allowances.read((caller, spender)) + amount);
            true
        }

        fn _decrease_allowance(
            ref self: ContractState, spender: ContractAddress, amount: u256
        ) -> bool {
            let caller = get_caller_address();
            self._approve(caller, spender, self._allowances.read((caller, spender)) - amount);
            true
        }
    }
}
