
module talesrules::talesrules {
    use sui::coin::Coin;
    use sui::sui::SUI;
    use sui::transfer_policy::{
        Self as policy,
        TransferPolicy,
        TransferPolicyCap,
        TransferRequest
    };

    // constants
    const EIncorrectAmount: u64 = 0;
    const EInsufficientAmount: u64 = 1;
    const MAX_BPS: u16 = 10_000;

    // rule witness struct
    struct Rule has drop {}

    // config struct
    struct Config has store, drop {
        tale_fixed_fee : u8,
    }

    // add a rule
    public fun add_tale_rule<T>(
        policy: &mut TransferPolicy<T>,
        cap: &TransferPolicyCap<T>,
        tale_fixed_price: u8,
    ) {
        assert!(tale_fixed_fee <= MAX_BPS, EIncorrectAmount);
        policy::add_rule(Rule {}, policy, cap, Config { tale_fixed_fee })
    }


}