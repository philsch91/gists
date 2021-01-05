# Jenkins Notes



## Cancel tasks in the queue
https://<jenkins-url>/script

```
import hudson.model.*
def q = Jenkins.instance.queue
q.items.each { 
  q.cancel(it.task)
}
```

## Clear the task queue
https://<jenkins-url>/script

```
import hudson.model.*
def queue = Hudson.instance.queue
println "Queue contains ${queue.items.length} items"
queue.clear()
println "Queue cleared"
```

## Cancel and stop jobs
https://<jenkins-url>/script

```
Jenkins.instance.queue.items.findAll {
    !it.task.name.contains("Extenda") }.each {
        println "Cancel ${it.task.name}"
        Jenkins.instance.queue.cancel(it.task)
    }

Jenkins.instance.items.each {
  stopJobs(it)
}

def stopJobs(job) {
  if (job in jenkins.branch.OrganizationFolder) {
    // Git behaves well so no need to traverse it.
    return
  } else if (job in com.cloudbees.hudson.plugins.folder.Folder) {
    job.items.each { stopJobs(it) }
  } else if (job in org.jenkinsci.plugins.workflow.multibranch.WorkflowMultiBranchProject) {
    job.items.each { stopJobs(it) }
  } else if (job in org.jenkinsci.plugins.workflow.job.WorkflowJob) {
    if (job.isBuilding() || job.isInQueue() || job.isBuildBlocked()) {
      job.builds.findAll { it.inProgress || it.building }.each { build ->
        println "Kill $build"
        build.finish(hudson.model.Result.ABORTED, new java.io.IOException("Aborted from Script Console"));
      }
    }
  }
}
return true
```