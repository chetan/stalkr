
module Stalkr

class Error < ::Exception

    attr_accessor :html

    def initialize(ex, html)
        super(ex.message)
        self.set_backtrace(ex.backtrace)
        self.html = html
    end

end

end
