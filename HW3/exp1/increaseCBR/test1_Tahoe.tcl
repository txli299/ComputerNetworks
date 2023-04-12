set ns [new Simulator]

set tf [open exp1_Tahoe.tr w]
$ns trace-all $tf

proc finish {} {
        global ns tf
        $ns flush-trace
        close $tf
        exit 0
}

set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]

$ns duplex-link $n0 $n2 10Mb 10ms DropTail
$ns duplex-link $n1 $n2 10Mb 10ms DropTail
$ns duplex-link $n2 $n3 10Mb 10ms DropTail
$ns duplex-link $n3 $n4 10Mb 10ms DropTail
$ns duplex-link $n3 $n5 10Mb 10ms DropTail

set tcp [new Agent/TCP]
$tcp set class_ 2
$ns attach-agent $n0 $tcp
set sink [new Agent/TCPSink]
$ns attach-agent $n4 $sink
$ns connect $tcp $sink
$tcp set fid_ 1

set ftp [new Application/FTP]
$ftp attach-agent $tcp
$ftp set type_ FTP
$ftp set packet_size_ 1000
$ftp set rate_ 1mb

set udp [new Agent/UDP]
$ns attach-agent $n2 $udp
set null [new Agent/Null]
$ns attach-agent $n3 $null
$ns connect $udp $null 
$udp set fid_ 2


set cbr1 [new Application/Traffic/CBR]
$cbr1 attach-agent $udp
$cbr1 set type_ CBR
$cbr1 set packet_size_ 1000
$cbr1 set rate_ 5Mb

set cbr2 [new Application/Traffic/CBR]
$cbr2 attach-agent $udp
$cbr2 set type_ CBR
$cbr2 set packet_size_ 1000
$cbr2 set rate_ 10Mb

set cbr3 [new Application/Traffic/CBR]
$cbr3 attach-agent $udp
$cbr3 set type_ CBR
$cbr3 set packet_size_ 1000
$cbr3 set rate_ 20Mb

set cbr4 [new Application/Traffic/CBR]
$cbr4 attach-agent $udp
$cbr4 set type_ CBR
$cbr4 set packet_size_ 1000
$cbr4 set rate_ 40Mb

set cbr5 [new Application/Traffic/CBR]
$cbr5 attach-agent $udp
$cbr5 set type_ CBR
$cbr5 set packet_size_ 1000
$cbr5 set rate_ 80Mb


$ns at 0.0 "$ftp start"
$ns at 18.0 "$ftp stop"
$ns at 1.0 "$cbr1 start"
$ns at 2.0 "$cbr1 stop"
$ns at 4.0 "$cbr2 start"
$ns at 5.0 "$cbr2 stop"
$ns at 7.0 "$cbr3 start"
$ns at 8.0 "$cbr3 stop"
$ns at 10.0 "$cbr4 start"
$ns at 11.0 "$cbr4 stop"
$ns at 13.0 "$cbr5 start"
$ns at 14.0 "$cbr5 stop"

$ns at 20.0 "finish"

$ns run