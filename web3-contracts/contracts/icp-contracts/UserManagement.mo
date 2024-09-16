import Nat "mo:base/Nat";

actor UserManagement {
    type User = {
        userAddress: Principal;
        username: Text;
        balance: Nat;
        registered: Bool;
    };

    stable var users : [Principal: User] = {};

    public func registerUser(username: Text): async () {
        let user = Principal.fromActor(this);
        if (users.contains(user)) {
            return;
        };
        users.put(user, {
            userAddress = user;
            username = username;
            balance = 0;
            registered = true;
        });
    };

    public func getUser(user: Principal): async ?User {
        return users.get(user);
    };

    public func updateUserBalance(user: Principal, newBalance: Nat): async () {
        if (let Some(u) = users.get(user)) {
            users.put(user, {u with balance = newBalance});
        };
    };
}
