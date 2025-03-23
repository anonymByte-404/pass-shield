module PassShield
  class CLI
    # Start the command-line interface
    # @param args [Array<String>] the command-line arguments passed to the script
    def self.start(args)
      command = args[0]        # The command to execute (e.g., "add", "get", "remove")
      service = args[1]        # The name of the service for which the password is being managed
      username = args[2]       # The username associated with the service (only used for "add" command)

      ARGV.clear

      print "Enter master password: "
      master_password = gets.chomp # The master password used for encrypting/decrypting passwords

      case command
      when "add"
        unless service && username
          puts "Usage: pass_shield add <service> <username>"
          return
        end
        print "Enter password: "
        password = gets.chomp # The password to be stored
        PassShield::Storage.add_password(service, username, password, master_password)

      when "get"
        unless service
          puts "Usage: pass_shield get <service>"
          return
        end
        PassShield::Storage.get_password(service, master_password)

      when "remove"
        unless service
          puts "Usage: pass_shield remove <service>"
          return
        end
        PassShield::Storage.remove_password(service, master_password)

      else
        puts "Usage: pass_shield <command> [arguments]"
        puts "Commands:"
        puts "  add <service> <username>    - Add a new password"
        puts "  get <service>               - Retrieve a password"
        puts "  remove <service>            - Remove a password"
      end
    end
  end
end
