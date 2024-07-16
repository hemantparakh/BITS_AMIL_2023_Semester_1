% Start the expert system
start :-
    write('Welcome to the Expert System Simulator'), nl,
    ask_party.
% Helper to ask questions
ask(Question, Response) :-
    format('~w (yes/no): ', [Question]),
    read(TempResponse),
    (   
        TempResponse == yes ; TempResponse == no
    ),
    !,  % Cut to prevent backtracking
    Response = TempResponse.
ask(Question, Response) :-
    write('Invalid response. Please answer with yes or no.'), nl,
    ask(Question, Response).
	
% Question predicates with input validation
ask_party :-
    ask('Do you attend parties?', PartyResponse),
    ( 
        PartyResponse == yes -> ask_goal(party_yes);
        PartyResponse == no -> ask_goal(party_no)
    ).
ask_goal(Path) :-
    ask('Have you derived your project goal successfully?', GoalResponse),
    (
        Path == party_yes, GoalResponse == yes -> ask_laptop(goal_yes_party_yes);
        Path == party_yes, GoalResponse == no -> ask_smart(goal_no_party_yes);
        Path == party_no, GoalResponse == yes -> ask_laptop(goal_yes_party_no);
        Path == party_no, GoalResponse == no -> ask_laptop(goal_no_party_no)
    ).
ask_smart(Path) :-
    ask('Are you smart?', SmartResponse),
    (
        Path == goal_no_party_yes, SmartResponse == yes -> ask_laptop(smart_yes_goal_no_party_yes);
        Path == goal_no_party_yes, SmartResponse == no -> ask_assignment(smart_no_goal_no_party_yes)
    ).
ask_laptop(Path) :-
    ask('Do you have a laptop?', LaptopResponse),
    (
		Path == goal_yes_party_yes, LaptopResponse == yes -> ask_innovative(laptop_yes_goal_yes_party_yes);
		Path == goal_yes_party_yes, LaptopResponse == no -> ask_project(laptop_no_goal_yes_party_yes);	
		Path == goal_yes_party_no, LaptopResponse == yes -> ask_project(laptop_yes_goal_yes_party_no);
		Path == goal_yes_party_no, LaptopResponse == no -> ask_innovative(laptop_no_goal_yes_party_no);		
		Path == goal_no_party_no, LaptopResponse == yes -> ask_assignment(laptop_yes_goal_no_party_no);
		Path == goal_no_party_no, LaptopResponse == no -> ask_innovative(laptop_no_goal_no_party_no);
        Path == smart_yes_goal_no_party_yes, LaptopResponse == yes -> conclusion(yes);
        Path == smart_yes_goal_no_party_yes, LaptopResponse == no -> conclusion(yes)
    ).
ask_innovative(Path) :-
    ask('Are you innovative?', InnovativeResponse),
    (
		Path == laptop_yes_goal_yes_party_yes, InnovativeResponse == yes -> conclusion(yes);
        Path == laptop_yes_goal_yes_party_yes, InnovativeResponse == no -> conclusion(yes);	
		Path == laptop_no_goal_yes_party_no, InnovativeResponse == yes -> conclusion(no);
		Path == laptop_no_goal_yes_party_no, InnovativeResponse == no -> conclusion(yes);
		Path == laptop_no_goal_no_party_no, InnovativeResponse == yes -> conclusion(no);
        Path == laptop_no_goal_no_party_no, InnovativeResponse == no -> conclusion(no)
    ).
ask_project(Path) :-
    ask('Does your project succeed between 40-100?', ProjectResponse),
    (
		Path == laptop_no_goal_yes_party_yes, ProjectResponse == yes -> conclusion(yes);
        Path == laptop_no_goal_yes_party_yes, ProjectResponse == no -> conclusion(yes);
		Path == laptop_yes_goal_yes_party_no, ProjectResponse == yes -> conclusion(yes);
        Path == laptop_yes_goal_yes_party_no, ProjectResponse == no -> conclusion(yes)
    ).

ask_assignment(Path) :-
    ask('Will you be up-to-date to finish your assignments?', AssignmentResponse),
    (
        Path == smart_no_goal_no_party_yes, AssignmentResponse == yes -> conclusion(yes);
		Path == smart_no_goal_no_party_yes, AssignmentResponse == no -> conclusion(yes);
		Path == laptop_yes_goal_no_party_no, AssignmentResponse == yes -> conclusion(no);
		Path == laptop_yes_goal_no_party_no, AssignmentResponse == no -> conclusion(no)
    ).
% Conclusion based on final answer
conclusion(yes) :-
    write('Final Prediction: [Yes] you are happy/successful.'), nl.
conclusion(no) :-
    write('Final Prediction: [No] you are not happy/successful.'), nl.
% Run the expert system
:- start.
