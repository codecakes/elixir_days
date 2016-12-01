defmodule ParseVcf do
	@moduledoc """
	Parses .vcf file, like a Google contacts file from a phone,
	and outputs an array of HashMaps of individual contacts. The fields parsed right now are:
		- Full Name
		- First Name
		- List of Contact Numbers
	"""
	defp regex_begin, do: ~r/BEGIN/iu
	defp regex_end, do: ~r/END/iu
	defp regex_body, do: ~r/(\w+)\W+([a-zA-Z0-9\;\s?]+)/iu
	defp regex_email, do: ~r/(\w+)\W+([a-zA-Z0-9]+)\@(\w+)\.(\w{2,})/iu
	defp regex_number, do: ~r/^TEL\;?([a-zA-Z]+)?\:(.+)/iu
	defp regex_version, do: ~r/VERSION/iu
	defp regex_photo, do: ~r/^PHOTO;ENCODING=BASE64;JPEG:(.)+/miux

	def parse_vcf(path) do
		contacts = case File.open(path) do
			{:ok, file} -> parse_vcf(file, %{}, [])
			{:error, _} -> "File does not exist"
		end
		
		if is_list(contacts) do
			Enum.filter(contacts, fn(contact) -> Enum.all?([:name, :fname, :numbers], fn(key) -> Map.has_key?(contact, key) end) == true end)
		end
	end
	
	def parse_vcf(file, chunk \\ %{}, acc \\ []) do
		data = IO.read(file, :line)
		cond do
			data == :eof -> acc
			
			data =~ regex_version -> parse_vcf(file, chunk, acc)
			
			data =~ regex_begin -> 
				{:ok, match} = Enum.fetch(Regex.run(regex_begin, data), 0)
				# parse_vcf(file, Map.put(chunk, :begin, match), acc)
				parse_vcf(file, chunk, acc)
				
			data =~ regex_end ->
				{:ok, match} = Enum.fetch(Regex.run(regex_end, data), 0)
				# parse_vcf(file, %{}, acc ++ [Map.put(chunk, :end, match)])
				parse_vcf(file, %{}, acc ++ [chunk])
				
			data =~ regex_number ->
				{:ok, match} = Enum.fetch(Regex.run(regex_number, data), 2)
				chunk = case Map.has_key?(chunk, :numbers) do
					true  -> 
						numbers = Map.get(chunk, :numbers)
						Map.put(chunk, :numbers, numbers ++ [String.split(match,"-") |> Enum.join("")])
					false -> Map.put(chunk, :numbers, [String.split(match,"-") |> Enum.join("")])
				end
				parse_vcf(file, chunk, acc)
				
			data =~ regex_photo ->
				parse_vcf(file, chunk, acc)
			
			data =~ regex_body ->
				case Regex.run(regex_body, data) do
					[match, "N", name] ->
						name =  Map.put(chunk, :name, name |> String.split(~r{;|-}, trim: true) |> Enum.join(" ") |> String.trim)
						parse_vcf(file, name, acc)
					
					[match, "FN", fname] -> parse_vcf(file, Map.put(chunk, :fname, fname |> String.trim), acc)
					
					[match, "EMAIL", username, email, domain] -> parse_vcf(file, Map.put(chunk, :email, "#{username}@#{email}.#{domain}"), acc)
					
					_ -> parse_vcf(file, chunk, acc)
				end
			
			true -> parse_vcf(file, chunk, acc)
		end
	end
	
end
