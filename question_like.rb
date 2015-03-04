class QuestionLike
  attr_accessor :id, :user_id, :question_id

  def initialize(params = {})
    @id = params['id']
    @user_id = params['user_id']
    @question_id = params['question_id']
  end

  def self.find_by_id(search_id)
    result = QuestionsDatabase.instance.execute(<<-SQL, search_id)
      SELECT
        *
      FROM
        users
      WHERE
        id = ?
    SQL

    QuestionLike.new(result[0])
  end

  def self.likers_for_question_id(question_id)
    result = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT
        users.id, users.fname, users.lname
      FROM
        users
      JOIN
        question_likes ON users.id = question_likes.user_id
      WHERE
        question_likes.question_id = ?
    SQL

    result.map { |row| User.new(row) }
  end

  def self.num_likes_for_question_id(question_id)
    result = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT
        COUNT(*)
      FROM
        question_likes
      WHERE
        question_id = ?
      GROUP BY
        question_id
    SQL

    result.empty? ? 0 : result[0]["COUNT(*)"]
  end

  def self.liked_questions_for_user_id(user_id)
    result = QuestionsDatabase.instance.execute(<<-SQL, user_id)
      SELECT
        q.id, q.title, q.body, q.author_id
      FROM
        questions AS q
      JOIN
        question_likes ON q.id = question_likes.question_id
      WHERE
        user_id = ?
    SQL

    result.map { |row| Question.new(row) }
  end

  def self.most_liked_questions(n)
    result = QuestionsDatabase.instance.execute(<<-SQL)
      SELECT
        questions.id, questions.title, questions.body, questions.author_id
      FROM
        question_likes
      JOIN
        questions ON questions.id = question_likes.question_id
      GROUP BY
        questions.id
      ORDER BY
        COUNT(*) DESC
    SQL

    result.take(n).map { |row| Question.new(row) }
  end

  def self.most_liked(n)
    QuestionLike.most_liked_questions(n)[n - 1]
  end

end
