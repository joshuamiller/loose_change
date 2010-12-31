namespace :loose_change do
  namespace :views do
    desc "Push custom views to server. Define an 'environment' task to load your model classes if you aren't using Rails"
    task :push, :view_dir, :needs => :environment do |t, args|
      view_dir = args['view_dir'] || File.join(Rails.root, 'db', 'couch', 'views')
      Dir.glob(File.join(view_dir, '*')).each do |model_dir|
        model = Kernel.const_get(model_dir.split(view_dir + '/').last)
        if defined?(model)
          Dir.glob(File.join(model_dir, '*')).each do |model_view_dir|
            view_name = model_view_dir.split(model_dir + '/').last

            ## Reduce
            if File.exists?(File.join(model_view_dir, 'reduce.coffee')) && defined?(CoffeeScript)
              reduce = CoffeeScript.compile(File.read(File.join(model_view_dir, 'reduce.coffee')), :no_wrap => true)
            elsif File.exists?(File.join(model_view_dir, 'reduce.js'))
              reduce = File.read(File.join(model_view_dir, 'reduce.js'))
            end
            
            ## Map
            if File.exists?(File.join(model_view_dir, 'map.coffee')) && defined?(CoffeeScript)
              map = CoffeeScript.compile(File.read(File.join(model_view_dir, 'map.coffee')), :no_wrap => true)
              model.add_view(view_name, map, reduce)
            elsif File.exists?(File.join(model_view_dir, 'map.js'))
              map = File.read(File.join(model_view_dir, 'map.js'))
              model.add_view(view_name, map, reduce)
            end
            
          end
        end
      end
    end
  end
end


