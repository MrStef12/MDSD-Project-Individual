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
	}
	
	def generateMissionGenerator() {
		val robots = resource.allContents.filter(Robot).toList;
		'''
			package robotdefinitionsample.models;
			
			import javafx.scene.layout.GridPane;
			
			public class MissionGenerator {
				«FOR robot : robots»
				public Mission «robot.name»(Robot r, GridPane grid) {
					Mission mission = new Mission(grid);
					«FOR missionTask : robot.mission.tasks»
					Task «missionTask.task.name» = new Task("«missionTask.task.name»");
					«missionTask.task.generateTaskItems»
					mission.addTask(«missionTask.task.name»);
					«ENDFOR»
					return mission;
				}
				«ENDFOR»
			}
		'''
	}
	
	def CharSequence generateTaskItems(Task task) {
		'''
			«FOR item : task.items»
			«item.generateTaskItem»
			«ENDFOR»
		'''
	}
	
	def dispatch generateTaskItem(Action action) {
		switch (action) {
			Retry: 
				previousTaskItem
			DoTask: 
				previousTaskItem = action.task.generateTaskItems
			default:
				previousTaskItem =
				'''
					t.addTask(new TaskItem(r, ActionCondition.«action.toEnumName»));
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
	
	def dispatch generateTaskItem(Condition condition) {
		val ifTasks = condition.tasks;
		val elseTasks = if(condition.getElse !== null) condition.getElse.tasks;
		'''
			t.addTask(new TaskItem(r, ActionCondition.CONDITION)
				«condition.state.generateState»
				.setIfTaskItems(
					«FOR task : ifTasks»
					«task.generateTaskItem»
					«ENDFOR»
				)
				«IF elseTasks !== null»
				.setElseTaskItems(
					«FOR task : elseTasks»
					«task.generateTaskItem»
					«ENDFOR»
				)
				«ENDIF»
			;
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