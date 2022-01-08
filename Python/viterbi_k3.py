gen_poly_1 = "001" #G1
gen_poly_2 = "101" #G2
#constraint_length = 3
#code_rate = 2

#string to list: we need this bc python is weird with binary
#convert string to list i.e:"000"->[0,0,0]
def string_to_list(digit_string):
    digit_map = map(int, digit_string)
    digit_list = list(digit_map)
    return digit_list

#branch metric calculation: this block includes 2 subblocks - encoder and hamming distance calculation

#convolution code block
#first calculate in individual element of output
#code rate = 2 -> two output for one input
def conv_code_inv(input_state,generate_poly):
    out = [0]*len(generate_poly)
    for i in range(int(len(generate_poly))):
        out[i] = int(input_state[i],2) & int(generate_poly[i],2)
    #print(out)
    output = out[0]
    for i in range(1,int(len(generate_poly))):
        output = output ^ out[i]
    return output

#actual convolution code block
def conv_code(input_state, generate_poly_1,generate_poly_2):
    #input =  1,[0,0] -> 3 bit with the first bit is the input

    #calculate the output
    output_1 = conv_code_inv(input_state, generate_poly_1)
    output_2 = conv_code_inv(input_state, generate_poly_2)
    output = str(output_1)+str(output_2)

    return output

#test data
print("test encoder")
in_state_test = "100"   #input =1, current state =00
conv_out = conv_code(in_state_test,gen_poly_1,gen_poly_2)
print("convolution output for input", in_state_test,":",conv_out,"\n") #01

#calculate the hamming distance of a pair of 2-bit code
def hamming_distance(code_1,code_2):
    code_1=string_to_list(code_1)
    code_2=string_to_list(code_2)

    #hamming distance
    ham = (code_1[0]^code_2[0]) + (code_1[1]^code_2[1])
    return ham

#setup state: constraint length = 3-> 2^(3-1)= 4 states
state =[0]*4
state[0]="00"
state[1]="01"
state[2]="10"
state[3]="11"

#calculate each branch of the branch metric calculation
def make_branch(data_in,pre_state,gen_poly_1,gen_poly_2):
    #each state can have take in 2 possible inputs -> 2 output->2 hamming distance => 2 branches
    output_0 = conv_code(str("0") + pre_state, gen_poly_1, gen_poly_2)
    output_1 = conv_code(str("1") + pre_state, gen_poly_1, gen_poly_2)
    ham_0 = hamming_distance(data_in, output_0)
    ham_1 = hamming_distance(data_in, output_1)

    #first output have input = 0, second output have input = 1
    return ham_0, ham_1

#main branch metric calculation block:
def bmc(data_input):
    branches = [0] * len(state)
    for i in range(int(len(state))):
        branches[i]=make_branch(data_input,state[i],gen_poly_1,gen_poly_2)

    #we have 4 states -> 8 branches
    return branches

#test data
print("test bmc")
data_in_test = "01"
branches_test = bmc(data_in_test)
print("branch metric for data in", data_in_test, ":", branches_test,"\n")

#path metric calculation: this block includes 2 subblocks
#register of previous path metric calculation and add-compare-select block
#python don't need reg so we only code acs

#compare select
def compare(data_0,data_1):
    if (data_0 <= data_1):
        min = data_0
        select = 0
    else:
        min = data_1
        select = 1

    return min, select

#calculate the path metric for each stage
def acs_inv(bm_in, pm_in):
    #setup
    pm_out = [0]*len(state)
    path_mem = [0]*len(state) #survival path
    sum_0 = [0]*len(state)
    sum_1 = [0]*len(state)

    #add
    sum_0[0] = bm_in[0][0] + pm_in[0]
    sum_1[0] = bm_in[1][0] + pm_in[1]

    sum_0[1] = bm_in[2][0] + pm_in[2]
    sum_1[1] = bm_in[3][0] + pm_in[3]

    sum_0[2] = bm_in[0][1] + pm_in[0]
    sum_1[2] = bm_in[1][1] + pm_in[1]

    sum_0[3] = bm_in[2][1] + pm_in[2]
    sum_1[3] = bm_in[3][1] + pm_in[3]

    #compare-select
    for i in range(int(len(state))):
        pm_out[i],path_mem[i] = compare(sum_0[i],sum_1[i])

    #smallest state = position of the state with the min path metric among the 4 path metrics
    smallest_state = bin(pm_out.index(min(pm_out)))[2:].zfill(2)
    return pm_out, path_mem,smallest_state

#test data
print("test pmc for the first stage:")
pm_in_test = [0]*4
pm_out_test, path_mem_test,smallest_test = acs_inv(branches_test,pm_in_test)
print("path metric, survival path, smallest state for input",data_in_test,":",pm_out_test,path_mem_test,smallest_test,"\n")

#main add-compare-select block
def acs(input_stream):
    #setup the first stage with all pmc = 0
    pm_in_first = [0] * len(state)
    pm_out = [0]*len(input_stream)
    path_mem = [0]*len(input_stream) #survival path
    branch = [0]*len(input_stream)

    #k = 3 -> 3-1 =2 first stage we assume the previous path metric is 0
    #for verilog the value will be x, for the first cycle and actual pmc for the next cycle
    #for python we need to setup the first pmc
    branch[0] = bmc(input_stream[0])
    pm_out[0], path_mem[0],smallest = acs_inv(branch[0],pm_in_first)

    #second stage and onward
    for i in range(1,int(len(input_stream))):
        branch[i]= bmc(input_stream[i])
        pm_out[i],path_mem[i],smallest =acs_inv(branch[i],pm_out[i-1])
        #print("input",i,":",input_stream[i])

    return pm_out,path_mem,smallest

#test data
print("test pmc for many stages:")
in_stream = ["01","10","11","00","10","01","11","00"]
pm_out_test, path_mem_test,smallest_test = acs(in_stream)
print("input:\t", in_stream)
print("path metric:", pm_out_test)
print("survival path:", path_mem_test)
print("smallest state:", smallest_test,"\n")

#traceback unit
#calculate the next state and decoded bit for the tbu (actually the previous state bc tbu calculate in reverse)
def next_state(n_state,path_mem):
    decimal_state = int(n_state,2)
    output = n_state[0] #decoded bit
    next_state = n_state[1] + str(path_mem[decimal_state])
    return next_state, output

def traceback(start,path_mem):
    #first stage
    #we include the start->end state = received stream length +1
    tb_state = [0]*(len(path_mem)+1)
    tb_state[0]= start
    out = [0]*len(path_mem)

    for i in range(len(path_mem)):
        next,output = next_state(str(tb_state[i]),path_mem[len(path_mem)-1-i])
        tb_state[i+1]= next
        out[i]=output

    #know the start state, we only return the 1->end state
    return tb_state,out

#test data
print("test tbu for input", in_stream)
path, decode_out = traceback(smallest_test,path_mem_test)
#reverse the list for readability
print("traceback path:", path[::-1])
#reverse the list for readability
print("decoded bit string:", decode_out[::-1],"\n")

#test for each clock cycle:
#we first encode a bit string using the convolution encoder
#then use the encoded output as input for the viterbi decoder
#then check if the decoded bit string is the same as the input of the encoder
#then show the error in bit position

#convolution encoder
#generate random input
import random
random_input = [random.choice('01') for _ in range(8)]
random_input = "".join(str(i) for i in random_input)
in_state= "10101000"
#in_state = random_input
in_state_pad = "00"+ in_state #we have to pad 00 first bc k = 3

output_test = [0]*len(in_state)
for i in range(int(len(in_state))):
    output = conv_code(in_state_pad[i:i+3],gen_poly_1,gen_poly_2)
    output_test[i]= output
    #print("clock ",i, ":", output_test[:i+1])

#print("output:", output_test)

#viterbi decoder
decode_out_test = [0]*len(in_state)
decode_out_string = [0]*len(in_state)
for i in range(int(len(output_test))):
    pm_out_test, path_mem_test, smallest_test = acs(output_test[0:i+1])
    path, decode_out_test[i] = traceback(smallest_test, path_mem_test)
    decode_out_string[i] = "".join(str(i) for i in decode_out_test[i][::-1])
    #print("clock", i, ":", decode_out_test[i][::-1])

#function to show different/error in the decoder
def dif(a, b):
    return [i for i in range(len(a)) if a[i] != b[i]]

#print the clock cycle + input + encoded output + decoded bit string + error position
for i in range(int(len(in_state))):
    print("clock:", i)
    print("convolution encoder input:\t\t\t", in_state[0:i+1])
    print("convolution encoder output:\t\t\t", output_test [:i+1])
    print("viterbi decoder decoded bit string: ", decode_out_string[i])
    print("error in position:\t\t\t\t\t", dif(in_state[0:i+1],decode_out_string[i]),"\n")