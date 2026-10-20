global key;

%brick = ConnectBrick("BOB");

%Functions: ----------------------------

function victoryBeep()
    
    brick.beep();
    pause(.5);
    brick.beep();
    pause(.5)
    brick.beep();
    pause(.1);
    brick.beep();
    pause(.1);
    brick.beep();
end



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
colorPort = 1;
touchPort = 2;
distancePort = 3;

%Try:
distance = brick.UltrasonicDist(distancePort);
touch = brick.TouchPressed(touchPort);
color = brick.ColorCode(colorPort);


%Main loop: ----------------------------

brick.beep();
while 1

    % distance = brick.UltrasonicDist(distancePort);
    % touch = brick.TouchPressed(touchPort);
    % color = brick.ColorCode(colorPort);
    

    
    %Regular decision 
    if state == "reg nav"

        %Color decision logic: ---------
        if colorState == "yellow" && color == yellow
            state = "reg nav";  %do nothing
            disp("starting nav")
        elseif colorState ~= "yellow" && color == yellow
            disp("Finished! Task done!");
            brick.StopMotor(leftMotor);
            brick.StopMotor(rightMotor);
            victoryBeep();
            break;
        
        %if encounters blue or green for first time, manual nav
        elseif colorState ~= "blue" && color == blue
                colorState = "blue";
                state = "manual nav";
                brick.StopMotor(leftMotor);
                brick.StopMotor(rightMotor);
        elseif colorState ~= "green" && color == green
                colorState = "green";
                state = "manual nav";
                brick.StopMotor(leftMotor);
                brick.StopMotor(rightMotor);
        
         %if in reg nav and already on blue or green, drive normally
        elseif colorState == "blue" && color == blue
                state = "reg nav";  %do nothing
        
        %if encounters red for first time, stop for one second
        elseif colorState ~= "red" && color == red
            brick.StopMotor('D');
            brick.StopMotor('A');
            pause(1);
            colorState = "red";
        end

        %Regular navigation logic: ---------
        display(distance);
       
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
    if state == "manual nav"
        while (state == "manual nav")
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
            
            case 'leftarrow'
            
                disp('Left Arrow Pressed!');
                    brick.MoveMotor(rightMotor, manualTurnSpeed);
                    brick.MoveMotor(leftMotor, -manualTurnSpeed);
                    pause(.1);
    
            
            case 'rightarrow'
            
                disp('Right Arrow Pressed!');
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
    elseif state == "execute left turn"
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