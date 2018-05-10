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
		fsa.generateFile("/src/robotdefinitionsample/exceptions/PropertyNotSet.java", generateNoPropertySet);
		fsa.generateFile("/src/robotdefinitionsample/exceptions/NoShelfPickedUp.java", generateNoShelfPickedUp);
		fsa.generateFile("/src/robotdefinitionsample/exceptions/InvalidMove.java", generateInvalidMove);
	}
	
	
	
	def generateNoPropertySet() {
		'''
		/*
		 * To change this license header, choose License Headers in Project Properties.
		 * To change this template file, choose Tools | Templates
		 * and open the template in the editor.
		 */
		package robotdefinitionsample.exceptions;
		
		/**
		 *
		 * @author ditlev
		 */
		public class PropertyNotSet extends Exception {
		
		    /**
		     * Creates a new instance of <code>PropertyNotSet</code> without detail
		     * message.
		     */
		    public PropertyNotSet() {
		    }
		
		    /**
		     * Constructs an instance of <code>PropertyNotSet</code> with the specified
		     * detail message.
		     *
		     * @param msg the detail message.
		     */
		    public PropertyNotSet(String msg) {
		        super(msg);
		    }
		}
		'''
	}
	
	def generateNoShelfPickedUp() {
		'''
		/*
		 * To change this license header, choose License Headers in Project Properties.
		 * To change this template file, choose Tools | Templates
		 * and open the template in the editor.
		 */
		package robotdefinitionsample.exceptions;
		
		/**
		 *
		 * @author ditlev
		 */
		public class NoShelfPickedUp extends Exception {
		
		    /**
		     * Creates a new instance of <code>NoShelfPickedUp</code> without detail
		     * message.
		     */
		    public NoShelfPickedUp() {
		    }
		
		    /**
		     * Constructs an instance of <code>NoShelfPickedUp</code> with the specified
		     * detail message.
		     *
		     * @param msg the detail message.
		     */
		    public NoShelfPickedUp(String msg) {
		        super(msg);
		    }
		}
		'''
	}
	
	def generateInvalidMove() {
		'''
		/*
		 * To change this license header, choose License Headers in Project Properties.
		 * To change this template file, choose Tools | Templates
		 * and open the template in the editor.
		 */
		package robotdefinitionsample.exceptions;
		
		/**
		 *
		 * @author ditlev
		 */
		public class InvalidMove extends Exception{
		    public InvalidMove() {
		        super();
		    }
		    
		    public InvalidMove(String name) {
		        super(name);
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