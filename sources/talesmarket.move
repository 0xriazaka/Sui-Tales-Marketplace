module tale::market {
    use std::string::{String};
  
    use sui::coin::{Self, Coin};
    use sui::object::{Self, ID, UID};
    use sui::table::{Table, Self};
    use sui::transfer;
    use sui::tx_context::{Self, TxContext};
    use sui::sui::{SUI};
    use sui::balance::{Self, Balance};
    use sui::kiosk::{Self, Kiosk, KioskOwnerCap};
    use sui::transfer_policy::{Self as tp};
    use sui::package::{Self, Publisher};

    // Error codes
    const ENoPicture: u64 = 0;
    const ENotOwner: u64 = 1;
    const EInvalidAmount: u64 = 2;

    /// Publisher capability object
    public struct TalePublisher has key { id: UID, publisher: Publisher }

     // one time witness 
    public struct MARKET has drop {}

    // Only owner of this module can access it.
    public struct AdminCap has key {
        id: UID,
    }

    public struct Tale has key, store {
        id: UID,
        owner: address,
        author: String,
        title: String,
        category: String,
        story: String,
    }

    // events
    public struct TaleCreated has copy, drop {
        tale_id: ID,
        author: address,
    }

    // mint tale
    public fun mint_tale (
        author: String,
        title: String,
        category: String,
        story: String,   
        ctx: &mut TxContext,
    ) : Tale {
        let tale = Tale {
            id: object::new(ctx),
            owner: ctx.sender(),
            author: author,
            title: title,
            category: category,
            story: story,
        };
        tale 
    }

    // =================== Initializer ===================
    fun init(otw: MARKET, ctx: &mut TxContext) {
        // define the publisher
        let publisher_ = package::claim<MARKET>(otw, ctx);
        // wrap the publisher and share.
        transfer::share_object(TalePublisher {
            id: object::new(ctx),
            publisher: publisher_
        });
        // transfer the admincap
        transfer::transfer(AdminCap{id: object::new(ctx)}, tx_context::sender(ctx));
    }

    /// Users can create new kiosk for marketplace 
    public fun new(ctx: &mut TxContext) : KioskOwnerCap {
        let(kiosk, kiosk_cap) = kiosk::new(ctx);
        // share the kiosk
        transfer::public_share_object(kiosk);
        kiosk_cap
    }
    // create any transferpolicy for rules 
    public fun new_policy(publish: &TalePublisher, ctx: &mut TxContext ) {
        // set the publisher
        let publisher = get_publisher(publish);
        // create an transfer_policy and tp_cap
        let (transfer_policy, tp_cap) = tp::new<Tale>(publisher, ctx);
        // transfer the objects 
        transfer::public_transfer(tp_cap, tx_context::sender(ctx));
        transfer::public_share_object(transfer_policy);
    }

    // =================== Helper Functions ===================

    // return the publisher
    fun get_publisher(shared: &TalePublisher) : &Publisher {
        &shared.publisher
     }

    #[test_only]
    // call the init function
    public fun test_init(ctx: &mut TxContext) {
        init(MARKET {}, ctx);
    }
}