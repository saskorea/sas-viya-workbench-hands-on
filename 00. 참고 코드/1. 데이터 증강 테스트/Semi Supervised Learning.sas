/*************************************************************************************************************
* Semi-Supervised Learning with PROC SEMISUPLEARN
*************************************************************************************************************/

%LET LABELED_SIZE  = 100;
%LET UNLABLED_SIZE = 5000;

DATA LABELED_EXAMPLE;
    DO ID = 1 TO &LABELED_SIZE.;
        X1  = RAND('NORMAL', 0, 1);
        X2  = RAND('NORMAL', 0, 1);
        ERR = RAND('NORMAL', 0, 1);
        Y = 0.4*X1 + 0.3*X2 + 0.3*ERR + 10;
        OUTPUT;
    END;
RUN;
DATA UNLABELED_EXAMPLE;
    DO ID = 1 TO &UNLABLED_SIZE.;
        X1  = RAND('NORMAL', 0, 1);
        X2  = RAND('NORMAL', 0, 1);
        ERR = RAND('NORMAL', 0, 1);
        OUTPUT;
    END;
RUN;



/* Semi-Supervised Learning */
PROC SEMISUPLEARN DATA  = UNLABELED_EXAMPLE
                  LABEL = LABELED_EXAMPLE
	;
   INPUT X1 X2;
   KERNEL KNN / K=5;
   OUTPUT OUT = SMI_OUTPUT COPYVARS=(_ALL_);
   TARGET Y;
RUN;

PROC REG DATA = LABELED_EXAMPLE;
    MODEL Y = X1 X2;
RUN;

DATA SMI_EXAMPLE;
    SET WORK.SMI_OUTPUT;
    Y = INPUT(I_Y, 8.);
RUN;

PROC REG DATA = SMI_EXAMPLE;
    MODEL Y = X1 X2;
RUN;
