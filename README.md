# Remote Control

## Overview

**Remote Control** is a cybersecurity project aimed at automating remote server operations for anonymous reconnaissance and data collection. This project utilizes various tools to ensure anonymity, execute commands remotely, and perform network scans efficiently.

---

## Features

1. **Anonymity Check**:

   - Verifies network anonymity using Tor and Proxychains.
   - Displays the spoofed IP and country information.

2. **Automated Server Connection**:

   - Connects to a remote server using SSH.
   - Executes commands on the remote server anonymously.

3. **Reconnaissance Tools**:

   - Performs Whois lookups and Nmap port scans on specified targets.
   - Saves results locally for analysis.

4. **Logging and Audit**:
   - Maintains detailed logs of all activities for auditing purposes.

---

## Tools and Technologies

- **Programming**: Bash (Shell Scripting)
- **Tools**:
  - `sshpass`: For automated SSH connections.
  - `nmap`: Network mapping and port scanning.
  - `whois`: Domain information gathering.
  - `tor` and `proxychains4`: For maintaining anonymity.
  - `curl` and `jq`: For data retrieval and JSON parsing.

---

## Installation and Usage

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/mahingaRodin/Remote-Control-.git
   cd Remote-Control-
   Make the Script Executable:
   ```

chmod +x remote_control.sh
Run the Script:

./remote_control.sh
Follow Prompts:

Enter the address to scan when prompted.
The script will automate the remaining tasks.
File Structure
remote_control.sh: Main script for automating server operations.
config.cfg: Configuration file containing server details.
whois_results.txt: Results of the Whois lookup.
nmap_results.txt: Results of the Nmap scan.
project_audit.log: Log file detailing script operations.
Requirements
Operating System: Linux (Ubuntu/Kali recommended)
Tools: Ensure the following are installed:
sshpass, nmap, whois, tor, proxychains4, curl, jq
Contribution
Contributions are welcome! If you have suggestions or improvements, please:

Fork this repository.
Make your changes in a feature branch.
Submit a pull request.
License
This project is licensed under the MIT License. See the LICENSE file for details.

Author
Mahinga Rodin
GitHub: mahingaRodin

Feel free to reach out for any questions or feedback!
