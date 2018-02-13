# Site Specific EPICS Module Patch Files

## Changes
The changes were tested in local environemnt, and commits to the forked repository and do pull request to the epics community module repository.

* Check the original HASH, and your own master
* feb8856 : The original HASH
* master : Changed


## How to create a p0 patch file between commits


* Show what the difference between commits


* Create p0 patch

```
$ git diff --no-prefix > ../patch/Site/config_app.p0.patch
$ git submodule foreach --recursive git diff --no-prefix > ../patch/Site/StreamDevice_streamApp_makefile.p0.patch

```

* Modify submodule patch file as p0,


