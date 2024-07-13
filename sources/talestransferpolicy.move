
module talestransferpolicy::talestransferpolicy {
    use sui::tx_context::sender;
    use sui::transfer_policy;
    use sui::package::Publisher;

    // create transferpolicy
    #[allow(lint(share_owned, self_transfer))]
    public fun new_policy<T>(publisher: &Publisher, ctx: &mut TxContext) {
        let (policy, policy_cap) = transfer_policy::new<T>(publisher, ctx);
        transfer::public_share_object(policy);
        transfer::public_transfer(policy_cap, sender(ctx));
    }
}