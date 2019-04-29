function transformedRefVal1Rt=inputTransform(input,RtRef,numberOfInputData)
[M,N]=size(RtRef);
transformedRefVal1Rt=zeros(numberOfInputData,N);
input(find(input>RtRef(1)))=RtRef(1);
input(find(input<RtRef(N)))=RtRef(N);
%for j=1:N
%     transformedRefVal1Rt(find(input== RtRef(j)),j)=1;       
%end
inputc=repmat(input',1,size(RtRef,2));
transformedRefVal1Rt(inputc==RtRef)=1;
for j=1:N-1
    aa=find((RtRef(j)> input ) & (input>RtRef(j+1)));
    transformedRefVal1Rt(aa,j+1)=(RtRef(j)-input(aa))/(RtRef(1)-RtRef(j+1));
    transformedRefVal1Rt(aa,j)=1-transformedRefVal1Rt(aa,j+1);
end    
% for i=1:numberOfInputData
%     input(i);
%     %RtRef(1,2);
%     if input(i)> (RtRef(1))
%         input(i)= RtRef(1,1);
%     elseif  input(i)< (RtRef(N))   
%         input(i)= RtRef(1,N);
%     end
%     for j=1:N
%         if input(i)== (RtRef(j))
%             transformedRefVal1Rt(i,j)= 1;
%         end
%     end
% %     for m=1:N-1
% %         if (RtRef(m)> input(i) ) && (input(i)>RtRef(m+1) )
% %             transformedRefVal1Rt(i,m+1)= (RtRef(m)-input(i))/(RtRef(m)-RtRef(m+1));
% %             transformedRefVal1Rt(i,m)=1-transformedRefVal1Rt(i,m+1);
% %         end
% %     end
%     a=zeros(1,N-1);
%     for m=1:N-1
%         if (RtRef(m)> input(i) ) && (input(i)>RtRef(m+1) )
%             ai,m+1)= (RtRef(m)-input(i))/(RtRef(m)-RtRef(m+1));
%             a(i,m)=1-a(m+1);
%         end
%     end
%     transformedRefVal1Rt(i,:)=a;
end
%transformedRefVal1Rt;
%return transformedRefVal1Rt