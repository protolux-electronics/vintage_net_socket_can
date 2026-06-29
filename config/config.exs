import Config

# When running the test suite on a host, VintageNet starts as an OTP
# application and would otherwise try to write to system paths like
# /etc/resolv.conf. Redirect its filesystem writes to a temp directory and
# disable persistence so unit tests stay hermetic.
if config_env() == :test do
  tmp_dir = Path.join(System.tmp_dir!(), "vintage_net_socket_can_test")

  config :vintage_net,
    resolvconf: Path.join(tmp_dir, "resolv.conf"),
    persistence: VintageNet.Persistence.Null,
    persistence_dir: Path.join(tmp_dir, "persistence")
end
