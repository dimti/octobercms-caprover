## Persistent directories

`/srv/app/storage/app`:`caprover-mysite-uploads`

*Use self-app naming for persistent volume label

## Environment variables

Your October CMS installation need to be prepared as use dot-env configs.

*Use .env-example for copy to bulk env into caprover app config.*

## Deploying

### Connect to caprover server

`caprover login -u "https://captain.server.mydomain.ru" -p VerySecurePass -n captain-mydomain`

### First deploy

`caprover deploy -n captain-mydomain -a mysite -b master`

### Other deployments

Repeat with previous deployment options

`caprover deploy -d`

## Abbreviation
`mysite` - Application name of your site

`server` - Unnecessary subdomain with wildcard of child subdomains for caprover installation.
For this case, you caprover dashboard url: `https://captain.server.mydomain.ru` 

`mydomain` - you two-level domain name, example: `mydomain.ru`

`captain-mydomain` - alias for you caprover server. Use any better name.

## Mailgun

`.env-example` contains mail system configs based on mailgun. 
