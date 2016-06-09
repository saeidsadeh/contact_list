require 'pg'
require 'pry'
# Represents a person in an address book.
# The ContactList class will work with Contact objects instead of interacting with the CSV file directly
class Contact

  attr_accessor :name, :email, :id
  

  def initialize(name, email, id = nil)

    @id = id
    @name = name
    @email= email
    
    
  end

  def to_s
    "#{@id}: #{@name}, #{@email}"
  end

  def save
    conn = Contact.connection
    if @id.nil? 
      result = conn.exec("insert into contacts(name, email) values ($1, $2) returning id", [name, email] )
      #[{id: 5}]
      @id = result.first["id"].to_i
    else
      params = [name, email, id]
      conn.exec("UPDATE contacts SET name = $1, email = $2 where id = $3", params)
      #update the actual record
    end
  end
  


  # Provides functionality for managing contacts in the csv file.
  class << self


     def all
      contacts = []
      conn = Contact.connection
      conn.exec('select id, name, email FROM contacts;') do |results|
        #[{id: 1, name: "name_value", email: "email_value"}, {id: 2 ....}]
        results.each do |row|
          #{id: 1, name: "name_value", email: "email_value"}
          id = row["id"]
          name = row["name"]
          email = row["email"]
          contacts << Contact.new(name, email, id) #Contact.new("name_value", "email_value", 1)
          #on the first loop, [contact1]
        end
      end
      contacts
    end

    def connection
      # Contact.connection takes no arguments
      # should return a PG connection object
      PG.connect(
      host: 'localhost',
      dbname: 'contact_list',
      user: 'development',
      password: 'development'
  )
    end

    
    def create(name, email)

      contact = Contact.new(name, email)
      contact.save

    end





    
    
    def find(id)
      contacts = []
      conn = Contact.connection
      results = conn.exec_params("SELECT * FROM contacts where id = $1", [id])
        results.each do |row|
          id = row["id"]
          name = row["name"]
          email = row["email"]
          contacts << Contact.new(name, email, id)
        end
      contacts
    end


    def search(term)
      contacts = []
      conn = Contact.connection
      results = conn.exec_params("SELECT * FROM contacts where name like $1", [term])
      results.each do |row|
        id = row["id"]
        name = row["name"]
        email = row["email"]
        contacts << Contact.new(name, email, id)
      end
      contacts
    end

  end
end