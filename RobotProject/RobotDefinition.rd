production MainTerminal

area ProductionFloor size 100 100
	obstacle Pole
		pos 2 2
		size 1 1
	endobstacle
	shelf MyShelf
		pos 20 20
		property PhysicalWeight default 100
	endshelf
endarea

task goToShelf
	forward 20
	if at MyShelf
		turn left
		backward 10
	else
		turn right
	endif
endtask