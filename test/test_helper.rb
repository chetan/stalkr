
require "rubygems"

if not ENV.include? "TM_MODE" then
    begin; require "turn"; rescue LoadError; end
end

require 'stringio'
require 'test/unit'
require File.dirname(__FILE__) + '/../lib/stalkr'
