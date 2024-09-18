mod bindings {
    wit_bindgen::generate!({});

    use crate::App;

    export!(App);
}

use bindings::docs::adder::api::{self, Wallet};
use bindings::exports::docs::calculator::hi::Guest;

struct App;

impl Guest for App {
    fn greet(a: Wallet) {
        match api::incr(a, 123) {
            Ok(_) => println!("ok"),
            Err(_) => println!("err"),
        }
    }
}
