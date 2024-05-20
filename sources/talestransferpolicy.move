
module talestransferpolicy::talestransferpolicy {
    use sui::tx_context::{TxContext, sender};
    use sui::transfer_policy::{Self, TransferRequest, TransferPolicy, TransferPolicyCap};
    use sui::package::{Self, Publisher};
    use sui::transfer::{Self};

    // create transferpolicy
    #[allow(lint(share_owned, self_transfer))]
    public fun new_policy<T>(publisher: &Publisher, ctx: &mut TxContext) {
        let (policy, policy_cap) = transfer_policy::new<T>(publisher, ctx);
        transfer::public_share_object(policy);
        transfer::public_transfer(policy_cap, sender(ctx));
    }

    public entry fun transfer_ownership(
        tale_id: ID,
        new_owner: address,
        ctx: &mut TxContext,
    ) {
        let sender = tx_context::sender(ctx);
        let tale = borrow_global_mut<Tale>(tale_id);
        
        assert!(tale.owner == sender, 1, "Only the owner can transfer the tale");

        tale.owner = new_owner;
    }
}