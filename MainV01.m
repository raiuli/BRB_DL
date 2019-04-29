% Stat clear previous data
% adding git
clear;
clc;
format compact;
fclose('all');

%addpath(pwd+"/DE");
addpath(pwd+"/BRBADE");
%load('randomConf.mat','s')
formatOut = 'yyyy-mmm-dd_HH_MM_SS';
dateString = datestr(datetime('now'),formatOut);
filename = strcat('RandomConfig/randomConf',dateString,'.mat');
%load('RandomConfig/randomConf2018-Oct-30_09_37_15.mat', 's');
%rng(s);
s=rng();
save(filename,'s');
%delete(gcp('nocreate'))
%parpool('local',4)
global input outputOpti observedOutput...
    transformedRefVal conseQuentRef...
    rulebase sizeOfData...
    numOfVariables numOfconRefval numOfAttrWeight numOfRuleWeight numOfbeliefDegrees ...
    fid_x1 fid_f1 data_rule Aeq beq d;

s = strcat('Log/simulation_result',dateString,'.txt');
%s = strcat('Log/simulation_result.txt');
fid_x1 = fopen (s, 'w');

fid_f1 = fopen ('Log/f1.txt', 'w');

dateString = datestr(datetime('now'));
fprintf(fid_x1,'Starting program %s \n',dateString);
%read input file
%fid = fopen ('JISC_Dataset_Paper_refined-2.csv', 'r');

%fid = fopen ('Dataset/JISC_Dataset_Paper_refined-2.csv', 'r');
%fid = fopen ('Dataset/JISC_Dataset_Paper_refined-2_small.csv', 'r');
fid = fopen ('Dataset/PUE_FB.csv', 'r');
fid = fopen ('Dataset/SmapleDataset.csv', 'r');
%fid=fopen('Dataset/input50000.csv','r');
%fid = fopen ('SecDataset.txt', 'r');
%fid = fopen ('SecDatasetstiny.txt', 'r');
%fid = fopen ('SecDataset100.txt', 'r');
%fid = fopen ('inputJBY.txt', 'r');
numberOfInputData=0;
%input=zeros(12,5);
while ~feof(fid)
    numberOfInputData=numberOfInputData+1;
    line=fgetl(fid);
    if numberOfInputData==1
        line=strtrim(line)
        keySet=split(strtrim(line),',');
        %valueSet = {ones};
        % mapObj = containers.Map(keySet,valueSet);
        
    else
        
        allvalueSet(numberOfInputData-1,:)=str2num(line);
        %svalueSet=str2num(split(line,','));
    end
    
    
end
fclose(fid);

indices = crossvalind('Kfold',allvalueSet(:,3),10);
ffilename = strcat('Dataset/SmapleDataset','_indices','.csv');
csvwrite(ffilename,indices);
%indices = csvread('Dataset/JISC_Dataset_Paper_refined-2_indices_.csv');
%indices = csvread('Dataset/JISC_Dataset_Paper_refined-2_small_indices_.csv');
%indices = csvread('Dataset/input50000_indices_.csv');
%indices = csvread('Dataset/PUE_FB_indices_.csv');
%indices = csvread('Dataset/SmapleDataset_indices.csv');
for counter =1:5
    test = (indices == counter);
    train = ~test;
    fprintf(fid_x1,'\nStarting Cross validation No %d: Training Data Point %d, Testing Data Point %d',counter,length(find(train==1)),length(find(test==1)));
    fprintf('\nStarting Cross validation No %d: Training Data Point %d, Testing Data Point %d',counter,length(find(train==1)),length(find(test==1)));
    valueSet=allvalueSet(train,:);
    sizeOfData=size(valueSet,1);
    numberOfInputData=sizeOfData;
    keySet=cellstr(keySet);
    valueSet=num2cell(valueSet,1);
    mapObj = containers.Map(keySet,valueSet);
    %numberOfInputData=numberOfInputData-1;
    %sizeOfData=numberOfInputData;
    %PUE 20000
%     brbTree(1).antecedent=cellstr(['x2';'x3';'x4']);
%     brbTree(1).antRefval={[1188897 608186 27475];
%         [27 23 21];
%         [17 10 3]
%         };
%     
%     brbTree(1).consequent=cellstr('x1');
%     brbTree(1).conRefval=[5 2 0];
%     %BRB tree for PUE_FB data
%     brbTree(1).antecedent=cellstr(['x2';'x3';'x4';'x5']);
%     brbTree(1).antRefval={[55.032 27.037 0.959];
%        [99.1 65.076 31.068];
%        [39.6 19.8 0];
%        [338 170 0]
%        };
%     brbTree(1).consequent=cellstr('x1');
%     brbTree(1).conRefval=[1.254 1.127 1];
    %     brbTree(1).antecedent=cellstr(['x22';'x23']);
    %     brbTree(1).antRefval={[110 56 2];
    %         [11 5.75 0.5]};
    %     brbTree(1).consequent=cellstr('x08');
    %     brbTree(1).conRefval=[0.9 0.7 0.5];
    %brbTree(1).rulebaseFile=['rulebaseX08.txt'];
    %BRB tree for PUE_FB data
    brbTree(1).antecedent=cellstr(['x2';'x3']);
    brbTree(1).antRefval={[55.032 27.516 0];
       [98.943 65.005 21.068]
       };
    brbTree(1).consequent=cellstr('x1');
    brbTree(1).conRefval=[1.254 1.0775 0];
    fid_tp = fopen ('Log/trainedParam.txt', 'a');
    
    lbCU=[];
    ubCU=[];
    for brdTreeID=1:size(brbTree,2)
        
        conseQuentRef=brbTree(brdTreeID).conRefval;
        numOfAttrWeight=size(brbTree(brdTreeID).antRefval,1);
        
        numOfconRefval=size(brbTree(brdTreeID).conRefval,2);
        %read initial rule base for subrule base 1
        %rulebase=readRuleBase(brbTree(brdTreeID).rulebaseFile);
        rule=calculateInitialRulebase(cell2mat(brbTree(brdTreeID).antRefval),brbTree(brdTreeID).conRefval);
        rule=calculateInitialRulebaseDisV1(cell2mat(brbTree(brdTreeID).antRefval),brbTree(brdTreeID).conRefval);
        rulebase=struct;
        %d=prod(size(brbTree(brdTreeID).antRefval));
        for i=1:size(rule,1)
            rulebase(i).conse=rule(i,size(brbTree(brdTreeID).antRefval,1)+1:end);
            rulebase(i).ruleweight=1;
        end
        %rulebase.
        size(brbTree(brdTreeID).antecedent,1);
        %observedOutput_old=mapObj(brbTree(brdTreeID).consequent{1});
        observedOutput=cell2mat(valueSet(find(strcmp(keySet,brbTree(brdTreeID).consequent{1}))));
        lbCU=horzcat(lbCU,ones(1,length(conseQuentRef))*min(observedOutput));
        ubCU=horzcat(ubCU,ones(1,length(conseQuentRef))*max(observedOutput));
        transformedRefVal={};
        lbAU=[];
        ubAU=[];
        in=[];
        numOfAntecedentsRefVals=0;
        fprintf(fid_x1,'\nAntecedents:');
        fprintf('\nAntecedents:');
        initialValAncedentRefValue=[];
        for antecedentID=1:size(brbTree(brdTreeID).antecedent,1)
            fprintf(fid_x1,' %s(',brbTree(brdTreeID).antecedent{antecedentID});
            fprintf(' %s(',brbTree(brdTreeID).antecedent{antecedentID});
            % in_old=mapObj(brbTree(brdTreeID).antecedent{antecedentID,1});
            in(antecedentID,:)=cell2mat(valueSet(find(strcmp(keySet,brbTree(brdTreeID).antecedent{antecedentID,1}))));
            antcedentRefVal=cell2mat(brbTree(brdTreeID).antRefval(antecedentID,:));
            lbAU=horzcat(lbAU,ones(1,length(antcedentRefVal))*min(in(antecedentID,:)));
            ubAU=horzcat(ubAU,ones(1,length(antcedentRefVal))*max(in(antecedentID,:)));
            numOfAntecedentsRefVals=numOfAntecedentsRefVals+length(antcedentRefVal);
            initialValAncedentRefValue=horzcat(initialValAncedentRefValue,antcedentRefVal);
            fprintf(fid_x1,'%2.2f ',antcedentRefVal);
            fprintf(fid_x1,')');
            fprintf('%2.2f ',antcedentRefVal);
            fprintf(')');
            %tmp=inputTransform(in,antcedentRefVal,numberOfInputData);
            %transformedRefVal(antecedentID,:)={tmp};
            %transformedRefVal(:,antecedentID)=tmp
            attrWeight(antecedentID)=1;
        end
        fprintf(fid_x1,'=>%s (',brbTree(brdTreeID).consequent{1});
        fprintf(fid_x1,'%2.2f ',brbTree(brdTreeID).conRefval);
        fprintf(fid_x1,')\n');
        
        fprintf('=>%s (',brbTree(brdTreeID).consequent{1});
        fprintf('%2.2f ',brbTree(brdTreeID).conRefval);
        fprintf(')\n');
        
        numOfRuleWeight=size(rulebase,2);
        numOfbeliefDegrees=numOfRuleWeight*numOfconRefval;
        %numOfVariables=numOfAttrWeight+numOfRuleWeight+numOfbeliefDegrees;
        numOfVariables=numOfconRefval+numOfAttrWeight+numOfRuleWeight+numOfbeliefDegrees+numOfAntecedentsRefVals;
        fprintf(fid_x1,'Number of Varaibles: %d=%d(CR)+%d(AW)+%d(RW)+%d(BD)+%d(Arefv)\n',numOfVariables,numOfconRefval,numOfAttrWeight,numOfRuleWeight,numOfbeliefDegrees,numOfAntecedentsRefVals);
        fprintf('Number of Varaibles: %d=%d(CR)+%d(AW)+%d(RW)+%d(BD)+%d(Arefv)\n',numOfVariables,numOfconRefval,numOfAttrWeight,numOfRuleWeight,numOfbeliefDegrees,numOfAntecedentsRefVals);
        for i=1:size(in,1) 
            fprintf(fid_x1,'%2.2f ',in(i,:) ) ;
            fprintf(fid_x1,'\n');
        end
        %initialiaze the x0
        initialValAttrWeight=ones([1,numOfAttrWeight]);
        initialValRuleWeight=ones([1,numOfRuleWeight]);
        initialValConsequent=conseQuentRef;
        %initialValAncedentRefValue=ones([1,numOfAntecedentsRefVals]);
        betam=[];
        for i=1:numOfRuleWeight
            betam(i,:)=rulebase(i).conse;
        end
        z1=betam';
        betam=z1(:)';
        x0=horzcat(initialValAttrWeight,initialValRuleWeight,betam,initialValConsequent,initialValAncedentRefValue);
        %x0=initialVal{brdTreeID};
        %x0=horzcat(x0,initialValConsequent);
        %initialiaze the constraints
        lb = zeros(1,numOfVariables)+0.000001;
        ub =ones(1,numOfVariables);
        lb(numOfAttrWeight+numOfRuleWeight+numOfbeliefDegrees+1:numOfVariables-numOfAntecedentsRefVals)=lbCU;
        ub(numOfAttrWeight+numOfRuleWeight+numOfbeliefDegrees+1:numOfVariables-numOfAntecedentsRefVals)=ubCU;
        lb(numOfAttrWeight+numOfRuleWeight+numOfbeliefDegrees+numOfconRefval+1:numOfVariables)=lbAU;
        ub(numOfAttrWeight+numOfRuleWeight+numOfbeliefDegrees+numOfconRefval+1:numOfVariables)=ubAU;
        %initialVal{brdTreeID};
        fprintf(fid_x1,'\nIntial value\n');
        fprintf (fid_x1,'Attribute Weights\n');
        fprintf (fid_x1,'%d ', x0(1:numOfAttrWeight) );
        fprintf (fid_x1,'\nRuleWeights\n');
        fprintf (fid_x1,'%d ', x0(numOfAttrWeight+1:numOfAttrWeight+numOfRuleWeight) );
        fprintf (fid_x1,'\nBelief Degrees\n');
        z=x0(numOfAttrWeight+numOfRuleWeight+1:numOfVariables-numOfconRefval-numOfAntecedentsRefVals);
        fprintf (fid_x1,'%2.2f ',z);
        fprintf (fid_x1,'\nConsequent utlity values\n');
        fprintf (fid_x1,'%d ', x0(numOfVariables-numOfconRefval-numOfAntecedentsRefVals+1:numOfVariables-numOfAntecedentsRefVals) );
        fprintf (fid_x1,'\nAntecedent utlity values\n');
        fprintf (fid_x1,'%d ', x0(numOfVariables-numOfAntecedentsRefVals+1:numOfVariables) );
      
        brbConfigdata.conseQuentRef=conseQuentRef;
        brbConfigdata.numOfAttrWeight=numOfAttrWeight;
        brbConfigdata.numOfconRefval=numOfconRefval;
        brbConfigdata.input=in;
        brbConfigdata.numOfAntecedentsRefVals=numOfAntecedentsRefVals;
        brbConfigdata.outputOpti=outputOpti;
        brbConfigdata.observedOutput=observedOutput;
        brbConfigdata.transformedRefVal=transformedRefVal;
        brbConfigdata.rulebase=rulebase;
        brbConfigdata.sizeOfData=sizeOfData;
        brbConfigdata.numOfVariables=numOfVariables;
        brbConfigdata.numOfRuleWeight=numOfRuleWeight;
        brbConfigdata.numOfbeliefDegrees=numOfbeliefDegrees;
        brbConfigdata.brbTree=brbTree(brdTreeID);
        brbConfigdata.rule=rule;
%         tstart = tic;
%         formatOut = 'FFF';
%         tS=datetime('now');
%         f=objFunAllParallelDisv1(x0,brbConfigdata);
%         tE=datetime('now');
%         datestr(tE-tS,formatOut)
%         fprintf (fid_x1,'\nF=%G\n',f);
%         fprintf ('\nF=%G\n',f);
%         telapsed = toc(tstart)
         fprintf (fid_x1,'\nBRBES actualOutput=\n');
        fprintf ('\nBRBES actualOutput=\n');
        fprintf (fid_x1,'%G, ',observedOutput);
        fprintf ('%G, ',observedOutput);
        tstart = tic;
        formatOut = 'FFF';
        tS=datetime('now');
        [f, predictatedOutputBRB]=objFunAllParallelDisv2(x0,brbConfigdata);
        tE=datetime('now');
        datestr(tE-tS,formatOut);
        fprintf (fid_x1,'\nBRBES predictatedOutput=\n');
        fprintf ('\nBRBES predictatedOutput=\n');
        fprintf (fid_x1,'%G, ',predictatedOutputBRB);
        fprintf ('%G, ',predictatedOutputBRB);
        fprintf (fid_x1,'\nBRBES F=%G\n',f);
        fprintf ('\nBRBES F=%G\n',f);
        telapsed = toc(tstart);
        
        tstart = tic;
        formatOut = 'FFF';
        tS=datetime('now');
        [f, predictatedOutputBRB_DL]=BRB_DLv01(x0,brbConfigdata);
        tE=datetime('now');
        datestr(tE-tS,formatOut);
        fprintf (fid_x1,'\nBRB_DL predictatedOutput=\n');
        fprintf ('\nBRB_DL predictatedOutput=\n');
        fprintf (fid_x1,'%G, ',predictatedOutputBRB_DL);
        fprintf ('%G, ',predictatedOutputBRB_DL);
        fprintf (fid_x1,'\nBRB_DL F=%G\n',f);
        fprintf ('\nBRB_DL F=%G\n',f);
        telapsed = toc(tstart);
        
        index=[1:1:length(observedOutput)];
        
        
        formatOut = 'yyyy-mmm-dd_HH_MM_SS';
        dateString = datestr(datetime('now'),formatOut);
        s = strcat('Graph/simulation_result_',dateString,'_',num2str(counter),'.png');
        plot(index,observedOutput,index,predictatedOutputBRB,index,predictatedOutputBRB_DL);
        legend('actualOutput','predictatedOutputBRB','predictatedOutputBRB_DL','Location','SouthEast');
        saveas(gcf,s);
    end
end
dateString = datestr(datetime('now'));
fprintf(fid_x1,'Ending program %s\n',dateString);
fprintf('Ending program %s\n',dateString);
% fprintf ( fid_x1,'____________________________\n');
% fprintf ( fid_x1,[repmat('%2.2f\t', 1, size(t_data_rule, 2)) '\n'], t_data_rule );
fclose(fid_x1);
fclose(fid_f1);
fclose(fid_tp);
