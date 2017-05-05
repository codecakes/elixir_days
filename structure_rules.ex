defprotocol Valid do
  def isvalid?(data)
end

defmodule Plane do
    defstruct name: :nil, gravity: 0, diameter: 0, distance: 0
end

defimpl Valid, for: Plane do
    def isvalid?(data) do
        is_binary data.name || is_atom data.name && is_number data.gravity && is_number data.gravity && is_number data.diameter && is_number data.distance         
    end
end