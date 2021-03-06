function [x]=initialize_state(pop, num_ens, M)
% x is (375*5, num_ens)

num_loc=size(pop,1);


% num_var=5*num_loc
% S,E,Is,Ia,obs
% prior range
Slow=1.0;Sup=1.0;%susceptible fraction
Elow=0;Eup=0;%exposed
Irlow=0;Irup=0;%documented infection
Iulow=0;Iuup=0;%undocumented infection
obslow=0;obsup=0;%reported case

xmin=[];
xmax=[];
for i=1:num_loc
    xmin=[xmin;Slow*pop(i);Elow*pop(i);Irlow*pop(i);Iulow*pop(i);obslow];
    xmax=[xmax;Sup*pop(i);Eup*pop(i);Irup*pop(i);Iuup*pop(i);obsup];
end

%seeding in Wuhan (city 170)
seedid=170;
%E
xmin((seedid-1)*5+2)=0;xmax((seedid-1)*5+2)=2000;
%Is
%xmin((seedid-1)*5+3)=0;xmax((seedid-1)*5+3)=0;
%Ia
xmin((seedid-1)*5+4)=0;xmax((seedid-1)*5+4)=2000;
%Latin Hypercubic Sampling
x=lhsu(xmin,xmax,num_ens);
x=x';
for i=1:num_loc
    x((i-1)*5+1:(i-1)*5+4,:)=round(x((i-1)*5+1:(i-1)*5+4,:));
end

%seeding in other cities
C=M(:,seedid,1);%first day
for i=1:num_loc
    if i~=seedid
        %E - exposed
        Ewuhan=x((seedid-1)*5+2,:);
        x((i-1)*5+2,:)=round(C(i)*3*Ewuhan/pop(seedid));
        %Ia - infected anon (unreported)
        Iawuhan=x((seedid-1)*5+4,:);
        x((i-1)*5+4,:)=round(C(i)*3*Iawuhan/pop(seedid));
    end
end

end
