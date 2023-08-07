#!/bin/bash
sui client publish --force --with-unpublished-dependencies  --gas-budget 200000000

##ENV_ADDR also the publisher
export ENV_ADDR=0x0dd0106a909560b8f2e0262e9946008e307ae7758fde5277853088d25b0b6c7f
export PACKAGE=0x14d0f46543a852bf651da621c497366bd10d2f8b34dcc6b7fcee6c97f8a37eea
export UPGRADE_CAP=0xb24342c5541ee723a6d8c885b2b2c813eb29169677186da2a68924f7672f2aa6
