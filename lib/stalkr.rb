
if RUBY_PLATFORM =~ /darwin/ then
    # fix for scrapi on Mac OS X
    require "tidy"
    Tidy.path = "/usr/lib/libtidy.dylib"
end

require 'scrapi'
require 'htmlentities'
require 'ostruct'

require 'stalkr/base'
require 'stalkr/ups'
require 'stalkr/usps'
require 'stalkr/fedex'

module Stalkr

    def self.track(id)
        if id =~ /\d{22}/ then
            return Stalkr::USPS.new.track(id)
        elsif id =~ /^1Z/ then
            return Stalkr::UPS.new.track(id)
        elsif id =~ /\d{20}/ or id =~ /\d{15}/ then
            return Stalkr::FEDEX.new.track(id)
        end
        raise 'Unknown shipper code'
    end

end # module Stalkr
