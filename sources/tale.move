module tale::tale {
    use std::option::{Self, Option};
    use std::string::{Self, String};
    use sui::object::{Self, UID, ID};
    use sui::tx_context::{Self, TxContext};
    use sui::coin::{Self, Coin};
    use sui::sui::SUI;
    use sui::event;

    // skin struct
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

        event::emit(TaleCreated {
            tale_id: object::id(&tale),
            author: ctx.sender(),
        });
        tale
       
    }
}
