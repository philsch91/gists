# Jenkins Notes

## Tasks

### Cancel tasks in the queue
https://<jenkins-url>/script

```
import hudson.model.*
def q = Jenkins.instance.queue
q.items.each {
  q.cancel(it.task)
}
```

#### Cancel task method 1
```
import hudson.model.*
import jenkins.model.Jenkins


for (queued in Jenkins.instance.queue.items) {
  Jenkins.instance.queue.cancel(queued.task)
}

```

#### Cancel task method 2
```
import hudson.model.*
import jenkins.model.Jenkins

def i = 0
def tasks = Jenkins.instance.queue.items.findAll {
  println("task " + i + ": " + it.task.name)
  i++
}
//tasks.each { Jenkins.instance.queue.cancel(it.task) }
```

```
Jenkins.instance.queue.items.findAll {
    !it.task.name.contains("Extenda") }.each {
        println "Cancel ${it.task.name}"
        Jenkins.instance.queue.cancel(it.task)
    }
```

### Clear the task queue

```
import hudson.model.*
def queue = Hudson.instance.queue
println "Queue contains ${queue.items.length} items"
queue.clear()
println "Queue cleared"
```

## Build Jobs

### Cancel and stop jobs
https://<jenkins-url>/script

#### Stop builds method 1
```
import hudson.model.*
import jenkins.model.Jenkins

def buildingJobs = Jenkins.instance.getAllItems(Job.class).findAll {
  it.isBuilding()
}

//println(buildingJobs)

def j = 0
buildingJobs.each {
  def jobName = it.toString()
  //println(jobName + "\n")
  def jobarr = jobName.split("\\[|\\]")
  println("jobarr[1]:" + jobarr[1])

  def job = Jenkins.instance.getItemByFullName(jobarr[1].trim())
  for (build in job.builds) {
    if (build.isBuilding()) {
      println("build " + j + ": " + build)
      //build.doStop();
      build.doKill();
      j++
    }
  }
}
```

#### Stop builds method 2
```
import hudson.model.*
import jenkins.model.Jenkins

for (job in Jenkins.instance.items) {
  stopJobs(job)
}

def stopJobs(job) {
  if (job in com.cloudbees.hudson.plugins.folder.Folder) {
    for (child in job.items) {
      stopJobs(child)
	}
  } else if (job in org.jenkinsci.plugins.workflow.multibranch.WorkflowMultiBranchProject) {
    for (child in job.items) {
      stopJobs(child)
    }
  } else if (job in org.jenkinsci.plugins.workflow.job.WorkflowJob) {
    if (job.isBuilding()) {
      for (build in job.builds) {
        build.doKill()
      }
    }
  }
}
```

#### Stop builds method 3
```
import hudson.model.*
import jenkins.model.Jenkins

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
