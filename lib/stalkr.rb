
if RUBY_PLATFORM =~ /darwin/ then
    # fix for scrapi on Mac OS X
    require "tidy"
    Tidy.path = "/usr/lib/libtidy.dylib"
end

require 'curb'
require 'scrapi'
require 'htmlentities'
require 'date'


stalkr_dir = File.dirname(__FILE__)
require "#{stalkr_dir}/stalkr/datetime_patch"
require "#{stalkr_dir}/stalkr/base"
require "#{stalkr_dir}/stalkr/result"
require "#{stalkr_dir}/stalkr/error"

require "#{stalkr_dir}/stalkr/ups"
require "#{stalkr_dir}/stalkr/usps"
require "#{stalkr_dir}/stalkr/fedex"
require "#{stalkr_dir}/stalkr/dhl"
require "#{stalkr_dir}/stalkr/china_post"
