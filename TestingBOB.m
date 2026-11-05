
%brick = ConnectBrick('BOB');
%States list:
%   turning left: "execute left turn"
%   turning right: "execute right turn"br
%   manual control: "manual nav"
%   regular navigation: "reg nav"
%
%
%Initial variables:
global key;
InitKeyboard();
state = "manual nav";
leftMotor = 'D';
rightMotor = 'A';
clawMotor = 'C';
regSpeed = 60;
manualTurnSpeed = 20;
colorPort = 4;
touchPort = 2;
distancePort = 3;
seenBlue = false;  %2
seenGreen = false;  %3
seenYellow = false;  %4  & red is 5
blue = 2;
green = 3;
yellow = 4;
red = 5;
brick.beep();
%Main loop:
while 1
 %Regular decision loop:
 while state == "reg nav"
    %Update variables:
    distance = brick.UltrasonicDist(distancePort);
    touch = brick.TouchPressed(touchPort);
    color = brick.ColorCode(colorPort);
    % State conversion check:
    if key == 'm'
       state = "manual nav";
       break;
    end
   %Color decision logic: vvvvvvvvvvvvvv
   if color == red  %Check for red:
       %temp beeping logic:
       brick.beep();
       pause(.5);
       brick.beep();
       disp('red sensed');
       brick.StopAllMotors();
       pause(1);
       brick.MoveMotor(leftMotor, -regSpeed);
       brick.MoveMotor(rightMotor, -regSpeed);
       pause(.5);
   end
   if ~seenBlue   %seeking blue
       if color == blue
           %temp beeping logic:
           brick.beep();
           pause(.5);
           brick.beep();
           seenBlue = true;
           state = "manual nav";
           break;
       end
   elseif ~seenGreen    %seeking green
        if color == green
           %temp beeping logic:
           brick.beep();
           pause(.5);
           brick.beep();
           seenGreen = true;
           state = "manual nav";
           break;
        end
   elseif ~seenYellow   %seeking yellow
       if color == yellow
           %temp beeping logic:
           brick.beep();
           pause(.5);
           brick.beep();
           seenYellow = true;
           break;
       end
   end
   % End color dicision logic: ^^^^^^^^^^^^^^
   %Wall and touch sensing logic (within loop):
   display(distance);
   if touch
         brick.StopMotor(rightMotor);
         brick.StopMotor(leftMotor);
         state = "execute right turn";
   elseif distance > 12 && distance < 25  %move away from wall
         brick.MoveMotor(rightMotor, -regSpeed-10);
         brick.MoveMotor(leftMotor, -regSpeed);
         pause(0.15);
         brick.MoveMotor(rightMotor, -regSpeed);
         brick.MoveMotor(leftMotor, -regSpeed-10);
         pause(0.1);
   elseif distance < 12  %move towards wall
         brick.MoveMotor(leftMotor, -regSpeed-15);
         brick.MoveMotor(rightMotor, -regSpeed);
         pause(0.15);
         brick.MoveMotor(leftMotor, -regSpeed);
         brick.MoveMotor(rightMotor, -regSpeed-5);
         pause(0.1);
   elseif distance > 25  % execute left turn
         state = "execute left turn";
   end
  
 end 
%End reg nav while loop ^^
%Execute right turn (no loop for right turn):
if state == "execute right turn"
     brick.MoveMotor(rightMotor, 50);
     brick.MoveMotor(leftMotor, 50);
     pause(0.3);
     brick.StopAllMotors();
     brick.MoveMotorAngleRel(rightMotor, 60, 230, 'Brake')
     brick.MoveMotorAngleRel(leftMotor, -60, 230, 'Brake');    
     brick.WaitForMotor(leftMotor);
     brick.WaitForMotor(rightMotor);     
     state = "reg nav";
%Execute left turn loop:
 elseif state == "execute left turn"
     while state == "execute left turn"
         %Update variables:
         color = brick.ColorCode(colorPort);
         touch = brick.TouchPressed(touchPort);
         distance = brick.UltrasonicDist(distancePort);
         display(state);
         display(distance);
       
         % State conversion check:
         if key == 'm'                % to exit to manual
             state = "manual nav";
         end
         if distance <= 20 || touch   % to exit to reg nav
             brick.StopAllMotors();
             state = "reg nav";
         end
       %Color decision check: vvvvvvvvvvvvvv
       if color == red  %Check for red:
           %temp beeping logic:
            brick.beep();
            pause(.5);
            brick.beep();
            disp('red sensed');
            brick.StopAllMotors();
            pause(1);
            brick.MoveMotor(leftMotor, -regSpeed);
            brick.MoveMotor(rightMotor, -regSpeed);
            pause(.5);
       end
       if ~seenBlue   %seeking blue
           if color == blue
               %temp beeping logic:
               brick.beep();
               pause(.5);
               brick.beep();
               seenBlue = true;
               state = "manual nav";
               break;
           end
       elseif ~seenGreen    %seeking green
            if color == green
               %temp beeping logic:
               brick.beep();
               pause(.5);
               brick.beep();
               seenGreen = true;
               state = "manual nav";
               break;
            end
       elseif ~seenYellow   %seeking yellow
           if color == yellow
               %temp beeping logic:
               brick.beep();
               pause(.5);
               brick.beep();
               seenYellow = true;
               break;
           end
       end
       % End color dicision check: ^^^^^^^^^^^^^^
       % Turn left:
         brick.MoveMotor(rightMotor, -60);
         brick.MoveMotor(leftMotor, -10);
         pause(0.2);
     end  % <-- Left turn while loop exit
     %Move straight for a bit after state change:
     brick.MoveMotor(rightMotor, -20);
     brick.MoveMotor(leftMotor, -20);
     pause(0.3);
end   % <-- Left/right turn logic exit
%Manual navigation loop:
     while (state == "manual nav")
         %Update variables (no distance or
         pause(0.1);
         color = brick.ColorCode(colorPort);
         disp(color);
       
          %Color decision logic: vvvvvvvvvvvvvv
          if color == red  %Check for red:
                disp('red sensed');
                brick.StopAllMotors();
                pause(1);
                brick.MoveMotor(leftMotor, -regSpeed);
                brick.MoveMotor(rightMotor, -regSpeed);
                pause(.5);
          end
          display(color);
           if ~seenBlue   %seeking blue
               if color == blue
                   %temp beeping logic:
                   brick.StopAllMotors();
                   brick.playTone(100, 1000, 500);
                   pause(.5);
                   brick.playTone(100, 1000, 500);
                    seenBlue = true;
                   state = "manual nav";
               end
            elseif ~seenGreen    %seeking green
                if color == green
                   %temp beeping logic:
                   brick.StopAllMotors();                   
                   brick.playTone(100, 1000, 500);
                   pause(.5);
                   brick.playTone(100, 1000, 500);
                   pause(.5);
                   brick.playTone(100, 1000, 500);
                    seenGreen = true;
                   state = "manual nav";
                end
           elseif ~seenYellow   %seeking yellow
               if color == yellow
                   seenYellow = true;
               end
           end
           % End color dicision logic: ^^^^^^^^^^^^^^
         switch key
             case 'p'
                 brick.MoveMotorAngleRel(rightMotor, 100, 700, 'Brake')
                 brick.MoveMotorAngleRel(leftMotor, -100, 700, 'Brake');
            
                 brick.WaitForMotor(leftMotor);
                 brick.WaitForMotor(rightMotor);
             case 'o'
                 brick.MoveMotor(leftMotor, -20);
                 brick.MoveMotorAngleRel(rightMotor, -60, 720, 'Brake');
              
                 brick.WaitForMotor(rightMotor);
             case 'downarrow'
                 disp('Up Arrow Pressed!');
                 brick.MoveMotor(rightMotor, manualTurnSpeed);
                 brick.MoveMotor(leftMotor, manualTurnSpeed);
                 pause(.1);
             case 'uparrow'
                 disp('Down Arrow Pressed!');
                 brick.MoveMotor(rightMotor, -manualTurnSpeed);
                 brick.MoveMotor(leftMotor,-manualTurnSpeed);
                 pause(.1);
             case 'rightarrow'
                 disp('Right Arrow Pressed!');
                 brick.MoveMotor(rightMotor, manualTurnSpeed);
                 brick.MoveMotor(leftMotor, -manualTurnSpeed);
                 pause(.1);
             case 'leftarrow'
                 disp('Left Arrow Pressed!');
                 brick.MoveMotor(rightMotor, -manualTurnSpeed);
                 brick.MoveMotor(leftMotor, manualTurnSpeed);
                 pause(.1);
             case 'space'
                 disp("Stopped");
                 brick.StopAllMotors();
             case 'w'
                 disp("Releasing object!");
                 brick.MoveMotor(clawMotor, -20);
                 pause(.1);
             case 's'
                 disp("Grabbing object!");
                 brick.MoveMotor(clawMotor, 20);
                 pause(.1);
             case 'r'
                 state = "reg nav";
             case 0
                 brick.StopAllMotors();
         end
     end % <-- Manual loop exit
end  % <-- Final loop exit

% Potential problems/questions:
% 1. No color sensing in right turn. Should color sensing be in turns?
%       What about manual?
% 2. What do 'p' and 'o' do, and should we still have them?
% 3. I put color sensing in manual nav for milestone 2, so it should be
%       removed eventually.
%



