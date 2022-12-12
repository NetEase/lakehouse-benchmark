CREATE TABLE warehouse (
    w_id       int            ,
    w_ytd      decimal(12, 2) ,
    w_tax      decimal(4, 4)  ,
    w_name     varchar(10)    ,
    w_street_1 varchar(20)    ,
    w_street_2 varchar(20)    ,
    w_city     varchar(20)    ,
    w_state    varchar(2)        ,
    w_zip      varchar(9)        
);

CREATE TABLE item (
    i_id    int           ,
    i_name  varchar(24)   ,
    i_price decimal(5, 2) ,
    i_data  varchar(50)   ,
    i_im_id int           
);

CREATE TABLE stock (
    s_w_id       int           ,
    s_i_id       int           ,
    s_quantity   int           ,
    s_ytd        decimal(8, 2) ,
    s_order_cnt  int           ,
    s_remote_cnt int           ,
    s_data       varchar(50)   ,
    s_dist_01    varchar(24)      ,
    s_dist_02    varchar(24)      ,
    s_dist_03    varchar(24)      ,
    s_dist_04    varchar(24)      ,
    s_dist_05    varchar(24)      ,
    s_dist_06    varchar(24)      ,
    s_dist_07    varchar(24)      ,
    s_dist_08    varchar(24)      ,
    s_dist_09    varchar(24)      ,
    s_dist_10    varchar(24)      
);

CREATE TABLE district (
    d_w_id      int            ,
    d_id        int            ,
    d_ytd       decimal(12, 2) ,
    d_tax       decimal(4, 4)  ,
    d_next_o_id int            ,
    d_name      varchar(10)    ,
    d_street_1  varchar(20)    ,
    d_street_2  varchar(20)    ,
    d_city      varchar(20)    ,
    d_state     varchar(2)        ,
    d_zip       varchar(9)        
);

CREATE TABLE customer (
    c_w_id         int            ,
    c_d_id         int            ,
    c_id           int            ,
    c_discount     decimal(4, 4)  ,
    c_credit       varchar(2)        ,
    c_last         varchar(16)    ,
    c_first        varchar(16)    ,
    c_credit_lim   decimal(12, 2) ,
    c_balance      decimal(12, 2) ,
    c_ytd_payment  real          ,
    c_payment_cnt  int            ,
    c_delivery_cnt int            ,
    c_street_1     varchar(20)    ,
    c_street_2     varchar(20)    ,
    c_city         varchar(20)    ,
    c_state        varchar(2)        ,
    c_zip          varchar(9)        ,
    c_phone        varchar(16)       ,
    c_since        timestamp,
    c_middle       varchar(2)        ,
    c_data         varchar(500)   
);

CREATE TABLE history (
    h_c_id   int           ,
    h_c_d_id int           ,
    h_c_w_id int           ,
    h_d_id   int           ,
    h_w_id   int           ,
    h_date   timestamp     ,
    h_amount decimal(6, 2) ,
    h_data   varchar(24)   
);

CREATE TABLE oorder (
    o_w_id       int       ,
    o_d_id       int       ,
    o_id         int       ,
    o_c_id       int       ,
    o_carrier_id int              ,
    o_ol_cnt     int       ,
    o_all_local  int       ,
    o_entry_d    timestamp
);

CREATE TABLE new_order (
    no_w_id int ,
    no_d_id int ,
    no_o_id int 
);

CREATE TABLE order_line (
    ol_w_id        int           ,
    ol_d_id        int           ,
    ol_o_id        int           ,
    ol_number      int           ,
    ol_i_id        int           ,
    ol_delivery_d  timestamp     ,
    ol_amount      decimal(6, 2) ,
    ol_supply_w_id int           ,
    ol_quantity    int           ,
    ol_dist_info   varchar(24)      
);