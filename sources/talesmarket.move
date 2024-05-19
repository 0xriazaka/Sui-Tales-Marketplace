
module talesmarket::talesmarket {
    use sui::kiosk::{Self, Kiosk, KioskOwnerCap};
    use sui::transfer_policy::{Self, TransferPolicy, TransferRequest};
    use sui::balance::{Self, Balance};
    use sui::coin::{Self, Coin};
    use sui::tx_context::{Self, TxContext};
    use sui::sui::SUI;
    use sui::object::{Self, UID, ID};

    // errors
    const ERR_UNAUTHORIZED: u64 = 1;

    // seller functions
    // create new marketplace
    entry fun create_tale_marketplace(ctx: &mut TxContext) {
        let (kiosk, cap) = kiosk::new(ctx);
        let sender = tx_context::sender(ctx);
        transfer::public_share_object(kiosk);
        transfer::public_transfer(cap, sender);
    }

    // Verify ownership of the kiosk
    fun verify_kiosk_ownership(kiosk: &Kiosk, cap: &KioskOwnerCap, sender: address): bool {
        true
    }

    // place a tale
    public fun place_tale<T: key + store>(kiosk: &mut Kiosk, cap: &KioskOwnerCap, tale: T, ctx: &mut TxContext) {
        let sender = tx_context::sender(ctx);
        assert!(verify_kiosk_ownership(kiosk, cap, sender), ERR_UNAUTHORIZED);
        kiosk::place(kiosk, cap, tale);
    }

    // unplace a tale
    public fun unplace_tale<T: key + store>(kiosk: &mut Kiosk, cap: &KioskOwnerCap, item_id: object::ID, ctx: &mut TxContext): T {
        let sender = tx_context::sender(ctx);
        assert!(verify_kiosk_ownership(kiosk, cap, sender), ERR_UNAUTHORIZED);
        kiosk::take<T>(kiosk, cap, item_id)
    }

    // list a tale
    public fun list_tale<T: key + store>(kiosk: &mut Kiosk, cap: &KioskOwnerCap, skin_id: object::ID, price: u64, ctx: &mut TxContext) {
        let sender = tx_context::sender(ctx);
        assert!(verify_kiosk_ownership(kiosk, cap, sender), ERR_UNAUTHORIZED);
        kiosk::list<T>(kiosk, cap, skin_id, price);
    }

    // delist a tale
    public fun delist_tale<T: key + store>(kiosk: &mut Kiosk, cap: &KioskOwnerCap, skin_id: object::ID, ctx: &mut TxContext) {
        let sender = tx_context::sender(ctx);
        assert!(verify_kiosk_ownership(kiosk, cap, sender), ERR_UNAUTHORIZED);
        kiosk::delist<T>(kiosk, cap, skin_id);
    }

    // lock a tale
    public fun lock_tale<T: key + store>(kiosk: &mut Kiosk, cap: &KioskOwnerCap, policy: &TransferPolicy<T>, tale: T, ctx: &mut TxContext) {
        let sender = tx_context::sender(ctx);
        assert!(verify_kiosk_ownership(kiosk, cap, sender), ERR_UNAUTHORIZED);
        kiosk::lock(kiosk, cap, policy, tale);
    }

    // withdraw kiosk profits
    public fun withdraw_profits(kiosk: &mut Kiosk, cap: &KioskOwnerCap, amount: Option<u64>, ctx: &mut TxContext): Coin<SUI> {
        let sender = tx_context::sender(ctx);
        assert!(verify_kiosk_ownership(kiosk, cap, sender), ERR_UNAUTHORIZED);
        kiosk::withdraw(kiosk, cap, amount, ctx)
    }

    // buyer functions
    // purchase a tale
    public fun purchase_tale<T: key + store>(kiosk: &mut Kiosk, item_id: object::ID, payment: Coin<SUI>): (T, sui::transfer_policy::TransferRequest<T>) {
        kiosk::purchase<T>(kiosk, item_id, payment)
    }
}

