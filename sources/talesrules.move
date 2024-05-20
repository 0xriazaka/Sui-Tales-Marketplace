module talesrule::talesrule {
    use sui::kiosk::{Self, Kiosk, KioskOwnerCap};
    use sui::transfer_policy::{Self, TransferPolicy, TransferRequest};
    use sui::balance::{Self, Balance};
    use sui::coin::{Self, Coin};
    use sui::tx_context::{Self, TxContext};
    use sui::sui::SUI;
    use sui::object::{Self, UID, ID};
    use sui::transfer;

    /// Creates a new marketplace kiosk.
    ///
    /// # Arguments
    /// * `ctx` - The transaction context.
    entry fun create_tale_marketplace(ctx: &mut TxContext) {
        let (kiosk, cap) = kiosk::new(ctx);
        let sender = tx_context::sender(ctx);
        transfer::public_share_object(kiosk);
        transfer::public_transfer(cap, sender);
    }

    /// Places a tale in the kiosk.
    ///
    /// # Arguments
    /// * `kiosk` - The kiosk where the tale will be placed.
    /// * `cap` - The owner's capability for the kiosk.
    /// * `tale` - The tale to be placed.
    public fun place_tale<T: key + store>(kiosk: &mut Kiosk, cap: &KioskOwnerCap, tale: T) {
        kiosk::place(kiosk, cap, tale);
    }

    /// Unplaces a tale from the kiosk.
    ///
    /// # Arguments
    /// * `kiosk` - The kiosk from where the tale will be removed.
    /// * `cap` - The owner's capability for the kiosk.
    /// * `item_id` - The ID of the tale to be removed.
    public fun unplace_tale<T: key + store>(kiosk: &mut Kiosk, cap: &KioskOwnerCap, item_id: object::ID): T {
        kiosk::take<T>(kiosk, cap, item_id)
    }

    /// Lists a tale for sale in the kiosk.
    ///
    /// # Arguments
    /// * `kiosk` - The kiosk where the tale will be listed.
    /// * `cap` - The owner's capability for the kiosk.
    /// * `tale_id` - The ID of the tale to be listed.
    /// * `price` - The price of the tale.
    public fun list_tale<T: key + store>(kiosk: &mut Kiosk, cap: &KioskOwnerCap, tale_id: object::ID, price: u64) {
        kiosk::list<T>(kiosk, cap, tale_id, price);
    }

    /// Delists a tale from the kiosk.
    ///
    /// # Arguments
    /// * `kiosk` - The kiosk where the tale is listed.
    /// * `cap` - The owner's capability for the kiosk.
    /// * `tale_id` - The ID of the tale to be delisted.
    public fun delist_tale<T: key + store>(kiosk: &mut Kiosk, cap: &KioskOwnerCap, tale_id: object::ID) {
        kiosk::delist<T>(kiosk, cap, tale_id);
    }

    /// Locks a tale in the kiosk.
    ///
    /// # Arguments
    /// * `kiosk` - The kiosk where the tale is listed.
    /// * `cap` - The owner's capability for the kiosk.
    /// * `policy` - The transfer policy for the tale.
    /// * `tale` - The tale to be locked.
    public fun lock_tale<T: key + store>(kiosk: &mut Kiosk, cap: &KioskOwnerCap, policy: &TransferPolicy<T>, tale: T) {
        kiosk::lock(kiosk, cap, policy, tale);
    }

    /// Withdraws profits from the kiosk.
    ///
    /// # Arguments
    /// * `kiosk` - The kiosk from where the profits will be withdrawn.
    /// * `cap` - The owner's capability for the kiosk.
    /// * `amount` - The amount to withdraw.
    /// * `ctx` - The transaction context.
    public fun withdraw_profits(kiosk: &mut Kiosk, cap: &KioskOwnerCap, amount: Option<u64>, ctx: &mut TxContext): Coin<SUI> {
        kiosk::withdraw(kiosk, cap, amount, ctx)
    }

    /// Purchases a tale from the kiosk.
    ///
    /// # Arguments
    /// * `kiosk` - The kiosk where the tale is listed.
    /// * `item_id` - The ID of the tale to be purchased.
    /// * `payment` - The payment for the tale.
    public fun purchase_tale<T: key + store>(kiosk: &mut Kiosk, item_id: object::ID, payment: Coin<SUI>): (T, TransferRequest<T>) {
        kiosk::purchase<T>(kiosk, item_id, payment)
    }
}
