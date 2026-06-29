defmodule VintageNetSocketCANTest do
  use ExUnit.Case

  alias VintageNet.Interface.RawConfig

  defp socket_can_opts(raw_config) do
    {:run, "ip", ["link", "set", "can0", "type", "can" | rest]} =
      Enum.find(raw_config.up_cmds, fn
        {:run, "ip", ["link", "set", "can0", "type", "can" | _]} -> true
        _ -> false
      end)

    rest
    |> Enum.chunk_every(2)
    |> Map.new(fn [k, v] -> {k, v} end)
  end

  describe "normalize/1" do
    test "applies defaults for omitted options" do
      %{vintage_net_socket_can: normalized} =
        VintageNetSocketCAN.normalize(%{
          type: VintageNetSocketCAN,
          vintage_net_socket_can: %{bitrate: 250_000}
        })

      assert normalized.bitrate == 250_000
      assert normalized.sample_point == 0.825
      assert normalized.loopback == false
      assert normalized.listen_only == false
      assert normalized.restart_ms == 0
    end

    test "keeps an explicit restart_ms" do
      %{vintage_net_socket_can: normalized} =
        VintageNetSocketCAN.normalize(%{
          type: VintageNetSocketCAN,
          vintage_net_socket_can: %{bitrate: 250_000, restart_ms: 100}
        })

      assert normalized.restart_ms == 100
    end

    test "raises when restart_ms is not an integer" do
      assert_raise ArgumentError, fn ->
        VintageNetSocketCAN.normalize(%{
          type: VintageNetSocketCAN,
          vintage_net_socket_can: %{bitrate: 250_000, restart_ms: 1.5}
        })
      end
    end
  end

  describe "to_raw_config/3" do
    @describetag :requires_ip

    test "includes restart-ms in the up command" do
      config =
        VintageNetSocketCAN.normalize(%{
          type: VintageNetSocketCAN,
          vintage_net_socket_can: %{bitrate: 250_000, restart_ms: 100}
        })

      raw_config = VintageNetSocketCAN.to_raw_config("can0", config, [])

      assert %RawConfig{} = raw_config
      assert socket_can_opts(raw_config)["restart-ms"] == "100"
    end

    test "defaults restart-ms to 0 (auto-recovery disabled)" do
      config =
        VintageNetSocketCAN.normalize(%{
          type: VintageNetSocketCAN,
          vintage_net_socket_can: %{bitrate: 250_000}
        })

      raw_config = VintageNetSocketCAN.to_raw_config("can0", config, [])

      assert socket_can_opts(raw_config)["restart-ms"] == "0"
    end
  end
end
