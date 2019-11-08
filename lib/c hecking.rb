require_relative "../config/environment.rb"

class Student

  attr_accessor :name, :grade
  attr_reader :id

  def initialize(name, grade, id=nil)
    @name=name
    @grade=grade
    @id=id
  end

  def self.create_table

    sql = <<-SQL
      CREATE TABLE IF NOT EXISTS students( 
        id INTEGER PRIMARY KEY,
        name STRING,
        grade STRING )
    SQL

    DB[:conn].execute(sql)

  end

  def self.drop_table

    sql = <<-SQL
      DROP TABLE IF EXISTS students
    SQL

    DB[:conn].execute(sql)

  end

  def save

    if self.id
      self.update
    else

    sql = <<-SLQ
      INSERT INTO students (name, grade)
      VALUES (?, ?)
    SLQ

    DB[:conn].execute(sql, self.name, self.grade)

    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]

    end
  end

  def self.create(name, grade)

    student = Student.new(name, grade)
    student = student.save
    student

  end

  def self.new_from_db(array)

    self.new(array[1], array[2], array[0])

  end

  def self.find_by_name(name)

    sql = "SELECT * FROM students WHERE name = ?"
    result = DB[:conn].execute(sql, name)[0]
    Student.new(result[1], result[2], result[0])
  end

  def update
    sql = "UPDATE students SET name = ?, grade = ? WHERE id = ?"
    DB[:conn].execute(sql, self.name, self.grade, self.id)
  end

end