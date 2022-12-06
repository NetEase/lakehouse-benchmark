CREATE TABLE region (
    r_regionkey int,
    r_name      varchar(55),
    r_comment   varchar(152)
);

CREATE TABLE nation (
    n_nationkey int,
    n_name      varchar(25),
    n_regionkey int,
    n_comment   varchar(152)
);

CREATE TABLE supplier (
    su_suppkey   int,
    su_name      varchar,
    su_address   varchar,
    su_nationkey int,
    su_phone     varchar,
    su_acctbal   DECIMAL(12, 2),
    su_comment   varchar
);
