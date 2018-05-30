import random
import SD_to_decimal as conv

class LFSRGenerator:
    
    def __init__(self, mask, initial_value, LFSR_BIT):
        self.mask = mask;
        self.value = initial_value;
        self.max_value = 2**LFSR_BIT;
    
    def __parity(self, x):
        k = 0
        d = x
        while d != 0:
            k = k + 1
            d = d & (d - 1)
        return k % 2

    def updateLFSR(self):
        # print (self.value);
        value_after_mask = self.mask & self.value;
        result = 1-self.__parity(value_after_mask);
        temp = self.value*2;
        # print (self.mask, self.value, value_after_mask, result, temp);
        # print (type(self.mask), type(self.value), type(value_after_mask), type(result), type(temp));
        if (temp>=self.max_value):
            self.value = result+temp-self.max_value;
        else:
            self.value = result+temp;
        # print (self.value);

    def output(self):
        if (self.value%2):
            return "1";
        else:
            return "0";


class LFSRBlock:
    
    def __init__(self, mask, initial_value, LFSR_BIT, no_of_bits):
        self.LFSRs = [];
        for i in range(no_of_bits):
            self.LFSRs.append(LFSRGenerator(mask, i+1+initial_value, LFSR_BIT));

    def output(self):
        result = "";
        for i in range(len(self.LFSRs)):
            # print (len(self.LFSRs)-1-i);
            result += self.LFSRs[len(self.LFSRs)-1-i].output();
            self.LFSRs[len(self.LFSRs)-1-i].updateLFSR();
        return result;

def generateInputData():
    common_mask = "10000000001000000000000000000011";
    common_mask_dec = int(common_mask, 2);
    init_offset = [0, 1451698946, 1537598292];
    LFSR_BIT = 32;
    no_of_digits = 8;
    radix_bits = 3;
    no_of_bits = no_of_digits * radix_bits;

    LFSR_block_1 = LFSRBlock(common_mask_dec, init_offset[0], LFSR_BIT, no_of_bits);
    LFSR_block_2 = LFSRBlock(common_mask_dec, init_offset[1], LFSR_BIT, no_of_bits);
    LFSR_block_3 = LFSRBlock(common_mask_dec, init_offset[2], LFSR_BIT, radix_bits);

    file1 = open("../data/input_data1.txt", "w");
    file2 = open("../data/input_data2.txt", "w");
    file3 = open("../data/input_data3.txt", "w");


    for i in range(16382):
        # print (LFSR_block_1.output(), int(LFSR_block_1.output(), 2));
        # temp = LFSR_block_2.output();
        # print (temp, int(temp, 2), LFSR_block_3.output());
        write_str_1 = LFSR_block_1.output()+"\n";
        write_str_2 = LFSR_block_2.output()+"\n";
        write_str_3 = LFSR_block_3.output()+"\n";
        file1.write(write_str_1);
        file2.write(write_str_2);
        file3.write(write_str_3);
        
    file1.close();
    file2.close();
    file3.close();

def calcAddDiff(din1, din2, cin, dout, radix_bits):
    '''
    This function converts inputs from binary string to decimals and compare if din1+din2 == dout
    
    '''
    data1 = conv.restoreNumberFromSD(din1, radix_bits);
    data2 = conv.restoreNumberFromSD(din2, radix_bits);
    data3 = conv.restoreNumberFromSD(cin, radix_bits);
    data4 = conv.restoreNumberFromSD(dout, radix_bits);
    # print (data1, din1, data2, din2, data3, cin, data4, dout);
    return data4-data3-data2-data1;

def main():
    generateInputData();
    
    file1 = open("../data/input_data1.txt", "r");
    file2 = open("../data/input_data2.txt", "r");
    file3 = open("../data/input_data3.txt", "r");
    radix_bits = 3;

    for j in range(1):
        file_name = "../data/RAM"+str(j)+".hex";
        print (file_name);
        file4 = open(file_name, "r");
        file4.close();
        for i in range(16382):
            din1 = file1.readline();
            din2 = file2.readline();
            cin = file3.readline();
            dout = file4.readline()[10:17];
            dout = bin(int(dout, 16))[2:].zfill(radix_bits*8);
            temp_diff = calcAddDiff(din1, din2, cin, dout, radix_bits);
            if (temp_diff != 0):
                print ("error with diff ", temp_diff, din1, din2, cin, dout);
                print ("current i is" , i);
        file4.close();
    file1.close();
    file2.close();
    file3.close();
    

if __name__ == "__main__":
    main();
