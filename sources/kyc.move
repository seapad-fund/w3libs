module w3libs::kyc {

    use sui::object::UID;
    use sui::vec_set;
    use sui::tx_context::{TxContext, sender};
    use sui::transfer;
    use sui::object;
    use sui::vec_set::VecSet;
    use std::vector;
    use sui::transfer::public_transfer;

    struct AdminCap has key, store {
        id: UID
    }

    struct KYC has key, store {
        id: UID,
        users: VecSet<address>
    }


    fun init(_witness: KYC, ctx: &mut TxContext) {
        let adminCap = AdminCap { id: object::new(ctx) };
        transfer::public_transfer(adminCap, sender(ctx));

        transfer::public_share_object(KYC {
            id: object::new(ctx),
            users: vec_set::empty<address>()
        })
    }

    public entry fun change_admin(admin_cap: AdminCap, to: address) {
        public_transfer(admin_cap, to);
    }

    public entry fun add_user(_admin_cap: &AdminCap, users: vector<address>, kyc: &mut KYC){
        let (i, n) = (0, vector::length(& users));
        while (i < n){
            let user = vector::pop_back(&mut users);
            assert!(!vec_set::contains(&kyc.users, &user), 0);
            vec_set::insert(&mut kyc.users, user);
        }
    }

    public entry fun remove_user(_admin_cap: &AdminCap, users: vector<address>, kyc: &mut KYC){
        let (i, n) = (0, vector::length(& users));
        while (i < n){
            let user = vector::pop_back(&mut users);
            assert!(vec_set::contains(&kyc.users, &user), 0);
            vec_set::remove(&mut kyc.users, &user);
        };
    }

    public fun hasKyc(user: address, kyc: &KYC): bool{
        vec_set::contains(&kyc.users, &user)
    }

    public entry fun reset(_admin_cap: &AdminCap, kyc: &mut KYC){
        remove_user(_admin_cap, vec_set::into_keys(kyc.users), kyc);
    }
}