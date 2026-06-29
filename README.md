# VintageNetSocketCan

**TODO: Add description**

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `vintage_net_socket_can` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:vintage_net_socket_can, "~> 0.1.0"}
  ]
end
```

## Configuration

Configure a SocketCAN interface through VintageNet:

```elixir
config :vintage_net,
  config: [
    {"can0",
     %{
       type: VintageNetSocketCAN,
       vintage_net_socket_can: %{
         bitrate: 250_000,
         restart_ms: 100
       }
     }}
  ]
```

### Options

- `:bitrate` (integer, required) - CAN bus bitrate in bits/sec (e.g. `250_000`
  for NMEA 2000).
- `:sample_point` (float, default `0.825`) - bit sample point.
- `:loopback` (boolean, default `false`) - enable local loopback.
- `:listen_only` (boolean, default `false`) - passive mode; the controller
  receives frames but never transmits or acknowledges. Useful for diagnostics.
- `:restart_ms` (integer, default `0`) - automatic bus-off recovery delay in
  milliseconds. `0` (the kernel default) disables auto-recovery, so once the
  controller goes bus-off it stays off until the interface is cycled. Set a
  positive value (e.g. `100`) so the controller automatically rejoins the bus
  after a bus-off condition.

## Documentation

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/vintage_net_socket_can>.

