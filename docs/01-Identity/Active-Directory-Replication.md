# Phase 1.1 - High Availability & Active Directory Replication

## Topology Overview

| Server | Role | IP Address | Primary DNS | Secondary DNS |
| :--- | :--- | :--- | :--- | :--- |
| **DC01** | Primary Domain Controller | `192.168.10.10/24` | `127.0.0.1` | `192.168.10.11` |
| **DC02** | Secondary Domain Controller | `192.168.10.11/24` | `192.168.10.10` | `127.0.0.1` |

## Deployment Summary
- Joined `DC02` to domain `dmontech.local`.
- Promoted `DC02` as an Additional Domain Controller with AD DS and DNS roles.
- Resolved initial DNS lookup error (8524) by configuring cross-referencing primary/secondary DNS listeners and registering CNAME GUID records via `nltest /dsregdns`.

## Verification Status
- Both `DC01` and `DC02` report **0 failures** across all 5 replication partitions (`repadmin /replsummary`).