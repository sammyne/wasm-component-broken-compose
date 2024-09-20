mod bindings {
    wit_bindgen::generate!({
        world: "docs-adder"
    });

    use crate::App;

    export!(App);
}

use bindings::exports::docs::adder::api::{Guest, Wallet};

struct App;

impl Guest for App {
    // 资产增加实现
    fn incr(self_: Wallet, value: u64) -> Result<Wallet, String> {
        match self_ {
            Wallet::Btc(mut balance) => {
                balance.value += value;
                println!("bitcoin incr");
            }
            _ => {
                println!("ethereum incr");
            }
        }
        Ok(self_)
    }
}
