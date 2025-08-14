sca;
close all;
clear;

%asking for participant ID
p.PARTID = ''; %saving
while isempty(p.PARTID)
    answr = inputdlg('Enter participant ID','Participant ID');
    p.PARTID = answr{1};
end
outputname = [p.PARTID '-' datestr(now,30) '.mat'];

%Setting up Psychtoolbox
PsychDefaultSetup(2);
Screen('Preference', 'SkipSyncTests', 1);
Screen('Preference','VisualDebugLevel',0);
Screen('Preference','SuppressAllWarnings',1);

screens = Screen('Screens');
screenNumber = max(screens);

black = BlackIndex(screenNumber);
white = WhiteIndex(screenNumber);
[window, windowRect] = PsychImaging('OpenWindow', screenNumber, black); %open an on screen window 
[p.screenXpixels, p.screenYpixels] = Screen('WindowSize', window); %size of the on screen window in pixels
[xCenter, yCenter] = RectCenter(windowRect); %center coordinates
baseSquare = [0 0 150 150];
centeredSquare = CenterRectOnPointd(baseSquare, xCenter, yCenter);
DistractorSquareLeft = CenterRectOnPointd(baseSquare, xCenter+180, yCenter);
DistractorSquareRight = CenterRectOnPointd(baseSquare, xCenter-180, yCenter);

%fixation cross
Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
fixCrossDimPix = 30;
xCoords = [-fixCrossDimPix fixCrossDimPix 0 0];
yCoords = [0 0 -fixCrossDimPix fixCrossDimPix];
allCoords = [xCoords; yCoords];
lineWidthPix = 6;
HideCursor;

%defining keys
p.ResponseKeys = {'A' 'L'};
KbName('UnifyKeyNames');
SpaceKey = KbName('Space');
aKey = KbName('A');
lKey = KbName('L');
keys = [aKey lKey];

p.ResponseStatus = {'1=correct, 2=wrong, 3=timeout'};
p.Congruency = {'1=congruent' '2=incongruent' '0=neutral'};
p.StimulusColors = {'1= red' '2=green' '3=blue' '4=yellow'};
%stimuli
p.numReps = 4;
p.StimColors = [1 0 0; 0 1 0; 0 0 1; 1 1 0; .5 .5 .5];
NumColors = size(p.StimColors,1);
stimMat = repmat(1:NumColors-1,1, (NumColors-1)*p.numReps)';
stimMat = [stimMat sort(stimMat)];
stimNeutral = repmat(1:NumColors-1, 1, 2*p.numReps)';
stimNeutral = [stimNeutral NumColors*ones(length(stimNeutral),1)];
stimMat = [stimMat; stimNeutral];
stimMat = Shuffle(stimMat, 2);
p.numTrials = size(stimMat, 1);

%
p.TrialDataLabels ={'Congruency' 'ResponseStatus' 'ResponseTime' 'Stimulus'};
p.TrialData = nan(p.numTrials, length(p.TrialDataLabels));

%showing instructions 
Screen('TextSize', window, 35);
DrawFormattedText(window,'Welcome to the Eriksen Flanker Task!\nIn this experiment, you will see 3 squares at the time.\nYou need to respond to the one in the middle.\nPress any key to continue.' , 'center', 'center',[1 1 1]);
vbl = Screen('Flip', window);
KbStrokeWait;
DrawFormattedText(window,'If you see a GREEN square or a RED square\nPRESS THE BUTTON "A".\n If you see a BLUE square or a YELLOW square\nPRESS THE BUTTON "L".\nPress any key to continue', 'center', 'center',[1 1 1]);
vbl = Screen('Flip', window);
KbStrokeWait;
vbl = Screen('Flip', window);

run EriksenFlankerPractise

stimMat = Shuffle(stimMat, 2); %Shuffling again after the practice block
vbl = Screen('Flip', window);

%for loop
p.NeutralNumCorrect= 0;
p.CongruentNumCorrect = 0;
p.IncongruentNumCorrect = 0;
p.NeutralNumCorrect = 0;

for trial = 1:p.numTrials
    
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
              p.TrialData(trial,3) = rt;
              break;
          end
        end
          if GetSecs-timeStart > 3  %if the participant does not respond for three seconds
             Screen('TextSize', window, 35);
             DrawFormattedText(window, 'TOO SLOW\nPress A for red and green\nPress L for blue and yellow', 'center', 'center',[1 1 1]);
             vbl = Screen('Flip', window);
             WaitSecs(2);
             Response= 0;
             keyIsDown=0;
             p.TrialData(trial,2) = 3; %timeout
             break;
          end
   end
    
%saving and giving feedback
if (MiddleSquareColorIndex == 1) || (MiddleSquareColorIndex == 2) %red and green
        p.TrialData(trial,4) = MiddleSquareColorIndex;
    if (DistractorSquareColorIndex == 1) || (DistractorSquareColorIndex == 2) %congruent
        p.TrialData (trial, 1) = 1;
        if Response == 1 %correct answer
           p.CongruentNumCorrect = p.CongruentNumCorrect+1;
           p.TrialData(trial, 2) = 1;
        elseif Response == 2  %wrong answer
        p.TrialData(trial, 2) = 2;
        end
    elseif (DistractorSquareColorIndex == 3) || (DistractorSquareColorIndex == 4) %incongruent
        p.TrialData (trial, 1) = 2;
        if Response == 1  %correct answer
        p.TrialData(trial, 2) = 1;
        p.IncongruentNumCorrect = p.IncongruentNumCorrect+1;
        elseif Response == 2 %wrong answer
        p.TrialData(trial, 2) = 2;
        end  
    elseif DistractorSquareColorIndex == 5 %neutral
        p.TrialData (trial, 1) = 0;
        if Response == 1  %correct answer
        p.TrialData(trial, 2) = 1;
        p.NeutralNumCorrect = p.NeutralNumCorrect+1;
        elseif Response == 2 %wrong answer
        p.TrialData(trial, 2) = 2;
        end
    end
elseif (MiddleSquareColorIndex == 3) || (MiddleSquareColorIndex == 4) %blue and yellow
      p.TrialData(trial,4) = MiddleSquareColorIndex;
      if (DistractorSquareColorIndex == 3) || (DistractorSquareColorIndex == 4) %congruent
        p.TrialData (trial, 1) = 1; 
        if Response == 2 %correct answer
           p.CongruentNumCorrect = p.CongruentNumCorrect+1;
           p.TrialData(trial, 2) = 1;
        elseif Response == 1 %wrong answer
        p.TrialData(trial, 2) = 2;
        end
    elseif (DistractorSquareColorIndex == 1) || (DistractorSquareColorIndex == 2) %incongruent
        p.TrialData (trial, 1) = 2;
        if Response == 2  %correct answer
        p.TrialData(trial, 2) = 1;
        p.IncongruentNumCorrect = p.IncongruentNumCorrect+1;
        elseif Response == 1 %wrong answer
        p.TrialData(trial, 2) = 2;
        end  
    elseif DistractorSquareColorIndex == 5 %neutral
        p.TrialData (trial, 1) = 0;
        if Response == 2  %correct answer
        p.TrialData(trial, 2) = 1;
        p.NeutralNumCorrect = p.NeutralNumCorrect+1;
        elseif Response == 1 %wrong answer
        p.TrialData(trial, 2) = 2;
        end
      end
end
vbl = Screen('Flip', window);
end
TotalNumCorrect = p.CongruentNumCorrect + p.IncongruentNumCorrect + p.NeutralNumCorrect;


CorrectTrials =  p.TrialData(p.TrialData(:,2)==1 ,:);  %all correctly responded trials
CongruentRTs = CorrectTrials( CorrectTrials(:,1)==1 ,3); %congruent correct answers
p.medianCongruentRTs = median(CongruentRTs);

IncongruentRTs = CorrectTrials( CorrectTrials(:,1)==2 ,3); %incongruent correct answers                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              
p.medianIncongruentRTs = median(IncongruentRTs);

NeutralRTs = CorrectTrials( CorrectTrials(:,1)==0 ,3); %neutral correct answers
p.medianNeutralRTs = median(NeutralRTs);

save(outputname,'p');

Screen('TextSize', window, 35);
DrawFormattedText(window,'Congratulations!\nYou are done with the experiment.\nPress any key to exit' , 'center', 'center',[1 1 1]);
vbl = Screen('Flip', window);
KbStrokeWait;
   
sca;