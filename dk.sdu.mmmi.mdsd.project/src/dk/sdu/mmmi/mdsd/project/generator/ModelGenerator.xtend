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
		fsa.generateFile('/src/robotdefinitionsample/RobotDefinitionSample.java', main)
		fsa.generateFile('/src/robotdefinitionsample/DesiredProps.java', DesiredProps)
		fsa.generateFile('/src/robotdefinitionsample/ObstacleDetection.java', ObstacleDetection)
		fsa.generateFile('/src/robotdefinitionsample/models/ActionCondition.java', ActionCondition)
		fsa.generateFile('/src/robotdefinitionsample/models/Obstacle.java', ObstacleModel)
		fsa.generateFile('/src/robotdefinitionsample/models/Property.java', PropertyModel)
		fsa.generateFile('/src/robotdefinitionsample/models/Robot.java', RobotModel)
		fsa.generateFile('/src/robotdefinitionsample/models/Shelf.java', shelfModel)
		fsa.generateFile('/src/robotdefinitionsample/models/Task.java', Task)
		fsa.generateFile('/src/robotdefinitionsample/models/TaskItem.java', TaskItem)
		fsa.generateFile('/src/robotdefinitionsample/models/Vector2.java', vectorModel)
		
	}
	
	def DesiredProps() {
		'''
		package robotdefinitionsample;
		
		import robotdefinitionsample.models.Vector2;
		
		public class DesiredProps {
		    
		    private Vector2 pos;
		    private int rotation;
		    private boolean discarded;
		    private String shelfNameToPickUp;
		
		    public DesiredProps(Vector2 pos, int rotation) {
		        this.pos = pos;
		        this.rotation = rotation;
		        this.discarded = false;
		        this.shelfNameToPickUp = "";
		    }
		
		    public Vector2 getPos() {
		        return pos;
		    }
		
		    public int getRotation() {
		        return rotation;
		    }
		
		    public boolean isDiscarded() {
		        return discarded;
		    }
		
		    public String getShelfNameToPickUp() {
		        return shelfNameToPickUp;
		    }
		
		    public void setPos(int x, int y) {
		        this.pos = new Vector2(x, x);
		    }
		    
		    public void setPos(Vector2 pos) {
		        this.pos = pos;
		    }
		
		    public void setRotation(int rotation) {
		        this.rotation = rotation;
		    }
		
		    public void setDiscarded(boolean discarded) {
		        this.discarded = discarded;
		    }
		
		    public void setShelfNameToPickUp(String shelfNameToPickUp) {
		        this.shelfNameToPickUp = shelfNameToPickUp;
		    }
		    
		}
		'''
	}
	
	def ObstacleDetection() {
		'''
		package robotdefinitionsample;
		
		import javafx.scene.Node;
		import javafx.scene.layout.GridPane;
		import robotdefinitionsample.models.Obstacle;
		import robotdefinitionsample.models.Shelf;
		import robotdefinitionsample.models.Vector2;
		
		public class ObstacleDetection {
		    public static boolean detect(GridPane grid, DesiredProps props) {
		        int x = props.getPos().getX();
		        int y = props.getPos().getY();
		        
		        for(Node node : grid.getChildren()) {
		            if (node instanceof Obstacle) {
		                Vector2 pos = ((Obstacle) node).getPos();
		                if (pos.getX() == x && pos.getY() == y) {
		                    return true;
		                }
		            }
		        }
		        return false;
		    }
		    
		    public static Shelf getShelfAtPos(GridPane grid, DesiredProps props) {
		        int x = props.getPos().getX();
		        int y = props.getPos().getY();
		        for(Node node : grid.getChildren()) {
		            if (node instanceof Shelf) {
		                Vector2 pos = ((Shelf) node).getPos();
		                if (pos.getX() == x && pos.getY() == y) {
		                    return (Shelf) node;
		                }
		            }
		        }
		        return null;
		    }
		}
		'''
	}
	
	def TaskItem() {
		'''
		package robotdefinitionsample.models;
		
		import robotdefinitionsample.interfaces.ICondition;
		import robotdefinitionsample.interfaces.IConditionTasks;
		import java.util.ArrayList;
		import java.util.List;
		import robotdefinitionsample.DesiredProps;
		import robotdefinitionsample.exceptions.InvalidMove;
		import robotdefinitionsample.exceptions.NoShelfPickedUp;
		
		public class TaskItem {
		    
		    //Direction values
		    private final int right = 0;
		    private final int up = 270;
		    private final int left = 180;
		    private final int down = 90;
		    
		    private Robot robot;
		    private ActionCondition ac;
		    private boolean done;
		    private int ticksToGo;
		    private String atShelfName;
		    private String shelfToPickUp;
		    private ICondition conditionChecker;
		    private List<TaskItem> ifTaskItems;
		    private List<TaskItem> elseTaskItems;
		    
		    public TaskItem(Robot robot, ActionCondition ac) {
		        this.robot = robot;
		        this.ac = ac;
		        this.done = false;
		        this.ticksToGo = 1;
		    }
		    
		    public ActionCondition getAction() {
		        return ac;
		    }
		    
		    public void executeCommand(DesiredProps props) throws NoShelfPickedUp, InvalidMove, Exception {
		        //Maybe some general code can be done here.
		        
		        switch (ac) {
		            case FORWARD:
		                forward(props);
		                break;
		            case TURN_CW:
		                turnCW(props);
		                break;
		            case TURN_CCW:
		                turnCCW(props);
		                break;
		            case BACKWARD:
		                backward(props);
		                break;
		            case CONDITION:
		                condition(props);
		                break;
		            case CONDITIONAT:
		                conditionAt(props);
		                break;
		            case PICKUP:
		                pickUp(props);
		                break;
		        }
		    }
		    
		    public boolean isDone() {
		        return done;
		    }
		    
		    private void forward(DesiredProps props) {
		       
		        int currentDirection = (int) robot.rotateProperty().get();
		
			        switch (currentDirection) {
			            case right:
			                props.setPos(robot.getPos().add(1, 0));
			                ticksToGo--;
			                break;
			            case left:
			                props.setPos(robot.getPos().add(-1, 0));
			                ticksToGo--;
			                break;
			            case up:
			                props.setPos(robot.getPos().add(0, -1));
			                ticksToGo--;
			                break;
			            case down:
			                props.setPos(robot.getPos().add(0, 1));
			                ticksToGo--;
			                break;
			        }
		
			        if (ticksToGo == 0) {
		                done = true;
		            }
		    }
		    
		    private void backward(DesiredProps props) {
		    	int currentDirection = (int) robot.rotateProperty().get();
		        
		    	while(ticksToGo > 0) {
			    	switch (currentDirection) {
			        case right:
			            props.setPos(robot.getPos().add(-ticksToGo, 0));
			            ticksToGo--;
			            break;
			        case left:
			            props.setPos(robot.getPos().add(ticksToGo, 0));
			            ticksToGo--;
			            break;
			        case up:
			            props.setPos(robot.getPos().add(0, ticksToGo));
			            ticksToGo--;
			            break;
			        case down:
			            props.setPos(robot.getPos().add(0, -ticksToGo));
			            ticksToGo--;
			            break;
			    	}
		    	}
		
		        if (ticksToGo == 0) {
		            done = true;
		        }
		    }
		    
		    private void turnCW(DesiredProps props) {
		        int currentDirection = (int) robot.rotateProperty().get();
		        
		        switch (currentDirection) {
		        case right:
		            props.setRotation(down);
		            break;
		        case left:
		            props.setRotation(up);
		            break;
		        case up:
		            props.setRotation(right);
		            break;
		        case down:
		            props.setRotation(left);
		            break;
		        }  
		        
		        done = true;
		    }
		    
		    private void turnCCW(DesiredProps props) {
		        int currentDirection = (int) robot.rotateProperty().get();
		        
		        switch (currentDirection) {
		        case right:
		            props.setRotation(up);
		            break;
		        case left:
		        	props.setRotation(down);
		            break;
		        case up:
		        	props.setRotation(left);
		            break;
		        case down:
		        	props.setRotation(right);
		            break;
		        }
		        
		        done = true;
		    }
		
		    private void pickUp(DesiredProps props) {
		        props.setShelfNameToPickUp(shelfToPickUp);
		        done = true;
		    }
		    
		    public TaskItem setTicksToGo(int speed) {
		    	this.ticksToGo = speed;
		    	return this;
		    }
		    
		    public void incrementTicksToGo() {
		        ticksToGo++;
		    }
		    
		    public TaskItem setAtShelfName(String shelfName) {
		        this.atShelfName = shelfName;
		        return this;
		    }
		
		    public TaskItem setShelfToPickUp(String shelfToPickUp) {
		        this.shelfToPickUp = shelfToPickUp;
		        return this;
		    }
		    
		    private void condition(DesiredProps props) throws Exception {
		        Shelf s = robot.getShelf();
		        if (conditionChecker.checkCondition(robot.getMission().getCurrentTask().getRetries(), s, s != null ? s.getShelfProperties() : null)) {
		            conditionProcessTasks(ifTaskItems, props);
		        } else {
		            conditionProcessTasks(elseTaskItems, props);
		        }
		        done = true;
		    }
		    
		    private void conditionProcessTasks(List<TaskItem> items, DesiredProps props) throws Exception {
		        for (int i=0; i<items.size(); i++) {
		            TaskItem ti = items.get(i);
		            if (i == 0) {
		                ti.executeCommand(props);
		            } else {
		                robot.getMission().addTaskAtCurrent(ti);
		            }
		        }
		    }
		    
		    public TaskItem setConditionChecker(ICondition checker) {
		        conditionChecker = checker;
		        return this;
		    }
		
		    public TaskItem setIfTaskItems(IConditionTasks tasks) {
		        List<TaskItem> list = new ArrayList<>();
		        tasks.addTasks(list);
		        this.ifTaskItems = list;
		        return this;
		    }
		
		    public TaskItem setElseTaskItems(IConditionTasks tasks) {
		        List<TaskItem> list = new ArrayList();
		        tasks.addTasks(list);
		        this.elseTaskItems = list;
		        return this;
		    }
		
		    private void conditionAt(DesiredProps props) throws Exception {
		        if (atShelfName != null) {
		            if (robot.getMission().collision(atShelfName, props)) {
		                // the first taskitem should be added last.
		                // As in the taskitems steps is reversed
		                conditionProcessTasks(ifTaskItems, props);
		            } else {
		                conditionProcessTasks(elseTaskItems, props);
		            }
		            done = true;
		        } else {
		            throw new Exception("Custom exception no shelf name set");
		        }
		    }
		}
		'''
	}
	
	def Task() {
		'''
		package robotdefinitionsample.models;
		
		import java.util.ArrayList;
		import java.util.List;
		import robotdefinitionsample.DesiredProps;
		import robotdefinitionsample.exceptions.InvalidMove;
		import robotdefinitionsample.exceptions.NoShelfPickedUp;
		
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
		    
		    public Task add(TaskItem item) {
		        items.add(item);
		        return this;
		    }
		    
		    public boolean isDone() {
		        return done;
		    }
		    
		    public void executeNext(DesiredProps props) throws InvalidMove, NoShelfPickedUp, Exception {
		        TaskItem currentTaskItem = items.get(currentTask);
		        if (!shouldRetry) {
		            while(currentTaskItem.isDone() && currentTask < items.size() - 1) {
		                currentTask++;
		                currentTaskItem = items.get(currentTask);
		            }    
		        } else {
		            retries++;
		            currentTaskItem.incrementTicksToGo();
		            shouldRetry = false;
		        }
		        
		        currentTaskItem.executeCommand(props);
		        
		        if (currentTask == items.size() - 1) {
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
		
		public class RobotDefinitionSample extends Application {
		    
		    @Override
		    public void start(Stage stage) throws Exception {
		        Parent root = FXMLLoader.load(getClass().getResource("«resource.allContents.filter(Area).next.name».fxml"));
		        
		        Scene scene = new Scene(root);
		        
		        stage.setScene(scene);
		        stage.show();
		    }
			
		    public static void main(String[] args) {
		        launch(args);
		    }
		    
		}'''
	}
	
	def ActionCondition() {
		'''
		package robotdefinitionsample.models;
		
		public enum ActionCondition {
		    PICKUP,
			FORWARD,
			BACKWARD,
			TURN_CW,
			TURN_CCW,
			DO,
			TERMINATE,
			CONDITION,
			CONDITIONAT
		}
		'''
	}
	
	
	def RobotModel() {
		'''
		package robotdefinitionsample.models;
		
		import javafx.scene.control.Alert;
		import javafx.scene.control.Label;
		import javafx.scene.layout.GridPane;
		import robotdefinitionsample.DesiredProps;
		import robotdefinitionsample.ObstacleDetection;
		import robotdefinitionsample.interfaces.IMoveable;
		
		public class Robot extends Label implements IMoveable {
		    private Vector2 pos;
		    private Mission mission;
		    private String name;
		    private Shelf pickedUpshelf;
		
		    public Robot(String name, Vector2 startpoint) {
		        super();
		        this.pos = startpoint;
		        this.name = name;
		    }
		    
		    public void setMission(Mission m) {
		        this.mission = m;
		    }
		
		    public String getName() {
		        return name;
		    }
		    
		    public Vector2 getPos() {
		        return pos;
		    }
		
		    public Mission getMission() {
		        return mission;
		    }
		    
		    public void setPos(Vector2 pos) {
		        this.pos = pos;
		    }
		    
		    public Shelf getShelf() {
		        return pickedUpshelf;
		    }
		
		    @Override
		    public void execute(GridPane grid) {
		        if (mission.isDone()) {
		            Alert alert = new Alert(Alert.AlertType.INFORMATION);
		            alert.setTitle("No more tasks");
		            alert.setHeaderText("No more tasks");
		            alert.setContentText("The robot \"" + getName() + "\" has no more tasks in its mission to execute.");
		            alert.showAndWait();
		        } else if (mission.getFailed()) {
		            Alert alert = new Alert(Alert.AlertType.INFORMATION);
		            alert.setTitle("Failed");
		            alert.setHeaderText("The mission failed");
		            alert.setContentText("The robot \"" + getName() + "\" execution failed");
		            alert.showAndWait();
		        } else {
		            DesiredProps props = new DesiredProps(getPos(), (int)getRotate());
		            mission.executeNext(props);
		            if (!props.isDiscarded()) {
		                setPos(props.getPos());
		                setRotate(props.getRotation());
		                if(ObstacleDetection.getShelfAtPos(grid, props) != null) {
		                    if(ObstacleDetection.getShelfAtPos(grid, props).getName().equals(props.getShelfNameToPickUp())) {
		                        if(pickedUpshelf == null) {
		                            pickedUpshelf = ObstacleDetection.getShelfAtPos(grid, props);
		                        }
		                    }
		                }
		                if(pickedUpshelf != null){
		                    pickedUpshelf.setPos(props.getPos());
		                }
		            }
		        }
		    }
		
		    @Override
		    public void move(GridPane grid) {
		        grid.getChildren().remove(this);
		        grid.add(this, this.getPos().getX(), this.getPos().getY());
		    }
		}
		'''
	}
	
	def ObstacleModel() {
		'''
		package robotdefinitionsample.models;
		
		import javafx.scene.control.Label;
		import javafx.scene.layout.GridPane;
		import robotdefinitionsample.interfaces.IMoveable;
		
		public class Obstacle extends Label implements IMoveable {
		    private Vector2 pos;
		    private Vector2 size;
		
		    public Obstacle(String name, Vector2 pos, Vector2 size) {
		        super(name);
		        this.pos = pos;
		        this.size = size;
		    }
		
		    public Vector2 getPos() {
		        return pos;
		    }
		
		    public Vector2 getSize() {
		        return size;
		    }
		
		    @Override
		    public void execute(GridPane grid) { }
		
		    @Override
		    public void move(GridPane grid) { }
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
		    
		    public Vector2 add(int x, int y) {
		        return new Vector2(this.x + x, this.y + y);
		    }
		    
		    public Vector2 add(Vector2 pos) {
		        return new Vector2(this.x + pos.getX(), this.y + pos.getY());
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
		import javafx.scene.layout.GridPane;
		import robotdefinitionsample.interfaces.IMoveable;
		
		public class Shelf extends Label implements IMoveable {
		    private Vector2 pos;
		    private Map<String, Property> properties;
		
		    public Shelf(String name, Vector2 pos) {
		        super(name);
		        this.pos = pos;
		        this.properties = new HashMap<>();
		    }
		
		    
		    public String getName() {
		        return this.getText();
		    }
		
		    public Vector2 getPos() {
		        return pos;
		    }
		
		    public Map<String, Property> getShelfProperties() {
		        return properties;
		    }
		    
		    public Property getProperty(String key){
		        return properties.get(key);
		    }
		
		    public void setPos(Vector2 pos) {
		        this.pos = pos;
		    }
		    
		    public void addProperty(String name, Property p) {
		        properties.put(name, p);
		    }
		
		    @Override
		    public void execute(GridPane grid) { }
		
		    @Override
		    public void move(GridPane grid) {
		        grid.getChildren().remove(this);
		        grid.add(this, this.getPos().getX(), this.getPos().getY());
		        System.out.println("X: " + this.getPos().getX() + " Y: " + this.getPos().getY());
		    }
		}
		'''
	}
}