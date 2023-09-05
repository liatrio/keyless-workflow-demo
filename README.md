[![OpenSSF Scorecard](https://api.securityscorecards.dev/projects/github.com/liatrio-delivery-povs/devops-knowledge-share-ui/badge)](https://api.securityscorecards.dev/projects/github.com/liatrio-delivery-povs/devops-knowledge-share-ui)
![CodeQL](https://github.com/liatrio-delivery-povs/devops-knowledge-share-ui/workflows/CodeQL/badge.svg?branch=main)

# DevOps Knowledge Share DOB UI

## Getting Started

> **_Note:_** Please note this is the DevOps Bootcamp version of the [DevOps Knowledge Share UI](https://github.com/liatrio-delivery-povs/devops-knowledge-share-ui). Some of the contents of this repo were sanitized and various links/references may no longer function.

### Prerequisites

- nvm (`brew install nvm`)
- Node 16.x (`nvm install` & `nvm use` - These commands will read the `.nvmrc` file included in the project)
- npm 8.x (`npm install -g npm@8`)
- Docker Desktop

### Run locally

1. Change your working directory to application root folder

2. Install dependencies using below command

   ```bash
   npm install
   ```

3. Start the DevOps Knowledge Share API locally. Set the `KNOWLEDGE_SHARE_API` environment variable for API communication.

   ```bash
   # if running on Host machine
   export KNOWLEDGE_SHARE_API=http://localhost:8080

   # if running on Remote Container such as VS Code
   export KNOWLEDGE_SHARE_API=<your host machine ip>

   # for example, docker is
   export KNOWLEDGE_SHARE_API=http://host.docker.internal:8080
   ```

4. To run the application with hot reloading, run the below command

   ```bash
   npm run dev
   ```

5. Navigate to `http://localhost:3000` to view your application

6. To execute testcases, run the below command

   ```bash
   npm run test
   ```

### Build and Run via Docker

1. Make sure that you have [Docker Desktop installed](https://docs.docker.com/desktop/mac/install/) and you have it running

2. Use the following command to build your Docker image

   ```bash
   # Note: the --platform flag is required for building on Apple Silicon
   docker build -t <repo>/devops-knowledge-share-ui . --platform linux/amd64
   ```

3. Use the following command to start the container with port `3000` forwarded to your local machine

   ```bash
   docker run -e KNOWLEDGE_SHARE_API=http://host.docker.internal:8080 -p 3000:3000 -it <repo>/devops-knowledge-share-ui
   ```

4. Navigate to `http://localhost:3000` to view your application

### Deploy to Kubernetes

1. Make sure that you have [Docker Desktop installed](https://docs.docker.com/desktop/mac/install/) and you have it running

2. Make sure Docker Desktop has [Kubernetes enabled](https://docs.docker.com/desktop/kubernetes/#enable-kubernetes)

3. To build a new Docker image and deploy via the Helm Chart, use the `buildAndHelm` npm script

   ```bash
   npm run buildAndHelm
   ```

4. Navigate to `http://localhost:30010` to view your application

### VS Code Remote Development

1. Get [VSCode](https://code.visualstudio.com/download)

2. Add [Remote Code - Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) Extension to VSCode

3. Make sure you have [Docker Desktop](https://docs.docker.com/desktop/#download-and-install) installed and running

4. Make sure to setup your SSH Agent. Follow [this guide](https://code.visualstudio.com/docs/remote/containers#_using-ssh-keys)

5. When opening the project with VSCode it should automatically startup your remote container environment

   - If not, go to **View** -> **Command Palette** and search for **Remote-Container: Open Folder in Container**

6. Now that you have your environment up and running follow the above **Run Locally** steps to get your app up and running.

> The Remote Container environment is codified according to the `.devcontainer/devcontainer.json` [specifications](https://code.visualstudio.com/docs/remote/devcontainerjson-reference). This definition is shared across the team via Git to produce a consistent development environment.

[More info on Remote Containers](https://code.visualstudio.com/docs/remote/containers#_dev-container-features-preview)

## Steps to access the API and application index page

1. Open [http://localhost:3000](http://localhost:3000) with your browser to see the result.

2. [API routes](https://nextjs.org/docs/api-routes/introduction) can be accessed on [http://localhost:3000/api/hello](http://localhost:3000/api/hello). This endpoint can be edited in `pages/api/hello.ts`.

3. The `pages/api` directory is mapped to `/api/*`. Files in this directory are treated as [API routes](https://nextjs.org/docs/api-routes/introduction) instead of React pages.

## Running SonarQube scans locally

Install the [sonar-scanner-cli](https://docs.sonarqube.org/latest/analysis/scan/sonarscanner/)

```
brew install sonar-scanner
```

Generate a SonarQube Token by going to https://sonar.exampleCompany.com, then My Account -> Security -> Generate Tokens. Set the token as an environment variable

```
export SONAR_TOKEN=PLACE_TOKEN_HERE
```

Start sonar scan locally w/ code coverage reportPaths

```
sonar-scanner -X \
 -Dsonar.projectKey=devops-knowledge-share-ui \
 -Dsonar.sources=src \
 -Dsonar.host.url=https://sonar.exampleCompany.com \
 -Dsonar.login=$SONAR_TOKEN
 -Dsonar.javascript.lcov.reportPaths=coverage/lcov.info
```

## Running Snyk scans Locally

> **_WARNING:_** Do not run `snyk monitor` from the command line locally as it should only be ran from CircleCI to maintain a single source of truth

Install the [Snyk CLI](https://docs.snyk.io/snyk-cli/install-the-snyk-cli)

```bash
brew tap snyk/tap
brew install snyk
```

Authenticate your Snyk CLI

```bash
snyk auth
```

Run `snyk test` to check for open source vulnerabilities and license issues

```bash
snyk test --severity-threshold=high --all-projects --prune-repeated-subdependencies
```

Run `snyk code test` to find security issues using static code analysis

```bash
snyk code test --severity-threshold=high --all-projects
```
