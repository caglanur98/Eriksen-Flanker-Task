Screen('TextSize', window, 35);
DrawFormattedText(window,'Now you will get a practise run to warm up.\nThere are 15 trials in the practise run.\nPlease try to respond as fast as you can.\nPress space bar to start the practise.' , 'center', 'center',[1 1 1]);
vbl = Screen('Flip', window);
keyIsDown=0;
while 1
        [keyIsDown, secs, keyCode] = KbCheck;
        if keyIsDown && sum(keyCode) == 1
          if keyCode(SpaceKey)
              break;
          else
              keyIsDown=0;
          end
        end
end

PractiseNumTrials = 15;

for trial = 1: PractiseNumTrials
    
    MiddleSquareColorIndex = stimMat(trial,1);
    MiddleSquareColor = p.StimColors(MiddleSquareColorIndex,:);
    DistractorSquareColorIndex = stimMat(trial,2);
    DistractorSquareColor = p.StimColors(DistractorSquareColorIndex,:);
    
    Screen('DrawLines', window, allCoords, lineWidthPix, white, [xCenter yCenter+50], 2);
    vbl = Screen('Flip', window);
    
    %draw and show stimulus
    Screen('FillRect', window, MiddleSquareColor, centeredSquare);
    Screen('FillRect', window, DistractorSquareColor, DistractorSquareLeft);
    Screen('FillRect', window, DistractorSquareColor, DistractorSquareRight);
    vbl = Screen('Flip', window, vbl+.2);
    
    %response
    keyIsDown=0;
    timeStart = GetSecs;
   while 1 
        [keyIsDown, secs, keyCode] = KbCheck;
        if keyIsDown && sum(keyCode) == 1
          if keyCode(lKey)|| keyCode(aKey)
              rt = 1000.*(secs-timeStart);
              Response = find(keys==find(keyCode));
              break;
          end
        end
          if GetSecs-timeStart > 4
             Screen('TextSize', window, 35);
             DrawFormattedText(window, 'TOO SLOW\nPress A for red and green\nPress L for blue and yellow', 'center', 'center',[1 1 1]);
             vbl = Screen('Flip', window);
             WaitSecs(2);
             Response= 0;
             keyIsDown=0;
             break;
          end
   end
    
%giving feedback
if (MiddleSquareColorIndex == 1) || (MiddleSquareColorIndex == 2) %red and green
        if Response == 2  %wrong answer
           Beeper;
           Screen('TextSize', window, 40);
           DrawFormattedText(window, 'YOU MADE A MISTAKE\nPress A for red and green\nPress L for blue and yellow', 'center', 'center',[1 0 0]);
           vbl = Screen('Flip', window);
           WaitSecs(2);
        end  
elseif (MiddleSquareColorIndex == 3) || (MiddleSquareColorIndex == 4) %blue and yellow
        if Response == 1  %wrong answer
           Beeper;
           Screen('TextSize', window, 40);
           DrawFormattedText(window, 'YOU MADE A MISTAKE\nPress A for red and green\nPress L for blue and yellow', 'center', 'center',[1 0 0]);
           vbl = Screen('Flip', window);
           WaitSecs(2);
        end  
end
vbl = Screen('Flip', window);
end

Screen('TextSize', window, 35);
DrawFormattedText(window,'You are done with the practise.\nNow you will start the real experiment.\nPress space bar to start the experiment.' , 'center', 'center',[1 1 1]);
vbl = Screen('Flip', window);
keyIsDown=0;
while 1
        [keyIsDown, secs, keyCode] = KbCheck;
        if keyIsDown && sum(keyCode) == 1
          if keyCode(SpaceKey)
              break;
          else
              keyIsDown=0;
          end
        end
end
save(outputname,'p');
vbl = Screen('Flip', window,vbl+.09);