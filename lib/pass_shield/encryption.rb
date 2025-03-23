require 'openssl'
require 'base64'
require 'bcrypt'
require 'digest'

module PassShield
  module Encryption
    # Generate a secure key from a master password and salt
    # @param master_password [String] the master password used for encryption
    # @param salt [String] the salt used for hashing the master password
    # @return [String] a SHA-256 key derived from the hashed master password
    def self.generate_key(master_password, salt)
      hashed = BCrypt::Engine.hash_secret(master_password, salt)
      Digest::SHA256.digest(hashed)
    end

    # Encrypt plaintext using AES-256
    # @param plaintext [String] the data to be encrypted
    # @param master_password [String] the master password used for encryption
    # @param salt [String] the salt used for hashing the master password
    # @return [String] the Base64-encoded encrypted data with the IV prepended
    def self.encrypt(plaintext, master_password, salt)
      cipher = OpenSSL::Cipher.new('AES-256-CBC')
      cipher.encrypt
      cipher.key = generate_key(master_password, salt)
      iv = cipher.random_iv
      encrypted = cipher.update(plaintext) + cipher.final
      Base64.strict_encode64(iv + encrypted)
    end

    # Decrypt ciphertext using AES-256
    # @param ciphertext [String] the Base64-encoded encrypted data to be decrypted
    # @param master_password [String] the master password used for encryption
    # @param salt [String] the salt used for hashing the master password
    # @return [String] the decrypted plaintext data
    def self.decrypt(ciphertext, master_password, salt)
      decoded = Base64.strict_decode64(ciphertext)
      cipher = OpenSSL::Cipher.new('AES-256-CBC')
      cipher.decrypt
      cipher.key = generate_key(master_password, salt)
      cipher.iv = decoded.slice!(0, 16) # Extract the IV
      cipher.update(decoded) + cipher.final
    end
  end
end
