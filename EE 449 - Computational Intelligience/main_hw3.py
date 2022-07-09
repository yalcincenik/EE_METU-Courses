import vaccination
import matplotlib.pyplot as plt
import skfuzzy as fuzzy
import skfuzzy.membership as mf
import numpy as np

'''
    PART 1:
    In this part of the homework we are not researched the failure rates. 
    TASK:
        - Create a object vaccination
        - Create arrays of current percentage of the vaccinated people [0.1]
        - Create control variable(output) as delta = [-0.2, 0.2]
        - Based on fuzzy plot set, finding the membership of the current percentage of the vaccinated people
        - Definition of the rules & applied to our controller
        - Defuzzification
        
        '''
# Create the vaccination v1 object based on the Vaccination class
vaccination_v1 = vaccination.Vaccination()
# Create current percentage of the vaccinated people ndarray
current_vaccinated_people_percentage = np.arange(0, 1, 0.0001)
# Create the control variable delta(the output in this case) in the range [-0.2, 0.2]
output_part_1 = np.arange(-0.2, 0.2, 0.0001)

# I prefer using triangular membership generator, which is done with trimf method in skfuzzy.membership
#  Based on the set partition, define the terms [Low, normal, high]
# mf(x-inp, [a,b,c]-parameters.)
current_vaccinated_people_percentage_LOW = mf.trimf(current_vaccinated_people_percentage, [0, 0, 0.59])
current_vaccinated_people_percentage_NORMAL = mf.trimf(current_vaccinated_people_percentage, [0.59, 0.60, 0.61])
current_vaccinated_people_percentage_HIGH = mf.trimf(current_vaccinated_people_percentage, [0.61, 1, 1])

# Output partition based on triangular membership generator

output_part_1_LOW = mf.trimf(output_part_1, [-0.2, -0.2, -0.0001])
output_part_1_NORMAL = mf.trimf(output_part_1, [-0.0001, 0, 0.0001])
output_part_1_HIGH = mf.trimf(output_part_1, [0.0001, 0.2, 0.2])

# Based on the partitions, plot the sets both measurements and output

figure, (ax0, ax1) = plt.subplots(nrows=2)
ax0.plot(current_vaccinated_people_percentage, current_vaccinated_people_percentage_LOW , 'b',
linewidth=3, label='LOW')
ax0.plot(current_vaccinated_people_percentage, current_vaccinated_people_percentage_NORMAL , 'g',
linewidth=3, label='NORMAL')
ax0.plot(current_vaccinated_people_percentage, current_vaccinated_people_percentage_HIGH , 'r',
linewidth=3, label='HIGH')
ax0.set_title('Current percentage of vaccinated people')
ax0.legend()

ax1.plot(output_part_1, output_part_1_LOW, 'r', linewidth=3, label='LOW')
ax1.plot(output_part_1, output_part_1_NORMAL, 'g', linewidth=3,
label='NORMAL')
ax1.plot(output_part_1, output_part_1_HIGH, 'b', linewidth=3, label='HIGH')
ax1.set_title('Output')
ax1.legend()
plt.show()

# Define the controller input(pi) accordingly
# Do the experiment in 200 iterations
# checkVaccinationStatus(),  returns the current vaccinated percentage and vaccination rate as a two-tuple
# (vaccinated_percentage, vaccination_rate)
for i in range(0, 200, 1):
    current_vaccinated_people_percentage_v1, effective_vaccination_rate_v1 = vaccination_v1.checkVaccinationStatus()
    # Membership of the current vaccination according to the set partitions
    # fuzzy.interp_membership(x, xmf, xx) => Find the degree of membership u(xx) for a given value of x = xx.
    current_vaccinated_people_percentage_v1_LOW = fuzzy.interp_membership(current_vaccinated_people_percentage,
                                                                          current_vaccinated_people_percentage_LOW,
                                                                          current_vaccinated_people_percentage_v1)
    current_vaccinated_people_percentage_v1_NORMAL = fuzzy.interp_membership(current_vaccinated_people_percentage,
                                                                          current_vaccinated_people_percentage_NORMAL,
                                                                          current_vaccinated_people_percentage_v1)
    current_vaccinated_people_percentage_v1_HIGH = fuzzy.interp_membership(current_vaccinated_people_percentage,
                                                                          current_vaccinated_people_percentage_HIGH,
                                                                          current_vaccinated_people_percentage_v1)
    # Control Rules based on HIGH-NORMAL-LOW
    # RULE1 : Output is HIGH when Vaccination percentage LOW
    # RULE2 : Output is NORMAL when Vaccination percentage NORMAL
    # RULE3 : Output is LOW when Vaccination percentage HIGH

    control_rule1 = np.fmin(current_vaccinated_people_percentage_v1_LOW, output_part_1_HIGH)
    control_rule2 = np.fmin(current_vaccinated_people_percentage_v1_NORMAL, output_part_1_NORMAL)
    control_rule3 = np.fmin(current_vaccinated_people_percentage_v1_HIGH, output_part_1_LOW)

    # Defuzzification based on the "The Max Criterion Method"
    # But in skfuzzy.defuzz there are several choices,we will experiment 3 of them
    # Namely, mean of maximum(mom), min of maximum(som), maximum of maximum(lom)

    output_part_1_final = np.fmax(np.fmax(control_rule1, control_rule2), control_rule3)
    output_part_1_final_2 = fuzzy.defuzz(output_part_1, output_part_1_final, 'lom')
    #output_part_1_final_3 = fuzzy.defuzz(output_part_1, output_part_1_final, 'som')
    #output_part_1_final_4 = fuzzy.defuzz(output_part_1, output_part_1_final, 'lom')
    vaccination_v1.vaccinatePeople(output_part_1_final_2 *10 )

# Vaccination population will be updated with those rates for 0.1 day==2.4 hour
vaccinated_percentage_curve = vaccination_v1.vaccinated_percentage_curve_
index1 = 14 # estimated iteration index at which the system is at steady state
vaccinated_rate_curve = vaccination_v1.vaccination_rate_curve_
vaccination_array = vaccinated_rate_curve[:index1]
vaccination_total = np.sum(vaccination_array)
#print(vaccination_spread_total)
vaccination_v1.viewVaccination(index1, vaccination_total, show_plot=True)

'''
    PART 2:
    In this part of the homework we are now researched the failure rates. 
    TASK:
        - Create a object vaccination
        - Create array of current percentage of the vaccinated people [0.1]
        - Create array of current effective vaccination rate in [-1,1]
        - Create control variable(output) as delta = [-0.2, 0.2]
        - Based on fuzzy plot set, finding the membership of the current percentage of the vaccinated people
        - Definition of the rules & applied to our controller
        - Defuzzification

 '''

vaccination_v2 = vaccination.Vaccination()
# Create current percentage of the vaccinated people ndarray
current_vaccinated_people_percentage_part2 = np.arange(0, 1, 0.0001)
# Create array of current effective vaccination rate in [-1,1]
current_effective_vaccination_rate_part2 = np.arange(-1, 1, 0.0001)
# Create the control variable delta(the output in this case) in the range [-0.2, 0.2]
output_part_2 = np.arange(-0.2, 0.2, 0.0001)

# Still I prefer using triangular membership generator, which is done with trimf method in skfuzzy.membership
# Based on the set partition, define the terms Input: [Low, normal, high]
# For the output : [too low, low, normal, high, too high]
current_vaccinated_people_percentage_part2_LOW = mf.trimf(current_vaccinated_people_percentage_part2, [0, 0, 0.59])
current_vaccinated_people_percentage_part2_NORMAL = mf.trimf(current_vaccinated_people_percentage_part2, [0.5901, 0.60,0.61])
current_vaccinated_people_percentage_part2_HIGH = mf.trimf(current_vaccinated_people_percentage_part2, [0.6101, 1, 1])

current_effective_vaccination_rate_part2_LOW = mf.trimf(current_effective_vaccination_rate_part2, [-1, -0.3, -0.05])
current_effective_vaccination_rate_part2_NORMAL = mf.trimf(current_effective_vaccination_rate_part2, [-0.05, 0, 0.1])
current_effective_vaccination_rate_part2_HIGH = mf.trimf(current_effective_vaccination_rate_part2, [0.1, 0.3, 1])

# Output in 5 fuzzy set over [-0.2, 0.2]
output_part_2_TOO_LOW = mf.trimf(output_part_2, [-0.2, -0.2, -0.019])
output_part_2_LOW = mf.trimf(output_part_2, [-0.19, -0.015, -0.01])
output_part_2_NORMAL = mf.trimf(output_part_2, [-0.01, 0.015, 0.02])
output_part_2_HIGH = mf.trimf(output_part_2, [0.02, 0.02, 0.025])
output_part_2_TOO_HIGH = mf.trimf(output_part_2, [0.025, 0.2, 0.2])

# Based on the partitions, plot the sets both measurements and output

fig2, (ax0_part2, ax1_part2, ax2_part2) = plt.subplots(nrows=3)
ax0_part2.plot(current_vaccinated_people_percentage_part2, current_vaccinated_people_percentage_part2_LOW , 'b',
linewidth=3, label='LOW')
ax0_part2.plot(current_vaccinated_people_percentage_part2, current_vaccinated_people_percentage_part2_NORMAL , 'g',
linewidth=3, label='NORMAL')
ax0_part2.plot(current_vaccinated_people_percentage_part2, current_vaccinated_people_percentage_part2_HIGH , 'r',
linewidth=3, label='HIGH')
ax0_part2.set_title('Current percentage of vaccinated people_part2')
ax0_part2.legend()

ax1_part2.plot(current_effective_vaccination_rate_part2, current_effective_vaccination_rate_part2_LOW, 'b',
linewidth=3, label='LOW')
ax1_part2.plot(current_effective_vaccination_rate_part2, current_effective_vaccination_rate_part2_NORMAL, 'g',
linewidth=3, label='NORMAL')
ax1_part2.plot(current_effective_vaccination_rate_part2, current_effective_vaccination_rate_part2_HIGH, 'r',
linewidth=3, label='HIGH')
ax1_part2.set_title('Current effective vaccinated people_part2')
ax1_part2.legend()

ax2_part2.plot(output_part_2, output_part_2_TOO_LOW, 'b',
linewidth=4, label=' TOO LOW')
ax2_part2.plot(output_part_2, output_part_2_LOW, 'b',
linewidth=2, label='LOW')
ax2_part2.plot(output_part_2, output_part_2_NORMAL, 'g',
linewidth=3, label='NORMAL')
ax2_part2.plot(output_part_2, output_part_2_HIGH, 'r',
linewidth=2, label='HIGH')
ax2_part2.plot(output_part_2, output_part_2_TOO_HIGH, 'r',
linewidth=4, label='TOO HIGH')

ax2_part2.set_title('Output part2')
ax2_part2.legend()
plt.show()

for j in range(0, 200, 1):
    current_vaccinated_people_percentage_v2, effective_vaccination_rate_v2 = vaccination_v2.checkVaccinationStatus()
    # Membership of the current vaccination according to the set partitions
    # fuzzy.interp_membership(x, xmf, xx) => Find the degree of membership u(xx) for a given value of x = xx.
    current_vaccinated_people_percentage_v2_LOW = fuzzy.interp_membership(current_vaccinated_people_percentage_part2,
                                                                          current_vaccinated_people_percentage_part2_LOW,
                                                                          current_vaccinated_people_percentage_v2)
    current_vaccinated_people_percentage_v2_NORMAL = fuzzy.interp_membership(current_vaccinated_people_percentage_part2,
                                                                          current_vaccinated_people_percentage_part2_NORMAL,
                                                                          current_vaccinated_people_percentage_v2)
    current_vaccinated_people_percentage_v2_HIGH = fuzzy.interp_membership(current_vaccinated_people_percentage_part2,
                                                                          current_vaccinated_people_percentage_part2_HIGH,
                                                                          current_vaccinated_people_percentage_v2)

    current_effective_vaccination_rate_v2_LOW = fuzzy.interp_membership(current_effective_vaccination_rate_part2,
                                                                          current_effective_vaccination_rate_part2_LOW,
                                                                          effective_vaccination_rate_v2)
    current_effective_vaccination_rate_v2_NORMAL = fuzzy.interp_membership(current_effective_vaccination_rate_part2,
                                                                        current_effective_vaccination_rate_part2_NORMAL,
                                                                        effective_vaccination_rate_v2)
    current_effective_vaccination_rate_v2_HIGH = fuzzy.interp_membership(current_effective_vaccination_rate_part2,
                                                                        current_effective_vaccination_rate_part2_HIGH,
                                                                        effective_vaccination_rate_v2)

    # Control Rules based on HIGH-NORMAL-LOW
    # RULE1 : Output is TOO HIGH when current Vaccination percentage LOW
    # RULE2 : Output is HIGH  when current Vaccination percentage NORMAL
    # AND current effective vaccination rate is LOW
    # RULE3 : Output is NORMAL when current Vaccination percentage NORMAL
    # AND current effective vaccination is NORMAL
    # RULE4 : Output is LOW when current Vaccination percentage NORMAL,
    # AND current effective vaccination is HIGH
    # RULE5 : Output is TOO LOW when Vaccination percentage HIGH

    control_rule1_part2 = np.fmin(current_vaccinated_people_percentage_v2_LOW, output_part_2_TOO_HIGH)
    control_rule2_part2 = np.fmin(np.fmin(current_vaccinated_people_percentage_v2_NORMAL,
                                    current_effective_vaccination_rate_v2_LOW), output_part_2_HIGH)
    control_rule3_part2 = np.fmin(np.fmin(current_vaccinated_people_percentage_v2_NORMAL,
                                    current_effective_vaccination_rate_v2_NORMAL),
                                    output_part_2_NORMAL)
    control_rule4_part2 = np.fmin(np.fmin(current_vaccinated_people_percentage_v2_NORMAL,
                                    current_effective_vaccination_rate_v2_HIGH),
                            output_part_2_LOW)
    control_rule5_part2 = np.fmin(current_vaccinated_people_percentage_v2_HIGH, output_part_2_TOO_LOW)

    # Defuzzification, algorithm given in the report
    rules_update = np.fmax(control_rule1_part2, control_rule2_part2)
    rules_update_2 = np.fmax(control_rule3_part2, control_rule4_part2)
    output_part_2_final = np.fmax(np.fmax(rules_update, rules_update_2), control_rule5_part2)
    output_part_2_final_2 = fuzzy.defuzz(output_part_2, output_part_2_final, 'mom')
    vaccination_v2.vaccinatePeople(output_part_2_final_2 * 10)

# Plots

vaccinated_percentage_curve_part2 = vaccination_v2.vaccinated_percentage_curve_
index2 = 12 # estimated iteration index at which the system is at steady state
vaccinated_rate_curve_part2 = vaccination_v2.vaccination_rate_curve_
vaccination_array_part2 = vaccinated_rate_curve_part2[:index2]
vaccination_total_part2 = np.sum(vaccination_array_part2)
vaccination_v2.viewVaccination(index2, vaccination_total_part2, show_plot=True)

# Comment : Better low cost value tha






