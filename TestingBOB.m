global key;


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

InitKeyboard();
state = "manual nav";
colorState = "yellow";
leftMotor = 'D';
rightMotor = 'A';
clawMotor = 'C';
regSpeed = 30;
colorPort = 1;
touchPort = 2;
distancePort = 3;

%States:
%   turning left: "execute left turn"
%   turning right: "execute right turn"
%   manual control: "manual nav"
%   regular navigation: "reg nav"
%
%


while 1

    pause(0.1);
    distance = brick.UltrasonicDist(distancePort);
    touch = brick.TouchPressed(touchPort);
    color = brick.ColorCode(colorPort);
    

    %Color decision logic:
    %Start and end condition
    if state == "reg nav" && colorState == "yellow" && color == yellow
        state = "reg nav";  %do nothing
        disp("starting nav")
    elseif state == "reg nav" && colorState ~= "yellow" && color == yellow
        disp("Finished! Task done!");
        brick.StopMotor(leftMoter);
        brick.StopMotor(rightMotor);
        victoryBeep();
        break;
    
    %if encounters blue or green for first time, manual nav
    elseif state == "reg nav" && colorState ~= "blue" && color == blue
            colorState = "blue";
            state = "manual nav";
            brick.StopMotor(leftMoter);
            brick.StopMotor(rightMotor);
    elseif state == "reg nav" && colorState ~= "green" && color == green
            colorState = "green";
            state = "manual nav";
            brick.StopMotor(leftMoter);
            brick.StopMotor(rightMotor);
    
     %if in reg nav and already on blue or green, drive normally
    elseif state == "reg nav" && colorState == "blue" && color == blue
            state = "reg nav";  %do nothing
    
    %if encounters red for first time, stop for one second
    elseif state == "reg nav" && colorState ~= "red" && color == red
        brick.StopMotor('D');
        brick.StopMotor('A');
        pause(1);
        colorState = "red";
    end
    
    
    %Navigation decision logic:
    %Manual navigation
    if state == "manual nav"
    
        switch key
        
        case 'uparrow'
        
            disp('Up Arrow Pressed!');
            brick.MoveMotor(rightMotor, regSpeed);
            brick.MoveMotor(leftMotor, regSpeed);
        
        
        case 'downarrow'
        
            disp('Down Arrow Pressed!');
            brick.MoveMotor(rightMotor, -regSpeed);
            brick.MoveMotor(leftMotor,-regSpeed);
        
        case 'leftarrow'
        
            disp('Left Arrow Pressed!');
            brick.MoveMotor(rightMotor, regSpeed);
        
        case 'rightarrow'
        
            disp('Right Arrow Pressed!');
            brick.MoveMotor(leftMotor, regSpeed);
    
        case 'w'
        
            disp("Releasing object!");
            brick.MoveMotor(clawMotor, -20);
    
        case 's'
        
            disp("Grabbing object!");
            brick.MoveMotor(clawMotor, 20);
        
        case 'r'
            
            state = "reg nav";
        
        end
    
    
    %Regular navigation
    elseif state == "reg nav"
        display(distance);
       
        if touch
            brick.StopMotor(rightMotor);
            brick.StopMotor(leftMotor);
            state = "execute right turn";
        elseif distance > 6 && distance < 15  %move away from wall
            brick.MoveMotor(leftMotor, regSpeed+5);
        elseif distance < 6  %move towards wall
            brick.MoveMotor(rightMotor, regSpeed+5);
        elseif distance > 15  % execute left turn
            state = "execute left turn";
        end
    
        if key == 'm'
            state = "manual nav";
        end
    
    
    %Execute manual left turn   
    elseif state == "execute left turn"
        brick.MoveMotorAngleRel(leftMotor, 20, 90, 'Brake');
        brick.WaitForMotor(leftMotor);
        % brick.MoveMotor('D', 40);
        % brick.MoveMotor('A', -40);
        % pause(.3);
        % brick.StopMotor('D');
        % brick.StopMotor('A');
        state = "reg nav";
    
    
     %Execute manual right turn
    elseif state == "execute right turn"
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
    end 

end