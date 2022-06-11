#!/bin/bash

curl -s https://tfnsw.redbook.com.au/stock_locator/search/Tesla/Model+Y/Rear-Wheel+Drive/0/0/0/0/0/0/0/0/0/0/0/0/Year/1956-2022/1 -A "Mozilla/5.0 (compatible;  MSIE 7.01; Windows NT 5.0)" | sed -En 's/^.*<h5>2022 Tesla Model Y Rear-Wheel Drive Auto <span.*?>(.*)<\/span><\/h5>/\1/p'
