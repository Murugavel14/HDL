module pro1 (
    input di3 , di2 , di1  ,di0,
    output d3, d2, d1, d0

);

    assign d3 = di3  | di2  | di1  | di0;
    assign d2 = di3 &(di2  | di1  | di0) | di2 &(di1  | di0) | (di1  & di0);
    assign d1 = di3 &(di2 &di1  | di2 &di0 | di1 &di0) | (di2  & di1  & di0);
    assign d0 = di3  & di2  & di1  & di0;

/*
    //HERE IS NOT MINIMIZED LOGIC
    assign d3 = di3  | di2  | di1  | d;
    assign d2 = (di3  & di1 ) | (di3  & d) | (di3  & di2 ) | (di2  & di1 ) | (di2  & d) | (d & di1 );
    assign d1 = (di3  & di2  & di1 ) | (d & di2  & di1 ) | (di3  & d & di1 ) | (di3  & di2  & d);
    assign d0 = di3  & di2  & di1  & d;
*/

endmodule

//Designed by Murugavel
