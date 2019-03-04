function [classesCorrect, classesWrong] = getClassIndices(labels) 
    classesCorrect = find(labels==0);
    classesWrong = find(labels==1);
end