module MCollective
  module Agent
    class Helloworld < RPC::Agent
      action "echo" do
        validate :msg, String
        reply[:msg] = request[:msg]
      end
    end
  end
end
