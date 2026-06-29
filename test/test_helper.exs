# `to_raw_config/3` shells out to `ip` while building the config, so the tests
# that exercise it can only run where `ip` is on the PATH (Linux/CI/target).
exclude = if System.find_executable("ip"), do: [], else: [requires_ip: true]
ExUnit.start(exclude: exclude)
