#!/bin/bash
#-------------------------------------------
SIZE=26214400
#--------------------------------------------
sysctl -w net.core.rmem_max=$SIZE
sysctl -w net.core.wmem_max=$SIZE
sysctl -w net.core.rmem_default=$SIZE
sysctl -w net.core.wmem_default=$SIZE
