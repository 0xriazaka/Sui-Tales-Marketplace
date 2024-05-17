
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
        amount_bp: u16,
    }

    // add a rule
    public fun add_tale_rule<T>(
        policy: &mut TransferPolicy<T>,
        cap: &TransferPolicyCap<T>,
        amount_bp: u8,
    ) {
        assert!(amount_bp <= MAX_BPS, EIncorrectAmount);
        policy::add_rule(Rule {}, policy, cap, Config { amount_bp })
    }

    // pay for the fee
    public fun pay<T>(
        policy: &mut TransferPolicy<T>,
        request: &mut TransferRequest<T>,
        payment: &mut Coin<SUI>,
        ctx: &mut TxContext
    ) {
        // using the getter to read the paid amount
        let paid = policy::paid(request);
        let config: &Config = policy::get_rule(Rule {}, policy);
        let amount = (((paid as u128) * (config.amount_bp as u128) / MAX_BP) as u64);
        assert!(coin::value(payment) >= amount, EInsufficientAmount);

        let fee = coin::split(payment, amount, ctx);
        policy::add_to_balance(Rule {}, policy, fee);
        policy::add_receipt(Rule {}, request)
    }
}