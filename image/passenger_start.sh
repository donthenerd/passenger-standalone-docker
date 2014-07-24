#!/bin/bash
echo "Starting Passenger"
cd /app
echo "Gone to /app"
passenger start -p 80 --environment=production --user=app --min-instances 4 --max-pool-size 4 --no-friendly-error-pages --sticky-sessions
echo "Exitted Passenger"
