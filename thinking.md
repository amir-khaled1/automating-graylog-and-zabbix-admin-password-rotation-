## problems 
there are multiples graylog servers to change
now i have .env file that in which contain the graylog server data (ip address , root password, primary user, path to the config file ... ) 

now the problem is adding a server to automate is kind of a hustle 
first i need to add his properties to .env file 
then i need to manully add in the automate.sh file his .exp script 
then i need to save the updated password in mypassword database 

how to group the 
## suggestion 
i would like to just add the prperties of a graylog server into .env file than the rest works without manually doing other parts  

## how 
write a script that read the .env , and get the values and inject it into the automate.sh 

## thinking how to do it 
use the ip of a server as an identifier for each server 
put in .env file a variable called graylog_list which contains all graylog servers ip iterate overeach one of them take the properties using grep and then inject into the :
