package dk.sdu.mmmi.mdsd.project.generator

import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.IFileSystemAccess2
import org.eclipse.xtext.generator.IGeneratorContext


class ProjectGenerator {
	Resource resource;
	IFileSystemAccess2 fsa;
	IGeneratorContext context;

	new (Resource resource, IFileSystemAccess2 fsa, IGeneratorContext context) {
		this.resource = resource
		this.fsa = fsa
		this.context = context
		
		fsa.generateFile( 'build.xml', build);
		fsa.generateFile('manifest.mf', manifest)
		fsa.generateFile('.gitignore', gitignore)
		fsa.generateFile('/nbproject/project.xml', project)
		fsa.generateFile('/nbproject/project.properties', projectProp)
		//fsa.generateFile('/nbproject/jfx-impl.xml', jfx)
		
		
	}
	
	def jfx() {
		'''
		
		'''
	}
	
	def projectProp() {
		'''
		annotation.processing.enabled=true
		annotation.processing.enabled.in.editor=false
		annotation.processing.processor.options=
		annotation.processing.processors.list=
		annotation.processing.run.all.processors=true
		annotation.processing.source.output=${build.generated.sources.dir}/ap-source-output
		application.title=RobotDefinitionSample
		application.vendor=ditlev
		build.classes.dir=${build.dir}/classes
		build.classes.excludes=**/*.java,**/*.form
		# This directory is removed when the project is cleaned:
		build.dir=build
		build.generated.dir=${build.dir}/generated
		build.generated.sources.dir=${build.dir}/generated-sources
		# Only compile against the classpath explicitly listed here:
		build.sysclasspath=ignore
		build.test.classes.dir=${build.dir}/test/classes
		build.test.results.dir=${build.dir}/test/results
		compile.on.save=true
		compile.on.save.unsupported.javafx=true
		# Uncomment to specify the preferred debugger connection transport:
		#debug.transport=dt_socket
		debug.classpath=\
		    ${run.classpath}
		debug.test.classpath=\
		    ${run.test.classpath}
		# This directory is removed when the project is cleaned:
		dist.dir=dist
		dist.jar=${dist.dir}/RobotDefinitionSample.jar
		dist.javadoc.dir=${dist.dir}/javadoc
		endorsed.classpath=
		excludes=
		includes=**
		# Non-JavaFX jar file creation is deactivated in JavaFX 2.0+ projects
		jar.archive.disabled=true
		jar.compress=false
		javac.classpath=\
		    ${javafx.classpath.extension}
		# Space-separated list of extra javac options
		javac.compilerargs=
		javac.deprecation=false
		javac.processorpath=\
		    ${javac.classpath}
		javac.source=1.8
		javac.target=1.8
		javac.test.classpath=\
		    ${javac.classpath}:\
		    ${build.classes.dir}
		javac.test.processorpath=\
		    ${javac.test.classpath}
		javadoc.additionalparam=
		javadoc.author=false
		javadoc.encoding=${source.encoding}
		javadoc.noindex=false
		javadoc.nonavbar=false
		javadoc.notree=false
		javadoc.private=false
		javadoc.splitindex=true
		javadoc.use=true
		javadoc.version=false
		javadoc.windowtitle=
		javafx.application.implementation.version=1.0
		javafx.binarycss=false
		javafx.classpath.extension=\
		    ${java.home}/lib/javaws.jar:\
		    ${java.home}/lib/deploy.jar:\
		    ${java.home}/lib/plugin.jar
		javafx.deploy.allowoffline=true
		# If true, application update mode is set to 'background', if false, update mode is set to 'eager'
		javafx.deploy.backgroundupdate=false
		javafx.deploy.embedJNLP=true
		javafx.deploy.includeDT=true
		# Set true to prevent creation of temporary copy of deployment artifacts before each run (disables concurrent runs)
		javafx.disable.concurrent.runs=false
		# Set true to enable multiple concurrent runs of the same WebStart or Run-in-Browser project
		javafx.enable.concurrent.external.runs=false
		# This is a JavaFX project
		javafx.enabled=true
		javafx.fallback.class=com.javafx.main.NoJavaFXFallback
		# Main class for JavaFX
		javafx.main.class=robotdefinitionsample.RobotDefinitionSample
		javafx.preloader.class=
		# This project does not use Preloader
		javafx.preloader.enabled=false
		javafx.preloader.jar.filename=
		javafx.preloader.jar.path=
		javafx.preloader.project.path=
		javafx.preloader.type=none
		# Set true for GlassFish only. Rebases manifest classpaths of JARs in lib dir. Not usable with signed JARs.
		javafx.rebase.libs=false
		javafx.run.height=600
		javafx.run.width=800
		# Pre-JavaFX 2.0 WebStart is deactivated in JavaFX 2.0+ projects
		jnlp.enabled=false
		# Main class for Java launcher
		main.class=com.javafx.main.Main
		# For improved security specify narrower Codebase manifest attribute to prevent RIAs from being repurposed
		manifest.custom.codebase=*
		# Specify Permissions manifest attribute to override default (choices: sandbox, all-permissions)
		manifest.custom.permissions=
		manifest.file=manifest.mf
		meta.inf.dir=${src.dir}/META-INF
		platform.active=default_platform
		run.classpath=\
		    ${dist.jar}:\
		    ${javac.classpath}:\
		    ${build.classes.dir}
		run.test.classpath=\
		    ${javac.test.classpath}:\
		    ${build.test.classes.dir}
		source.encoding=UTF-8
		src.dir=src
		test.src.dir=test
		'''
	}
	
	def project() {
		'''
		<?xml version="1.0" encoding="UTF-8"?>
		<project xmlns="http://www.netbeans.org/ns/project/1">
		    <type>org.netbeans.modules.java.j2seproject</type>
		    <configuration>
		        <buildExtensions xmlns="http://www.netbeans.org/ns/ant-build-extender/1">
		            <extension file="jfx-impl.xml" id="jfx3">
		                <dependency dependsOn="-jfx-copylibs" target="-post-jar"/>
		                <dependency dependsOn="-rebase-libs" target="-post-jar"/>
		                <dependency dependsOn="jfx-deployment" target="-post-jar"/>
		                <dependency dependsOn="jar" target="debug"/>
		                <dependency dependsOn="jar" target="profile"/>
		                <dependency dependsOn="jar" target="run"/>
		            </extension>
		        </buildExtensions>
		        <data xmlns="http://www.netbeans.org/ns/j2se-project/3">
		            <name>RobotDefinitionSample</name>
		            <source-roots>
		                <root id="src.dir"/>
		            </source-roots>
		            <test-roots>
		                <root id="test.src.dir"/>
		            </test-roots>
		        </data>
		    </configuration>
		</project>
		'''
	}
	
	
	def gitignore() {
		'''
		# Created by https://www.gitignore.io/api/netbeans
		
		### NetBeans ###
		nbproject/private/
		build/
		nbbuild/
		dist/
		nbdist/
		.nb-gradle/
		nbactions.xml
		
		
		# End of https://www.gitignore.io/api/netbeans
		'''
	}
	
	def manifest() {
		'''
		Manifest-Version: 1.0
		X-COMMENT: Main-Class will be added automatically by build
		'''
	}
	
	def build() {
		'''
		<?xml version="1.0" encoding="UTF-8"?><!-- You may freely edit this file. See commented blocks below for --><!-- some examples of how to customize the build. --><!-- (If you delete it and reopen the project it will be recreated.) --><!-- By default, only the Clean and Build commands use this build script. --><project name="RobotDefinitionSample" default="default" basedir="." xmlns:fx="javafx:com.sun.javafx.tools.ant">
		    <description>Builds, tests, and runs the project RobotDefinitionSample.</description>
		    <import file="nbproject/build-impl.xml"/>
		    <!--
		    There exist several targets which are by default empty and which can be 
		    used for execution of your tasks. These targets are usually executed 
		    before and after some main targets. Those of them relevant for JavaFX project are: 
		      -pre-init:                 called before initialization of project properties
		      -post-init:                called after initialization of project properties
		      -pre-compile:              called before javac compilation
		      -post-compile:             called after javac compilation
		      -pre-compile-test:         called before javac compilation of JUnit tests
		      -post-compile-test:        called after javac compilation of JUnit tests
		      -pre-jfx-jar:              called before FX SDK specific <fx:jar> task
		      -post-jfx-jar:             called after FX SDK specific <fx:jar> task
		      -pre-jfx-deploy:           called before FX SDK specific <fx:deploy> task
		      -post-jfx-deploy:          called after FX SDK specific <fx:deploy> task
		      -pre-jfx-native:           called just after -pre-jfx-deploy if <fx:deploy> runs in native packaging mode
		      -post-jfx-native:          called just after -post-jfx-deploy if <fx:deploy> runs in native packaging mode
		      -post-clean:               called after cleaning build products
		    (Targets beginning with '-' are not intended to be called on their own.)
		    Example of inserting a HTML postprocessor after javaFX SDK deployment:
		        <target name="-post-jfx-deploy">
		            <basename property="jfx.deployment.base" file="${jfx.deployment.jar}" suffix=".jar"/>
		            <property name="jfx.deployment.html" location="${jfx.deployment.dir}${file.separator}${jfx.deployment.base}.html"/>
		            <custompostprocess>
		                <fileset dir="${jfx.deployment.html}"/>
		            </custompostprocess>
		        </target>
		    Example of calling an Ant task from JavaFX SDK. Note that access to JavaFX SDK Ant tasks must be
		    initialized; to ensure this is done add the dependence on -check-jfx-sdk-version target:
		        <target name="-post-jfx-jar" depends="-check-jfx-sdk-version">
		            <echo message="Calling jar task from JavaFX SDK"/>
		            <fx:jar ...>
		                ...
		            </fx:jar>
		        </target>
		    For more details about JavaFX SDK Ant tasks go to
		    http://docs.oracle.com/javafx/2/deployment/jfxpub-deployment.htm
		    For list of available properties check the files
		    nbproject/build-impl.xml and nbproject/jfx-impl.xml.
		    -->
		</project>
		'''
	}
}