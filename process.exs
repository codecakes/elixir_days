"""
This file shows different ways of using spawn function and Task module to create some asynchronously tasks thus working in a nonblocking manner
"""

defmodule NonBlocking do
	@moduledoc """
	A simple non-blocking process.
	The blocking part is timer sleep which becomes non-blocking 
	in as it is spawned.
	
	"""	
	def recv(task) do
		case Task.await(task) do
			{fun, msg, sender_pid} ->
				spawn(fn ->
					IO.puts "sender pid"
					IO.inspect sender_pid
					:timer.sleep(10000)
					Task.async(fn -> send(sender_pid, fun.(msg)) end) |> recv
				end)
			result -> IO.puts "result: #{result}"
			_ -> IO.puts "Didnt find a matching message!"
		end
	end
	
	def send_state(parent_pid, fun, msg) do
		task = Task.async( fn -> send(parent_pid, {fun, msg, self()}) end )
		recv(task)
	end
	
end

defmodule Generate do
	@moduledoc """
	This module has two functions:
	gen: passes an array to the divide method of DividenConquer module
	gen_async: resolves an asynchronous function and returns the result, using Task module
	
	"""
	
	def gen_async(num, pid \\ self ) do
		case Task.async(fn -> send(pid, :math.pow(num, 2) ) end) |> Task.await do
			res -> IO.inspect res
			_ -> IO.puts "Hmmm. not going to matched output"
		end
	end
	
	def gen(arr) do
		parent = self
		DividenConquer.divide(arr, parent)
	end
	
end

defmodule DividenConquer do
	@moduledoc """
	the divide module that slices an array in O(lgN) time.
	Once the array is broken down to single numbers, it is passed off to the gen_async function of Generate module.
	"""
	def divide(arr, pid) when length(arr) == 1 do
		Enum.fetch!(arr, 0) |> Generate.gen_async(pid)
	end 
	
	def divide(arr, pid) when length(arr) > 1 do
		len = arr |> length
		mid = div(len,2)
		Enum.slice(arr, 0, mid) |> divide(pid)
		Enum.slice(arr, mid, len) |> divide(pid)
	end

end
