defmodule NonBlocking do
	
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
