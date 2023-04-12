#Create a simulator object
set ns [new Simulator]


set cbr_rate 1mb

set tf [open exp3_red_reno.tr w]
$ns trace-all $tf

proc finish {} {
        global ns tf
        $ns flush-trace
        close $tf
        exit 0
}

#Create four nodes
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]

# $ns simplex-link hnode0i hnode1i hbandwidthi hdelayi hqueue_typei
#Create links between the nodes
$ns duplex-link $n0 $n2 10Mb 2ms DropTail
$ns duplex-link $n1 $n2 10Mb 3ms DropTail
$ns duplex-link $n2 $n3 1.5Mb 20ms RED
$ns duplex-link $n3 $n4 10Mb 4ms DropTail
$ns duplex-link $n3 $n5 10Mb 5ms DropTail

#Set Queue Size of link (n2-n3) to 25
$ns queue-limit $n2 $n3 25
$ns queue-limit $n3 $n2 25


# N0 --- N3
	#Setup a TCP connection
	set tcp [new Agent/TCP/Reno]
	$tcp set class_ 2
	$ns attach-agent $n0 $tcp

	set sink [new Agent/TCPSink]
	$ns attach-agent $n4 $sink
	$ns connect $tcp $sink
	$tcp set fid_ 1

	#Setup a FTP over TCP connection
	set ftp [new Application/FTP]
	$ftp attach-agent $tcp
	$ftp set type_ FTP

# N4 --- N5
	#Setup a UDP connection
	set udp [new Agent/UDP]
	$ns attach-agent $n1 $udp

	set null [new Agent/Null]
	$ns attach-agent $n5 $null
	$ns connect $udp $null
	$udp set fid_ 2

	#Setup a CBR over UDP connection
	set cbr [new Application/Traffic/CBR]
	$cbr attach-agent $udp
	$cbr set type_ CBR
	$cbr set packet_size_ 500
	# CBR rate
	$cbr set rate_ $cbr_rate
	$cbr set random_ false



#Schedule events for the CBR and FTP agents
$ns at 0.1 "$ftp start"
$ns at 0.3 "$cbr start"
$ns at 4.3 "$cbr stop"
$ns at 4.5 "$ftp stop"

#Call the finish procedure after 5 seconds of simulation time
$ns at 5.0 "finish"


#Run the simulation
$ns run