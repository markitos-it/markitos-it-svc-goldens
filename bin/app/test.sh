#!/bin/bash
#:[.'.']:>- ===================================================================================
#:[.'.']:>- Marco Antonio - markitos devsecops kulture
#:[.'.']:>- The Way of the Artisan
#:[.'.']:>- markitos.es.info@gmail.com
#:[.'.']:>- 🌍 https://github.com/orgs/markitos-it/repositories
#:[.'.']:>- 🌍 https://github.com/orgs/markitos-public/repositories
#:[.'.']:>- 📺 https://www.youtube.com/@markitos_devsecops
#:[.'.']:>- ===================================================================================
source "$(dirname "$0")/test-setup.sh"

go test -cover -count=1 ./...
