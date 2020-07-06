#!/bin/sh

netlabelctl map del default
netlabelctl cipsov4 del doi:87654321
netlabelctl map add default protocol:unlbl
