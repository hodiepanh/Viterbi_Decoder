gen_poly_1 = "001"
gen_poly_2 = "101"
#in_stream = ["01","10","11","00","10","01","11","00"]
#in_stream = ["00","01","11","10","01","10"]

#constraint_length = 3
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
#in_state = "011"
#out1= conv_code_inv(in_state,gen_poly_1)
#out2= conv_code_inv(in_state,gen_poly_2)
#print(out1,out2)

#actual convolution code block
def conv_code(input_state, generate_poly_1,generate_poly_2):
    #input =  1,[0,0] -> 3 bit with the first bit is the input

    #calculate the output
    output_1 = conv_code_inv(input_state, generate_poly_1)
    output_2 = conv_code_inv(input_state, generate_poly_2)
    output = str(output_1)+str(output_2)

    return output

#test data
#in_state = "001"
#out = conv_code(in_state,gen_poly_1,gen_poly_2)
#print(out)

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
state =[0]*4
state[0]="00"
state[1]="01"
state[2]="10"
state[3]="11"

def make_branch(data_in,pre_state,gen_poly_1,gen_poly_2):
    #each state can have take in 2 possible inputs -> 2 output->2 hamming distance => 2 branches
    output_0 = conv_code(str("0") + pre_state, gen_poly_1, gen_poly_2)
    output_1 = conv_code(str("1") + pre_state, gen_poly_1, gen_poly_2)
    ham_0 = hamming_distance(data_in, output_0)
    ham_1 = hamming_distance(data_in, output_1)

    #we know the first output have input = 0, second ouput have input = 1
    return ham_0, ham_1

#number of state = 4 -> change this for k = 7
def bmc(data_input):

    branches = [0] * len(state)
    for i in range(int(len(state))):
        branches[i]=make_branch(data_input,state[i],gen_poly_1,gen_poly_2)

    #we have 4 states -> 8 branches
    return branches

# test data
# branches_test = bmc("01")
# print(branches_test)

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

#4 states->change this for k=7
#always start at state 0
def acs_inv(bm_in, pm_in):
    #first stage
    pm_out = [0]*len(state)
    path_mem = [0]*len(state)
    sum_0 = [0]*4
    sum_1 = [0]*4

    #i=0
    sum_0[0] = bm_in[0][0] + pm_in[0]
    sum_1[0] = bm_in[1][0] + pm_in[1]

    sum_0[1] = bm_in[2][0] + pm_in[2]
    sum_1[1] = bm_in[3][0] + pm_in[3]

    sum_0[2] = bm_in[0][1] + pm_in[0]
    sum_1[2] = bm_in[1][1] + pm_in[1]

    sum_0[3] = bm_in[2][1] + pm_in[2]
    sum_1[3] = bm_in[3][1] + pm_in[3]

    for i in range(int(len(state))):
        pm_out[i],path_mem[i] = compare(sum_0[i],sum_1[i])

    smallest = min(pm_out)
    #print(pm_out)
    start = bin(pm_out.index(min(pm_out)))[2:].zfill(2)
    return pm_out, path_mem,smallest, start

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

    #k = 3 -> 3-1 =2 first stage no compare
    branch[0] = bmc(input_stream[0])
    pm_out[0], path_mem[0],smallest, start= acs_inv(branch[0],pm_in_first)
    #print(pm_out, path_mem[0],smallest,start)

    #second stage
    for i in range(1,int(len(input_stream))):
        branch[i]= bmc(input_stream[i])
        pm_out[i],path_mem[i],smallest,start=acs_inv(branch[i],pm_out[i-1])

    return pm_out,path_mem,smallest,start


#traceback unit
#change this for k = 7
def next_state(n_state,path_mem):
    decimal_state = int(n_state,2)
    output = n_state[0]
    next_state = n_state[1] + str(path_mem[decimal_state])
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

f1 = open("E:\\Term20211\\TKHTS2\\input_16bit.txt",'r',encoding = 'utf-8')  #open file text to read input data
f2 = open("E:\\Term20211\\TKHTS2\\output_8bit.txt",'a') #open file text to write output data

for i in range(1000): 
    str1 = f1.readline()
    in_stream = [str1[0:2],str1[2:4],str1[4:6],str1[6:8],str1[8:10],str1[10:12],str1[12:14],str1[14:16]]
    print("Input sequence bits: ",in_stream)
    pm_out_test, path_mem_test,smallest_test,start_state = acs(in_stream)
    path, decode_out = traceback(start_state,path_mem_test)
    print("Path: ",path)
    #reverse the list for readability
    print("Decoded sequence bits",decode_out[::-1])
    f2.writelines(decode_out[::-1])
    f2.write("\n")
    print("*************************************************************\n")