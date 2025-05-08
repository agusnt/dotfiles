#!/bin/bash

echo "$(curl ipinfo.io/city 2>/dev/null), $(curl ipinfo.io/country 2>/dev/null)" >/tmp/location
