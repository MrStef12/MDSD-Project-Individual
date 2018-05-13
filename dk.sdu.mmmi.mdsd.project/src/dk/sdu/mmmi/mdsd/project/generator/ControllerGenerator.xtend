package dk.sdu.mmmi.mdsd.project.generator

import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.IFileSystemAccess2
import org.eclipse.xtext.generator.IGeneratorContext
import dk.sdu.mmmi.mdsd.project.dSL.Area
import dk.sdu.mmmi.mdsd.project.dSL.Robot
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
		var area = resource.allContents.filter(Area).next;
		fsa.generateFile('/src/robotdefinitionsample/' + area.name + 'Controller.java', area.generateController);
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
		import javafx.scene.image.Image;
		import javafx.scene.image.ImageView;
		import javafx.scene.layout.GridPane;
		import robotdefinitionsample.interfaces.IMoveable;
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
			
			private List<IMoveable> moveables;
		
		
			@Override
			public void initialize(URL url, ResourceBundle rb) {
				moveables = new ArrayList<>();
				MissionGenerator generator = new MissionGenerator();
				Image image = new Image(getClass().getResourceAsStream("robot.png"));
				
				«generateRobots»
		        «area.items.generateItems»
		    }
		
		    private void tick() {
			    for (IMoveable m : moveables) {
			        m.execute(grid);
			        m.move(grid);
			    }
			}
		
		    @FXML
		    private void onClick(ActionEvent event) {
		        tick();
		    }
		}
		'''
	}
	
	
	def generateRobots() {
		var robots = resource.allContents.filter(Robot).toList
		'''
		«FOR robot : robots»
		«robot.construct»
		«ENDFOR»
		'''
	}
	
	def generateItems(List<AreaItem> items) {
		'''
		«FOR i : items»
		«i.construct»
		«ENDFOR»
		'''
	}
	
	def dispatch construct(Robot r) {
		'''
		Robot robot_«r.name» = new Robot("«r.name»", new Vector2(«r.startpoint.pos.x», «r.startpoint.pos.y»));
		robot_«r.name».setMission(generator.«r.name»(robot_«r.name», grid));
		robot_«r.name».setGraphic(new ImageView(image));
		moveables.add(robot_«r.name»);
		grid.add(robot_«r.name», «r.startpoint.pos.x», «r.startpoint.pos.y»);
		'''
	}
	
	def dispatch construct(Shelf s) {
		'''
		Shelf shelf_«s.name» = new Shelf("«s.name»", new Vector2(«s.pos.x», «s.pos.y»));
		moveables.add(shelf_«s.name»);
		grid.add(shelf_«s.name», «s.pos.x», «s.pos.y»);
		'''
	}
	
	def dispatch construct(Obstacle o) {
		'''
		Obstacle obstacle_«o.name» = new Obstacle("«o.name»", new Vector2(«o.pos.x», «o.pos.y»), new Vector2(«o.size.x», «o.size.y»));
		moveables.add(obstacle_«o.name»);
		grid.add(obstacle_«o.name», «o.pos.x», «o.pos.y»);
		'''
	}
	
	
	
	
	
	
	
	
	
}