module module_3::hero; 
    // ========= IMPORTS =========
    use std::string::String;
    use sui::coin::{Self, Coin};
    use sui::sui::SUI;
    use sui::event;
    
    // ========= STRUCTS =========
    public struct Hero has key, store {
        id: UID,
        name: String,
        image_url: String,
        power: u64,
    }

    public struct ListHero has key, store {
        // TODO: Add the fields for the ListHero
        // 1. The id of the ListHero
        // 2. The nft object
        // 3. The price of the Hero
        // 4. The seller of the Hero
        id : UID,
        nft : Hero,
        price : u64,
        seller: address,

    }

    public struct HeroMetadata has key, store {
        // TODO: Add the fields for the HeroMetadata
        // 1. The id of the HeroMetadata
        // 2. The timestamp of the HeroMetadata
        id : UID,
        timestamp : u64,
    }

    // ========= EVENTS =========

    public struct HeroListed has copy, drop {
        // TODO: Add the fields for the HeroListed
        // 1. The id of the HeroListed
        // 2. The price of the Hero
        // 3. The seller of the Hero
        // 4. The timestamp of the HeroListed   
        id : ID,// unique bir id olma durumu yok copy çünkü key değil
        price : u64,
        seller : address,
        timestamp: u64,
    }

    public struct HeroBought has copy, drop {// nft nin satın alınma bilgileri
        // TODO: Add the fields for the HeroBought
        // 1. The id of the HeroBought
        // 2. The price of the Hero
        // 3. The buyer of the Hero
        // 4. The seller of the Hero
        // 5. The timestamp of the HeroBought
        id : ID,
        price : u64,
        seller : address,
        buyer : address,
        timestamp : u64,
    }

    // ========= FUNCTIONS =========

    #[allow(lint(self_transfer))]
    public entry fun create_hero(name: String, image_url: String, power: u64,  ctx: &mut TxContext) {
        let hero = Hero {
            id: object::new(ctx),
            name,
            image_url,
            power
        };

        let hero_metadata = HeroMetadata {
            id: object::new(ctx),   
            timestamp: ctx.epoch_timestamp_ms(),
        };

        transfer::transfer(hero, ctx.sender());

        // TODO: Freeze the HeroMetadata object

        transfer::freeze_object(hero_metadata);
        
    }



    public entry fun list_hero(nft: Hero, price: u64, ctx: &mut TxContext) {
        // TODO: Define the ListHero object,

         let hero_id = object::id(&nft);

        let list_hero = ListHero {
            // TODO: Define the fields for the ListHero object
            // 1. Create the object id for the ListHero object
            // 2. The nft object
            // 3. The price of the Hero
            // 4. The seller of the Hero (the sender)
            id: object::new(ctx),        // Yeni UID oluştur (list_hero henüz yok!)
            nft: nft,                   
            price: price,                
            seller: ctx.sender(),
        };

        // TODO: Emit the HeroListed event
        // 
        event::emit(HeroListed {
        id: hero_id,                
        price: price,
        seller: ctx.sender(),
        timestamp: ctx.epoch_timestamp_ms(),
        });



        // TODO: Share the ListHero object 

        transfer::share_object(list_hero)
        
    }

    public entry fun buy_hero(list_hero: ListHero, coin: Coin<SUI>, ctx: &mut TxContext) {
        // TODO: Deconstruct the ListHero object
        // TODO: Assert the price of the Hero is equal to the coin amount
        // TODO: Transfer the coin to the seller
        // TODO: Transfer the Hero object to the sender
        // TODO: Emit the HeroBought event
        // TODO: Destroy the ListHero object

        let ListHero {id, nft, price, seller} = list_hero;

        assert!(coin.value() == price, 1);

        transfer::public_transfer(coin, seller);
        transfer::public_transfer(nft, ctx.sender());

        event::emit( HeroBought{
            id: id.to_inner(),
            price : price,
            buyer : ctx.sender(),
            seller : seller,
            timestamp : ctx.epoch_timestamp_ms(),  

        });

        object::delete(id);

    }

    public entry fun transfer_hero(hero: Hero, to: address) {
        transfer::public_transfer(hero, to);
    }

    // ========= GETTER FUNCTIONS =========
    
    #[test_only]
    public fun hero_name(hero: &Hero): String {
        hero.name
    }

    #[test_only]
    public fun hero_image_url(hero: &Hero): String {
        hero.image_url
    }

    #[test_only]
    public fun hero_power(hero: &Hero): u64 {
        hero.power
    }

    #[test_only]
    public fun hero_id(hero: &Hero): ID {
        object::id(hero)
    }





