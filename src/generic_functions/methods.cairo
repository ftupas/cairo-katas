use debug::PrintTrait;

struct Wallet<T> {
    balance: T, 
}

// Define our own implementation of Drop for Wallet<T>
impl WalletDrop<T, impl TDrop: Drop<T>> of Drop<Wallet<T>>;

// Define a trait for Wallet<T>
trait WalletTrait<T> {
    fn balance(self: @Wallet<T>) -> @T;
}

// Define an implementation of WalletTrait<T> for Wallet<T>
impl WalletImpl<T> of WalletTrait<T> {
    // This method takes the wallet by reference and returns a reference to the balance
    fn balance(self: @Wallet<T>) -> @T {
        return self.balance;
    }
}

// Define a trait for a concrete type Wallet<u128>
trait WalletReceiveTrait {
    fn receive(ref self: Wallet<u128>, value: u128);
}

// Definee an implementation of WalletReceiveTrait for Wallet<u128>
impl WalletReceiveImpl of WalletReceiveTrait {
    // This method takes the wallet by value and another value and returns the balance incremented by the value
    fn receive(ref self: Wallet<u128>, value: u128) {
        self.balance += value;
    }
}

struct WalletAddress<T, U> {
    balance: T,
    address: U,
}

// Define a trait for WalletAddress<T, U>
trait WalletAddressMixTrait<T1, U1> {
    fn mixup<T2, impl T2Drop: Drop<T2>, U2, impl U2Drop: Drop<U2>>(
        self: WalletAddress<T1, U1>, other: WalletAddress<T2, U2>
    ) -> WalletAddress<T1, U2>;
}

// Define an implementation of WalletAddressMixTrait<T, U> for WalletAddress<T, U>
// Add Droppable bounds to T1 and U1 on the implementation declaration
impl WalletAddressMixImpl<T1,
impl T1Drop: Drop<T1>,
U1,
impl U1Drop: Drop<U1>> of WalletAddressMixTrait<T1, U1> {
    // Mixes up two WalletAddress<T, U> instances, takes T1 from WalletAddress<T1, U1> and U2 from WalletAddress<T2, U2>
    // Add Droppable bounds to T2 and U2 as part of the signature
    fn mixup<T2, impl T2Drop: Drop<T2>, U2, impl U2Drop: Drop<U2>>(
        self: WalletAddress<T1, U1>, other: WalletAddress<T2, U2>
    ) -> WalletAddress<T1, U2> {
        WalletAddress { balance: self.balance, address: other.address }
    }
}

fn main() {
    let mut w = Wallet { balance: 50_u128 };
    assert(*w.balance() == 50_u128, 0);

    w.receive(100_u128);
    assert(*w.balance() == 150_u128, 0);

    // Create a WalletAddress<bool, u128>
    let wa1 = WalletAddress { balance: true, address: 10_u128 };
    // Create a WalletAddress<felt252, u8>
    let wa2 = WalletAddress { balance: 32, address: 100_u8 };

    // Mix up the two WalletAddress instances to get WalletAddress<bool, u8>
    let wa3 = wa1.mixup(wa2);

    wa3.balance.print();
    wa3.address.print();

    assert(wa3.balance == true, 0);
    assert(wa3.address == 100_u8, 0);
}
