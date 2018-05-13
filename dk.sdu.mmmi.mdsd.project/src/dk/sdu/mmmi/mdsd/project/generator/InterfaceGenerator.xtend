package dk.sdu.mmmi.mdsd.project.generator

import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.IFileSystemAccess2
import org.eclipse.xtext.generator.IGeneratorContext

class InterfaceGenerator {
	private Resource resource;
	private IFileSystemAccess2 fsa;
	private IGeneratorContext context;
	
	new (Resource resource, IFileSystemAccess2 fsa, IGeneratorContext context) {
		this.resource = resource
		this.fsa = fsa
		this.context = context
		
		fsa.generateFile('/src/robotdefinitionsample/interfaces/ICondition.java', generateICondition)
		fsa.generateFile('/src/robotdefinitionsample/interfaces/IConditionTasks.java', generateIConditionTasks)
		fsa.generateFile('/src/robotdefinitionsample/interfaces/IMoveable.java', generateIMoveable)
	}
	
	def generateICondition()
	'''
	package robotdefinitionsample.interfaces;
	
	import java.util.Map;
	import robotdefinitionsample.models.Property;
	import robotdefinitionsample.models.Shelf;
	
	public interface ICondition {
	    public boolean checkCondition(int retries, Shelf shelf, Map<String, Property> properties);
	}
	'''
	
	def generateIConditionTasks()
	'''
	package robotdefinitionsample.interfaces;
	
	import java.util.List;
	import robotdefinitionsample.models.TaskItem;
	
	public interface IConditionTasks {
	    public void addTasks(List<TaskItem> items);
	}
	'''
	
	def generateIMoveable()
	'''
	package robotdefinitionsample.interfaces;
	
	import javafx.scene.layout.GridPane;
	
	public interface IMoveable {
	    void execute(GridPane grid);
	    void move(GridPane grid);
	}
	'''
	
}