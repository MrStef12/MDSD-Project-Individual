package dk.sdu.mmmi.mdsd.project.generator

import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.IFileSystemAccess2
import org.eclipse.xtext.generator.IGeneratorContext
import dk.sdu.mmmi.mdsd.project.dSL.Robot
import java.util.List
import dk.sdu.mmmi.mdsd.project.dSL.AreaItem
import dk.sdu.mmmi.mdsd.project.dSL.Obstacle
import dk.sdu.mmmi.mdsd.project.dSL.RobotDefinition
import dk.sdu.mmmi.mdsd.project.dSL.Pickupable

class ControllerGenerator {
	Resource resource;
	IFileSystemAccess2 fsa;
	IGeneratorContext context;

	new (Resource resource, IFileSystemAccess2 fsa, IGeneratorContext context) {
		this.resource = resource
		this.fsa = fsa
		this.context = context
		
		var rd = resource.allContents.filter(RobotDefinition).next;
		fsa.generateFile('/src/robotdefinitionsample/FXMLDocumentController.java', rd.generateController);
	}
	
	def generateController(RobotDefinition rd) {
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
		import robotdefinitionsample.models.Obstacle;
		import robotdefinitionsample.models.Robot;
		import robotdefinitionsample.models.Pickupable;
		import robotdefinitionsample.models.Vector2;
		
		public class FXMLDocumentController implements Initializable {
		    
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
		        
		        «rd.area.items.generateItems»
		        
		        «rd.robots.generateRobots»
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
	
	
	def generateRobots(List<Robot> robots) 
		'''
		«FOR robot : robots»
		«robot.construct»
		«ENDFOR»
		'''
	
	def generateItems(List<AreaItem> items) 
		'''
		«FOR i : items»
		«i.construct»
		«ENDFOR»
		'''
	
	def dispatch construct(Robot r) {
		'''
		Robot r_«r.name» = new Robot("«r.name»", new Vector2(«r.startpoint.pos.x», «r.startpoint.pos.y»), generator.«r.name»(grid));
		r_«r.name».setGraphic(new ImageView(image));
		moveables.add(r_«r.name»);
		grid.add(r_«r.name», «r.startpoint.pos.x», «r.startpoint.pos.y»);
		'''
	}
	
	def dispatch construct(Pickupable s) {
		'''
		Pickupable p_«s.name» = new Pickupable("«s.name»", new Vector2(«s.pos.x», «s.pos.y»));
		«FOR p : s.properties»
		p_«s.name».addProperty("«p.name»", «p.^default»);
		«ENDFOR»
		moveables.add(p_«s.name»);
		grid.add(p_«s.name», «s.pos.x», «s.pos.y»);
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