# Developer's guide

This document is a brief overview of how to use this code base. Some understanding of Nextflow and how it implements DSL2 is assumed. 

## Basic concept

This pipeline base is organized in the following way:

* `main.nf` - entry point into the pipeline, imports the core workflow from workflow/<pipeline>.nf
* `workflow/<pipeline.nf>` - the actual core logic of the pipeline; imports sub-workflows from subworkflow/<sub>.nf
* `subworkflow/<sub>.nf` - a self-contained processing chain that is part of the larger workflow (e.g. read alignment and dedup in a WGS calling workflow)
* `modules/<module>.nf` - A command line tool/call that can be imported into a (sub)workflow. 

## Groovy libraries

This pipeline imports a few functions into the nextflow files from lib/ - mostly to keep the actual pipeline code a bit cleaner/more readable. For example, 
the `--help` command line option can be found in lib/WorkflowMain.groovy. Likewise, you could use this approach to do some basic validation of your inputs etc. 

## Github workflows

Github supports the automatic execution of specific tasks on code branches, such as the automatic building pushing of Docker containers. To add github workflows to your repository, rename the folder `dot_github` to `.github` and adjust the files therein accordingly (name of pipeline, docker repo etc).

### Docker containers

In order to automatically push Docker containers, you must add your docker username and API token as secrets to your repository (DOCKERHUB_USERNAME and DOCKERHUB_TOKEN). Secrets can be created under Settings/Secrets and Variables/Actions. Of course, you also need to have an account on Dockerhub and generate a permanent token.  

## How to Start

1. Create a new repository and use this template 

![](../images/github_template.png)

2. Go through the source files and address the sections marked with `//DEV`

- Update `nextflow.config' with the name and version of your pipeline, required nextflow version and so on
- Rename the main workflow file and workflow definition to match your pipeline topic (and update main.nf accordingly)
- If you want to provision a pipeline-specific Docker container
  - rename dot_github to .github
  - Create a dockerhub project for this pipeline
  - Update the github actions to the name of the dockerhub project 

3. Outline your primary workflow logic in `workflow/<pipeline.nf>` 

4. Start outlining your subworkflows, if any in `subworkflows/<subworkflow.nf>`

5. Build all the necessary modules in `modules/`, using `modules/fastp/main.nf` as a template
   - Use a subfolder for each software package and folders therein for sub-functions of a given tool (e.g. samtools)
   - Each module should include a `container` statement to specify which software container is to be used
   - Each module should collect information on the software version(s) of the tools used
