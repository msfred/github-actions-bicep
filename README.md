# GitHub Actions Samples

## CI - Continuous Integration
With continuous integration, each time code is committed, changes are validated and merged to the main branch, and the code is packaged into a build artifact.

The [Continuous Integration Workflow](https://github.com/fredcicles/github-actions/blob/main/.github/workflows/continuous-integration.yml) is an example of a GitHub Workflow that automatically builds, validates, and generates a build artifact for the project whenever a commit is made to the main or a pull request branch.


## CI/CD - Continuous Integration & Continuous Delivery
When teams implement both continuous integration and continuous delivery (CI/CD), the build and deployment phases are automated. Code remains ready for production at any time. All teams must do is manually trigger the transition from develop to deploy—making the automated build artifact available for automatic deployment—which can be as simple as pressing a button.

The [Continuous Delivery Workflow](https://github.com/fredcicles/github-actions/blob/main/.github/workflows/continuous-delivery.yml) is an example of a GitHub Workflow that automatically performs the CI step and then deploys the build to a development environment.  A manual step is required to advance the deployment to each subsequent environment (QA, UAT, STAGE, PRODUCTION).

### Workflow
```mermaid
stateDiagram
  direction LR
  J1: Build
  B1: Download code to runner
  B2: Build code
  B3: Unit tests
  B4: Code scanning
  B5: Security scanning
  B6: Dependency scanning
  B7: Publish Build as Artifact
  B8: Publish Infrastructure as Artifact
  J2: Deploy to Development
  D1: Deploy Infrastructure
  D2: Deploy Application
  D3: Integration Tests
  D4: Performance Tests
    
  state J1 {
    direction LR
    B1 --> B8
    B1 --> B2
    B2 --> B3
    B2 --> B4
    B2 --> B5
    B2 --> B6
    B3 --> B7
    B4 --> B7
    B5 --> B7
    B6 --> B7
  }
  
  J1 --> J2
  state J2 {
    direction LR
    D1 --> D2
    D2 --> D3
    D2 --> D4
  }
```


## Continuous Deployment
Continuous deployment takes this one step further.  When all testing for each environment (unit / integration / user acceptance) can be automated, then manual approval steps can be removed and the workflow of code from commit to production deployment can be fully automated.

### Workflow
```mermaid
stateDiagram
  direction LR
  J1: Build
  J2: Deploy to Test
  J21: Deploy Infrastructure
  J22: Deploy Application
  J23: Integration Tests
  J24: Performance Tests
  J3: Deploy to Staging
  J31: Deploy Infrastructure
  J32: Deploy Application
  J33: Integration Tests
  J34: Performance Tests
  J4: Deploy to Production
  J41: Swap Deployment Slots
  J43: Integration Tests
  J44: Performance Tests

  J1 --> J2
  state J2 {
    direction LR
    J21 --> J22
    J22 --> J23
    J22 --> J24
  }

  J2 --> J3
  state J3 {
    direction LR
    J31 --> J32
    J32 --> J33
    J32 --> J34
  }

  J3 --> J4
  state J4 {
    direction LR
    J41 --> J43
    J41 --> J44
  }
```
