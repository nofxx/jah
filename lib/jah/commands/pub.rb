require "blather/client/dsl"

module Jah

  class Pub
    include Command

    register  :create, 'create\spubsub.*'


    def self.create(_, node)
    #  pubsub = Blather::DSL::PubSub.new()
      request(Blather::Stanza::PubSub::Create.new(:set,
        "Jah.host.com", node)) { |n| yield n if block_given? }


    end

    def self.all


    end










  end
end
