require 'pry'

class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    # create a new Student object given a row from the database
    # There has to be a more flexible way to match variable names to columns. Did we do that last time with a k,v pair?
    noob= self.new
    noob.id = row[0]
    noob.name = row[1]
    noob.grade = row[2]
    noob
  end

  @@all = []

  def self.all
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
    sql = <<-SQL
      SELECT * FROM students
    SQL
    # what_we_get = DB[:conn].execute(sql)
    DB[:conn].execute(sql).each {|row| @@all << self.new_from_db(row)}
    # what_we_get.each {|row| @@all << self.new_from_db(row)}
    @@all
  end

  def self.find_by_name(name)
    # find the student in the database given a name
    # return a new instance of the Student class
    # Does this really need to create a new instance in a real world situation? 
    sql = <<-SQL
      SELECT * FROM students
      WHERE name = ?
      LIMIT 1
    SQL
    row = DB[:conn].execute(sql, name)
    #feels like there is a better way to get this single item out of the array, or maybe not return an array at all from previous method
    self.new_from_db(row[0])
  end
  
  def save
    sql = <<-SQL
      INSERT INTO students (name, grade) 
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end
  
  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end

  def self.all_students_in_grade_9
    # This feels like too specific a method to really be useful. Should take 'grade' as an argument and be more flexi.
    sql = <<-SQL
      SELECT * FROM students
      WHERE grade = ?
    SQL
    DB[:conn].execute(sql, 9).map {|row| self.new_from_db(row) }
  end

  def self.students_below_12th_grade
    sql = <<-SQL
      SELECT * FROM students
      WHERE grade < ?
    SQL
    DB[:conn].execute(sql, 12).map {|row| self.new_from_db(row)}
  end

  def self.first_X_students_in_grade_10(x)
    sql = <<-SQL
      SELECT * FROM students
      WHERE grade = ?
      LIMIT ?
    SQL
    DB[:conn].execute(sql, 10, x).map {|row| self.new_from_db(row)}
  end 

  def self.first_student_in_grade_10
    self.first_X_students_in_grade_10(1)[0]
  end

  def self.all_students_in_grade_X(x)
    sql = <<-SQL
      SELECT * FROM students
      WHERE grade = ?
    SQL
    DB[:conn].execute(sql, x).map {|row| self.new_from_db(row)}  
  end


end
