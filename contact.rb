require 'csv'

# Represents a person in an address book.
# The ContactList class will work with Contact objects instead of interacting with the CSV file directly
class Contact

  attr_accessor :name, :email, :id
  
  # Creates a new contact object
  # @param name [String] The contact's name
  # @param email [String] The contact's email address
  def initialize(id, name, email)

    @id = id
    @name = name
    @email= email
    
    
  end

  def to_s
    "#{@id}: #{@name}, #{@email}"
  end

  # Provides functionality for managing contacts in the csv file.
  class << self

    # Opens 'contacts.csv' and creates a Contact object for each line in the file (aka each contact).
    # @return [Array<Contact>] Array of Contact objects
    def all
      contacts = []
      CSV.foreach("contactList.csv") do |row|
        contacts << Contact.new(row[0], row[1], row[2])
      end
      contacts
    end

    # Creates a new contact, adding it to the csv file, returning the new contact.
    # @param name [String] the new contact's name
    # @param email [String] the contact's email
    def create(name, email)
      id = CSV.read("contactList.csv").last[0].to_i + 1
      CSV.open("contactList.csv", "a") do |csv|
        csv << [id, name, email]
      end
      Contact.new(id, name, email)


      # @contact_collection.push(contact_insert)
      # TODO: Instantiate a Contact, add its data to the 'contacts.csv' file, and return it.
    end
    
    # Find the Contact in the 'contacts.csv' file with the matching id.
    # @param id [Integer] the contact id
    # @return [Contact, nil] the contact with the specified id. If no contact has the id, returns nil.
    def find(iden)
      all.each do |contact|
        if iden.to_i == contact.id.to_i
          return contact
        end
      end
        nil
      # TODO: Find the Contact in the 'contacts.csv' file with the matching id.
    end
    
    # Search for contacts by either name or email.
    # @param term [String] the name fragment or email fragment to search for
    # @return [Array<Contact>] Array of Contact objects.
    def search(term)
      all.each do |contact|
        if (term.to_s == contact.name.to_s) || (term.to_s == contact.email.to_s)
          return contact
        end
      end
        nil
      # TODO: Select the Contact instances from the 'contacts.csv' file whose name or email attributes contain the search term.
    end

  end

end
