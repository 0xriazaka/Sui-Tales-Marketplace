
module talestransferpolicy::talestransferpolicy {
    use sui::sui::SUI;
    use sui::coin::{Self, Coin};
    use sui::transfer_policy::{
        Self,
        TransferPolicy,
        TransferPolicyCap,
        TransferRequest
    };

    // Kiosk struct
    public struct KIOSK has drop {}

    fun init(witness: KIOSK, ctx: &mut TxContext) {
        let pub = package::claim(otw, ctx);
        transfer::public_transfer(pub, sender(ctx));
    }

    public fun new_policy(pub: &Publisher, ctx: &mut TxContext) {
        let (policy, policy_cap) = transfer_policy::new<T>(pub, ctx);
        transfer::public_share_object(policy);
        transfer::public_transfer(policy_cap, sender(ctx));
    }   
}