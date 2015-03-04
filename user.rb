
class User
  attr_accessor :id, :fname, :lname

  def initialize(params = {})
    @id = params['id']
    @fname = params['fname']
    @lname = params['lname']
  end

  def save
    return update unless @id.nil?

    params = [@fname, @lname]

    QuestionsDatabase.instance.execute(<<-SQL, *params)
      INSERT INTO
        users (fname, lname)
      VALUES
        (?, ?)
    SQL

    @id = QuestionsDatabase.instance.last_insert_row_id
  end

  def update
    params = [@fname, @lname, @id]
    QuestionsDatabase.instance.execute(<<-SQL, *params)
      UPDATE
        users
      SET
        fname = ?, lname = ?
      WHERE
        id = ?
    SQL
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
    User.new(result[0])
  end

  def self.find_by_name(fname, lname)
    user = QuestionsDatabase.instance.execute(<<-SQL, fname, lname)
      SELECT
        *
      FROM
        users
      WHERE
        fname = ? AND lname = ?
    SQL
    User.new(user[0])
  end

  def authored_questions
    Question.find_by_author_id(@id)
  end

  def authored_replies
    Reply.find_by_user_id(@id)
  end

  def followed_questions
    QuestionFollow.followed_questions_for_user_id(@id)
  end

  def liked_questions
    QuestionLike.liked_questions_for_user_id(@id)
  end

  def average_karma
    result = QuestionsDatabase.instance.execute(<<-SQL, @id)
      SELECT
        CAST(COUNT(question_likes.user_id) AS FLOAT) /
        COUNT(DISTINCT(questions.id))
      FROM
        questions
      LEFT OUTER JOIN
        question_likes ON questions.id = question_likes.question_id
      WHERE
        questions.author_id = ?
    SQL

    result[0].values.first.nil? ? 0 : result[0].values.first
  end
end
