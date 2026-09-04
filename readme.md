# Password Rotation Automation for Graylog and Zabbix

## Overview

This project automates password rotation on Graylog and Zabbix servers.

The automation is driven by the `automate.sh` script, which reads the target servers from the `.env` file and executes the appropriate Expect script according to the server type.

The solution consists of three main scripts:

- `automate.sh`
- `graylog.exp`
- `zabbix.exp`

## Architecture

```text

                +------------+
                |  .env file |
                +------------+
                       |
                       v
                +-------------+
                | automate.sh |
                +-------------+
                       |
            +----------+----------+
            |                     |
            v                     v
     +---------------+     +---------------+
     |  graylog.exp  |     |  zabbix.exp   |
     +-------+-------+     +-------+-------+
             |                     |
             v                     v
          logfile               logfile
```

## Components

### automate.sh

Main orchestration script.

Responsibilities:

- Reads the list of servers from the `.env` file.
- Determines the server type (Graylog or Zabbix).
- Launches the appropriate Expect script.
- Captures and processes the exit code returned by the Expect script.
- Logs success and failure information.

### graylog.exp

Automates password rotation on Graylog servers.

Responsibilities:

- SSH connection to the target server.
- Authentication using administrative credentials.
- Password update operations.
- Service stop/start operations when required.
- Validation of each step.
- Returns custom exit codes in case of failure.

### zabbix.exp

Automates password rotation on Zabbix servers.

Responsibilities:

- SSH connection to the target server.
- Authentication using administrative credentials.
- Database password update operations.
- Validation of execution status.
- Returns custom exit codes in case of failure.

## Configuration

Server information is stored in the `.env` file.
check the .env file for the right naming conventions of servers' properties 


The `automate.sh` script iterates through all configured servers and launches the corresponding automation workflow.

## Execution

```bash
chmod +x automate.sh

./automate.sh
```

## Graylog Exit Codes

| Exit Code | Description |
|------------|------------|
| 3 | Wrong RSI Admin password |
| 4 | Wrong root password |
| 5 | Failed to stop `graylog-server` |
| 6 | Failed to stop `elasticsearch` |
| 7 | Failed during configuration update (`sed`) |
| 8 | Failed to start `elasticsearch` |
| 9 | Failed to start `graylog-server` |
| 10 | Unexpected EOF during SSH session |
| 11 | SSH connection timed out |

## Zabbix Exit Codes

| Exit Code | Description |
|------------|------------|
| 1 | SSH connection timed out |
| 3 | Wrong RSI Admin password |
| 4 | Wrong root password |
| 5 | SQL-related error |
| 10 | Unexpected EOF during SSH session |
| 11 | SSH connection timed out |

## Logging and Error Handling

The automation relies on custom exit codes returned by the Expect scripts.

Each exit code corresponds to a specific failure scenario, allowing:

- Rapid troubleshooting
- Precise error reporting
- Easier integration with monitoring tools
- Automated alerting mechanisms

## Notes

- Multiple Graylog and Zabbix servers can be managed through the same execution.
- The password rotation workflow is executed independently for each configured server.
- A failure on one server does not prevent the processing of subsequent servers unless explicitly configured otherwise.
- Ensure SSH connectivity and required privileges are available before execution.

## Prerequisites

- Linux environment
- Bash shell
- Expect package installed
- SSH access to target servers
- Appropriate administrative credentials

## Author

Password Rotation Automation Project


