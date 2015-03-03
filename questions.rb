require 'sqlite3'
require 'singleton'

class QuestionsDatabase < SQLite3::Database
  include Singleton

  def initialize
    super('questions.db')
    self.results_as_hash = true
    self.type_translation = true
  end
end

class User
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

  attr_accessor :id, :fname, :lname

  def initialize(params = {})
    @id = params['id']
    @fname = params['fname']
    @lname = params['lname']
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

end

class Question
  attr_accessor :id, :title, :body, :author_id

  def initialize(params = {})
    @id = params['id']
    @title = params['title']
    @body = params['body']
    @author_id = params['author_id']
  end

  def self.find_by_id(search_id)
    result = QuestionsDatabase.instance.execute(<<-SQL, search_id)
      SELECT
        *
      FROM
        questions
      WHERE
        id = ?
    SQL

    Question.new(result[0])
  end

  def self.find_by_author_id(author_id)
    result = QuestionsDatabase.instance.execute(<<-SQL, author_id)
      SELECT
        *
      FROM
        questions
      WHERE
        author_id = ?
    SQL

    Question.new(result[0])
  end
end


class Reply
  def self.find_by_id(search_id)
    result = QuestionsDatabase.instance.execute(<<-SQL, search_id)
      SELECT
        *
      FROM
        users
      WHERE
        id = ?
    SQL

    Reply.new(result[0])
  end

  attr_accessor :id, :body, :question_id, :parent_id, :user_id

  def initialize(params = {})
    @id = params['id']
    @body = params['body']
    @question_id = params['question_id']
    @parent_id = params['parent_id']
    @user_id = params['user_id']
  end
end

class QuestionFollow
  def self.find_by_id(search_id)
    result = QuestionsDatabase.instance.execute(<<-SQL, search_id)
      SELECT
        *
      FROM
        users
      WHERE
        id = ?
    SQL

    QuestionFollow.new(result[0])
  end

  attr_accessor :id, :user_id, :question_id

  def initialize(params = {})
    @id = params['id']
    @user_id = params['user_id']
    @question_id = params['question_id']
  end
end

class QuestionLike
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

  attr_accessor :id, :user_id, :question_id

  def initialize(params = {})
    @id = params['id']
    @user_id = params['user_id']
    @question_id = params['question_id']
  end
end
