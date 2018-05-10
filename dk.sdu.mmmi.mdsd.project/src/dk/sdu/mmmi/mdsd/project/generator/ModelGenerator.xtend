package dk.sdu.mmmi.mdsd.project.generator

import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.IFileSystemAccess2
import org.eclipse.xtext.generator.IGeneratorContext
import dk.sdu.mmmi.mdsd.project.dSL.Area
import dk.sdu.mmmi.mdsd.project.dSL.MissionTask
import dk.sdu.mmmi.mdsd.project.dSL.Action
import dk.sdu.mmmi.mdsd.project.dSL.Condition
import dk.sdu.mmmi.mdsd.project.dSL.Pickup
import dk.sdu.mmmi.mdsd.project.dSL.Forward
import dk.sdu.mmmi.mdsd.project.dSL.Backward
import dk.sdu.mmmi.mdsd.project.dSL.Turn
import dk.sdu.mmmi.mdsd.project.dSL.LeftDir
import dk.sdu.mmmi.mdsd.project.dSL.RightDir
import dk.sdu.mmmi.mdsd.project.dSL.State
import dk.sdu.mmmi.mdsd.project.dSL.StateAt
import dk.sdu.mmmi.mdsd.project.dSL.Expression
import dk.sdu.mmmi.mdsd.project.dSL.Plus
import dk.sdu.mmmi.mdsd.project.dSL.Minus
import dk.sdu.mmmi.mdsd.project.dSL.Mult
import dk.sdu.mmmi.mdsd.project.dSL.Div
import dk.sdu.mmmi.mdsd.project.dSL.Num
import dk.sdu.mmmi.mdsd.project.dSL.Sign
import dk.sdu.mmmi.mdsd.project.dSL.Equals
import dk.sdu.mmmi.mdsd.project.dSL.SmallerThan
import dk.sdu.mmmi.mdsd.project.dSL.GreaterThan
import dk.sdu.mmmi.mdsd.project.dSL.SmallerThanEquals
import dk.sdu.mmmi.mdsd.project.dSL.GreaterThanEquals
import dk.sdu.mmmi.mdsd.project.dSL.TaskItem
import dk.sdu.mmmi.mdsd.project.dSL.StatePickedUp
import dk.sdu.mmmi.mdsd.project.dSL.StateRetries
import dk.sdu.mmmi.mdsd.project.dSL.Else
import dk.sdu.mmmi.mdsd.project.dSL.TerminatableDef
import dk.sdu.mmmi.mdsd.project.dSL.Terminatable

class ModelGenerator {
	
	Resource resource;
	IFileSystemAccess2 fsa;
	IGeneratorContext context;

	new (Resource resource, IFileSystemAccess2 fsa, IGeneratorContext context) {
		this.resource = resource
		this.fsa = fsa
		this.context = context
		
		generateModels()
	}
	
	def generateModels() {
		fsa.generateFile('/src/robotdefinitionsample/models/Shelf.java', shelfModel)
		fsa.generateFile('/src/robotdefinitionsample/models/Vector2.java', vectorModel)
		fsa.generateFile('/src/robotdefinitionsample/models/Property.java', PropertyModel)
		fsa.generateFile('/src/robotdefinitionsample/models/Obstacle.java', ObstacleModel)
		fsa.generateFile('/src/robotdefinitionsample/models/Robot.java', RobotModel)
		fsa.generateFile('/src/robotdefinitionsample/models/Mission.java', MissionModel)
		fsa.generateFile('/src/robotdefinitionsample/models/ActionCondition.java', ActionCondition)
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
		import robotdefinitionsample.DesiredProps;
		import robotdefinitionsample.exceptions.InvalidMove;
		import robotdefinitionsample.exceptions.NoShelfPickedUp;
		import robotdefinitionsample.exceptions.PropertyNotSet;
		
		/**
		 *
		 * @author ditlev
		 */
		public class Task {
		    private String name;
		    private List<TaskItem> items;
		    private int currentTask;
		    private boolean done;
		    private int retries;
		    private boolean shouldRetry;
		    
		    public Task(String name) {
		        this.name = name;
		        this.items = new ArrayList<>();
		        this.currentTask = 0;
		        this.done = false;
		        this.retries = 0;
		        this.shouldRetry = false;
		    }
		    
		    //anonymously task comes generaly from a TaskItem
		    public Task() {
		        this.items = new ArrayList<>();
		        this.currentTask = 0;
		        this.done = false;
		        this.retries = 0;
		        this.shouldRetry = false;
		    }
		    
		    public Task addTask(TaskItem item) {
		        items.add(item);
		        return this;
		    }
		    
		    public boolean isDone() {
		        return done;
		    }
		    
		    public void executeNext(DesiredProps props) throws InvalidMove, NoShelfPickedUp, «FOR term : resource.allContents.filter(Terminatable).toList SEPARATOR ", "»«term.name»«ENDFOR» {
		        TaskItem currentTaskItem = items.get(currentTask);
		        if (!shouldRetry) {
		            while(currentTaskItem.isDone()) {
		                currentTask++;
		                currentTaskItem = items.get(currentTask);
		            }    
		        } else {
		            retries++;
		            currentTaskItem.incrementTicksToGo();
		            shouldRetry = false;
		        }
		        
		        currentTaskItem.executeCommand(props);
		        
		        if (currentTask == items.size()) {
		            done = true;
		        }
		    }
		    
		    public void setRetry(boolean b) {
		        this.shouldRetry = b;
		    }
		    
		    public int getRetries() {
		        return retries;
		    }
		
		    void addTaskAtCurrent(TaskItem t) {
		        items.add(currentTask + 1, t);
		        System.out.println("Okay");
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
		        Parent root = FXMLLoader.load(getClass().getResource("«resource.allContents.filter(Area).next.name».fxml"));
		        
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
	
	def ActionCondition() {
		'''
		package robotdefinitionsample.models;
		
		/**
		 *
		 * @author ditlev
		 */
		public enum ActionCondition {
		    PICKUP,
		    FORWARD,
		    BACKWARD,
		    TURN_CW,
		    TURN_CCW,
		    DO,
		    TERMINATE,
		    CONDITIONAT,
		    CONDITIONPICKEDUP,
		    CONDITIONRETRIES
		    
		}
		
		'''
	}
	
	def MissionModel() {
		'''
		package robotdefinitionsample.models;
		
		import java.util.ArrayList;
		import java.util.List;
		import javafx.scene.control.Alert;
		import javafx.scene.layout.GridPane;
		import robotdefinitionsample.DesiredProps;
		import robotdefinitionsample.exceptions.InvalidMove;
		import robotdefinitionsample.ObstacleDetection;
		
		public class Mission {
		    private List<Task> mission;
		    private int currentTask;
		    private boolean done;
		    
		    
		    public Mission() {
		        mission = new ArrayList<>();
		        currentTask = 0;
		        done = false;
		    }
		
		    public boolean isDone() {
		        return done;
		    }
		    
		    public void addTask(Task t) {
		        mission.add(t);
		    }
		    
		    public void executeNext(GridPane grid, DesiredProps props) {
		        Task t = mission.get(currentTask);
				try {
		            t.executeNext(props);
		            if (ObstacleDetection.detect(grid, props)) {
		                props.setDiscarded(true);
		                throw new InvalidMove();
		            }
				} catch(InvalidMove e) {
		            Alert alert = new Alert(Alert.AlertType.INFORMATION);
		            alert.setTitle("Invalid mode");
		            alert.setHeaderText("Robot cannot execute task");
		            alert.setContentText("The robot hit an invalid move");
		            alert.showAndWait();
		    	}
		    	«FOR e : resource.allContents.filter(MissionTask).toList»
		    		«IF e.terminated !== null»
		    			catch («e.terminated.terminatable.name» e) {
		    				«FOR ti : e.terminated.items»
		    					«ti.generateTaskItem»
		    				«ENDFOR»
		    			}
		    		«ENDIF»
		    	«ENDFOR»
		    	
		        if (t.isDone()) {
		            currentTask++;
		        }
		        if (currentTask == mission.size()) {
		            done = true;
		        }
		    }
		}
		'''
	}
	
	def CharSequence generateTaskItem(TaskItem t) {		
		switch t {
			Pickup : '''addTaskAtCurrent(new TaskItem(robot, ActionCondition.PICKUP));'''
			Forward : '''addTaskAtCurrent(new TaskItem(robot, ActionCondition.FORWARD)«IF t.amount != 0».setTicksToGo(«t.amount»)«ENDIF»);'''
			Backward : '''addTaskAtCurrent(new TaskItem(robot, ActionCondition.BACKWARD)«IF t.amount != 0».setTicksToGo(«t.amount»)«ENDIF»);'''
			Turn : '''addTaskAtCurrent(new TaskItem(robot, ActionCondition.«turnDirection(t.direction)»));'''
			Else : '''«t.generateTaskItem»'''
			Condition : s(t)

		}
	}
	
	def s(Condition c) {
		var tasks = c.tasks;
		var elseTasks = c.getElse.tasks;
		switch c {
			StateAt : '''addTaskCurrent(new TaskItem(robot, ActionCondition.CONDITIONAT).setAtShelfName(«c.shelf.name»));'''
			State : '''if («c.left.displayExp» «c.sign.displaySign» «c.right.displayExp») {
				«FOR t : tasks»
				«t.generateTaskItem»
				«ENDFOR»
			} «IF elseTasks !== null» else { «FOR task : elseTasks» «task.generateTaskItem» «ENDFOR» }«ENDIF»
			'''
		}
	}
	
	
	def displaySign(Sign s) {
		switch s {
			Equals : '''=='''
			SmallerThan : '''<'''
			SmallerThanEquals : '''<='''
			GreaterThan : '''>'''
			GreaterThanEquals : '''>='''
		}
	}
	
	// Ulriks display function 
	def String displayExp(Expression exp) {
		"("+switch exp {
			Plus: exp.left.displayExp+"+"+exp.right.displayExp
			Minus: exp.left.displayExp+"-"+exp.right.displayExp
			Mult: exp.left.displayExp+"*"+exp.right.displayExp
			Div: exp.left.displayExp+"/"+exp.right.displayExp
			Num: Integer.toString(exp.value)
			StatePickedUp : ''''''
			StateRetries : '''mission.get(currentTask).getRetries() { mission.get(currentTask).setRetry(true) }'''
			default: throw new Error("Invalid expression")
		}+")"
	}
	
	def dispatch turnDirection(LeftDir d) {
		'''TURN_CW'''
	}
	
	def dispatch turnDirection(RightDir d) {
		'''TURN_CCW'''
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