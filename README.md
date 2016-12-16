# Facial-Recognition-Project
Created a facial recognition program that analyzes an image and correlates it with the most similar image in a database of pictures of faces.

Introduction: Since computers only understand and operate with sequences of 0’s and 1’s, images are stored in their memory or hard-drive as arrays or matrices of numbers. What we perceive in the physical world as colors is no more than values which encode light intensity in the digital world. Since Linear Algebra is based on matrix and vector operations it consitutes one of the most powerful tools to process and analyze images. In this Lab Project we will explore some of its capabilities. As mentioned above, images are represented as numbers. For black-and-white images (or grayscale images) the value of each pixel is most commonly represented in the computer by 8 bits of information (0’s or 1’s). As such, there is 28 combinations of sequences or else integer values in the range of 0−255 can be represented. The value 0 corresponds to the absolute black color, the value 255 to the absolute white color, while values in between represent diﬀerent shades of gray. Obviously, for representing a color image we would need more bits to encode the color. This is indeed the case. Each color image is represented by a set of triplets of 8 bits, each one corresponding to a value of Red, Green or Blue colors. In other words, a color image of size m×n can be represented as a 3D matrix of size m×n×3. Each one of the depth layers of the matrix corresponds to the intensity of a diﬀerent color in the scene and the linear combination of their values is perceived by the human eye as a diﬀerent color. 

Project Design: The main idea behind our facial recognition software is ﬁnding the face image that looks most similar to the query image. Assume that we have access to a database of labeled images, i.e., images that depict people whose identity is known and these images have been appropriately labeled. Now, if one sends a query face image for recognition, the most straightforward way to recognize this face is to look through the images in the database and ﬁnd the one which is most similar to our query image. Since the images in the database are labeled, ﬁnding the image with the most similar appearance implies that the identity of the person in the image can be found, assuming that the face of this person exists in the database. Obviously, the problem is not that simple and there is ongoing research on the topic for images that have been corrupted by noise, occlusions, facial expressions, lighting variations, etc. However, in this Lab Project we want to introduce the main concepts behind the topic and we will present them in a simple and straightforward way. Assume that we have access to N RGB images (color images) of players. Also, assume that the size of each one of the R, G and B Channels in each image is m × n = M. One can read these images, convert them to grayscale, vectorize them and store them in the columns of a matrix (database) D of size M ×N, i.e., each column contains an image of m×n = M pixels and there is N such columns. Furthermore, assume that we also have access to a Labeling vector p of size N ×1 that holds the name of the k-th player (Name-k) at location k, where k = 1...N. Since we know the (Index - Player Name) correspondence in vector p, the easiest way to perform Face Recognition would be to reorder the columns of the database D such that the image of the k-th player is at the k-th column of the matrix D. Then, by sending a query image, we can ﬁnd the column of the matrix D that holds an image which is most similar to our query image and then identify the player as player-k with name Name-k.

Lab Project

    clear; 
    close all; 
    clc;
    imagePath = ['.', filesep(), 'Player_Images', filesep()];

    playerNumber = 1;   % Image that is chosen to recognize
                  

    playerImage = [imagePath, 'player', num2str(playerNumber), '.png'];

%% Program Error Checking mechanism 

    if ~exist(playerImage,'file') 
    error('Query image does not exist... Please select a playerNumber between 1 and 100.');
    end

%% Create and Unscramble Image Database

    if ~exist('imageDatabases.mat','file')

    % Create Scrambled Image Database
    fprintf(2,'Constructing Image Database...\n');
    scrambledDatabase = createImageDatabase(imagePath);
    fprintf('Done!\n\n');
    
    % Unscramble the Database
    fprintf(2,'Unscrambling the Image Database...\n');
    [correctDatabase,scrambledIndices] = unScrambleDatabase(imagePath,scrambledDatabase);
    fprintf('Done!\n\n');
    
    % Verify that the Database has been Unscrambled
    fprintf(2,'Verifying that the Image Database is corrected...\n');
    [~,correctIndices] = unScrambleDatabase(imagePath,correctDatabase);
    if exist('calcMSE','file')
        if calcMSE(correctIndices,1:length(correctIndices)) == 0
            % If database has been corrected store the results so you don't
            % have to rerun the unscrambling code every time.
            save('imageDatabases.mat','scrambledDatabase','correctDatabase','scrambledIndices','correctIndices');
            warningFlag = false;
            fprintf('Done!\n\n');
        else
            warningFlag = true;
            warning('Image Database was not properly unscrambled');
            fprintf('\n');
        end
    else
        warning('Successful unscrambling cannot be currently evaluated... Create "calcMSE" function first');
        fprintf('\n');
    end
    
    else 
    fprintf(2,'Correct Database is already stored in a file... Loading...\n');
    scrambledDatabase  = load('imageDatabases.mat','scrambledDatabase');
    scrambledDatabase  = scrambledDatabase.scrambledDatabase;
    correctDatabase    = load('imageDatabases.mat','correctDatabase');
    correctDatabase    = correctDatabase.correctDatabase;
    scrambledIndices   = load('imageDatabases.mat','scrambledIndices');
    scrambledIndices   = scrambledIndices.scrambledIndices;
    correctIndices     = load('imageDatabases.mat','correctIndices');
    correctIndices     = correctIndices.correctIndices;
    fprintf('Done!\n\n');
    end

% If unScrambling was performed correctly show the indices before and after unscrambling

    
    if exist('plotIndices','file')

    plotIndices(scrambledIndices,correctIndices)
    
    else
    warning('Indices cannot be currently plotted... Create "plotIndices" function first.');
    fprintf('\n');
    end


%% Checking if you can identify yourself in the database

    % Read Image to be Found (will work only after you create the readImage
    % function
    if exist('readImage','file')

    x = readImage(playerImage);
    else

        x = [];
    end

    % First check your identity using the scrambled database
    fprintf(2,'Checking Player Identity in the Scrambled Database...\n'); pause(0.2);
    if exist('findMinimumErrorPosition','file') && exist('computePSNRs','file')

    identificationFlag = true;
    minPos = findMinimumErrorPosition(makeVector(x),scrambledDatabase);
    PSNRs  = computePSNRs(makeVector(x),scrambledDatabase);
    else

    identificationFlag = false;
    end

    if identificationFlag

      playerName = identifyPlayer(x,imagePath,minPos,PSNRs);
      fprintf('Player identified as %s at the Scrambled Database column: %d!\n\n', playerName, minPos);
      pause(0.2);
      
    else

    warning('Players cannot be currently identified in the Scrambled Database... Create "findMinimumErrorPosition" and "computePSNRs" functions first.');
    fprintf('\n');
    end

% Then check your identity again using the correct database

    fprintf(2,'Checking Player Identity in the Corrected Database...\n'); pause(0.2);
    if exist('findMinimumErrorPosition','file') && exist('computePSNRs','file')
        identificationFlag = true;
        minPos = findMinimumErrorPosition(makeVector(x),correctDatabase);
        PSNRs  = computePSNRs(makeVector(x),correctDatabase);
    else
        identificationFlag = false;
    end

    if identificationFlag
        PlayerName = identifyPlayer(x,imagePath,minPos,PSNRs);
        fprintf('Player identified as %s at the Corrected Database column: %d!\n\n', PlayerName, minPos);
        pause(0.2);
    else
        warning('Players cannot be currently identified in the Corrected Database... Create "findMinimumErrorPosition" and "computePSNRs" functions first.');
        fprintf('\n');
    end
