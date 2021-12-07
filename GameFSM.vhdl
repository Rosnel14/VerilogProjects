module GameFSM(); 

endmodule

//this will manage the interpretation of states from the room 
// state machine 
// likely going to be a 3-7 decoder 
module stateDecoder(); 

endmodule 

//this manages the position of the player 
module roomStateMachine(N); 

endmodule 


//this manages the possession of the sword 
module swordStateMachine(); 
nput clk, in ,reset, 
 utput reg out 
); 
 
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
always @ (state or in) 
begin 
  case(state) 
    S0:  
      if(in) 
          nextstate = S1; 
      else 
          nextstate = S0; 
    S1: 
      if(in) 
          nextstate = S1; 
      else 
          nextstate = S0; 
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
