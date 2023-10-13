#!/bin/bash
# use testnet settings,  if you need mainnet,  use ~/.fuertecoin/fuertecoind.pid file instead
fuertecoin_pid=$(<~/.fuertecoin/testnet3/fuertecoind.pid)
sudo gdb -batch -ex "source debug.gdb" fuertecoind ${fuertecoin_pid}
