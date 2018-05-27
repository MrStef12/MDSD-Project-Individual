RobotDefinition for MainTerminal

area ProductionFloor size 10 10
	obstacle Pole
		pos 2 2
		size 1 1
	endobstacle
	pickupable TestShelf
		pos 2 0
		property PhysicalWeight default 100
	endpickupable
	pickupable TestShelf2
		pos 2 0
		property PhysicalWeight default 200
	endpickupable
endarea

task driveShelfToRight
	pickup
	if picked up PhysicalWeight > 99
		backward 1
		forward 1
	else
		forward 1
		backward 1
	endif
	turn right
	forward 1
	setdown
	backward 1
	turn left
endtask

robot Rob1
	startpoint 0 0
	path
		forward 5
	endpath
	mission
		when at pickupable TestShelf
			do driveShelfToRight
		end
	endmission
endrobot

robot Rob2
	startpoint 0 1
	path
		forward 5
		backward 2
	endpath
	mission
		when at pos 0 1
			wait until pickupable TestShelf at 2 1 for 20 seconds or cancel
		end
		when at pickupable TestShelf
			pickup
		end 
	endmission
endrobot