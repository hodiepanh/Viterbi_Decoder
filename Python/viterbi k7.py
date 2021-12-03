gen_poly_1 = "1010"
gen_poly_2 = "0011"
in_stream = ["00","01","11","10","00","11"]
#in_stream = ["00","01","11","10","01","10"]

#constraint_length = 4
#code_rate = 2
#number to list: we need this bc python is weird with binary
#convert string to list i.e:"000"->[0,0,0]
def string_to_list(digit_string):
    digit_map = map(int, digit_string)
    digit_list = list(digit_map)
    return digit_list

#calculate the output of the convolution code block
#first calculate in individual element of output
#code rate = 2-> two output for one input
def conv_code_inv(input_state,generate_poly):
    #input_state = string_to_list(input_state)
    #generate_poly = string_to_list(generate_poly)

    out = [0]*len(generate_poly)
    for i in range(int(len(generate_poly))):
        out[i] = int(input_state[i],2) & int(generate_poly[i],2)
    #print(out)
    output = out[0]
    for i in range(1,int(len(generate_poly))):
        output = output ^ out[i]
    return output

#test data
in_state = "0010"
out1= conv_code_inv(in_state,gen_poly_1)
out2= conv_code_inv(in_state,gen_poly_2)
print(out1,out2)

#actual convolution code block
def conv_code(input_state, generate_poly_1,generate_poly_2):
    #input =  1,[0,0] -> 3 bit with the first bit is the input

    #calculate the output
    output_1 = conv_code_inv(input_state, generate_poly_1)
    output_2 = conv_code_inv(input_state, generate_poly_2)
    output = str(output_1)+str(output_2)

    return output

#test data
in_state = "0010"
out = conv_code(in_state,gen_poly_1,gen_poly_2)
print(out)

#viterbi decode block

#branch metric calculation
#calculate the hamming distance of a pair of 2-bit code
def hamming_distance(code_1,code_2):
    code_1=string_to_list(code_1)
    code_2=string_to_list(code_2)

    #hamming distance
    ham = (code_1[0]^code_2[0]) + (code_1[1]^code_2[1])
    return ham

#setup state: constraint length = 3-> 2^3=8 states
#this will be different for constraint length = 7 (64 states)
#setup state: constraint length = 7-> 2^6=64 states we love to suffer
state=[0]*64
state[0]="000000"
state[1]="000001"
state[2]="000010"
state[3]="000011"
state[4]="000100"
state[5]="000101"
state[6]="000110"
state[7]="000111"
state[8]="001000"
state[9]="001001"
state[10]="001010"
state[11]="001011"
state[12]="001100"
state[13]="001101"
state[14]="001110"
state[15]="001111"

state[16]="010000"
state[17]="010001"
state[18]="010010"
state[19]="010011"
state[20]="010100"
state[21]="010101"
state[22]="010110"
state[23]="010111"
state[24]="011000"
state[25]="011001"
state[26]="011010"
state[27]="011011"
state[28]="011100"
state[29]="011101"
state[30]="011110"
state[31]="011111"

state[32]="100000"
state[33]="100001"
state[34]="100010"
state[35]="100011"
state[36]="100100"
state[37]="100101"
state[38]="100110"
state[39]="100111"
state[40]="101000"
state[41]="101001"
state[42]="101010"
state[43]="101011"
state[44]="101100"
state[45]="101101"
state[46]="101110"
state[47]="101111"

state[48]="110000"
state[49]="110001"
state[50]="110010"
state[51]="110011"
state[52]="110100"
state[53]="110101"
state[54]="110110"
state[55]="110111"
state[56]="111000"
state[57]="111001"
state[58]="111010"
state[59]="111011"
state[60]="111100"
state[61]="111101"
state[62]="111110"
state[63]="111111"

def make_branch(data_in,pre_state,gen_poly_1,gen_poly_2):
    #each state can have take in 2 possible inputs -> 2 output->2 hamming distance => 2 branches
    output_0 = conv_code(str("0") + pre_state, gen_poly_1, gen_poly_2)
    output_1 = conv_code(str("1") + pre_state, gen_poly_1, gen_poly_2)
    ham_0 = hamming_distance(data_in, output_0)
    ham_1 = hamming_distance(data_in, output_1)

    #we know the first output have input = 0, second ouput have input = 1
    return ham_0, ham_1

#number of state = 64
def bmc(data_input):

    branches = [0] * len(state)
    for i in range(int(len(state))):
        branches[i]=make_branch(data_input,state[i],gen_poly_1,gen_poly_2)

    #we have 4 states -> 8 branches
    return branches

#test data
test_data="00"
branches_test = bmc(test_data)
print("bm for ",test_data,":",branches_test)

#add compare select
def compare(data_0,data_1):
    if (data_0 <= data_1):
        min = data_0
        select = 0
    else:
        min = data_1
        select = 1

    return min, select

#test data
#min_test, select_test = compare(0,0)
#print(min_test,select_test)

#k=7
def acs_inv(bm_in, pm_in):
    #first stage
    pm_out = [0]*len(state)
    path_mem = [0]*len(state)
    sum_0 = [0]*len(state)
    sum_1 = [0]*len(state)

    # branch 0
    cnt = 0
    for i in range(0, int(len(state)), 2):
        sum_0[cnt] = bm_in[i][0] + pm_in[i]
        sum_1[cnt] = bm_in[i + 1][0] + pm_in[i + 1]
        cnt = cnt + 1
    # branch 1
    for i in range(0, int(len(state)), 2):
        sum_0[cnt] = bm_in[i][1] + pm_in[i]
        sum_1[cnt] = bm_in[i + 1][1] + pm_in[i + 1]
        cnt = cnt + 1

    for i in range(int(len(state))):
        pm_out[i],path_mem[i] = compare(sum_0[i],sum_1[i])

    smallest = min(pm_out)
    #print(pm_out)
    start = bin(pm_out.index(min(pm_out)))[2:].zfill(6)
    return pm_out, path_mem,smallest, start

pm_in_test = [0]*len(state)
pm_out_test, path_mem_test,smallest_test,start_test = acs_inv(branches_test,pm_in_test)
print(pm_out_test,path_mem_test,smallest_test,start_test)

#branch_next = bmc("01")
#print(branch_next)
#pm_in_next = pm_out_test
#pm_out_next, path_mem_next,smallest_next,start_next = acs_inv(branch_next,pm_in_next)
#print(pm_out_next,path_mem_next,smallest_next,start_next)

def acs(input_stream):
    #setup the first stage with all bmc = 0
    pm_in_first = [0] * len(state)
    pm_out = [0]*len(input_stream)
    path_mem = [0]*len(input_stream)
    branch = [0]*len(input_stream)

    branch[0] = bmc(input_stream[0])
    pm_out[0], path_mem[0],smallest, start= acs_inv(branch[0],pm_in_first)
    #print(pm_out, path_mem[0],smallest,start)

    #second stage
    for i in range(1,int(len(input_stream))):
        branch[i]= bmc(input_stream[i])
        pm_out[i],path_mem[i],smallest,start=acs_inv(branch[i],pm_out[i-1])

    return pm_out,path_mem,smallest,start



pm_out_test, path_mem_test,smallest_test,start_state = acs(in_stream)
print(pm_out_test)
print(path_mem_test)
print(smallest_test)
print("start_state:", start_state)
#traceback unit
#change this for k = 7
def next_state(n_state,path_mem):
    decimal_state = int(n_state,2)
    output = n_state[0]
    next_state = n_state[1:] + str(path_mem[decimal_state])
    return next_state, output

#test = next_state("00",[0,0,0,1])
#print(test)

def traceback(start,path_mem):
    #first stage
    #in state we include the start->end state = received stream length +1
    tb_state = [0]*(len(path_mem)+1)
    tb_state[0]= start
    out = [0]*len(path_mem)

    for i in range(len(path_mem)):
        next,output = next_state(str(tb_state[i]),path_mem[len(path_mem)-1-i])
        tb_state[i+1]= next
        out[i]=output
    #know the start state is 00, we only return the 1->7 state
    return tb_state,out

#default_start = "01"
path, decode_out = traceback(start_state,path_mem_test)
print(path[::-1])
#reverse the list for readability
print(decode_out[::-1])


