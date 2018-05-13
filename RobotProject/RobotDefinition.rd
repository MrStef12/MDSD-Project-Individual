production MainTerminal

area ProductionFloor size 10 10
	obstacle Pole
		pos 2 2
		size 1 1
	endobstacle
	shelf TestShelf
		pos 0 2
		property PhysicalWeight default 100
	endshelf
endarea

terminatable WeightTooHigh

task goToShelf
	turn right
	forward 2
	if at TestShelf
		pickup
		turn left
		forward 1
		turn left
		forward 2
		turn right
	else
		turn right
	endif
endtask

task turnTest
	turn right
	forward 2
	if at TestShelf
		pickup
		turn left
	else
		forward 5
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
	startpoint 0 0
	mission
		goToShelf
	endmission
endrobot