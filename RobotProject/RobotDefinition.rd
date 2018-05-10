production MainTerminal

area ProductionFloor size 10 20
	obstacle Pole
		pos 2 2
		size 1 1
	endobstacle
	shelf TestShelf
		pos 20 20
		property PhysicalWeight default 100
	endshelf
endarea

terminatable WeightTooHigh

task goToShelf
	forward 20
	if at TestShelf
		turn left
		backward 10
	else
		turn right
	endif
endtask

task driveShelf
	pickup
	if at TestShelf
		if pickedUp PhysicalWeight < 130
			turn left
			backward 20
		else
			terminate WeightTooHigh
		endif
	endif
endtask

robot Rob1 in ProductionFloor
	startpoint 20 10
	mission
		goToShelf terminated {
			WeightTooHigh {
				if retries < 100
					retry
				else
					do goToShelf
				endif
				// other things
			}
			// other terminatables
		}
		driveShelf
	endmission
endrobot