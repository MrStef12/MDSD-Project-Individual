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
		fsa.generateFile('/src/robotdefinitionsample/models/Shelf.java', shelfModel)
		fsa.generateFile('/src/robotdefinitionsample/models/Vector2.java', vectorModel)
		fsa.generateFile('/src/robotdefinitionsample/models/Property.java', PropertyModel)
		fsa.generateFile('/src/robotdefinitionsample/models/Obstacle.java', ObstacleModel)
		fsa.generateFile('/src/robotdefinitionsample/models/Robot.java', RobotModel)
		fsa.generateFile('/src/robotdefinitionsample/models/Mission.java', MissionModel)
		fsa.generateFile('/src/robotdefinitionsample/models/ActionCondition.java', ActionCondition)
		fsa.generateFile('/src/robotdefinitionsample/models/MissionGenerator.java', MissionGenerator)
		fsa.generateFile('/src/robotdefinitionsample/models/Task.java', Task)
		fsa.generateFile('/src/robotdefinitionsample/models/TaskItem.java', TaskItem)
		fsa.generateFile('/src/robotdefinitionsample/RobotDefinitionSample.java', main)
		
	}
	
	def TaskItem() {
		'''
		/*
		 * To change this license header, choose License Headers in Project Properties.
		 * To change this template file, choose Tools | Templates
		 * and open the template in the editor.
		 */
		package robotdefinitionsample.models;
		
		/**
		 *
		 * @author ditlev
		 */
		class TaskItem {
		    
		    //Direction values
		    private final int right = 0;
		    private final int up = 90;
		    private final int left = 180;
		    private final int down = 270;
		    
		    private Robot robot;
		    private ActionCondition ac;
		    private boolean done;
		    
		    public TaskItem(Robot robot, ActionCondition ac) {
		        this.robot = robot;
		        this.ac = ac;
		        this.done = false;
		    }
		    
		    public ActionCondition getAction() {
		        return ac;
		    }
		    
		    public void executeCommand() {
		        //Maybe some general code can be done here.
		        
		        switch (ac) {
		            case FORWARD:
		                forward();
		                break;
		            case TURN:
		                turn();
		                break;
		        }
		        
		        done = true;
		        
		    }
		    
		    public boolean done() {
		        return done;
		    }
		    
		    private void forward() {
		       
		        int currentDirection = (int) robot.rotateProperty().get();
		        
		        switch (currentDirection) {
		            case right:
		                robot.getPos().setX(robot.getPos().getX() + 1);
		                break;
		            case left:
		                robot.getPos().setX(robot.getPos().getX() - 1);
		                break;
		            case up:
		                robot.getPos().setY(robot.getPos().getY() -1);
		                break;
		            case down:
		                robot.getPos().setY(robot.getPos().getY() + 1);
		                break;
		        }
		    }
		    
		    private void turn() {
		        int currentDirection = (int) robot.rotateProperty().get();
		        
		        
		        
		    }
		    
		    private void backward() {
		        
		    }
		}
		'''
	}
	
	def Task() {
		'''
		/*
		 * To change this license header, choose License Headers in Project Properties.
		 * To change this template file, choose Tools | Templates
		 * and open the template in the editor.
		 */
		package robotdefinitionsample.models;
		
		import java.util.ArrayList;
		import java.util.List;
		
		/**
		 *
		 * @author ditlev
		 */
		public class Task {
		    private String name;
		    private List<TaskItem> items;
		    private int currentTask;
		    private boolean done;
		    
		    public Task(String name) {
		        this.name = name;
		        items = new ArrayList<>();
		        currentTask = 0;
		        done = false;
		    }
		    
		    public void addTask(TaskItem item) {
		        items.add(item);
		    }
		    
		    public boolean done() {
		        return done;
		    }
		    
		    public void executeTaskItem() {
		        TaskItem currentTaskItem = items.get(currentTask);
		        
		        currentTaskItem.executeCommand();
		        if (currentTaskItem.done()) {
		            currentTask++;
		        }
		        
		        if (currentTask == items.size()) {
		            done = true;
		        }
		    }
		}
		'''
	}
	
	def main() {
		'''
		package robotdefinitionsample;
		
		import javafx.application.Application;
		import javafx.fxml.FXMLLoader;
		import javafx.scene.Parent;
		import javafx.scene.Scene;
		import javafx.stage.Stage;
		
		/**
		 *
		 * @author ditlev
		 */
		public class RobotDefinitionSample extends Application {
		    
		    @Override
		    public void start(Stage stage) throws Exception {
		        Parent root = FXMLLoader.load(getClass().getResource("ProductionFloor.fxml"));
		        
		        Scene scene = new Scene(root);
		        
		        stage.setScene(scene);
		        stage.show();
		    }
		
		    /**
		     * @param args the command line arguments
		     */
		    public static void main(String[] args) {
		        launch(args);
		    }
		    
		}'''
	}
	
	def MissionGenerator() {
		'''
		package robotdefinitionsample.models;
		
		/**
		 *
		 * @author ditlev
		 */
		public class MissionGenerator {
		    
		    
		    public Mission Robot1(Robot r) {
		        Mission m = new Mission();
		        Task t = new Task("asd");
		        
		        TaskItem ti = new TaskItem(r, ActionCondition.FORWARD);
		        TaskItem ti1 = new TaskItem(r, ActionCondition.FORWARD);
		        TaskItem ti2 = new TaskItem(r, ActionCondition.FORWARD);
		        
		        t.addTask(ti);
		        t.addTask(ti1);
		        t.addTask(ti2);
		        m.addTask(t);
		        return m;
		    }
		    
		}
		'''
	}
	
	def ActionCondition() {
		'''
		package robotdefinitionsample.models;
		
		/**
		 *
		 * @author ditlev
		 */
		public enum ActionCondition {
		    PICKUP,
		    FORWARDUNTIL,
		    FORWARD,
		    BACKWARD,
		    TURN,
		    RETRY,
		    DO,
		    TERMINATE,
		    CONDITION
		    
		}
		'''
	}
	
	def MissionModel() {
		'''
		package robotdefinitionsample.models;
		
		import java.util.ArrayList;
		import java.util.List;
		
		/**
		 *
		 * @author ditlev
		 */
		public class Mission {
		    private List<Task> mission;
		    private int currentTask;
		    
		    public Mission() {
		        mission = new ArrayList<>();
		        currentTask = 0;
		    }
		    
		    public void addTask(Task t) {
		        mission.add(t);
		    }
		    
		    public Task getNextTask() {
		        Task t = mission.get(currentTask);
		        if (t.done()) {
		            currentTask++;
		        }
		        return t;
		    }
		    
		}
		'''
	}
	
	def RobotModel() {
		'''
		package robotdefinitionsample.models;
		
		import javafx.scene.control.Label;
		
		public class Robot extends Label {
		    private Vector2 pos;
		    private Mission mission;
		
		    public Robot(String name, Vector2 startpoint) {
		        super(name);
		        this.pos = startpoint;
		    }
		    
		    public void setMission(Mission m) {
		        this.mission = m;
		    }
		
		    public String getName() {
		        return this.getText();
		    }
		    
		    public Vector2 getPos() {
		        return pos;
		    }
		
		    public Mission getMission() {
		        return mission;
		    }
		    
		    public void execute() {
		        Task t = mission.getNextTask();
		        t.executeTaskItem();
		    }
		}
		'''
	}
	
	def ObstacleModel() {
		'''
		package robotdefinitionsample.models;
		
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
		package robotdefinitionsample.models;
		
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
		
		package robotdefinitionsample.models;
		
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
		    
		    public void setY(int y) {
		        this.y = y;
		    }
		    
		    public void setX(int x) {
		        this.x = x;
		    }
		}
		'''
	}
	
	
	
	def shelfModel() {
		'''
		package robotdefinitionsample.models;
		
		import java.util.HashMap;
		import java.util.Map;
		import javafx.scene.control.Label;
		
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