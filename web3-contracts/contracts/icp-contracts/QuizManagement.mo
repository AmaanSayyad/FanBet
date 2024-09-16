import Nat "mo:base/Nat";

actor QuizManagement {
    type Quiz = {
        id: Nat;
        question: Text;
        options: [Text];
        correctOption: Nat8;
        isActive: Bool;
    };

    stable var quizzes: [Nat: Quiz] = {};
    stable var totalQuizzes: Nat = 0;

    public func addQuiz(question: Text, options: [Text], correctOption: Nat8): async () {
        assert(options.size() > 1, "At least two options required");
        assert(correctOption < Nat8.fromNat(Nat.fromInt(options.size())), "Invalid correct option index");

        let quizId = totalQuizzes;
        quizzes.put(quizId, {
            id = quizId;
            question = question;
            options = options;
            correctOption = correctOption;
            isActive = true;
        });

        totalQuizzes := totalQuizzes + 1;
    };

    public func updateQuizStatus(quizId: Nat, isActive: Bool): async () {
        if (let Some(quiz) = quizzes.get(quizId)) {
            quizzes.put(quizId, {quiz with isActive = isActive});
        };
    };

    public func getQuiz(quizId: Nat): async ?Quiz {
        return quizzes.get(quizId);
    };
}
