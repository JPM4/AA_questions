require 'sqlite3'
require 'singleton'
require_relative 'question_like.rb'
require_relative 'reply.rb'
require_relative 'user.rb'
require_relative 'question_follow.rb'
require_relative 'question.rb'

class QuestionsDatabase < SQLite3::Database
  include Singleton

  def initialize
    super('questions.db')
    self.results_as_hash = true
    self.type_translation = true
  end

  def save
    return update unless @id.nil?

    params = self.instance_variables.drop(1).map { |ivar| ivar.to_s[1..-1] }
    params_eval = params.map { |ivar| eval(ivar.to_s) }

    QuestionsDatabase.instance.execute(<<-SQL, *params)
      INSERT INTO
        users (#{params.join(", ")})
      VALUES
        (?#{", ?" * (params.count - 1) })
    SQL

    @id = QuestionsDatabase.instance.last_insert_row_id
  end
end
