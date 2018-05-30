begin_memory_edit -hardware_name "USB-BlasterII \[USB-1\]" -device_name "@2: 5CSEBA6(.|ES)/5CSEMA6/.. (0x02D020DD)"

for {set i 0} {$i < 1} {incr i} {
    save_content_from_memory_to_file -instance_index 0 -mem_file_path "C:\\Users\\J_Lian\\Desktop\\FYP\\data\\RAM$i.hex" -mem_file_type hex
    update_content_to_memory_from_file -instance_index 0 -mem_file_path "C:\\Users\\J_Lian\\Desktop\\FYP\\data\\RAMwrite0.hex" -mem_file_type hex
    update_content_to_memory_from_file -instance_index 0 -mem_file_path "C:\\Users\\J_Lian\\Desktop\\FYP\\data\\RAMwrite1.hex" -mem_file_type hex
    update_content_to_memory_from_file -instance_index 0 -mem_file_path "C:\\Users\\J_Lian\\Desktop\\FYP\\data\\RAMwrite0.hex" -mem_file_type hex
    update_content_to_memory_from_file -instance_index 0 -mem_file_path "C:\\Users\\J_Lian\\Desktop\\FYP\\data\\RAMwrite1.hex" -mem_file_type hex
    update_content_to_memory_from_file -instance_index 0 -mem_file_path "C:\\Users\\J_Lian\\Desktop\\FYP\\data\\RAMwrite0.hex" -mem_file_type hex
    after 1000 # wait for 1 second
}


end_memory_edit