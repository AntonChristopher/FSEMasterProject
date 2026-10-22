global key;
%brick = ConnectBrick("BOB");
%Initial variables: ----------------------------
%States list:
%   turning left: "execute left turn"
%   turning right: "execute right turn"
%   manual control: "manual nav"
%   regular navigation: "reg nav"
%
%
InitKeyboard();
state = "manual nav";
colorState = "yellow";
leftMotor = 'A';
rightMotor = 'D';
clawMotor = 'C';
regSpeed = 60;
manualTurnSpeed = 30;
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


%brick.SetColorMode(colorPort, 2);
%Main loop: ----------------------------
brick.beep();
while 1
   distance = brick.UltrasonicDist(distancePort);
   touch = brick.TouchPressed(touchPort);
   color = brick.ColorCode(colorPort);
   %Regular decision
   if state == "reg nav"
       %Color decision logic: ---------
       if ~seenBlue   %seeking blue
           if color == blue
               seenBlue = true;
               state = "manual nav";
           end
       elseif ~seenGreen    %seeking green
            if color == green
                seenGreen = true;
                state = "manual nav";
            end
       elseif ~seenYellow
           if color == yellow
               seenYellow = true;
               break;
           end
       end
       %Regular navigation logic: ---------
       display(distance);
       %Stop sign 
       % if color == red
       %     brick.StopAllMotors();
       %     pause(1);
       %     brick.MoveMotor(leftMotor, rightMotor, redSpeed);
       %     pause(0.5);
       %  end
       if 
       if touch 
           brick.StopMotor(rightMotor);
           brick.StopMotor(leftMotor);
           state = "execute right turn";
       elseif distance > 6 && distance < 15  %move away from wall
           brick.MoveMotor(leftMotor, regSpeed+10);
       elseif distance < 6  %move towards wall
           brick.MoveMotor(rightMotor, regSpeed+10);
       elseif distance > 15  % execute left turn
           state = "execute left turn";
       end
       if key == 'm'
           state = "manual nav";
       end
   end
   %Manual navigation
        while (state == "manual nav")
           if color == red
               brick.StopAllMotors();
               pause(1);
               brick.MoveMotor(leftMotor, rightMotor, redSpeed);
               pause(0.5);
           end

           pause(0.1);
           switch key
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
        end
       %Execute manual left turn
   if state == "execute left turn"
       brick.MoveMotor(rightMotor, -40);
       brick.MoveMotor(leftMotor, -40);
       pause(0.01);
       brick.StopMotor(rightMotor);
       brick.StopMotor(leftMotor);
       brick.MoveMotor(rightMotor, 40);
       brick.MoveMotor(leftMotor, -40);
       pause(.3);
       brick.StopMotor(rightMotor);
       brick.StopMotor(leftMotor);
       state = "reg nav";
       %Execute manual right turn
   elseif state == "execute right turn"
       brick.MoveMotor(rightMotor, -40);
       brick.MoveMotor(leftMotor, -40);
       pause(0.01);
       brick.StopMotor(rightMotor);
       brick.StopMotor(leftMotor);
       brick.MoveMotor(rightMotor, -40);
       brick.MoveMotor(leftMotor, 40);
       pause(.3);
       brick.StopMotor(rightMotor);
       brick.StopMotor(leftMotor);
       state = "reg nav";
   end
end

