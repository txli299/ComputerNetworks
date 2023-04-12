set ns [new Simulator]

set tf [open exp2_NR.tr w]
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

set tcp1 [new Agent/TCP/Newreno]
$tcp1 set class_ 2
$ns attach-agent $n0 $tcp1
set sink [new Agent/TCPSink]
$ns attach-agent $n4 $sink
$ns connect $tcp1 $sink
$tcp1 set fid_ 1

set ftp1 [new Application/FTP]
$ftp1 attach-agent $tcp1
$ftp1 set type_ FTP
$ftp1 set packet_size_ 1000
$ftp1 set rate_ 1mb

set tcp2 [new Agent/TCP/Reno]
$tcp2 set class_ 2
$ns attach-agent $n1 $tcp2
set sink [new Agent/TCPSink]
$ns attach-agent $n5 $sink
$ns connect $tcp2 $sink
$tcp2 set fid_ 1

set ftp2 [new Application/FTP]
$ftp2 attach-agent $tcp2
$ftp2 set type_ FTP
$ftp2 set packet_size_ 1000
$ftp2 set rate_ 1mb

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


$ns at 0.0 "$ftp1 start"
$ns at 18.0 "$ftp1 stop"
$ns at 0.0 "$ftp2 start"
$ns at 18.0 "$ftp2 stop"
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