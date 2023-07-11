# ERC20

## Test

```bash
scarb test
```

## Build

```bash
scarb build
```

## Declare

```bash
starkli declare ./target/dev/erc20_ERC20.sierra.json
```

## Deploy

```bash
starkli deploy <class_hash> <name> <symbol> <total_supply.low> < total_supply.high> <recipient>
```
