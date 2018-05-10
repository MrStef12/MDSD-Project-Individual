package dk.sdu.mmmi.mdsd.project.generator

import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.IFileSystemAccess2
import org.eclipse.xtext.generator.IGeneratorContext
import dk.sdu.mmmi.mdsd.project.dSL.Robot
import dk.sdu.mmmi.mdsd.project.dSL.Action
import dk.sdu.mmmi.mdsd.project.dSL.Condition
import dk.sdu.mmmi.mdsd.project.dSL.Pickup
import dk.sdu.mmmi.mdsd.project.dSL.Forward
import dk.sdu.mmmi.mdsd.project.dSL.Backward
import dk.sdu.mmmi.mdsd.project.dSL.Turn
import dk.sdu.mmmi.mdsd.project.dSL.Direction
import dk.sdu.mmmi.mdsd.project.dSL.LeftDir
import dk.sdu.mmmi.mdsd.project.dSL.RightDir
import dk.sdu.mmmi.mdsd.project.dSL.Retry
import dk.sdu.mmmi.mdsd.project.dSL.DoTask
import dk.sdu.mmmi.mdsd.project.dSL.Task
import dk.sdu.mmmi.mdsd.project.dSL.Terminate
import dk.sdu.mmmi.mdsd.project.dSL.State
import dk.sdu.mmmi.mdsd.project.dSL.StateAt
import dk.sdu.mmmi.mdsd.project.dSL.Sign
import dk.sdu.mmmi.mdsd.project.dSL.Equals
import dk.sdu.mmmi.mdsd.project.dSL.SmallerThan
import dk.sdu.mmmi.mdsd.project.dSL.SmallerThanEquals
import dk.sdu.mmmi.mdsd.project.dSL.GreaterThan
import dk.sdu.mmmi.mdsd.project.dSL.GreaterThanEquals
import dk.sdu.mmmi.mdsd.project.dSL.Plus
import dk.sdu.mmmi.mdsd.project.dSL.Minus
import dk.sdu.mmmi.mdsd.project.dSL.Mult
import dk.sdu.mmmi.mdsd.project.dSL.Div
import dk.sdu.mmmi.mdsd.project.dSL.Num
import dk.sdu.mmmi.mdsd.project.dSL.StatePickedUp
import dk.sdu.mmmi.mdsd.project.dSL.StateRetries
import dk.sdu.mmmi.mdsd.project.dSL.Expression
import dk.sdu.mmmi.mdsd.project.dSL.MissionTask
import dk.sdu.mmmi.mdsd.project.dSL.TaskTerminated

class MissionGeneratorGenerator {
	
	private Resource resource;
	private IFileSystemAccess2 fsa;
	private IGeneratorContext context;
	private CharSequence previousTaskItem;
	
	new (Resource resource, IFileSystemAccess2 fsa, IGeneratorContext context) {
		this.resource = resource
		this.fsa = fsa
		this.context = context
		
		fsa.generateFile('/src/robotdefinitionsample/models/MissionGenerator.java', generateMissionGenerator)
		fsa.generateFile('/src/robotdefinitionsample/models/Mission.java', generateMission)
	}
	
	def generateMission() {
		'''
		/*
		 * To change this license header, choose License Headers in Project Properties.
		 * To change this template file, choose Tools | Templates
		 * and open the template in the editor.
		 */
		package robotdefinitionsample.models;
		
		import java.util.ArrayList;
		import java.util.List;
		import java.util.Map;
		import javafx.scene.control.Alert;
		import javafx.scene.layout.GridPane;
		import robotdefinitionsample.DesiredProps;
		import robotdefinitionsample.exceptions.InvalidMove;
		import robotdefinitionsample.ObstacleDetection;
		import robotdefinitionsample.exceptions.NoShelfPickedUp;
		import robotdefinitionsample.exceptions.PropertyNotSet;
		
		/**
		 *
		 * @author ditlev
		 */
		public class Mission {
		    private List<Task> mission;
		    private int currentTask;
		    private boolean done;
		    private boolean failed;
		    private GridPane grid;
		    
		    public Mission(GridPane grid) {
		        mission = new ArrayList<>();
		        currentTask = 0;
		        done = false;
		        failed = false;
		        this.grid = grid;
		    }
		    
		    public boolean isDone() {
		        return done;
		    }
		    
		    public void addTask(Task t) {
		        mission.add(t);
		    }
		    
		    public void addTaskAtCurrent(TaskItem t) {
		        mission.get(currentTask).addTaskAtCurrent(t);
		    }
		    
		    public Task getCurrentTask() {
		        return mission.get(currentTask);
		    }
		    
		    public void executeNext(DesiredProps props) {
		        Task t = getCurrentTask();
		        
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
		            
		            if (t.getRetries() < 3) {
		                t.setRetry(true);
		            } else {
		                missionFailed();
		            }
		            
		        } catch(NoShelfPickedUp e) {
		            Alert alert = new Alert(Alert.AlertType.INFORMATION);
		            alert.setTitle("No shelf");
		            alert.setHeaderText("Robot cannot execute task");
		            alert.setContentText("The robot did not have a shelf picked up");
		            alert.showAndWait();
		        }
		    	«FOR e : resource.allContents.filter(MissionTask).toList»
		    		«IF e.terminated !== null»
		    			catch («e.terminated.terminatable.name» e) {
		    				«e.terminated.generateTaskItems»
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
		
		    private void missionFailed() {
		        failed = true;
		    }
		    
		    public boolean getFailed() {
		        return failed;
		    }
		    
		    //Called from TaskItem conditionAt()
		    public boolean collision(String shelfName, DesiredProps props) {
		        Shelf s = ObstacleDetection.getShelfAtPos(grid, props);
		        if (s != null) {
		            if (s.getName().equals(shelfName)) {
		                return true;
		            }
		            return false;
		        }
		        return false;
		    }
		}
		
		'''
	}
	
	def generateMissionGenerator() {
		val robots = resource.allContents.filter(Robot).toList;
		'''
			package robotdefinitionsample.models;
			
			import java.util.List;
			import java.util.Map;
			import javafx.scene.layout.GridPane;
			
			public class MissionGenerator {
				«FOR robot : robots»
				public Mission «robot.name»(Robot r, GridPane grid) {
					Mission mission = new Mission(grid);
					Task items;
					«FOR missionTask : robot.mission.tasks»
					items = new Task("«missionTask.task.name»");
					«missionTask.task.generateTaskItems»
					mission.addTask(«missionTask.task.name»);
					«ENDFOR»
					return mission;
				}
				«ENDFOR»
			}
		'''
	}
	
	def dispatch CharSequence generateTaskItems(Task task) {
		'''
			«FOR item : task.items»
			«item.generateTaskItem»
			«ENDFOR»
		'''
	}
	
	def dispatch CharSequence generateTaskItems(TaskTerminated task) {
		'''
		«FOR item : task.items»
		addTaskAtCurrent(«item.generateTaskItem.toString.substring(10)»);
		«ENDFOR»
		'''
	}
	
	def dispatch CharSequence generateTaskItem(Action action) {
		switch (action) {
			Retry: 
				previousTaskItem
			DoTask: 
				previousTaskItem = action.task.generateTaskItems
			default:
				previousTaskItem =
				'''
					items.add(new TaskItem(r, ActionCondition.«action.toEnumName»));
				'''
		}
	}
	
	def toEnumName(Action action) {
		switch(action) {
			Pickup: '''PICKUP'''
			Forward: '''FORWARD).setTicksToGo(«action.amount»'''
			Backward: '''BACKWARD).setTicksToGo(«action.amount»'''
			Turn: '''TURN_«action.direction.turnDir»'''
			Terminate: '''TERMINATE'''
		}
	}
	
	def getTurnDir(Direction dir) {
		switch (dir) {
			LeftDir: "CCW"
			RightDir: "CW"
		}
	}
	
	def dispatch CharSequence generateTaskItem(Condition condition) {
		val ifTasks = condition.tasks;
		val elseTasks = if(condition.getElse !== null) condition.getElse.tasks;
		'''
			items.add(new TaskItem(r, ActionCondition.CONDITION)
				«condition.state.generateState»
				.setIfTaskItems(
					new IConditionTasks() {
			            @Override
			            public void addTasks(List<TaskItem> items) {
			                «FOR task : ifTasks»
        					«task.generateTaskItem»
        					«ENDFOR»
			            }
			        }
				)
				«IF elseTasks !== null»
				.setElseTaskItems(
					new IConditionTasks() {
						@Override
						public void addTasks(List<TaskItem> items) {
        					«FOR task : elseTasks»
        					«task.generateTaskItem»
        					«ENDFOR»
						}
					}
				));
				«ENDIF»
		'''
	}
	
	def dispatch generateState(StateAt stateAt) 
	'''
		.setAtShelfName("«stateAt.shelf.name»")
	'''
	
	def dispatch generateState(StatePickedUp state)
	'''
		.setConditionChecker(new ICondition() {
		    @Override
			public boolean checkCondition(int retries, Shelf shelf, Map<String, Property> properties) {
		        return properties.containsKey("«state.prop.name»") ? properties.get("«state.prop.name»").getDefault() «state.sign.displaySign» «state.right.displayExp» : false;
		    }
		})
	'''
	
	def dispatch generateState(Expression state)
	'''
		.setConditionChecker(new ICondition() {
		    @Override
			public boolean checkCondition(int retries, Shelf shelf, Map<String, Property> properties) {
		        return «state.displayExp»;
		    }
		})
	'''
	
	def displaySign(Sign s) {
		switch s {
			Equals : '''=='''
			SmallerThan : '''<'''
			SmallerThanEquals : '''<='''
			GreaterThan : '''>'''
			GreaterThanEquals : '''>='''
		}
	}
	
	def String displayExp(Expression exp) {
		"("+switch exp {
			State: exp.left.displayExp + exp.sign.displaySign + exp.right.displayExp
			Plus: exp.left.displayExp+"+"+exp.right.displayExp
			Minus: exp.left.displayExp+"-"+exp.right.displayExp
			Mult: exp.left.displayExp+"*"+exp.right.displayExp
			Div: exp.left.displayExp+"/"+exp.right.displayExp
			Num: Integer.toString(exp.value)
			StateRetries : "retries"
			default: throw new Error("Invalid expression")
		}+")"
	}
}