# atlas-rs
Deploys a 5-node distributed Replica Set plus a regional read-only node in MongoDB Atlas (AWS).

## Terraform Infrastructure

This repository now contains a Terraform project (in `terraform/`) that provisions:

* A MongoDB Atlas cluster in an existing Atlas Project
* A two-region (US-EAST-1 + US-EAST-2) advanced replica set cluster (5 electable nodes by default: 3 in US-EAST-1, 2 in US-EAST-2), plus an additional read-only node in AP-SOUTHEAST-2 (Sydney, Australia), running MongoDB 7.0. Note: Multi-region requires at least M30 instance size.

### 1. Setup

* Terraform >= 1.6
* MongoDB Atlas API Key with access to the target project
* Existing Atlas Project ID

The MongoDB Atlas provider requires credentials. Update the [`.env`](./terraform/.env) the following environment variables before `terraform init/plan/apply`:

```bash
cd terraform

source .env
terraform init
terraform validate
terraform plan
terraform apply
```

### 2. Run Demos

There are demo apps available to show the impact of read preference and write times to sharded clusters at:

- `https://us.mdb-architect-day.net:3000`
-`https://au.mdb-architect-day.net:3000`

One instance is deployed on an AWS EC2 node in `US-EAST-1`, the other in `AP-SOUTHEAST-2`.

#### 2a. Localized Reads vs not so

The AU demo instance, in particualr, will show a significant drop in latency when switching from default '`PRIMARY`' read preference, to '`NEAREST`' read preference.

#### 2b. Upgrade to MongoDB 8.0 while application is running.

See the step-by-step Terraform demo: `demos/upgrade-mongodb-7-to-8/README.md:1`

#### 2c. Convert Replica Set to One-Shard Cluster

See the sharding upgrade demo: `demos/replicaset-to-one-shard/README.md:1`
