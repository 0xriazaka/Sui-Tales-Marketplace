
module talesmarket::talesmarket {
    use sui::kiosk::{Self, Kiosk, KioskOwnerCap};
    use sui::transfer_policy::{
        Self,
        TransferPolicy,
        TransferRequest
    };
    use sui::balance::{Self, Balance};
    use sui::coin::{Self, Coin};
    use sui::tx_context:: {Self, TxContext};
    use sui::sui::SUI;
    use sui::object:: {Self, UID, ID};

    // seller functions
    // create new kiosk
    entry fun create_tale_marketplace(ctx: &mut TxContext) {
        let (kiosk, cap) = kiosk::new(ctx);
        let sender = tx_context::sender(ctx);
        transfer::public_share_object(kiosk);
        transfer::public_transfer(cap, sender);
    }

    // place tale
    public fun place_tale<T: key + store>(kiosk: &mut Kiosk, cap: &KioskOwnerCap, tale: T) {
        kiosk::place(kiosk, cap, tale);
    }

    // unplace tale
    public fun unplace_tale<T: key + store>(kiosk: &mut Kiosk, cap: &KioskOwnerCap, item_id: object::ID): T {
        kiosk::take<T>(kiosk, cap, item_id)
    }

    // list tale
    public fun list_tale<T: key + store>(kiosk: &mut Kiosk, cap: &KioskOwnerCap, skin_id: object::ID, price: u64) {
        kiosk::list<T>(kiosk, cap, skin_id, price);
    }

    // delist tale
    public fun delist_tale<T: key + store>(kiosk: &mut Kiosk, cap: &KioskOwnerCap, skin_id: object::ID) {
        kiosk::delist<T>(kiosk, cap, skin_id);
    }

    // lock tale
    public fun lock_tale<T: key + store>(kiosk: &mut Kiosk, cap: &KioskOwnerCap, policy: &TransferPolicy<T>, tale: T) {
        kiosk::lock(kiosk, cap, policy, tale);
    }

    // withdraw tale profits
    public fun withdraw_profits(kiosk: &mut Kiosk, cap: &KioskOwnerCap, amount: Option<u64>, ctx: &mut TxContext): Coin<SUI> {
        kiosk::withdraw(kiosk, cap, amount, ctx)
    }

    // buyer functions
    // purchase tale
    public fun purchase_tale<T: key + store>(kiosk: &mut Kiosk, item_id: object::ID, payment: Coin<SUI>): (T, sui::transfer_policy::TransferRequest<T>) {
        kiosk::purchase<T>(kiosk, item_id, payment)
    }
}

