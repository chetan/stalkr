
# http://trkcnfrm1.smi.usps.com/PTSInternetWeb/InterLabelInquiry.do?origTrackNum=9102901001312014825845

module Stalkr

class USPS < Base

    def track(id)

        url = "http://trkcnfrm1.smi.usps.com/PTSInternetWeb/InterLabelInquiry.do?origTrackNum=%CODE%"

        url.gsub!(/%CODE%/, id)
        html = fetchurl(url)

        info_scraper = Scraper.define do

            process "td.mainText", :info => :text

            result :info

        end

        info = info_scraper.scrape(html)

        obj = OpenStruct.new(:shipper => 'USPS')
        if info =~ /There is no record of this item/ then
            obj.status = 'There is no record of this item'
        end

        return obj

    end

end # class USPS
end # module Stalkr
