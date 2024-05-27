function [command, sourceImage, sourceImagePath, savedImagePath] = getBasicInfo()
    sourceImagePathPrompt = "input the path of the source image:\n";
    savedImagePathPrompt = "input the path of the saved image:\n";
    commandPrompt = "Please select the algorithm to compress and decompress the image:\n1)HuffmanCompression\n2)RLCcompression\n3)JPEG\n4)Exit the program\n> ";
    command = input(commandPrompt);
    EXIT = 4;
    if command ~= EXIT
        sourceImagePath = input(sourceImagePathPrompt,"s");
        savedImagePath = input(savedImagePathPrompt,"s");
        sourceImage = imread(sourceImagePath);
    else
        sourceImagePath = '';
        savedImagePath = '';
        sourceImage = zeros(2,2);
    end
end