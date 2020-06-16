namespace :roster do

  task :update => :environment do
    Raven.capture do
      Roster::Chapter.where.not(vc_username: nil).each do |chapter|
        next unless chapter.vc_username.present?
        begin
          sh("rake roster:update_positions CHAPTER_ID=#{chapter.id}")
        rescue => e
          Raven.capture_exception e
        end
      end
    end
  end

  task :update_positions => :environment do
    Raven.capture do
      chapter = Roster::Chapter.find ENV['CHAPTER_ID']
      Core::JobLog.capture("UpdatePositions", chapter) do |logger, log|
        Roster::VcQueryToolImporter.new(logger, log).import(chapter, [:positions, :qualifications, :usage])
      end
    end
  end

  task :geocode_users do
    Raven.capture do
      # NOTE: Squeel migration note:
      # When converting from Squeel, the original form of this clause
      # was `(address !- nil)`, which as far as I can tell is not valid syntax
      # in Squeel. My guess is it was a typo for `!=`, but I'm leaving the
      # original Squeel syntax in place so that it blows up if anyone tries to
      # use it, and hopefully they'll be in a better position to figure out
      # the original intent.
      raise("Incomplete Squeel migration")
      Roster::Person.where(vc_is_active: true)
        .where(lat: nil)
        .where{(address !- nil)}
        .find_each {|p| p.save; sleep 0.1 }
    end
  end

end