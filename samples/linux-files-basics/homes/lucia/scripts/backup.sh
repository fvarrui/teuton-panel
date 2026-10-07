#!/bin/bash
# Daily backup of my notes
tar czf ~/backup-$(date +%F).tar.gz ~/docs
