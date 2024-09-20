mod bindings {
    wit_bindgen::generate!({});

    use crate::App;

    export!(App);
}

use bindings::docs::adder::api;
use bindings::exports::docs::calculator::hi::Guest;
use bindings::exports::docs::calculator::hi::Wallet;

struct App;

impl Guest for App {
    fn greet(a: Wallet) {
        match api::incr(a.into(), 123) {
            Ok(_) => println!("ok"),
            Err(_) => println!("err"),
        }
    }
}

impl From<Wallet> for api::Wallet {
    fn from(value: Wallet) -> Self {
        match value {
            Wallet::Btc(balance) => Self::Btc(balance),
            Wallet::Eth(balance) => Self::Eth(balance),
        }
    }
}