module tale::tale {
    use std::string::{Self, String};
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
    public entry fun mint_tale (
        author: vector<u8>,
        title: vector<u8>,
        category: vector<u8>,
        story: vector<u8>,   
        ctx: &mut TxContext,
    ) {
        let sender = tx_context::sender(ctx);
        let tale = Tale {
            id: object::new(ctx),
            owner: sender,
            author: string::utf8(author),
            title: string::utf8(title),
            category: string::utf8(category),
            story: string::utf8(story),
        };

        event::emit(TaleCreated {
            tale_id: object::id(&tale),
            author: sender,
        });

        transfer::public_transfer(tale, sender);
    }
}
