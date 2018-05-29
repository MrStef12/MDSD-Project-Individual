package dk.sdu.mmmi.mdsd.project.generator

import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.IFileSystemAccess2
import org.eclipse.xtext.generator.IGeneratorContext
import java.util.List
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
import dk.sdu.mmmi.mdsd.project.dSL.Path
import dk.sdu.mmmi.mdsd.project.dSL.Mission
import dk.sdu.mmmi.mdsd.project.dSL.WhenTrigger
import dk.sdu.mmmi.mdsd.project.dSL.WhenAtPos
import dk.sdu.mmmi.mdsd.project.dSL.WhenAtPickupable
import dk.sdu.mmmi.mdsd.project.dSL.MissionTriggerAction
import dk.sdu.mmmi.mdsd.project.dSL.WaitAction
import dk.sdu.mmmi.mdsd.project.dSL.TaskItem
import dk.sdu.mmmi.mdsd.project.dSL.ForTime
import dk.sdu.mmmi.mdsd.project.dSL.UntilRobot
import dk.sdu.mmmi.mdsd.project.dSL.UntilPickupable
import dk.sdu.mmmi.mdsd.project.dSL.Until
import dk.sdu.mmmi.mdsd.project.dSL.Seconds
import dk.sdu.mmmi.mdsd.project.dSL.Minutes
import dk.sdu.mmmi.mdsd.project.dSL.Cancel
import dk.sdu.mmmi.mdsd.project.dSL.WhenAtTrigger
import dk.sdu.mmmi.mdsd.project.dSL.Setdown

class MissionGenerator {
	
	CharSequence previousTaskItem;
	
	new (Resource resource, IFileSystemAccess2 fsa, IGeneratorContext context) {
		var robots = resource.allContents.filter(Robot).toList
		fsa.generateFile('/src/robotdefinitionsample/MissionGenerator.java', robots.generateMissionGenerator)
	}
	
	def generateMissionGenerator(List<Robot> robots) {
		'''
			package robotdefinitionsample;
			
			import java.util.ArrayList;
			import java.util.LinkedList;
			import java.util.List;
			import java.util.Map;
			import javafx.scene.layout.GridPane;
			import robotdefinitionsample.interfaces.ICondition;
			import robotdefinitionsample.interfaces.ITaskFetcher;
			import robotdefinitionsample.interfaces.TaskItem;
			import robotdefinitionsample.interfaces.TriggerItem;
			import robotdefinitionsample.models.Mission;
			import robotdefinitionsample.models.Pickupable;
			import robotdefinitionsample.models.Vector2;
			import robotdefinitionsample.models.taskitems.*;
			import robotdefinitionsample.models.triggerItems.*;
			
			public class MissionGenerator {
				«FOR robot : robots»
				public Mission «robot.name»(GridPane grid) {
					List<TaskItem> items = new ArrayList<>();
					List<TriggerItem> triggers = new ArrayList<>();
					
					«robot.path.generatePath»
					«robot.mission.generateTriggers»
					
					return new Mission(new LinkedList<>(items), new LinkedList<>(triggers));
				}
				«ENDFOR»
			}
		'''
	}
	
	def generatePath(Path path)
		'''
		«FOR item : path.items»
		«item.generateTaskItem»
		«ENDFOR»
		'''
	
	def generateTaskItems(Task task)
		'''
		«FOR item : task.items»
		«item.generateTaskItem»
		«ENDFOR»
		'''
	
	def generateTriggers(Mission mission)
		'''
		«FOR trigger : mission.triggers»
		«trigger.generateTrigger»
		«ENDFOR»
		'''
		
	def generateTrigger(WhenTrigger when)
		'''
		triggers.add(new «when.trigger.generateTriggerType», new ITaskFetcher() {
			@Override
			public void addTasks(List<TaskItem> items) {
			    «FOR item : when.items»
			    «item.generateMissionTriggerAction»
			    «ENDFOR»
			}
		}));
		'''
	
	def generateTriggerType(WhenAtTrigger when) {
		switch when {
			WhenAtPos: '''WhenAtPos(new Vector2(«when.pos.x», «when.pos.y»)'''
			WhenAtPickupable: '''WhenAtPickupable("«when.pickupable.name»"''' 
		}
	}
	
	def generateMissionTriggerAction(MissionTriggerAction action) {
		switch action {
			WaitAction: action.generateWaitAction
			TaskItem: action.generateTaskItem
		}
	}
	
	def dispatch generateWaitAction(ForTime time) 
		'''
		items.add(new WaitFor(«time.time.time»));
		'''
	
	def dispatch generateWaitAction(UntilRobot until)
		'''
		items.add(new WaitUntilRobot("«until.robot.name»", new Vector2(«until.pos.x», «until.pos.y»)«until.generateUntilOr»));
		'''
	
	def dispatch generateWaitAction(UntilPickupable until)
		'''
		items.add(new WaitUntilPickupable("«until.pickupable.name»", new Vector2(«until.pos.x», «until.pos.y»)«until.generateUntilOr»));
		'''
	
	def generateUntilOr(Until until) {
		if (until.time !== null) {
			var time = 0
			switch until.time.time {
				Seconds: time = until.time.time.time
				Minutes: time = until.time.time.time * 60
			}
			var or = 'Constants.OR.'
			switch until.or {
				Cancel: or = or + 'CANCEL'
				Terminate: or = or + 'TERMINATE'
			}
			''', «time», «or»'''
		}
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
					items.add(new «action.generateTaskItemInstance»);
				'''
		}
	}
	
	def generateTaskItemInstance(Action action) {
		switch(action) {
			Pickup: '''Pickup()'''
			Setdown: '''Setdown()'''
			Forward: '''Forward(«action.amount»)'''
			Backward: '''Backward(«action.amount»)'''
			Turn: '''Turn(«action.direction.turnDir»)'''
		}
	}
	
	def getTurnDir(Direction dir) {
		switch (dir) {
			LeftDir: "true"
			RightDir: "false"
		}
	}
	
	def dispatch CharSequence generateTaskItem(Condition condition) {
		val ifTasks = condition.tasks;
		val elseTasks = if(condition.getElse !== null) condition.getElse.tasks;
		'''
			items.add(new Condition(new ICondition() {
			    @Override
			    public boolean checkCondition(int retries, Pickupable shelf, Map<String, Integer> properties) {
			        return «condition.state.generateState»
			    }
			})
			.setIfTaskItems(
				new ITaskFetcher() {
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
				new ITaskFetcher() {
					@Override
					public void addTasks(List<TaskItem> items) {
    					«FOR task : elseTasks»
    					«task.generateTaskItem»
    					«ENDFOR»
					}
				}
			)«ENDIF»
			);
		'''
	}
	
	def dispatch generateState(StatePickedUp state)
	'''
	properties.containsKey("«state.prop.name»") ? properties.get("«state.prop.name»") «state.sign.displaySign» «state.right.displayExp» : false;
	'''
	
	def dispatch generateState(Expression state) { state.displayExp }
	
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