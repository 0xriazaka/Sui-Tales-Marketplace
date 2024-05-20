module tale::tale {
    use std::option::{Self, Option};
    use std::string::{Self, String};
    use sui::transfer;
    use sui::object::{Self, UID, ID};
    use sui::tx_context::{Self, TxContext};
    use sui::coin::{Self, Coin};
    use sui::sui::SUI;
    use sui::event;

    /// The `Tale` struct represents a tale with various attributes.
    public struct Tale has key, store {
        id: UID,
        owner: address,
        author: String,
        title: String,
        category: String,
        story: String,
    }

    /// Event emitted when a new `Tale` is created.
    public struct TaleCreated has copy, drop {
        tale_id: ID,
        author: address,
    }

    /// Mints a new `Tale`.
    ///
    /// # Arguments
    /// * `author` - The author of the tale.
    /// * `title` - The title of the tale.
    /// * `category` - The category of the tale.
    /// * `story` - The content of the tale.
    /// * `ctx` - The transaction context.
    public entry fun mint_tale(
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

    /// Updates the metadata of an existing `Tale`.
    ///
    /// # Arguments
    /// * `tale_id` - The ID of the tale to be updated.
    /// * `new_title` - The new title of the tale.
    /// * `new_category` - The new category of the tale.
    /// * `new_story` - The new story content.
    /// * `ctx` - The transaction context.
    public entry fun update_tale(
        tale_id: ID,
        new_title: vector<u8>,
        new_category: vector<u8>,
        new_story: vector<u8>,
        ctx: &mut TxContext,
    ) {
        let sender = tx_context::sender(ctx);
        let tale = borrow_global_mut<Tale>(tale_id);
        
        assert!(tale.owner == sender, 1, "Only the owner can update the tale");

        tale.title = string::utf8(new_title);
        tale.category = string::utf8(new_category);
        tale.story = string::utf8(new_story);
    }
}
