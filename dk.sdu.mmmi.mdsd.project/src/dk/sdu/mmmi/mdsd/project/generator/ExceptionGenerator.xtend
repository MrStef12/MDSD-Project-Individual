package dk.sdu.mmmi.mdsd.project.generator

import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.IFileSystemAccess2
import org.eclipse.xtext.generator.IGeneratorContext
import dk.sdu.mmmi.mdsd.project.dSL.Terminate

class ExceptionGenerator {
	Resource resource;
	IFileSystemAccess2 fsa;
	IGeneratorContext context;

	new (Resource resource, IFileSystemAccess2 fsa, IGeneratorContext context) {
		this.resource = resource
		this.fsa = fsa
		this.context = context
		
		generateExceptions()
	}
	
	def generateExceptions() {
		var terminatables = resource.allContents.filter(Terminate).toList
		for (Terminate t : terminatables)
			fsa.generateFile("/src/robotdefinitionsample/exceptions/" + t.name + ".java", exception(t))
		
		fsa.generateFile("/src/robotdefinitionsample/exceptions/InvalidMove.java", generateInvalidMove);
	}
	
	def generateInvalidMove() {
		'''
		package robotdefinitionsample.exceptions;

		public class InvalidMove extends Exception{
		    public InvalidMove() {
		    }
		}
		'''
	}
	
	def exception(Terminate t) {
		'''
		package robotdefinitionsample.exceptions;

		public class «t.name» extends Exception{
		    public «t.name»() {
		    }
		}
		'''
	}
}