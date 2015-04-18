
function led(r,g,b)
    pwm.setduty(2,r)
    pwm.setduty(3,b)
    pwm.setduty(4,g)
end

clock = 500
pwm.setup(2,clock,0)
pwm.setup(3,clock,0)
pwm.setup(4,clock,0)

pwm.start(2)
pwm.start(3)
pwm.start(4)

-- start half blue
led(0,0,512)

