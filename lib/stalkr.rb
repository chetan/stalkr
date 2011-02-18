
if RUBY_PLATFORM =~ /darwin/ then
    # fix for scrapi on Mac OS X
    require "tidy"
    Tidy.path = "/usr/lib/libtidy.dylib"
end

require 'scrapi'
require 'htmlentities'
require 'date'


stalkr_dir = File.dirname(__FILE__)
require "#{stalkr_dir}/stalkr/base"
require "#{stalkr_dir}/stalkr/result"
require "#{stalkr_dir}/stalkr/error"

require "#{stalkr_dir}/stalkr/ups"
require "#{stalkr_dir}/stalkr/usps"
require "#{stalkr_dir}/stalkr/fedex"
require "#{stalkr_dir}/stalkr/china_post"

if not DateTime.new.public_methods.include? "to_time" then
    # monkey patch DateTime to add to_time (exists in Ruby 1.9.2 and above)
    class DateTime
        def to_time
          d = new_offset(0)
          t = d.instance_eval do
            Time.utc(year, mon, mday, hour, min, sec +
                     sec_fraction)
          end
          t.getlocal
        end
    end
end

module Stalkr

    def self.shippers
        return [ Stalkr::UPS, Stalkr::USPS, Stalkr::FEDEX ]
    end

    def self.track(id)
        shipper = nil
        if id =~ /\d{22}/ then
            shipper = Stalkr::USPS
        elsif id =~ /^1Z/ then
            shipper = Stalkr::UPS
        elsif id =~ /\d{20}/ or id =~ /\d{15}/ then
            shipper = Stalkr::FEDEX
        end
        raise 'Unknown shipper code' if shipper.nil?
        return shipper.new.track(id)
    end

end # module Stalkr
