#!/bin/bash

# Dynamically determine onion address to serve monerod on tor network

while [ ! -f /var/lib/tor/monerod/hostname ]; do
    echo -e "[+] Waiting for onion address to be generated"
    sleep 1
done

export ONION_ADDRESS=$(cat /var/lib/tor/monerod/hostname)

echo "=========================================="
echo "Your Monero RPC Onion address is: ${ONION_ADDRESS}"
echo "=========================================="

sleep 3

monerod \
    --data-dir=/data \
    --p2p-bind-ip=0.0.0.0 \
    --p2p-bind-port=18080 \
    --zmq-rpc-bind-ip=0.0.0.0 \
    --zmq-rpc-bind-port=18082 \
    --zmq-pub=tcp://0.0.0.0:18085 \
    --rpc-bind-ip=0.0.0.0 \
    --rpc-bind-port=18083 \
    --rpc-restricted-bind-ip=0.0.0.0 \
    --rpc-restricted-bind-port=18081 \
    --non-interactive \
    --confirm-external-bind \
    --public-node \
    --log-level=0 \
    --max-log-file-size=1048576 \
    --max-log-files=3 \
    --no-igd \
    --rpc-ssl=disabled \
    --ban-list=/ban_list.txt \
    --anonymous-inbound=${ONION_ADDRESS}:18081,127.0.0.1:18089,24 \
    --tx-proxy=tor,172.31.255.250:9050,disable_noise,24 \
    --tx-proxy=i2p,172.31.255.251:4447,disable_noise,24 \
    --check-updates=disabled \
    --enable-dns-blocklist \
    --out-peers=32 \
    --in-peers=48 \
    --limit-rate-up=1048576 \
    --limit-rate-down=1048576 \
    --allow-local-ip \
    --db-sync-mode=fast:async:250000000bytes \
    --max-txpool-weight=2684354560 \
    --fast-block-sync=1
