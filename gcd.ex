defmodule GCD do
  @moduledoc """
  The largest qoutient when remainder is 0
  """
  
  def gcd(num, 0), do: num
  
  def gcd(num, den) when is_integer(den), do: gcd(den, rem(num, den))
  
end