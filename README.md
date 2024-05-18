# Sui Tales Marketplace

Marketplace for trading tales using the Kiosk framework

## Publish the package to the Sui testnet
```bash
sui client publish --gas-budget 100000000
```

## Usage

```bash
# mint a tale
sui client call --function mint_tale --module tale --package $PACKAGE_ID --args $AUTHOR $TITLE $CATEGORY $STORY --gas-budget 10000000

# create tales marketplace "kiosk"
sui client call --function create_tale_marketplace --module talesmarket --package $PACKAGE_ID --gas-budget 10000000

# place a tale
sui client call --function place_tale --module talesmarket --package $PACKAGE_ID --args $KIOSK_ID $KIOSKOWNERCAP_ID $TALE_ID --type-args $TYPE_ARGS --gas-budget 10000000

# list a tale
sui client call --function list_tale --module talesmarket --package $PACKAGE_ID --args $KIOSK_ID $KIOSKOWNERCAP_ID $TALE_ID $PRICE --type-args $TYPE_ARGS --gas-budget 10000000

# buy a tale 
sui client call --function purchase_tale --module talesmarket --package $PACKAGE_ID --args $KIOSK_ID $KIOSKOWNERCAP_ID $TALE_ID $PAYMENT_ID --type-args $TYPE_ARGS --gas-budget 10000000
```

## Contributing

Pull requests are welcome. For major changes, please open an issue first
to discuss what you would like to change.
