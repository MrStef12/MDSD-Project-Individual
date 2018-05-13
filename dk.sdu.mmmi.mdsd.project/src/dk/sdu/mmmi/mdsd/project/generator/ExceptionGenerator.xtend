package dk.sdu.mmmi.mdsd.project.generator

import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.IFileSystemAccess2
import org.eclipse.xtext.generator.IGeneratorContext
import dk.sdu.mmmi.mdsd.project.dSL.TerminatableDef
import dk.sdu.mmmi.mdsd.project.dSL.Terminatable

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
		var terminatables = resource.allContents.filter(TerminatableDef).next
		for (Terminatable t : terminatables.terms)
			fsa.generateFile("/src/robotdefinitionsample/exceptions/" + t.name + ".java", t.name.generateException)
		
		var staticExceptions = #["InvalidMove", "NoShelfPickedUp"];
		for (String s : staticExceptions) {
			fsa.generateFile("/src/robotdefinitionsample/exceptions/" + s + ".java", s.generateException);
		}
	}
	
	def generateException(String name) {
		'''
		package robotdefinitionsample.exceptions;
				
				public class «name» extends Exception{
				    public «name»() {
				        super();
				    }
				    
				    public «name»(String message) {
				        super(message);
				    }
				}
		'''
	}
}