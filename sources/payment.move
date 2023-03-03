// Copyright (c) Web3 Labs, Inc.
// SPDX-License-Identifier: Apache-2.0

module w3libs::payment {
    use sui::coin::Coin;
    use sui::sui::SUI;
    use sui::tx_context::TxContext;
    use sui::pay;
    use sui::coin;
    use std::vector as vec;

    public fun merge_and_split(coins: vector<Coin<SUI>>, amount: u64, ctx: &mut TxContext): (Coin<SUI>, Coin<SUI>) {
        let base = vec::pop_back(&mut coins);
        pay::join_vec(&mut base, coins);
        assert!(coin::value(&base) > amount, 0);
        (coin::split(&mut base, amount, ctx), base)
    }

    public fun take_from(coins: vector<Coin<SUI>>, amount: u64, ctx: &mut TxContext): Coin<SUI> {
        let base = vec::pop_back(&mut coins);
        pay::join_vec(&mut base, coins);
        assert!(coin::value(&base) > amount, 0);
        let expect = coin::split(&mut base, amount, ctx);
        transfer::transfer(base, tx_context::sender(ctx));

        expect
    }
}
