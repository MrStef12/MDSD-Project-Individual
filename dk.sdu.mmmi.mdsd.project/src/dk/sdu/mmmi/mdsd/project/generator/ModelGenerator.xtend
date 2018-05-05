package dk.sdu.mmmi.mdsd.project.generator

import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.AbstractGenerator
import org.eclipse.xtext.generator.IFileSystemAccess2
import org.eclipse.xtext.generator.IGeneratorContext
import dk.sdu.mmmi.mdsd.project.dSL.Area

class ModelGenerator {
	
	Resource resource;
	IFileSystemAccess2 fsa;
	IGeneratorContext context;

	new (Resource resource, IFileSystemAccess2 fsa, IGeneratorContext context) {
		this.resource = resource
		this.fsa = fsa
		this.context = context
		
		generateModels(fsa, resource)
	}
	
	def generateModels(IFileSystemAccess2 fsa, Resource resource) {
		fsa.generateFile('Shelf.java', shelfModel)
		fsa.generateFile('Vector.java', vectorModel)
		fsa.generateFile('Property.java', PropertyModel)
		fsa.generateFile('Obstacle.java', ObstacleModel)
		fsa.generateFile('Robot.java', RobotModel)
		fsa.generateFile('Mission.java', MissionModel)
	}
	
	def MissionModel() {
		'''
		public class Mission {
		    private List<Task> mission;
		    private int currentTask;
		    
		    public Mission() {
		        currentTask = 0;
		    }
		    
		    public Task getNextTask() {
		        Task t = mission.get(currentTask);
		        currentTask++;
		        return t;
		    }
		    
		}
		'''
	}
	
	def RobotModel() {
		'''
		import javafx.scene.control.Label;
		
		public class Robot extends Label {
		    private Vector2 pos;
		    private Mission mission;
		
		    public Robot(String name, Vector2 startpoint, Mission mission) {
		        super(name);
		        this.pos = startpoint;
		        this.mission = mission;
		    }
		
		    public String getName() {
		        return this.textProperty().toString();
		    }
		    
		    public Vector2 getPos() {
		        return pos;
		    }
		
		    public Mission getMission() {
		        return mission;
		    }
		    
		    public void execute() {
		        Task t = mission.getNextTask();
		        
		    }
		}
		'''
	}
	
	def ObstacleModel() {
		'''
		import javafx.scene.control.Label;
		
		public class Obstacle extends Label {
		    private Vector2 pos;
		    private Vector2 size;
		
		    public Obstacle(String name, Vector2 pos, Vector2 size) {
		        super(name);
		        this.pos = pos;
		        this.size = size;
		    }
		
		    public String getName() {
		        return this.getText();
		    }
		
		    public Vector2 getPos() {
		        return pos;
		    }
		
		    public Vector2 getSize() {
		        return size;
		    }
		    
		}
		'''
	}
	
	
	def PropertyModel() {
		'''
		public class Property {
		    private String name;
		    private int _default;
		
		    public String getName() {
		        return name;
		    }
		
		    public int getDefault() {
		        return _default;
		    }
		
		    public Property(String name, int _default) {
		        this.name = name;
		        this._default = _default;
		    }
		}
		'''
	}
	
	def vectorModel() {
		'''
		public class Vector2 {
		    private int x;
		    private int y;
		    
		    public Vector2 (int x, int y) {
		        this.x = x;
		        this.y = y;
		    }
		    
		    public int getX() {
		        return x;
		    }
		    
		    public int getY() {
		        return y;
		    }
		}
		'''
	}
	
	
	
	def shelfModel() {
		'''
		public class Shelf {
		    private String name;
		    private Vector2 pos;
		    private Map<String, Property> properties;
		
		    public Shelf(String name, Vector2 pos) {
		        this.name = name;
		        this.pos = pos;
		        this.properties = new HashMap<>();
		    }
		
		    public String getName() {
		        return name;
		    }
		
		    public Vector2 getPos() {
		        return pos;
		    }
		    
		    public Property getProperty(String key){
		        return properties.get(key);
		    }
		    
		    public void addProperty(String name, Property p) {
		        properties.put(name, p);
		    }
		    
		}
		'''
	}
}