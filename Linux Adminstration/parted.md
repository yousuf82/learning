# partition disk using parted command
``` parted /dev/sdb```

```mklabel gpt ```

``` unit GB ```

``` mkpart primary 0GB 5909GB```

