# Bcoin Bitcoin Node Docker Image

<b style="color: #1383de">docker</b>&nbsp;+&nbsp;<b style="color: #FF9900">₿</b><b>itcoin</b>

This docker image builds and runs the bcoin Bitcoin node.

## Usage

Example command for starting a full node:

    docker run -d --restart unless-stopped -v "bitcoin":/home/bcoin/ --name bcoin aphex3k/bcoin:latest

Example command for starting a light _simple payment verification_ node:

    docker run -d --restart unless-stopped -v "bitcoin-spv":/home/bcoin/ --name bcoin-spv aphex3k/bcoin:latest --spv

## Configuration

Please see the [official bcoin repository](https://github.com/bcoin-org/bcoin/blob/master/docs/configuration.md) for how to configure your node fully.
