# Examples for now

invf inv create -h

invf inv create -n 111-222 -c 10 -d 2011-10-10 -p 2011-20-10 -s 2011-10-11

invf inv list -f csv

invf inv next-doc -h

invf inv next-doc -f csv


# Planned uses

$ invf contact find "Alb" -f tab -nohead
#> 10     Albatross computers   	...
#> 12     Alba corp 	     	...

# default value of -f is formatting that is best suited to sed/awk and other
# shell tools

$ invf contact find "Alba co" -justid -1 | \ #-1 = -nohead -oneline
      xargs -0 -I contact_id \
      invf inv create -n auto -c contact_id -d auto -p auto
#> 14 #the id of created invoice 

# default value for -ndps is auto so we can leave them out
  # auto for -n means the next propper document id
  # auto for -d means current date
  # auto for -p means current date + days_to_pay set in the contact data
  # auto for -s means current date

$ invf contact find "Alba co" -justid -1 | \
      xargs -0 -I contact_id \
      invf inv create -c contact_id 
#> 15

# adding body of invoice using pipes should also work

$ invf contact find "Alba co" -justid -1 | \
      xargs -I contact_id \
      invf inv create -c contact_id | \
      xargs -I inv_id \
      invf inv-b add inv_id -d "Programming by contract" -u hour -q 30 -p 40 -t 20
#> 104

# inv-b(ody) add [invoice_id] -d description, -u unit, -q qty, -p price, -t tax, -d discount
# returns id of added inv-b


# find contact by part of the name
# create invoice head with it
# create 3 invoice bodies in parallel
# when they are created
# download PDF of invoice to local dir
# send ODT of invoice to your accountant (in parallel)

$ mkfifo _P1 _P2 _P3 _P4
$ invf contact find "Alba co" -justid -1 | \
      xargs -I contact_id \
      invf inv create -c contact_id | \
      tee _P1 | tee _P2 | tee _P3 | tee _P4 | \
      xargs -I inv_id \
      invf inv-b add inv_id -d "Programming" -u hour -q 30 -p 40 -t 20 & \
      invf inv-b add `cat <_P1` -d "Support" -u hour -q 10 -p 35 -t 20 & \
      invf inv-b add `cat <_P2` -d "Cleanup" -u hour -q 5 -p 45 -t 20 & \
      wait & \
      invf inv download `cat <_P3` -f pdf -o ~/invoices/. & \
      invf inv send `cat <_P4` -f odt -e accountant@email.com
$ rm _P1 _P2 _P3 _P4

