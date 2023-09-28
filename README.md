
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# High urgency incident related to host context switching.
---

This incident type relates to a high urgency issue regarding host context switching. The incident is triggered when the context switching grows on the node beyond a certain level, typically over 10000 per second. This issue can cause performance degradation and impact the stability of the system. The incident requires immediate attention from a software engineer to identify the root cause and take the necessary steps to resolve the issue.

### Parameters
```shell
export INSTANCE="PLACEHOLDER"

export PORT="PLACEHOLDER"

export SERVICE_NAME="PLACEHOLDER"
```

## Debug

### Check the CPU usage of the affected instance
```shell
ssh ${INSTANCE} top -bn1 | grep "Cpu(s)"
```

### Check the memory usage of the affected instance
```shell
ssh ${INSTANCE} free -m
```

### Check the number of context switches per second on the affected instance
```shell
ssh ${INSTANCE} grep ctxt /proc/stat
```

### Check the network connection status of the affected instance
```shell
ssh ${INSTANCE} netstat -anp | grep ${PORT}
```

### Check the disk usage of the affected instance
```shell
ssh ${INSTANCE} df -h
```

### Check the logs related to the affected service
```shell
journalctl -u ${SERVICE_NAME}.service
```

### Check the status of the affected service
```shell
systemctl status ${SERVICE_NAME}.service
```

### The system may be overloaded with too many requests, causing the CPU to switch between different processes frequently, leading to high context switching rates.
```shell
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


```

## Repair

### Consider restarting the affected service or host.
```shell
bash

#!/bin/bash

# Script to remediate high context switching rate issue



# Restart the affected service or host

echo "Restarting ${SERVICE_NAME} to remediate high context switching rate issue"

sudo systemctl restart ${SERVICE_NAME}



# Verify that the service or host has restarted successfully

echo "Verifying that ${SERVICE_NAME} has restarted successfully"

sudo systemctl status ${SERVICE_NAME}


```