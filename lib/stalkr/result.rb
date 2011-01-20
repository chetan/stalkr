
module Stalkr

    UNKNOWN = 0
    DELIVERED = 1
    IN_TRANSIT = 2

    class Result

        attr_accessor :shipper, :status, :updated_at, :delivered_at

        def initialize(shipper)
            @shipper = shipper
        end

    end # class Result

end # module Stalkr
