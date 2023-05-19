use debug::PrintTrait;

struct Wallet<T> {
    balance: T, 
}

// Define our own implementation of Drop for Wallet
impl WalletDrop<T, impl TDrop: Drop<T>> of Drop<Wallet<T>>;

struct WalletAddress<T, U> {
    balance: T,
    address: U,
}

// Define our own implementation of Drop for WalletAddress
impl WalletAddressDrop<T, impl TDrop: Drop<T>, U, impl UDrop: Drop<U>> of Drop<WalletAddress<T, U>>;


fn main() {
    let w = Wallet { balance: 3_u128 };
    let wa = WalletAddress { balance: 3_u128, address: 14 };
    wa.balance.print();
    wa.address.print();
}
