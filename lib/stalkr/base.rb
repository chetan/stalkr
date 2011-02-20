
module Stalkr

    @@shippers = []

    def self.shippers
        return @@shippers
    end

    def self.detect_shipper(text)
        Stalkr.shippers.each do |s|
            id = s.extract_id(text)
            return [id, s] if id
        end
        return nil
    end

    class Base

        class << self
            attr_accessor :regex
        end

        def fetchurl(url, data = nil)
            if data.nil? then
                # GET
                return Curl::Easy.perform(url).body_str
            else
                # POST
                return Curl::Easy.http_post(url, data.map{ |k,v| Curl::PostField.content(k, v) }).body_str
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
            r = regex()
            if r.kind_of? Regexp then
                r = [ r ]
            end
            r.each do |re|
                if str =~ re then
                    # return the first non-nil backreference
                    m = $~.to_a
                    m.shift
                    return m.find{ |s| not s.nil? }.gsub(/ /, '').upcase
                end
            end
            return nil
        end

    end # class Base

end # module Stalkr
