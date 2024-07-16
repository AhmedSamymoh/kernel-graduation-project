#!/usr/bin/bash

######################################
# @Project Module 1 Linux fundamentals
# @file: analyze_traffic.sh
# @date: Jul 12, 2024
# @author: Ahmed Samy
######################################


# Input: Path to the Wireshark pcap file
########################################
#         User Configurable             # 
########################################
pcap_file="./capture_file.pcap"
########################################

# Varify that the .pcap file exists
if [ ! -f "$pcap_file" ]; then
    echo "file not found: $pcap_file"
    exit 1
fi
    
# extract IP addresses, and generate summary statistics.
getTop_Src_IPs() {
    # tshark: Reads $pcap_file --> extracts IP addresses (-T fields -e ip)
    # sort: sorts IPs
    # uniq -c: Counts each unique IP
    # sort -nr: Sorts counts numerically in reverse
    # head -5: then Selects top 5 IP

    tshark -r "$pcap_file" -T fields -e ip.src | sort | uniq -c | sort -nr | head -5 | while read count ip; do
        echo "- $ip: $count packets  "
    done  

    # SAME Example
    # cat $PWD/test.txt | while read line; do
    #     echo "${line}"
    # done

}

getTop_dst_IPs() {

    tshark -r "$pcap_file" -T fields -e ip.src | sort | uniq -c | sort -nr | head -5 | while read count ip; do
        echo "- $ip: $count packets  "
    done  
}

# Function to extract information from the pcap file
analyze_traffic() {
    # Use tshark or similar commands for packet analysis.
    # Hint: Consider commands to count total packets, filter by protocols (HTTP, HTTPS/TLS),
    


    #    - Analyze packets from a file:
    #    tshark -r {{path/to/file.pcap}}
    Total_No_of_packets=$(tshark -r "$pcap_file" | wc --lines)

    #    -Y|--display-filter  <displaY filter> 
    http_packets=$(tshark -r "$pcap_file" -Y "http" | wc --lines )

    https_packets=$(tshark -r "$pcap_file" -Y "tls" | wc --lines ) # i did not find https filter so i used tls





    # Output analysis summary
    echo ""
    echo "----- Network Traffic Analysis Report -----"
    # Provide summary information based on your analysis
    # Hints: Total packets, protocols, top source, and destination IP addresses.
    echo "1. Total Packets: ${Total_No_of_packets}"
    echo "-------------------------------------------"
    
    echo "2. Protocols:"
    echo "   - HTTP: ${http_packets} packets"
    echo "   - HTTPS/TLS: ${https_packets} packets"
    echo "-------------------------------------------"


    echo "3. Top 5 Source IP Addresses:"
    # Provide the top source IP addresses
    getTop_Src_IPs

    echo "-------------------------------------------"


    echo "4. Top 5 Destination IP Addresses:"
    # Provide the top destination IP addresses
    getTop_dst_IPs



    echo ""
    echo "-----------  End of Report  ---------------"
    echo ""
}   


# Run the analysis function
analyze_traffic
