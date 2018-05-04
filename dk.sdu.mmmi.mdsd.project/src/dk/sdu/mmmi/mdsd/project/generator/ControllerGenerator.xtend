package dk.sdu.mmmi.mdsd.project.generator

import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.IFileSystemAccess2
import org.eclipse.xtext.generator.IGeneratorContext
import dk.sdu.mmmi.mdsd.project.dSL.Area
import dk.sdu.mmmi.mdsd.project.dSL.AreaItem
import org.eclipse.emf.common.util.EList

class ControllerGenerator {
	Resource resource;
	IFileSystemAccess2 fsa;
	IGeneratorContext context;

	new (Resource resource, IFileSystemAccess2 fsa, IGeneratorContext context) {
		this.resource = resource
		this.fsa = fsa
		this.context = context
		
		generateArea(fsa, resource)
	}
	
	def void generateArea(IFileSystemAccess2 fsa, Resource resource) {
		var areas = resource.allContents.filter(Area).toList;
		
		for (Area area : areas) {
			fsa.generateFile( area.name + 'Controller.java', generateController(area) );
		}
		
	}
	
	def generateController(Area area) {
		
		//for (Shelf s : items.filter(Shelf))
		
		
		'''
		import java.net.URL;
		import java.util.HashMap;
		import java.util.Map;
		import java.util.ResourceBundle;
		import javafx.fxml.FXML;
		import javafx.fxml.Initializable;
		import javafx.scene.control.Label;
		import javafx.scene.input.MouseEvent;
		import javafx.scene.layout.GridPane;
		
		public class «area.name»Controller implements Initializable {
		    
		    @FXML
		    private GridPane grid;
		    
		    private Map<String, Label> robots;
		
		    
		    @Override
		    public void initialize(URL url, ResourceBundle rb) {
		        robots = new HashMap<>();
		        
		        Shelf s1 = new Shelf("navn", new Vector2(4,5), );
		        
		
		        
		        robots.put("robotName", l);
		        grid.add(l, 0, 0);
		        
		        
		        
		    }
		
		    @FXML
		    private void doStuff(MouseEvent event) {
		        
		        
		        grid.getChildren().remove(l);
		        grid.add(l, 9, 9);
		        
		        System.out.println("relocate");
		    }
		    
		}
		'''
	}
}