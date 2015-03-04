
class Reply
  attr_accessor :id, :body, :question_id, :parent_id, :user_id

  def initialize(params = {})
    @id = params['id']
    @body = params['body']
    @question_id = params['question_id']
    @parent_id = params['parent_id']
    @user_id = params['user_id']
  end

  def save
    return update unless @id.nil?

    params = [@body, @question_id, @parent_id, @user_id]

    QuestionsDatabase.instance.execute(<<-SQL, *params)
      INSERT INTO
        replies (body, question_id, parent_id, user_id)
      VALUES
        (?, ?, ?, ?)
    SQL

    @id = QuestionsDatabase.instance.last_insert_row_id
  end

  def update
    params = [@body, @question_id, @parent_id, @user_id, @id]
    QuestionsDatabase.instance.execute(<<-SQL, *params)
      UPDATE
        replies
      SET
        body = ?, question_id = ?, parent_id = ?, user_id = ?
      WHERE
        id = ?
    SQL
  end

  def self.find_by_id(search_id)
    result = QuestionsDatabase.instance.execute(<<-SQL, search_id)
      SELECT
        *
      FROM
        replies
      WHERE
        id = ?
    SQL

    Reply.new(result[0])
  end

  def self.find_by_user_id(user_id)
    result = QuestionsDatabase.instance.execute(<<-SQL, user_id)
      SELECT
        *
      FROM
        replies
      WHERE
        user_id = ?
    SQL

    result.map { |row| Reply.new(row) }
  end

  def self.find_by_question_id(question_id)
    result = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT
        *
      FROM
        replies
      WHERE
        question_id = ?
    SQL

    result.map { |row| Reply.new(row) }
  end

  def author
    User.find_by_id(@user_id)
  end

  def question
    Question.find_by_id(@question_id)
  end

  def parent_reply
    Reply.find_by_id(@parent_id)
  end

  def child_replies
    replies = QuestionsDatabase.instance.execute(<<-SQL, @id)
      SELECT
        *
      FROM
        replies
      WHERE
        parent_id = ?
    SQL

    replies.map { |row| Reply.new(row) }
  end
end
