function [R_pu, X_pu, B_pu] = e200756_p2(text_path, library_path)

% Phase 1
% ---------------------------------------------------------------------------------------------------
% Start reading the CSV file by converting to table to using readtable
% function
format long
table_data = readtable(library_path);

% Detect import options for a spreadsheet file, specify the variables to import, and then read the data.
% Create an import options object from a file.

options = detectImportOptions(text_path);

% We are dealing with the data in the range [1 32] in terms of rows

options.DataLines = [1 32];

% Get the values from the table according to options that we have defines above.
% Keep the table values into the array
data_values = table2array(readtable(text_path, options));

% Getting the conductor name from the input file by the help of
% two functions: "fopen, textscan"
% fopen: to open the file and obtain the fileID value.
% textscan : reads data from an open text file into a cell array, C.
fileID = fopen(text_path);
mConductorNameCell = textscan(fileID, '%s', 1, 'delimiter', '\n', 'headerlines',13);
mConductorName = string(mConductorNameCell); % Convert to the string
% (This is C++-style naming for the object)

% Position of the conductor name in the table data
conductor_names = table2cell(table_data(:, 1));
idx = find(contains(conductor_names, mConductorName));
% Gettings raw data from the correct index of the :
    % Outside diameter,
    % AC Resistance
    % GMR 
mOutside_diameter_1 = table2array(table_data(idx, 5));
mRAC_1 = table2array(table_data(idx, 7));
mGMR_1 = table2array(table_data(idx, 8));

% Set data values to corresponding input objects
mS_base = data_values(2);
mV_base = data_values(4);
mlength = data_values(12);

% Type conversions between metric units and imperical units
% 1 inch = 2.54 cm,1 1 foot = 30.48 cm, 1 mile = 1.609 km

mOutside_diameter = mOutside_diameter_1*(0.0264);
mRAC = mRAC_1*(1/1609);
mGMR = mGMR_1*(0.3048);
mS_base = mS_base*1000000 ; % Sbase MVA--> VA
mV_base = mV_base*1000;  % Vbase kV ---> V
mlength = mlength*1000; % length of the line in km-->m

% Phase 2
% ---------------------------------------------------------------------------------------------
number_of_circuit = data_values(6);
n_conductors = data_values(8);
bundle_distance = data_values(10);

if n_conductors == 1 
    gmr_bundle = mGMR;
elseif n_conductors == 2 
    gmr_bundle = (mGMR*bundle_distance)^(1/2); 
elseif n_conductors == 3 
    gmr_bundle = (mGMR*bundle_distance*bundle_distance)^(1/3); 
elseif n_conductors == 4 
    gmr_bundle = (mGMR*bundle_distance*bundle_distance*sqrt(2)*bundle_distance)^(1/4);    
elseif n_conductors == 5 
    gmr_bundle = (mGMR*bundle_distance*bundle_distance* (bundle_distance*(1+sqrt(5))/2) * (bundle_distance*(1+sqrt(5))/2) )^(1/5);    
elseif n_conductors == 6 
    gmr_bundle = (mGMR*bundle_distance*bundle_distance* 2*bundle_distance * bundle_distance*sqrt(3) * bundle_distance*sqrt(3) )^(1/6);    
elseif n_conductors == 7 
    gmr_bundle = (mGMR*bundle_distance*bundle_distance *(bundle_distance/(2*sin(pi/14))) *(bundle_distance/(2*sin(pi/14))) *2*bundle_distance*cos(pi/7) *2*bundle_distance*cos(pi/7))^(1/7);  
elseif n_conductors == 8 
    gmr_bundle = (mGMR*bundle_distance*bundle_distance *bundle_distance*sqrt(2+sqrt(2)) *bundle_distance*sqrt(2+sqrt(2)) *bundle_distance*(1+sqrt(2)) *bundle_distance*(1+sqrt(2)) *bundle_distance*sqrt(4+2*sqrt(2)))^(1/8);
end

% Other GMR calculations

x_1 = data_values(16);
x_2 = data_values(19);
x_3 = data_values(22);

y_1 = data_values(17);
y_2 = data_values(20);
y_3 = data_values(23);

if number_of_circuit==1
    GMR_real = gmr_bundle;

elseif number_of_circuit==2

    x_4 = data_values(31);
    x_5 = data_values(28);
    x_6 = data_values(25);

    y_4 = data_values(32);
    y_5 = data_values(29);
    y_6 = data_values(26);

    a_to_a = sqrt(abs(x_1-x_6)^2+abs(y_1-y_6)^2);
    b_to_b = sqrt(abs(x_2-x_5)^2+abs(y_2-y_5)^2);
    c_to_c = sqrt(abs(x_3-x_4)^2+abs(y_3-y_4)^2);

    gmr_value_of_a_to_a = sqrt(gmr_bundle*a_to_a);
    gmr_value_of_b_to_b  = sqrt(gmr_bundle*b_to_b);
    gmr_value_of_c_to_c  = sqrt(gmr_bundle*c_to_c);

    GMR_real = (gmr_value_of_a_to_a *gmr_value_of_b_to_b*gmr_value_of_c_to_c)^(1/3);
end

% This part finds the GMD values of the conductors

a1_to_b1 = sqrt(abs(x_1-x_2)^2+abs(y_1-y_2)^2);
b1_to_c1 = sqrt(abs(x_2-x_3)^2+abs(y_2-y_3)^2);
c1_to_a1 = sqrt(abs(x_3-x_1)^2+abs(y_3-y_1)^2);

if number_of_circuit==1
    GMD_real =(a1_to_b1*b1_to_c1*c1_to_a1)^(1/3);

elseif number_of_circuit==2
    a1_to_b2 = sqrt(abs(x_1-x_5)^2+abs(y_1-y_5)^2);
    a2_to_b2 = sqrt(abs(x_5-x_6)^2+abs(y_5-y_6)^2);
    a2_to_b1 = sqrt(abs(x_2-x_6)^2+abs(y_2-y_6)^2);
    
    b1_to_c2 = sqrt(abs(x_2-x_4)^2+abs(y_2-y_4)^2);
    b2_to_c2 = sqrt(abs(x_4-x_5)^2+abs(y_4-y_5)^2);
    b2_to_c1 = sqrt(abs(x_3-x_5)^2+abs(y_3-y_5)^2);
    
    c1_to_a2 = sqrt(abs(x_3-x_6)^2+abs(y_3-y_6)^2);
    c2_to_a2 = sqrt(abs(x_4-x_6)^2+abs(y_4-y_6)^2);
    c2_to_a1 = sqrt(abs(x_1-x_4)^2+abs(y_1-y_4)^2);

    GMD_A_to_B = (a1_to_b1*a1_to_b2*a2_to_b2*a2_to_b1)^(1/4);
    GMD_B_to_C = (b1_to_c1*b1_to_c2*b2_to_c2*b2_to_c1)^(1/4);
    GMD_C_to_A = (c1_to_a1*c1_to_a2*c2_to_a2*c2_to_a1 )^(1/4);

    GMD_real = (GMD_A_to_B*GMD_B_to_C*GMD_C_to_A)^(1/3);
end

% Resistance and reactance calculation based on length
resistance = mlength*mRAC/(number_of_circuit*n_conductors); 
inductance = 2*10^(-7)*log(GMD_real/GMR_real);
reactance = 2*pi*50*inductance*mlength ; % 2*pi*L*l
%Susceptence value
epsilon = 8.8541878128*10^(-12);

if number_of_circuit==1
    H1_2 =  sqrt(abs(x_1-x_2)^2+abs(y_1+y_2)^2);
    H1_3 =  sqrt(abs(x_1-x_3)^2+abs(y_1+y_3)^2);
    H2_3 =  sqrt(abs(x_2-x_3)^2+abs(y_2+y_3)^2);

    H_1 = 2*y_1;
    H_2 = 2*y_2;
    H_3 = 2*y_3;

elseif number_of_circuit==2
    H1_2 = (sqrt(abs(x_1-x_2)^2+abs(y_1+y_2)^2)*sqrt(abs(x_1-x_5)^2+abs(y_1+y_5)^2)*sqrt(abs(x_6-x_2)^2+abs(y_6+y_2)^2)*sqrt(abs(x_6-x_5)^2+abs(y_6+y_5)^2) )^(1/4);
    H1_3 = (sqrt(abs(x_1-x_3)^2+abs(y_1+y_3)^2)*sqrt(abs(x_1-x_4)^2+abs(y_1+y_4)^2)*sqrt(abs(x_6-x_3)^2+abs(y_6+y_3)^2)*sqrt(abs(x_6-x_4)^2+abs(y_6+y_4)^2) )^(1/4);
    H2_3 = (sqrt(abs(x_2-x_3)^2+abs(y_2+y_3)^2)*sqrt(abs(x_2-x_4)^2+abs(y_2+y_4)^2)*sqrt(abs(x_5-x_3)^2+abs(y_5+y_3)^2)*sqrt(abs(x_5-x_4)^2+abs(y_5+y_4)^2) )^(1/4);

    H_1 = (2*y_1 * 2*y_6 * sqrt(abs(x_1-x_6)^2+abs(y_1+y_6)^2)*sqrt(abs(x_6-x_1)^2+abs(y_6+y_1)^2) )^(1/4);
    H_2 = (2*y_2 * 2*y_5 * sqrt(abs(x_2-x_5)^2+abs(y_2+y_5)^2)*sqrt(abs(x_5-x_2)^2+abs(y_5+y_2)^2) )^(1/4);
    H_3 = (2*y_3 * 2*y_4 * sqrt(abs(x_3-x_4)^2+abs(y_3+y_4)^2)*sqrt(abs(x_4-x_3)^2+abs(y_4+y_3)^2) )^(1/4);
end

r_equivalent_conductor = mOutside_diameter/2;

if n_conductors == 1 
    r_equivalent_bundle = r_equivalent_conductor;
elseif n_conductors == 2 
    r_equivalent_bundle = (r_equivalent_conductor*bundle_distance)^(1/2); 
elseif n_conductors == 3 
    r_equivalent_bundle = (r_equivalent_conductor*bundle_distance*bundle_distance)^(1/3); 
elseif n_conductors == 4 
    r_equivalent_bundle = (r_equivalent_conductor*bundle_distance*bundle_distance*sqrt(2)*bundle_distance)^(1/4);    
elseif n_conductors == 5 
    r_equivalent_bundle = (r_equivalent_conductor*bundle_distance*bundle_distance* (bundle_distance*(1+sqrt(5))/2) * (bundle_distance*(1+sqrt(5))/2) )^(1/5);    
elseif n_conductors == 6 
    r_equivalent_bundle = (r_equivalent_conductor*bundle_distance*bundle_distance* 2*bundle_distance * bundle_distance*sqrt(3) * bundle_distance*sqrt(3) )^(1/6);    
elseif n_conductors == 7 
    r_equivalent_bundle = (r_equivalent_conductor*bundle_distance*bundle_distance *(bundle_distance/(2*sin(pi/14))) *(bundle_distance/(2*sin(pi/14))) *2*bundle_distance*cos(pi/7) *2*bundle_distance*cos(pi/7))^(1/7);  
elseif n_conductors == 8 
    r_equivalent_bundle = (r_equivalent_conductor*bundle_distance*bundle_distance *bundle_distance*sqrt(2+sqrt(2)) *bundle_distance*sqrt(2+sqrt(2)) *bundle_distance*(1+sqrt(2)) *bundle_distance*(1+sqrt(2)) *bundle_distance*sqrt(4+2*sqrt(2)))^(1/8);  
end

if number_of_circuit==1

    req_real = r_equivalent_bundle;

elseif number_of_circuit==2

    r_eqivalent_a_a = sqrt(r_equivalent_bundle*a_to_a);
    r_eqivalent_b_b = sqrt(r_equivalent_bundle*b_to_b);
    r_eqivalent_c_c = sqrt(r_equivalent_bundle*c_to_c);
    req_real = (r_eqivalent_a_a*r_eqivalent_b_b*r_eqivalent_c_c)^(1/3);
end

capacitance = (2*pi*epsilon)/(log(GMD_real/req_real)-log( ((H1_2*H1_3*H2_3)^(1/3)) / ((H_1*H_2*H_3)^(1/3)) ));
susceptance = (2*pi*50*capacitance);

% Per unit value calculations

z_base_value = mV_base^2/mS_base ;

R_pu = resistance / (z_base_value);
X_pu = reactance / z_base_value;
B_pu = susceptance * mlength* z_base_value;

end






