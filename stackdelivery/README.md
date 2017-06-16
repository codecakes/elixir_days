# Stackdelivery

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `stackdelivery` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:stackdelivery, "~> 0.1.0"}]
end
```

### Calling from an Umbrella App:

Call this app from other apps in an umbrella project like:

```elixir
defp deps do
[
  ...
  {:stackdelivery, in_umbrella: true},
  ...
]
end
```

### Description

The Stacks act as sources to a one or more sinks in numerous ways.

  The main operations these stacks can do are:
    - Transfer from Stack A to Stack B
    - Copy from Stack A to [Stack B, C, D, .... so on ]
    - Copy & Transfer, in which case the following concurrent operations happen:
      a. Copy from Stack A to [Stack B, C, D, .... so on ]
      b. Transfer from Stack A to only one of Stacks excluding the above stacks.
    
  Consider a Subscriber point A that has subscribed to a broadcast channel.
  When A receives the input, it can pass it down to further pipes, based on how 
  the user wants to consume this information. This way any information packet <#Package{}> can be piped like:

  >> A |> B |> {C, D, E} |> .. or
  >> {A, B, C} |> {D, E, F}

  So, if there are companies like:

                                 A
                               /   \
                              B     C
                            /  \   / \
                           D   E   F  G
  
  Then A could subscribe to updates from {D, E, F, G} AND
  B could subscribe to updates from {D, E} AND
  D could subscribe to updates from {A, B} and even {A, B, E}.
  It really depends upon the constraint on how <#Package{}> is 
  consumed.

  Infact one could implement something a well defined struct like:
  
  ```elixir
  defmodule Package do
    defstruct %{txnID: txnID, dt dt, packetname: packetname}
  end
  ```

  and implement a protocol like:
  
  ```elixir
  defimpl Stackdelivery, for: Package do
    ..
  end
  ```

