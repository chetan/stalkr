
if not DateTime.new.public_methods.include? "to_time" then
    # monkey patch DateTime to add to_time (exists in Ruby 1.9.2 and above)
    class DateTime
        def to_time
          d = new_offset(0)
          t = d.instance_eval do
            Time.utc(year, mon, mday, hour, min, sec +
                     sec_fraction)
          end
          t.getlocal
        end
    end
end
