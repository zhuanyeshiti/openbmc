#!/bin/bash

power_on_mask=0x2000

Control_PT_funtion(){
/sbin/devmem 0x1e6e2000 32 0x1688A8A8
reg=$(/sbin/devmem 0x1e6e208c)

if [ $1 == "disable" ]; then
   echo "Disable GPIO E2/E3 pass-through function (Bit 13)"
   result=$((${reg} & $((~${power_on_mask}))))
elif [ $1 == "enable" ]; then
   echo "Enable GPIO E2/E3 pass-through function (Bit 13)"
   result=$((${reg} | ${power_on_mask}))
fi

result_base16=$(printf "0x%x" $result)
/sbin/devmem 0x1e6e208c 32 $result_base16
#/sbin/devmem 0x1e6e208c 32 0x00001000
/sbin/devmem 0x1e6e2000 32 0x00000001
echo "Display reg SCU80 value:" $(/sbin/devmem 0x1e6e208c);
}


echo "Enter Power on System action"

#USE GPIOS1 to check power status
pwrstatus=$(/usr/bin/gpioget gpiochip0 145)
if [ $pwrstatus -eq 0 ]; then

    Control_PT_funtion disable
    # *** Push power button ***
    # GPIO E3 for power on
    /usr/bin/gpioset gpiochip0 35=0
    sleep 1
    /usr/bin/gpioset gpiochip0 35=1 
    sleep 1
  
    #Monitor the PGood Status    
    CHECK=0
    while [ ${CHECK} -lt 10 ]
    do
        sleep 1
        pwrstatus=$(/usr/bin/gpioget gpiochip0 145)
        if [ $pwrstatus -eq 1 ]; then
           busctl set-property xyz.openbmc_project.Watchdog /xyz/openbmc_project/watchdog/host0 xyz.openbmc_project.State.Watchdog Enabled b false
           if [ $? == 0 ]; then
               break;
           fi
        fi
        (( CHECK=CHECK+1 ))
    done

    Control_PT_funtion enable

fi

echo "Exit Power on System action"
exit 0;
