function [kymo] = create_kymograph(data, binsize, num_Naan_thr)
    arguments
        data;
        % bins for spatial averaging
        binsize=1;
        % threshold for including given distance from centroid
        % Will not return value on kymograph if more than this percentage of
        % points at that distance are outside the extent of the tissue
        num_Naan_thr = 0.95;
    end

% create_kymograph generates kymograph from stack
% Inputs:
% data: 3-dimensional array to be made in a kymograph (e.g. stack of velocity fields)
% binsize: bins for spatial averaging, default value = 1;

%% Make kymographs
firstImageSlice=data(:,:,1); %look at the first timepoint for image size info
numberOfSlices=size(data,3); %see how many timepoints are present

%make a distance map that returns the distance of every measurement from the 
%tissue centroid (here tissues are segmented with the original tissue 
%centroid also corresponding to the image centroid.
thisCentroid=size(firstImageSlice)/2+0.5;
% thisCentroid =[120,150];
% thisCentroid=[xc, yc];
[Y,X]=meshgrid(1:size(firstImageSlice,1),1:size(firstImageSlice,2));
disFromCentroidYX=sqrt((X-thisCentroid(2)).^2+(Y-thisCentroid(1)).^2); 

kymoLength=round(min(thisCentroid-0.5));%set the spatial extent of the kymograph
kymo=nan(numberOfSlices,kymoLength); %predefine the kymograph with NaNs
tcounter=1; %counter for timeslices
%outer loop is over timepoints
for t=1:1:numberOfSlices
       thisArraySlice=data(:,:,t);
       rCounter=1;
       %inner loop is over bins
       for r=binsize:binsize:kymoLength

               if r<=binsize %first bin is from the center to the binsize

                   kymo(tcounter,1)=nanmean(thisArraySlice((disFromCentroidYX>=0)&(disFromCentroidYX<=binsize)));
               else %successive bins are between inner and outer sizes
                    elementIsNan=isnan(thisArraySlice((disFromCentroidYX>r-binsize)&(disFromCentroidYX<=r)));
                    numberOfElements=length(elementIsNan);
                    numberOfNans=sum(elementIsNan); 
                    %numberOfNans returns the number of measurements
                    %that are outside of the tissue at a given distance
                    %from the centroid
                   if numberOfNans/numberOfElements<=num_Naan_thr
                       %do not record a value on the kymograph for a given 
                       %distance from the centroid if more than 75% of the
                       %points at that distance are outside the extent of 
                       %the tissue
                        kymo(tcounter,rCounter)=nanmean(thisArraySlice((disFromCentroidYX>r-binsize)&(disFromCentroidYX<=r)));
                   end
               end
           rCounter=rCounter+1;
       end
    tcounter=tcounter+1;
end