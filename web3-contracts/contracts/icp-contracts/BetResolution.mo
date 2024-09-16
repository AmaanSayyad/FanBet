import Nat "mo:base/Nat";
import Betting "your_betting_actor";
import UserManagement "your_user_management_actor";
import QuizManagement "your_quiz_management_actor";

actor BetResolution {
    public func resolveBet(betId: Nat): async () {
        let bet = Betting.bets.get(betId);
        if (bet?.resolved == true) {
            return;
        };

        let quiz = QuizManagement.quizzes.get(bet?.quizId ?? 0);
        let won = (bet?.option == quiz?.correctOption);
        let reward = if (won) bet?.amount * 2 else 0;

        Betting.bets.put(betId, {bet with resolved = true; won = won});
        if (won) {
            UserManagement.updateUserBalance(bet?.user ?? Principal.null(), UserManagement.users.get(bet?.user ?? Principal.null())?.balance # reward);
        };
    };
}
