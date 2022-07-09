function [S_base, V_base, N_circuit, N_bundle, d_bundle, length, conductor_name, outside_diameter, RAC, GMR_conductor] = e200756_p1(text_path, library_path)

    % Start reading the CSV file by converting to table to using readtable
    % function
    table_data = readtable(library_path, "VariableNamingRule","preserve");

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
    mN_circuit = data_values(6);
    mN_bundle = data_values(8);
    md_bundle = data_values(10);

    % Type conversions between metric units and imperical units
    % 1 inch = 2.54 cm,1 1 foot = 30.48 cm, 1 mile = 1.609 km
    
    mOutside_diameter = mOutside_diameter_1*(0.0264);
    mRAC = mRAC_1*(1/1609);
    mGMR = mGMR_1*(0.3048);
    mS_base = mS_base*1000000 ; % Sbase MVA--> VA
    mV_base = mV_base*1000;  % Vbase kV ---> V
    mlength = mlength*1000; % length of the line in km-->m

    % Assign each value to the actual input parameters.

    S_base = mS_base;
    V_base = mV_base;
    N_circuit = mN_circuit;
    N_bundle = mN_bundle;
    d_bundle = md_bundle;
    length = mlength;
    conductor_name = mConductorName;
    outside_diameter = mOutside_diameter;
    RAC = mRAC;
    GMR_conductor = mGMR;
    
end
