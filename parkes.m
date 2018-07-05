function [total, percentage, eliminatedPoints, FinalPoints] = parkes(y,yp)
% PARKES    Performs Parkes Error Grid Analysis
%
% The Clarke error grid approach is used to assess the clinical
% significance of differences between the glucose measurement technique
% under test and the venous blood glucose reference measurements. The
% method uses a Cartesian diagram, in which the values predicted by the
% technique under test are displayed on the y-axis, whereas the values
% received from the reference method are displayed on the x-axis. The
% diagonal represents the perfect agreement between the two, whereas the
% points below and above the line indicate, respectively, overestimation
% and underestimation of the actual values. Zone A (acceptable) represents
% the glucose values that deviate from the reference values by 20% or are
% in the hypoglycemic range (<70 mg/dl), when the reference is also within
% the hypoglycemic range. The values within this range are clinically exact
% and are thus characterized by correct clinical treatment. Zone B (benign
% errors) is located above and below zone A; this zone represents those
% values that deviate from the reference values, which are incremented by
% 20%. The values that fall within zones A and B are clinically acceptable,
% whereas the values included in areas C-E are potentially dangerous, and
% there is a possibility of making clinically significant mistakes. [1-4]
%
% Parkes error grid approach is a different approach in the same line of
% Clarke error grid
%
% SYNTAX:
% 
% [total, percentage , eliminatedPoints, FinalPoints] = parkes(y,yp)
% 
% INPUTS: 
% y             Reference values (mg/dl) 
% yp            Predicted/estimtated values (mg/dl)
% 
% OUTPUTS: 
% total         Total points per zone: 
%               total(1) = zone A, 
%               total(2) = zone B, and so on
% percentage    Percentage of data which fell in certain region:
%               percentage(1) = zone A, 
%               percentage(2) = zone B, and so on.
% eliminatedPoints Points deleted because of out of boundaries
% FinalPoints  Total Plotted points
% 
% EXAMPLE:      load example_data.mat 
%               [tot, per, el, points] = clarke(y,yp)
% 
% References:  
% [1]  A. Maran et al. "Continuous Subcutaneous Glucose Monitoring in Diabetic 
%       Patients" Diabetes Care, Volume 25, Number 2, February 2002
% [2]   B.P. Kovatchev et al. "Evaluating the Accuracy of Continuous Glucose-
%       Monitoring Sensors" Diabetes Care, Volume 27, Number 8, August 2004
% [3]   E. Guevara and F. J. Gonzalez, Prediction of Glucose Concentration by
%       Impedance Phase Measurements, in MEDICAL PHYSICS: Tenth Mexican 
%       Symposium on Medical Physics, Mexico City (Mexico), 2008, vol. 1032, pp.
%       259261. 
% [4]   E. Guevara and F. J. Gonzalez, Joint optical-electrical technique for
%       noninvasive glucose monitoring, REVISTA MEXICANA DE FISICA, vol. 56, 
%       no. 5, pp. 430434, Sep. 2010. 
% [5]   JL Parkes, SL Slatin, S Pardo, BH Ginsberg - Diabetes Care, 2000 
%       A new consensus error grid to evaluate the clinical significance of 
%       inaccuracies in the measurement of blood glucose. Diabetes Care
%        23(8):1143–1148., 2000
% [6]   J. Ignacio Hidalgo, J. Manuel Colmenar, Jose L. Risco-Martín, 
%       Esther Maqueda, Marta Botella, Jose Antonio Rubio, Alfredo Cuesta
%       Oscar Garnica, and Juan Lanchares. 2014. 
%       Clarke and parkes error grid analysis of diabetic glucose models 
%       obtained with evolutionary computation. In Proceedings of the 2014 
%       conference companion on Genetic and evolutionary computation companion 
%       (GECCO Comp '14). ACM, New York, NY, USA, 1305-1312..

%  Edgar Guevara Codina 
% codina@REMOVETHIScactus.iico.uaslp.mx 
% File Version 1.2 
% March 29 2013 
% 
% Ignacio Hidalgo, Parkes version
% September 15 2014
%hidalgo@ucm.es
%Adaptive and Bioinspired Systems Group 
%Universidad Complutense de Madrid (Spain)
% Included deleting values out of boundaries
% July 5th 2018
%
% Ver. 1.2 Statistics verified, fixed some errors in the display; thanks to Tim
% Ruchti from Hospira Inc. for the corrections
% Ver. 1.1 corrected upper B-C boundary, lower B-C boundary slope ok; thanks to
% Steven Keith from BD Technologies for the corrections! 
% 
% MATLAB ver. 7.10.0.499 (R2010a)
% ------------------------------------------------------------------------------

% Error checking
if nargin == 0
 error('parkes:Inputs','There are no inputs.')
end
if length(yp) ~= length(y)
    error('parkes:Inputs','Vectors y and yp must be the same length.')
end
%if (max(y) > 550) || (max(yp) > 550) || (min(y) < 0) || (min(yp) < 0)
 %   error('parkes:Inputs','Vectors y and yp are not in the physiological range of glucose (<400mg/dl).')
%end
% -------------------------- Print figure flag ---------------------------------
PRINT_FIGURE = true;
% ------------------------- Determine data length ------------------------------
n = length(y);
% ------------- Deleting Points out of boundaries ------------------------------
eliminatedPoints=0;
j=1;
for i=1:n
    if (y(i) < 550) & (y(i) < 550) & (yp(i) > 0) & (yp(i) > 0)
        y1(j)=y(i);
        yp1(j)=yp(i);
        j=j+1;
    else
       eliminatedPoints=eliminatedPoints+1;
    end  
end
n = length(y1);
y=y1;
yp=yp1;
% ------------------------- Plot Parker's Error Grid ---------------------------
h = figure;
plot(y,yp,'ko','MarkerSize',4,'MarkerFaceColor','k','MarkerEdgeColor','k');
xlabel('Reference Concentration [mg/dl]');
ylabel ('Predicted Concentration [mg/dl]');
title('Parker''s Error Grid Analysis');
set(gca,'XLim',[0 550]);
set(gca,'YLim',[0 550]);
axis square
hold on
plot([0 550],[0 550],'k:')                  % Theoretical 45 regression line line 4 ok
plot([0 37 50],[150 152 550],'k-')                   % line 8 ok
plot([0 25 50 250/3 120],[100 100 125 215 550],'k-')    % line 7 ok
plot([0 30 50 70 250],[58 58 75 112 550],'k-')             % line 6
plot([0 30 50 140 275 415],[50 50 67.5 165 350+100/3 550],'k-')             % line 5
plot([50 50 200 350+100/3 550],[0 35 150 300 450],'k-')             % line 3
plot([120 120 260 550],[0 35 140 225],'k-')             % line 2
plot([250 250 550],[0 50 150],'k-')                       % line 1





text(20,500,'E','FontSize',12);
text(75,480,'D','FontSize',12);
text(150,460,'C','FontSize',12);
text(250,440,'B','FontSize',12);
text(300,375,'A','FontSize',12);
text(350,320,'A','FontSize',12);
text(400,220,'B','FontSize',12);
text(430,150,'C','FontSize',12);
text(475,75,'D','FontSize',12);
set(h, 'color', 'white');                   % sets the color to white 
% Specify window units
set(h, 'units', 'inches')
% Change figure and paper size (Fixed to 3x3 in)
set(h, 'Position', [0.1 0.1 3 3])
set(h, 'PaperPosition', [0.1 0.1 3 3])
if PRINT_FIGURE
    % Saves plot as a Enhanced MetaFile
  %  print(h,'-dmeta','Parker_EGA');           
    % Saves plot as PNG at 300 dpi
    print(h, '-dpng', 'Parker_EGA', '-r300'); 
end
total = zeros(5,1);                         % Initializes output
% ------------------------------- Statistics -----------------------------------
for i=1:n,
    if (yp(i) <= 70 && y(i) <= 70) || (yp(i) <= 1.2*y(i) && yp(i) >= 0.8*y(i))
        total(1) = total(1) + 1;            % Zone A
    else
        if ( (y(i) >= 180) && (yp(i) <= 70) ) || ( (y(i) <= 70) && yp(i) >= 180 )
            total(5) = total(5) + 1;        % Zone E
        else
            if ((y(i) >= 70 && y(i) <= 290) && (yp(i) >= y(i) + 110) ) || ((y(i) >= 130 && y(i) <= 180)&& (yp(i) <= (7/5)*y(i) - 182))
                total(3) = total(3) + 1;    % Zone C
            else
                if ((y(i) >= 240) && ((yp(i) >= 70) && (yp(i) <= 180))) || (y(i) <= 175/3 && (yp(i) <= 180) && (yp(i) >= 70)) || ((y(i) >= 175/3 && y(i) <= 70) && (yp(i) >= (6/5)*y(i)))
                    total(4) = total(4) + 1;% Zone D
                else
                    total(2) = total(2) + 1;% Zone B
                end                         % End of 4th if
            end                             % End of 3rd if
        end                                 % End of 2nd if
    end                                     % End of 1st if
end                                         % End of for loop
percentage = (total./n)*100;
FinalPoints = n;
% ------------------------------------------------------------------------------
% EOF
