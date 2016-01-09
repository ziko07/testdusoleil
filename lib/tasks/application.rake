
namespace :geocode do
  desc "Load geocode csv files"
  task :load => :environment do
    # load csv files
    puts "loading blocks..."
    GeocodeBlock.load_csv
    puts "loading locations..."
    GeocodeLocation.load_csv
    puts "loading metro_codes..."
    GeocodeMetroCode.load_csv
  end
end

