#!/usr/bin/bash

finger celsius@escher.rhwyd.co.uk | \
    awk 'f{print} /Plan/{f=1}'

