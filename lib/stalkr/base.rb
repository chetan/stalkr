
module Stalkr

    class Base

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
            str.gsub!(/&nbsp;/, '')
            str = strip_tags(str)
            str.strip!
            str.squeeze!(" \n\r")
            return str
        end

    end # class Base

end # module Stalkr
