package dk.sdu.mmmi.mdsd.project.generator

import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.IFileSystemAccess2
import org.eclipse.xtext.generator.IGeneratorContext
import dk.sdu.mmmi.mdsd.project.dSL.Area
import dk.sdu.mmmi.mdsd.project.dSL.Robot
import org.eclipse.emf.ecore.EObject
import java.util.List
import dk.sdu.mmmi.mdsd.project.dSL.Shelf
import dk.sdu.mmmi.mdsd.project.dSL.AreaItem
import dk.sdu.mmmi.mdsd.project.dSL.Obstacle

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
		
		//«»
		
		'''
		import java.net.URL;
		import java.util.ArrayList;
		import java.util.List;
		import java.util.ResourceBundle;
		import javafx.fxml.FXML;
		import javafx.fxml.Initializable;
		import javafx.scene.control.Label;
		import javafx.scene.input.MouseEvent;
		import javafx.scene.layout.GridPane;
		
		public class «area.name»Controller implements Initializable {
		    
		    @FXML
		    private GridPane grid;
			    
			private List<Robot> robots;
			private List<Obstacle> obstacles;
			private List<Shelf> shelfs;
		
		
			@Override
			public void initialize(URL url, ResourceBundle rb) {
				robots = new ArrayList<>();
				obstacles = new ArrayList<>();
				shelfs = new ArrayList<>();
		
		        «robots(area.name)»
		        «generateItems(area.items)»
		        
		    }
		
		    @FXML
		    private void doStuff(MouseEvent event) {
		        grid.getChildren().remove(l);
		        grid.add(l, 9, 9);
		        
		        System.out.println("relocate");
		    }
		    
			private void tick() {
	            for (Robot r : robots) {
	                r.execute();
	                grid.getChildren().remove(r);
	                grid.add(r, r.getPos().getX(), r.getPos().getY());
	            }
	        }
		    
		}
		'''
	}
	
	
	def robots(String AreaName) {
		
		var robots = resource.allContents.filter[r |
			if (r instanceof Robot) {
				System.out.println("Fandt robot: " + r.area.name.equals(AreaName));
				return r.area.name.equals(AreaName);
			}
			false
		].toList
		
		'''
		«instanciateObjects(robots)»
		'''
		
	}
	
	def generateItems(List<AreaItem> items) {
		'''
		«FOR i : items»
		«construct(i)»
		«ENDFOR»
		'''
	}
	
	def instanciateObjects(List<EObject> objects) {
		'''
		«FOR r : objects»
		«construct(r)»
		«ENDFOR»
		'''
	}
	
	def dispatch construct(Robot r) {
		'''
		Robot R«r.name» = new Robot(«r.name», new Vector2(«r.startpoint.pos.x», «r.startpoint.pos.y»));
		'''
	}
	
	def dispatch construct(Shelf s) {
		'''
		Shelf S«s.name» = new Shelf(«s.name», new Vector2(«s.pos.x», «s.pos.y»));
		'''
	}
	
	def dispatch construct(Obstacle o) {
		'''
		Obstacle O«o.name» = new Obstacle(«o.name», new Vector2(«o.pos.x», «o.pos.y»), new Vector2(«o.size.x», «o.size.y»));
		'''
	}
	
	
	
	
	
	
	
	
	
}