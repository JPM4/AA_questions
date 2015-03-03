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
end
