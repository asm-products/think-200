module Think200

  def self.aggregate_test_status(collection:)
  end

  module HttpStatus

    # Return the status string for the
    # given status code
    def self.title(code:)
      Rack::Utils::HTTP_STATUS_CODES[code]
    end

    def self.summary(code:)
      'Aut viam inveniam aut faciam'
    end

    def self.descriptions(code:)
      {
        wikipedia: {
          body: "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
          link: '#'
        },
        ietf: {
          body: "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
          link: '#'
        },
      }
    end
  end
end
