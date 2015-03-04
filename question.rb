
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

    result.map { |row| Question.new(row) }
  end

  def author
    User.find_by_id(@author_id)
  end

  def replies
    Reply.find_by_question_id(@id)
  end

  def followers
    QuestionFollow.followers_for_question_id(@id)
  end

  def likers
    QuestionLike.likers_for_question_id(@id)
  end

  def num_likes
    QuestionLike.num_likes_for_question_id(@id)
  end  
end
