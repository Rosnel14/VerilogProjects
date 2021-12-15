module GameFSM(LEDR,SW); 

	output [17:0]LEDR; 
	input [17:0]SW; 
	
	//North
	/*input SW[1]; //South 
	input SW[2]; //West 
	input SW[3]; //East 
	input KEY[0]; //clock 
	input KEY[1]; //reset 
	*/
	
	
	wire swordWire;  
	
	roomStateMachine machine0(LEDR,SW[0],SW[1],SW[2],SW[3],swordWire,SW[4],SW[5]);
	swordStateMachine machine1(swordWire, LEDR, SW[4], SW[5]); 
	

endmodule

//this manages the position of the player 
module roomStateMachine(out,North,South,West,East,swordbit,clk,reset); 

output reg [2:0]out; 
 
input North, South, West, East; //user defined direction ([3:0]SW) probably 
input swordbit; //input from output of sword-state machine 
input reset; // user defined reset signal 
input clk;  

// state registers 
reg [2:0]state;  
reg [2:0]nextstate; 
 
// state encodings 
parameter S0 = 3'b000, S1=3'b001, S2=3'b010, S3=3'b011, S4=3'b100, S5=4'b101, S6=4'b110;

//key for state encodings
// 000 = cave 
// 001 = tunnel 
// 010 = River 
// 011 = stash 
// 100 = den 
// 101 = graveyard 
// 110 = vault  
  
 
// compute output 
always @ (state) 
begin 
  case (state) //oops, gotta make outbit a three bit signal, or not? 
    S0: 
		 out = S0; 
    S1: 
       out = S1;
    S2: 
       out = S2;
	 S3: 
		 out = S3;               
	 S4: 
		 out = S4; 
	 S5: 
		 out = S5;
	 S6: 
		 out = S6;
	default:
		out = S0; 
  endcase 
end 
 
 
 //compute next state 

always@(North or South or West or East or swordbit)begin 
		
	case(state) 
    S0: //cave   
      if(East) 
          nextstate = S1; 
      else 
          nextstate = S0;
	 S1: //tunnel 
		if(West)
			nextstate = S0; 
		else if(South)
			nextstate = S2; 
		else 
			nextstate = S1; 
	 S2: //River 
		if(North)
			nextstate = S1; 
		else if(West)
			nextstate = S3; 
		else if(East)
			nextstate = S4; 
		else 
			nextstate = S2; 
	 S3: //stash 
		if(East)
			nextstate = S2; 
		else 
			nextstate = S3; 
	 S4: //den 
		if(West)
			nextstate = S2; 
		else if(East & swordbit)
			nextstate = S6; 
		else if((East) & (~swordbit))
			nextstate = S5; 
		else 
			nextstate = S4; 
	 S5: 
		nextstate = S5; 
	 S6: 
		nextstate = S6; 
			
  endcase 
end 

// advance or reset the state 
always @ (posedge clk or posedge reset) 
begin 

  if(reset) 
      state <= S0; 
  else 
      state <= nextstate; 
end
endmodule 



//this manages the possession of the sword - working 12/7/21 
module swordStateMachine(out, roomInput, clk, reset); 

output reg out; //output 
input [2:0]roomInput; //this returns the state of the room state machine 
input clk; //clock for advancement 
input reset; //reset pin to start over 
 
// state registers 
reg state;  
reg nextstate; 
 
// state encodings 
parameter S0 = 0, S1=1; 
 
// compute output 
always @ (state) 
begin 
  case (state) 
    S0: 
        out = S0; 
    S1: 
        out = S1; 
    default: 
        out = S0; 
  endcase 
end 
 
// compute next state 
always @ (state or roomInput) 
begin 
  case(state) 
    S0:  
      if(roomInput == 3'b011) 
          nextstate = S1; 
      else 
          nextstate = S0;
	 S1: 
		nextstate = S1; 
  endcase 
end 
 
// advance or reset the state 
always @ (posedge clk or posedge reset) 
begin 

  if(reset) 
      state <= S0; 
  else 
      state <= nextstate; 
end

endmodule
