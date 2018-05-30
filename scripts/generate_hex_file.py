import math

def ChangeHex(n):
    if (n < 0):
        print(0)
    elif (n<=1):
        print (n),
    else:
        ChangeHex( n / 16 )
        x =(n%16)
        if (x < 10):
            print(x), 
        if (x == 10):
            print("A"),
        if (x == 11):
            print("B"),
        if (x == 12):
            print("C"),
        if (x == 13):
            print("D"),
        if (x == 14):
            print("E"),
        if (x == 15):
            print ("F"),


def calcChecksum(input_str):
    temp = 0;
    for i in range((len(input_str)-1)/2):
        temp += int(input_str[2*i+1: 2*i+3], 16);
    temp = temp % 256;
    temp = 256 - temp;
    temp = "{0:#0{1}X}".format(temp,4);
    temp = temp[(len(temp)-2):len(temp)];
    return temp;

def generateHexFile(no_of_digits, radix_bits, burst_index, max_ram_address):

    file_1 = open("../data/RAMwrite0.hex", "w");
    file_2 = open("../data/RAMwrite1.hex", "w");
    no_of_bytes = int(math.ceil(no_of_digits+1)*radix_bits*burst_index/8);
    zeros_str = "";
    one_str = "";
    byte_count = "{0:#0{1}X}".format(no_of_bytes,4)[2:];
    for i in range(no_of_bytes):
        zeros_str += "00";
        if (i != no_of_bytes -1):
            one_str += "00";
        else:
            one_str += "{0:#0{1}X}".format((2**radix_bits)-1,4)[2:];
    for i in range(max_ram_address-1):
        temp = ":";
        # temp += str(ChangeHex(262144+i));
        temp += byte_count;
        address = "{0:#0{1}X}".format(i,6)[2:];
        temp += address;
        temp += "00";
        temp += zeros_str;
        checksum = calcChecksum(temp);
        # checksum = hex(4096-temp[1:3])[3:6];
        temp += checksum;
        temp += "\n";
        # print (temp);
        file_1.write(temp);
        file_2.write(temp);

    temp = ":";
    # temp += str(ChangeHex(262144+i));
    temp += byte_count;
    address = "{0:#0{1}X}".format(max_ram_address-1,6)[2:];
    temp += address;
    temp += "00";
    temp1 = temp + one_str;
    temp += zeros_str;
    checksum = calcChecksum(temp);
    checksum1 = calcChecksum(temp1);
    # checksum = hex(4096-temp[1:3])[3:6];
    temp += checksum;
    temp += "\n";
    temp1+= checksum1;
    temp1+= "\n";
    file_1.write(temp);
    file_2.write(temp1);
    file_1.write(":00000001FF");
    file_2.write(":00000001FF");
    file_1.close();
    file_2.close();

def main():
    no_of_digits = 8;
    radix_bits = 3;
    burst_index = 8;
    max_ram_address = 16384;
    generateHexFile(no_of_digits, radix_bits, burst_index, max_ram_address)

if __name__ == "__main__":
    main();
