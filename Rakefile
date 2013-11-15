require 'rake/testtask'
require 'sinatra'
require './config/init.rb'
require 'timeout'
require 'yaml'

# Timeout constant
# If the main rake task for importing takes more
# then a certain time limit, to prevent data corruption
# the methods are skipped.
#
# For instance, if stats are imported every minute, then
# it best to stop the transaction if its taking more than
# 50s to complete or else things will get out of control.
TIMEOUT_IN_SECONDS = 50

Rake::TestTask.new do |t|
  t.pattern = "test/*_test.rb"
end

namespace :import do
  namespace :stats do
    
    task :all do
      desc "Import station stats from Citi Bike API"
    
      begin
        main_timer_start = Time.now
        cities = YAML.load_file('cities.yml')
        adapter = Api::V1::BikeDept.new

        cities.each_key do |city|
          timer_start = Time.now
          adapter.import_station_stats("#{city.capitalize}Stat", city)
          timer_end = Time.now
          puts "#{Api::V1::BikeDept::LOG_TIMESTAMP} Completed stats import for #{city.capitalize} #{(timer_end-timer_start).round(2)}s."
        end
        
        main_timer_end = Time.now
        puts "#{Api::V1::BikeDept::LOG_TIMESTAMP} Completed all stats import in #{(main_timer_end-main_timer_start).round(2)}s."
        puts "-"*60
      rescue Timeout::Error
        puts "#{Api::V1::BikeDept::LOG_TIMESTAMP} Stat import took more than #{TIMEOUT_IN_SECONDS}s, skipping..."
      end
      
      begin
        main_timer_start = Time.now
        cities.each_key do |city|
          timer_start = Time.now
          stations = Object.const_get(:Api)
                      .const_get(:V1)
                      .const_get("#{city.capitalize}Station")
                      .all
          
          stations.each { |station| station.set_analytics(city) }
          timer_end = Time.now
          puts "#{Api::V1::BikeDept::LOG_TIMESTAMP} Compiled analytics for #{city.capitalize} #{(timer_end-timer_start).round(2)}s."
        end
        
        main_timer_end = Time.now
        puts "#{Api::V1::BikeDept::LOG_TIMESTAMP} Compiled all analytics in #{(main_timer_end-main_timer_start).round(2)}s."
        puts "-"*60
      rescue Timeout::Error
        puts "#{Api::V1::BikeDept::LOG_TIMESTAMP} Stat import took more than #{TIMEOUT_IN_SECONDS}s, skipping..."
      end
    end
  end # // stats

  namespace :stations do
    [:citi, :chi].each do |city|
      task city do
        desc "Import stations from #{city} Bike API"
        timer_start = Time.now
        adapter = Api::V1::BikeDept.new
        adapter.import_stations("#{city.capitalize}Station", city)
        timer_end = Time.now
        puts "#{Api::V1::BikeDept::LOG_TIMESTAMP} Completed #{city.capitalize} stations import in #{(timer_end-timer_start).round(2)}s"
      end
    end 
  end # // stations
end # // import

namespace :set do
  task :analytics do
    desc "Set trends and mins for each station"
    
    main_timer_start = Time.now
    
    cities = YAML.load_file('cities.yml')
    cities.each_key do |city|
      timer_start = Time.now
      stations = Object.const_get(:Api)
                  .const_get(:V1)
                  .const_get("#{city.capitalize}Station")
                  .all
      
      stations.each { |station| station.set_analytics(city) }
      timer_end = Time.now
      puts "#{Api::V1::BikeDept::LOG_TIMESTAMP} Compiled analytics for #{city.capitalize} #{(timer_end-timer_start).round(2)}s."
    end
    
    main_timer_end = Time.now
    puts "#{Api::V1::BikeDept::LOG_TIMESTAMP} Compiled all analytics in #{(main_timer_end-main_timer_start).round(2)}s."
  end
end
