#!/bin/bash

curl -s https://www.health.nsw.gov.au/Infectious/covid-19/Pages/default.aspx | grep -oP '(?<=>).*?(?=<\/span> total new cases)'
