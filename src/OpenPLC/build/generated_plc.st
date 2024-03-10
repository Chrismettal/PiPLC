PROGRAM MAIN
  VAR
    Input_I1_S0Powermeter AT %IX0.0 : BOOL;
    Input_I2_LightSwitch AT %IX0.1 : BOOL;
    Input_I3_EstopNO AT %IX0.2 : BOOL;
    Input_I4_EstopNC AT %IX0.3 : BOOL;
    Input_I5_ToggleLeft AT %IX0.4 : BOOL;
    Input_I6_ToggleRight AT %IX0.5 : BOOL;
    Input_I7_ButtonGreen AT %IX0.6 : BOOL;
    Input_I8_ButtonRed AT %IX0.7 : BOOL;
    Output_Q1_230vLight AT %QX0.0 : BOOL;
    Output_Q2 AT %QX0.1 : BOOL;
    Output_Q3_StacklightGreen AT %QX0.2 : BOOL;
    Output_Q4_StacklightYellow AT %QX0.3 : BOOL;
    Output_Q5_StacklightRed AT %QX0.4 : BOOL;
    Output_Q6 AT %QX0.5 : BOOL;
    Output_Q7 AT %QX0.6 : BOOL;
    Output_Q8 AT %QX0.7 : BOOL;
    PWM_0_LED1 AT %QW0 : UINT;
    PWM_1_LED2 AT %QW1 : UINT;
    ModIO_Q1 AT %QX100.0 : BOOL;
    ModIO_Q2 AT %QX100.1 : BOOL;
    ModIO_Q3 AT %QX100.2 : BOOL;
    ModIO_Q4 AT %QX100.3 : BOOL;
  END_VAR
  VAR
    InitDone : BOOL := FALSE;
    CurrentPower : REAL;
    msSinceLastEdge : REAL;
    S0Timer : TON;
    rtrigLightSwitch : R_TRIG;
    MachineRunning : BOOL := FALSE;
    tonBlinker : TON;
    Blinker : BOOL := FALSE;
    rtrigStepModRelay : R_TRIG;
    ActiveRelay : USINT := 0;
  END_VAR

  (* This is a testing program to test most functions on a PiPLC                                      *)
  (* Make sure to activate the "Binary-6 PiPLC" hardware layer on your PLC before uploading this code *)

  IF NOT InitDone THEN
    (* Oneshots at init *)
      
    (* Set InitDone so we execute cyclic tasks starting next scan *)
    InitDone := TRUE;

  ELSE
    (*----------------------------------------*)
    (* Cyclic calls after init oneshots       *)
    (*----------------------------------------*)
    (* Global blinker *)
    tonBlinker(IN := NOT tonBlinker.Q, PT := T#500ms);
    IF tonBlinker.Q THEN
      Blinker := NOT Blinker;
    END_IF;
    
    (* "Safety" handling (Yeah, not real safety, but bear with me) *)  
    IF NOT (Input_I3_EstopNO AND NOT Input_I4_EstopNC) THEN
      (* If either of the Estop channels fail, kill all power outputs *)
      Output_Q1_230vLight         := FALSE;
      Output_Q2                   := FALSE;
      Output_Q6                   := FALSE;
      Output_Q7                   := FALSE;
      Output_Q8                   := FALSE;
      
      ModIO_Q1    := FALSE;
      ModIO_Q2    := FALSE;
      ModIO_Q3    := FALSE;
      ModIO_Q4    := FALSE;
      
      PWM_0_LED1  := 0;
      PWM_1_LED2  := 0;
      
      ActiveRelay := 0;
      
      (* Update stacklight *)
      Output_Q3_StacklightGreen   := FALSE;
      Output_Q4_StacklightYellow  := FALSE;
      Output_Q5_StacklightRed     := Blinker;
      
    ELSE
      (* As long as Estop is good, execute regular logic *)
      
      (* S0 Current Power for 1000 imp/kWh meter*)
      (* PowerInW := 1000ms / TimeSinceLastEdge in ms * 60 s * 60 min * 1000 / 1000 imp/kwh *)
      S0Timer(IN := NOT Input_I1_S0PowerMeter, PT := T#600S);
      msSinceLastEdge := TIME_TO_REAL(S0Timer.ET);
      CurrentPower := 1000.0 / msSinceLastEdge * 3600.0;
              
                    
      (* Light switch toggle*)
      rtrigLightswitch(CLK := Input_I2_LightSwitch);
      IF rtrigLightswitch.Q THEN
        Output_Q1_230vLight := NOT Output_Q1_230vLight;
      END_IF;

              
      (*----------------------------------------*)
      (* Machine Automode                       *)
      (*----------------------------------------*)
      (* Buttons to start / stop machine *)
      MachineRunning := MachineRunning OR      Input_I7_ButtonGreen;
      MachineRunning := MachineRunning AND NOT Input_I8_ButtonRed;
      (* Automode vs Manual mode *)
      IF MachineRunning THEN
        (* Show running state in stacklight *)
        Output_Q3_StacklightGreen   := TRUE;
        Output_Q4_StacklightYellow  := FALSE;
        Output_Q5_StacklightRed     := FALSE;
      
        (* Dimming lights *)
        PWM_0_LED1 := PWM_0_LED1 + 1000;
        IF PWM_0_LED1 > 64000 THEN
          PWM_0_LED1 := 0;
        END_IF;
        PWM_1_LED2 := 65535 - PWM_0_LED1;
        
        
        (* Modbus IO *)
        rtrigStepModRelay(CLK := Blinker);
        IF rtrigStepModRelay.Q THEN
          
          ActiveRelay := ActiveRelay + 1;
          
          IF ActiveRelay > 4 THEN
            ActiveRelay := 1;
          END_IF;
          
          ModIO_Q1    := ActiveRelay = 1;
          ModIO_Q2    := ActiveRelay = 2;
          ModIO_Q3    := ActiveRelay = 3;
          ModIO_Q4    := ActiveRelay = 4;
        END_IF;
        
        (* Modbus temp probe *)
        
        
        (* 1-Wire temp probe *)
        
        
        (* Arduino Slave *)
        
        
        (* I²C Servos *)
        
        
        (* EtherCAT *) 
        
      ELSE
        (* Show idle state in stacklight *)
        Output_Q3_StacklightGreen   := FALSE;
        Output_Q4_StacklightYellow  := Blinker;
        Output_Q5_StacklightRed     := FALSE;
      END_IF;
              
    END_IF;
    
  END_IF;
END_PROGRAM


CONFIGURATION Config0

  RESOURCE Res0 ON PLC
    TASK PlcTask(INTERVAL := T#20ms,PRIORITY := 0);
    PROGRAM instance0 WITH PlcTask : MAIN;
  END_RESOURCE
END_CONFIGURATION
