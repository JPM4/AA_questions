#unfinished

module Save
  def save
    return update unless @id.nil?

    params = self.instance_variables.drop(1).map { |ivar| ivar.to_s[1..-1] }
    params_eval = params.map { |ivar| eval(ivar.to_s) }

    QuestionsDatabase.instance.execute(<<-SQL, *params_eval)
      INSERT INTO
        users (#{params.join(", ")})
      VALUES
        (?#{", ?" * (params.count - 1) })
    SQL

    @id = QuestionsDatabase.instance.last_insert_row_id
  end

  def update
    params = self.instance_variables.drop(1).map { |ivar| ivar.to_s[1..-1] }
    params_eval = params.map { |ivar| eval(ivar.to_s) }

    QuestionsDatabase.instance.execute(<<-SQL, *params_eval)
      UPDATE
        users (#{params.join(", ")})
      VALUES
        (?#{", ?" * (params.count - 1) })
    SQL

    @id = QuestionsDatabase.instance.last_insert_row_id
  end

end
