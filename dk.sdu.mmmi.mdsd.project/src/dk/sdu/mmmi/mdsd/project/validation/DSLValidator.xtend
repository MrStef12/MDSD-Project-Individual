/*
 * generated by Xtext 2.13.0
 */
package dk.sdu.mmmi.mdsd.project.validation

import dk.sdu.mmmi.mdsd.project.dSL.Shelf
import org.eclipse.xtext.EcoreUtil2
import org.eclipse.xtext.validation.IResourceValidator
import javax.inject.Inject
import org.eclipse.emf.ecore.resource.Resource
import dk.sdu.mmmi.mdsd.project.dSL.DSLPackage

/**
 * This class contains custom validation rules. 
 *
 * See https://www.eclipse.org/Xtext/documentation/303_runtime_concepts.html#validation
 */
class DSLValidator extends AbstractDSLValidator {
	
//	public static val INVALID_NAME = 'invalidName'
//
//	@Check
//	def checkGreetingStartsWithCapital(Greeting greeting) {
//		if (!Character.isUpperCase(greeting.name.charAt(0))) {
//			warning('Name should start with a capital', 
//					DSLPackage.Literals.GREETING__NAME,
//					INVALID_NAME)
//		}
//	}

	public static val INVALID_NAME = 'Invalid name 2 objects with same name';
	
	def checkNames(Shelf s) {
		val container = EcoreUtil2.getRootContainer(s);
		val cand = EcoreUtil2.getAllContentsOfType(container, Shelf);
		
		for (Shelf myS : cand) {
			if (s.name.equals(myS.name)) {
				warning(INVALID_NAME,  DSLPackage.Literals.);
			}
		}
		
		if () {
			
		}
	}
	
}