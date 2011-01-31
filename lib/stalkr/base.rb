
module Stalkr

    class Base

        class << self
            attr_accessor :regex
        end

        def fetchurl(url)
            return Net::HTTP.get_response(URI.parse(URI.escape(url))).body
        end

        def strip_tags(html)

            HTMLEntities.new.decode(
                html.gsub(/<.+?>/,'').
                gsub(/<br *\/>/m, '')
            )

        end

        def cleanup_html(str)
            str.gsub!(/&nbsp;/, ' ')
            str = strip_tags(str)
            str.strip!
            str.squeeze!(" \n\r")
            return str
        end

        def self.is_valid?(id)
            return (id =~ regex() ? true : false)
        end

        def self.extract_id(str)
            if str =~ regex() then
                # return the first non-nil backreference
                m = $~
                m.shift
                return m.find{ |s| not s.nil? }.gsub(/ /, '').upcase
            end
            return nil
        end

    end # class Base

end # module Stalkr
