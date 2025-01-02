/************************************************************************************************
** 제목: 
**
**  
**
**
**
**
**
*************************************************************************************************/

proc print data = sashelp.cars noobs;
run;
proc tabulate data = sashelp.cars;
    class Type Origin DriveTrain;
    var   MSRP Invoice EngineSize Cylinders Horsepower;
    table Origin ALL = 'Total'
        , (N='Frequency' PCTN = 'Percent(%)')
    ;
run;
proc tabulate data = sashelp.cars;
    class Make Model Type Origin DriveTrain;
    var   MSRP Invoice EngineSize Cylinders Horsepower;
    table Origin='' * Type='' ALL = 'Total'
        , (N='Frequency' PCTN = 'Percent(%)')
        / Box="Origin / Type"
    ;
run;

