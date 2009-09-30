require "blather/client/dsl"

module Jah
  PUBSUB = {:pubs => [], :subs => []}

  class Pub
    include Command

   # register  :create, 'create\spubsub.*'
  #  register  :publish, 'pub:'


    def self.create(_, node)
    #  pubsub = Blather::DSL::PubSub.new()
      request(Blather::Stanza::PubSub::Create.new(:set,
        "Jah.host.com", node)) { |n| yield n if block_given? }


    end

    def self.all
      "Owner => #{PUBSUB[:pubs].join(", ")}"
    end


    def self.publish(name, body)
      Blather::Stanza::PubSub::Publish.new("pubsub.fireho.com", name, :set, body)
    end


    def self.destroy
    end









  end
end
