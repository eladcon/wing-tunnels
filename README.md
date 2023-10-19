## Wing Tunnels

Wing tunnels is a POC of a http(s) tunneling serice written in winglang.

### How it works

The server uses wing to create a cloud API which listens to http requests under a subdomain (e.g. `*.tunnels.wingcloud.io`). 
Clients are using websockets to reserve a specific subdomain and listen to those requests, while proxing them to the local port.

#### How to use it

```bash
bring "./server/tunnels.w" as tunnels;

let t = new tunnels.TunnelsApi(zoneName: "wingcloud.io", subDomain: "tunnels");
```

#### How to deploy it

```bash
cd server
wing compile -t tf-aws tunnels.main.w
cd target/tunnels.main.tfaws
terraform init
terraform deploy
```

#### How to test it

```bash
cd server
wing test -t <tf-aws/sim> tunnels.test.w
```
### Tunnels Client

#### How to build it

```
cd client
npm install
npm run build
```