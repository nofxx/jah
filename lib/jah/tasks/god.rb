  GROUPS = [:webapp, :db]
  # GOD
  #
  namespace :god do
    desc "Start all"
    task :start do
      GROUPS.each { |stack| send(stack, :start) }
    end
    desc "Stop all"
    task :stop do
      GROUPS.each { |stack| send(stack, :stop) }
    end
    desc "Restart all"
    task :stop do
      GROUPS.each { |stack| send(stack, :restart) }
    end
    desc "Check status"
    task :status do
      v = run "sudo god status"
      puts v
    end
    GROUPS.each do |stack|
      namespace stack do
        #desc "Start #{stack} stack"
        task :start, :roles => :app do
          run "sudo god start #{stack}"
        end
        #desc "Stop #{stack} stack"
        task :stop, :roles => :app do
          run "sudo god stop #{stack}"
        end
        #desc "Restart #{stack} stack"
        task :restart, :roles => :app do
          run "sudo god restart #{stack}"
        end
      end
    end
  end
