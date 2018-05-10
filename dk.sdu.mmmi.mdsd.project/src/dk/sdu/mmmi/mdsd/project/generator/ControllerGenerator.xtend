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
import dk.sdu.mmmi.mdsd.project.dSL.Mission

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
		var area = resource.allContents.filter(Area).next;
		
		
		fsa.generateFile('/src/robotdefinitionsample/' + area.name + 'Controller.java', generateController(area) );
		
		
	}
	
	def generateController(Area area) {
		
		
		'''
		package robotdefinitionsample;
		
		import java.net.URL;
		import java.util.ArrayList;
		import java.util.List;
		import java.util.ResourceBundle;
		import javafx.event.ActionEvent;
		import javafx.fxml.FXML;
		import javafx.fxml.Initializable;
		import javafx.scene.control.Button;
		import javafx.scene.layout.GridPane;
		import robotdefinitionsample.models.MissionGenerator;
		import robotdefinitionsample.models.Obstacle;
		import robotdefinitionsample.models.Robot;
		import robotdefinitionsample.models.Shelf;
		import robotdefinitionsample.models.Vector2;
		
		public class «area.name»Controller implements Initializable {
		    
		    @FXML
		    private GridPane grid;
		    @FXML
		    private Button Tick;
		    
		    private List<Robot> robots;
		    private List<Obstacle> obstacles;
		    private List<Shelf> shelfs;
		
		
			@Override
			public void initialize(URL url, ResourceBundle rb) {
				robots = new ArrayList<>();
				obstacles = new ArrayList<>();
				shelfs = new ArrayList<>();
				MissionGenerator generator = new MissionGenerator();
				
				«robots(area.name)»
		        «generateItems(area.items)»
		        
                Robot r = new Robot("name", new Vector2(0,0));
                r.setMission(generator.Robot1(r));
        
                robots.add(r);
                
                grid.add(r, r.getPos().getX(), r.getPos().getY());
		    }
		
		    private void tick() {
		        for (Robot r : robots) {
		            r.execute();
		            grid.getChildren().remove(r);
		            grid.add(r, r.getPos().getX(), r.getPos().getY());
		        }
		    }
		
		    @FXML
		    private void onClick(ActionEvent event) {
		        tick();
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
		«FOR i : objects»
		«construct(i)»
		«ENDFOR»
		'''
	}
	
	def dispatch construct(Robot r) {
		'''
		Robot «r.name» = new Robot(«r.name», new Vector2(«r.startpoint.pos.x», «r.startpoint.pos.y»));
		«generateMission(r)»
		'''
	}
	
	def generateMission(Robot r) {
		'''
		«r.name».setMission(generate.«r.name»(r));
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