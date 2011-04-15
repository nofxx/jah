  GROUPS = [:webapp, :db]
  # BLUEPILL
  #
  namespace :bluepill do
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
      v = run "sudo bluepill status"
      puts v
    end
    GROUPS.each do |stack|
      namespace stack do
        #desc "Start #{stack} stack"
        task :start, :roles => :app do
          run "sudo bluepill start #{stack}"
        end
        #desc "Stop #{stack} stack"
        task :stop, :roles => :app do
          run "sudo bluepill stop #{stack}"
        end
        #desc "Restart #{stack} stack"
        task :restart, :roles => :app do
          run "sudo bluepill restart #{stack}"
        end
      end
    end
  end
