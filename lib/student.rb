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
    binding.pry
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
end
