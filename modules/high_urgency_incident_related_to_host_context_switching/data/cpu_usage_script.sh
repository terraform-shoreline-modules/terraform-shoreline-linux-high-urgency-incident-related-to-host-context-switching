bash

#!/bin/bash



# Check CPU usage

CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4}')

THRESHOLD=80



if (( $(echo "${CPU_USAGE} > ${THRESHOLD}" | bc -l) )); then

  echo "CPU usage is high. Current usage is ${CPU_USAGE}%"

  echo "Checking context switching rates..."

  

  # Check context switching rates

  CONTEXT_SWITCHES=$(vmstat 1 2 | tail -1 | awk '{print $12}')

  THRESHOLD_SWITCHES=10000

  

  if (( ${CONTEXT_SWITCHES} > ${THRESHOLD_SWITCHES} )); then

    echo "Context switching rate is high. Current rate is ${CONTEXT_SWITCHES}"

    echo "System may be overloaded with too many requests."

  else

    echo "Context switching rate is normal. Current rate is ${CONTEXT_SWITCHES}"

    echo "No issues detected."

  fi

else

  echo "CPU usage is normal. Current usage is ${CPU_USAGE}%"

  echo "No issues detected."

fi