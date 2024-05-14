
module kiosk::skinsMarketplace {
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

    // create new kiosk
    entry fun create_skins_marketplace(ctx: &mut TxContext) {
        let (kiosk, cap) = kiosk::new(ctx);
        let sender = tx_context::sender(ctx);
        transfer::public_share_object(kiosk);
        transfer::public_transfer(cap, sender);
    }

    //place tale
    public fun place_tale<T: key + store>(kiosk: &mut Kiosk, cap: &KioskOwnerCap, tale: T) {
        kiosk::place(kiosk, cap, tale);
    }

    //list tale
    public fun list_tale<T: key + store>(kiosk: &mut Kiosk, cap: &KioskOwnerCap, skin_id: object::ID, price: u64) {
        kiosk::list<T>(kiosk, cap, skin_id, price);
    }

    //lock tale
    public fun lock_tale<T: key + store>(kiosk: &mut Kiosk, cap: &KioskOwnerCap, policy: &TransferPolicy<T>, tale: T) {
        kiosk::lock(kiosk, cap, policy, tale);
    }
}

