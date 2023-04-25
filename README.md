# Deno Runscript

> Run user provided scripts safely using deno

This is a simple bash script executing all Javascript and Typescript files in `.scripts` folders of a root folder hierarchy.

Useful for liteweight static websites that doen't need heavy server side intelligence.
Just execute `run-scripts.sh` on your root folder from cron or manually.

This script only gives permission to read or write parent folder of the script and `deno.land` and `esm.sh` network access.