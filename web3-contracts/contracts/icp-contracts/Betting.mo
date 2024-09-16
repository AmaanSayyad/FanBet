import Nat "mo:base/Nat";
import UserManagement "your_user_management_actor";
import QuizManagement "your_quiz_management_actor";

actor Betting {
    type Bet = {
        id: Nat;
        user: Principal;
        quizId: Nat;
        option: Nat8;
        amount: Nat;
        resolved: Bool;
        won: Bool;
    };

    stable var totalBets: Nat = 0;
    stable var bets: [Nat: Bet] = {};
    stable var userBets: [Principal: [Nat]] = {};

    public func placeBet(quizId: Nat, option: Nat8, amount: Nat): async () {
        assert(QuizManagement.quizzes.get(quizId)?.isActive == true, "Quiz is not active");
        assert(option < Nat8.fromNat(Nat.fromInt(QuizManagement.quizzes.get(quizId)?.options.size() ?? 0)), "Invalid option");

        let user = Principal.fromActor(this);
        let betId = totalBets;
        bets.put(betId, {
            id = betId;
            user = user;
            quizId = quizId;
            option = option;
            amount = amount;
            resolved = false;
            won = false;
        });

        if (!userBets.contains(user)) {
            userBets.put(user, []);
        };
        userBets.get(user)?.append(betId);

        UserManagement.updateUserBalance(user, UserManagement.users.get(user)?.balance #amount);
        totalBets := totalBets + 1;
    };

    public func getUserBets(user: Principal): async ?[Nat] {
        return userBets.get(user);
    };
}
