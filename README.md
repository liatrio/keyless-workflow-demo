# DevOps Knowledge Share DOB UI

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
