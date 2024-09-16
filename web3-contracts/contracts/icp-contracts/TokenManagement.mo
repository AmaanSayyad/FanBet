import Nat "mo:base/Nat";
import UserManagement "your_user_management_actor";

actor TokenManagement {
    public func withdraw(amount: Nat): async () {
        let user = Principal.fromActor(this);
        assert(UserManagement.users.get(user)?.balance >= amount, "Insufficient balance");

        UserManagement.updateUserBalance(user, UserManagement.users.get(user)?.balance - amount);
    };

    public func deposit(): async () {
        let user = Principal.fromActor(this);
        let depositAmount = 100; // Example fixed deposit for demonstration

        UserManagement.updateUserBalance(user, UserManagement.users.get(user)?.balance + depositAmount);
    };

    public func getBalance(user: Principal): async ?Nat {
        return UserManagement.users.get(user)?.balance;
    };
}
