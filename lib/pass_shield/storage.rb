require 'json'
require 'fileutils'
require 'pass_shield/encryption'

module PassShield
  module Storage
    # Path to the storage file
    STORAGE_PATH = File.expand_path("~/.pass_shield/passwords.enc")
    SALT_PATH = "#{STORAGE_PATH}.salt"  # Separate salt file

    # Ensure the storage directory exists
    def self.ensure_storage_directory
      FileUtils.mkdir_p(File.dirname(STORAGE_PATH))
    end

    # Call this method when starting the application to ensure the directory exists
    def self.initialize_storage
      ensure_storage_directory
    end

    # Add a password for a specific service
    # @param service [String] the name of the service for which the password is being added
    # @param username [String] the username associated with the service
    # @param password [String] the password to be stored
    # @param master_password [String] the master password used for encryption
    def self.add_password(service, username, password, master_password)
      data = load_data(master_password)
      salt = data[:salt] || Encryption.generate_salt

      puts "Data before saving: #{data.inspect}"

      encrypted_password = Encryption.encrypt(password, master_password, salt)

      data[:passwords] ||= {}
      data[:passwords][service] = { username: username, password: encrypted_password }
      data[:salt] = salt

      save_data(data, master_password, salt)
      puts "Password for #{service} added successfully!"
    end    

    # Retrieve the password for a specific service
    # @param service [String] the name of the service for which the password is being retrieved
    # @param master_password [String] the master password used for decryption
    def self.get_password(service, master_password)
      data = load_data(master_password)
      salt = data[:salt]

      unless salt
        puts "No passwords found."
        return
      end

      puts "Data when retrieving: #{data.inspect}"

      if data[:passwords] && data[:passwords][service.to_sym]
        encrypted_password = data[:passwords][service.to_sym][:password]
        username = data[:passwords][service.to_sym][:username]

        puts "Encrypted password for #{service}: #{encrypted_password}"

        begin
          password = Encryption.decrypt(encrypted_password, master_password, salt)
          puts "Decrypted password: #{password}"
        rescue OpenSSL::Cipher::CipherError
          puts "❌ Error: Decryption failed. Wrong master password or corrupted data."
          return
        end

        puts "Username: #{username}, Password: #{password}"
      else
        puts "No password found for #{service}."
      end
    end          

    private

    # Load existing passwords and salt from storage
    # @param master_password [String] the master password used for decryption
    # @return [Hash] the loaded passwords and salt
    def self.load_data(master_password)
      unless File.exist?(STORAGE_PATH)
        return { passwords: {}, salt: nil }
      end

      encrypted_data = File.read(STORAGE_PATH)
      salt = File.exist?(SALT_PATH) ? File.read(SALT_PATH).strip : nil

      unless salt
        puts "Error: Salt file is missing or corrupted."
        return { passwords: {}, salt: nil }
      end

      begin
        decrypted_data = Encryption.decrypt(encrypted_data, master_password, salt)
        JSON.parse(decrypted_data, symbolize_names: true).merge({ salt: salt })
      rescue OpenSSL::Cipher::CipherError
        puts "Error: Incorrect master password or corrupted data."
        return { passwords: {}, salt: nil }
      end
    end

    # Save passwords and salt to storage
    # @param data [Hash] the data containing passwords and salt to be saved
    # @param master_password [String] the master password used for encryption
    # @param salt [String] the salt used for hashing the master password
    def self.save_data(data, master_password, salt)
      encrypted_data = Encryption.encrypt(data.to_json, master_password, salt)
      File.write(STORAGE_PATH, encrypted_data)
      File.write(SALT_PATH, salt)  

      puts "Data saved successfully!"
    end

    # Remove a password for a specific service
    # @param service [String] the name of the service for which the password is being removed
    # @param master_password [String] the master password used for decryption
    def self.remove_password(service, master_password)
      data = load_data(master_password)

      unless data[:passwords] && data[:passwords][service.to_sym]
        puts "No password found for #{service}."
        return
      end

      data[:passwords].delete(service.to_sym)

      save_data(data, master_password, data[:salt])
      puts "Password for #{service} has been removed successfully!"
    end    
  end
end
