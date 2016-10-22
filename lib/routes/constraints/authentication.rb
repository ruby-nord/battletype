module Routes
  module Constraints
    class Authentication
      def matches?(name, password)
        name == ENV.fetch('ADMIN_USERNAME') && password == ENV.fetch('ADMIN_PASSWORD')
      end
    end
  end
end
