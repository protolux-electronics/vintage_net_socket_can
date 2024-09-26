defmodule VintageNetSocketCAN do
  @moduledoc """
  Support for SocketCAN interfaces
  """

  @behaviour VintageNet.Technology

  alias VintageNet.Interface.RawConfig

  @required_options [
    {:bitrate, :integer},
    {:sample_point, :float},
    {:loopback, :boolean},
    {:listen_only, :boolean}
  ]

  @impl VintageNet.Technology
  def normalize(%{type: __MODULE__} = config) do
    socket_can_config = Map.get(config, :vintage_net_socket_can)

    default =
      %{
        sample_point: 0.825,
        loopback: false,
        listen_only: false
      }

    normalized = Map.merge(default, socket_can_config)

    # check the options to ensure they are the right type and present
    for {key, type} <- @required_options do
      case({normalized[key], type}) do
        {value, :integer} when is_integer(value) -> :ok
        {value, :float} when is_float(value) -> :ok
        {value, :boolean} when is_boolean(value) -> :ok
        _ -> raise ArgumentError, "#{type} key :#{key} is required"
      end
    end

    %{type: __MODULE__, vintage_net_socket_can: normalized}
  end

  @impl VintageNet.Technology
  def to_raw_config(ifname, %{type: __MODULE__} = config, _opts) do
    normalized_config = Map.get(config, :vintage_net_socket_can, %{})

    %RawConfig{
      ifname: ifname,
      type: __MODULE__,
      source_config: config,
      required_ifnames: [],
      child_specs: [{VintageNet.Connectivity.LANChecker, ifname}],
      up_cmds: up_cmds(ifname, normalized_config),
      up_cmd_millis: 5_000,
      down_cmds: [
        {:run_ignore_errors, "ip", ["addr", "flush", "dev", ifname, "label", ifname]},
        {:run, "ip", ["link", "set", ifname, "down"]}
      ]
    }
  end

  defp up_cmds(ifname, config) do
    [
      maybe_add_interface(ifname),
      {:run, "ip",
       [
         "link",
         "set",
         ifname,
         "type",
         "can",
         "bitrate",
         Integer.to_string(config[:bitrate]),
         "sample-point",
         Float.to_string(config[:sample_point]),
         "loopback",
         if(config[:loopback], do: "on", else: "off"),
         "listen-only",
         if(config[:listen_only], do: "on", else: "off")
       ]},
      {:run, "ip", ["link", "set", ifname, "up"]}
    ]
  end

  defp maybe_add_interface(ifname) do
    case System.cmd("ip", ["link", "show", ifname]) do
      {_, 0} -> []
      _ -> {:run_ignore_errors, "ip", ["link", "add", ifname, "type", "can"]}
    end
  end
end
