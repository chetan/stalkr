
module Stalkr

    class Base

        class << self
            attr_accessor :regex
        end

        def fetchurl(url, data = nil)
            url = URI.parse(URI.escape(url))
            if data.nil? then
                # GET request
                return Net::HTTP.get_response(url).body
            else
                return Net::HTTP.post_form(url, data).body
            end
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
                m = $~.to_a
                m.shift
                return m.find{ |s| not s.nil? }.gsub(/ /, '').upcase
            end
            return nil
        end

    end # class Base

end # module Stalkr
