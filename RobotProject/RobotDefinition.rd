RobotDefinition for MainTerminal

area ProductionFloor size 10 10
	obstacle Pole
		pos 2 2
		size 1 1
	endobstacle
	pickupable TestShelf
		pos 0 2
		property PhysicalWeight default 100
	endpickupable
endarea

task driveShelfToLeft
	pickup
	turn left
	forward 3
	setdown
	backward 3
	turn right
endtask

robot Rob1
	startpoint 0 0
	path
		forward 10
		turn left
		forward 2
	endpath
	mission
		when at pos 2 3
			wait for 2 seconds
			wait until robot Rob2 at 2 3 for 1 minutes or cancel
			do driveShelfToLeft
		end
		when at pickupable TestShelf
			wait for 2 seconds
		end
	endmission
endrobot

robot Rob2
	startpoint 2 2
	path
		
	endpath
	mission
	
	endmission
endrobot