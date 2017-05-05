defmodule Drop do

    def calc({planet, vel}) when vel >= 0 do
        
        gravity = case planet do
            :earth -> 9.8
            :moon -> 1.6
            :mars -> 3.71
            _ -> :none
        end

        res = cond do
            is_number gravity -> :math.sqrt 2*gravity*vel
            not is_number gravity -> "Wrong planet"
        end
        IO.puts res
    end

    def calc({planet, vel}) do
        IO.puts "Wrong velocity. Enter positive value"
    end

end

Drop.calc {:earth, 20}
Drop.calc {:moon, 20}
Drop.calc {:pluto, 2000}
Drop.calc {:pluto, -2000}