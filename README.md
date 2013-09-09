# Jettyshift, an OpenShift QuickStart for Jetty

[Jetty](http://eclipse.org/jetty/) is a web server that serves (Java) web applications. It's blazingly fast, feature-rich and it does not waste resources.

It's perfect for applications running on [OpenShift](http://openshift.com).

Jettyshift is an improved variant of the [jetty-openshift-quickstart](https://github.com/openshift-quickstart/jetty-openshift-quickstart) QuickStart from OpenShift. 

It supports Jetty 9.

## Installation

Create a new application from the DIY cartrige:

    rhc app create -a jettyshift -c diy-0.1

Then, replace the default contents of the application's repository with this repository. Example:
    
    cd YOUR_OPENSHIFT_APP_DIRECTORY
    rm -r .openshift
    git pull git@github.com:hf/jettyshift.git

## Structure

Everything that Jettyshift needs can be found in `.jettyshift` and `.openshift` directories. Please do not exclude them from the git commits.

Jetty is installed in `$OPENSHIFT_DATA_DIR/jetty`.

Maven dependencies can be found in `$OPENSHIFT_DATA_DIR/maven`.

Webapps should be installed in the `deployments` folder from Maven, i.e. `$OPENSHIFT_REPO_DIR/deployments`.

### Action Hooks

In the `.openshift/action_hooks` directory there are action hooks for OpenShift which setup a default Jetty 9 installation. 

### Startup Scripts

In the `.jettyshift/scripts` directory there are scripts that are used to setup Jetty, build your application (through Maven), start and stop Jetty.

You can change the version of Jetty that will be installed from the `.jettyshift/scripts/setup.sh` script, where you should modify the `$JETTY_MAJOR` and `$JETTY_VERSION` variables accordingly. 

See a [listing of all available Jetty versions](http://download.eclipse.org/jetty/).

### Configuration Files

In the `.jettyshift/config` directory there are configuration files used to setup Jetty, mainly `start.ini`. Add/modify files here so that they will be copied over to Jetty's installation directory upon installation.

`.jettyshift/maven.xml` is used to setup the Maven configuration.

### Project Object Model

`pom.xml` contains a sample Maven POM file. Feel free to change it as it suits your needs. Make sure it installs your webapps in the directories discussed earlier.

## Debugging

Whenever you deploy your application to OpenShift, you will get a detailed description on what is going on. In case something does not work, ensure that:

* the start and stop action hooks completed without error
* see Jetty's log, found at `$OPENSHIFT_DIY_LOG_DIR/server.log`
* check other logs you have set up, if any
* check Jetty's configuration files
* restart your application 

        rhc app restart YOUR_APP

* reinstall Jetty  
        
        rhc ssh YOUR_APP
        cd $OPENSHIFT_DATA_DIR
        if [ -f jetty/jetty.pid ]; then kill `cat jetty/jetty.pid`; fi
        rm -rf jetty

        exit # from SSH

        rhc app restart YOUR_APP # or push with changes

* check your webapp code
