module Jah

  class Admin
    include Command

    register(:get_roster, "roster$")
    register(:drop_user, "drop\s")
    #Jah::Command.register(:create_group, "")

    class << self


      def get_roster
        out = ""
        client.roster.grouped.each do |group, items|
          out << "#{'*'*3} #{group || 'Ungrouped'} #{'*'*3}\n"
          items.each { |item| out << "- #{item.name} (#{item.jid})\n" }
          out << "\n"
        end
        out
      end

      def drop_user(user)
        puts "DROP..."
      end

      def join_group()
      end




      def create_group(name)

      end

    end

  end
end
