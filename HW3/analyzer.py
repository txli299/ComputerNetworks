import matplotlib.pyplot as plt
import  traceanalyzer as tr
#Throughput
#Packet Delivery Ratio
# pdr1=tr.Pdr('exp3/exp3_DT_reno.tr','5')
# pdr1.sample()
# pdr1.plot('sr-') #plotting with argument

#Throughput
# throughput1=tr.Throughput('exp3/exp3_red_sack.tr','5')
# throughput1.sample()#eedelay2.sample(1.5) for sampling with step=1.5
# throughput1.plot()

#end-to-end delay
eedelay1=tr.Eedelay('exp3/exp3_red_sack.tr','5')
eedelay1.plot()

plt.show()