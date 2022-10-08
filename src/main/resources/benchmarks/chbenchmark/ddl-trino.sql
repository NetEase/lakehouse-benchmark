CREATE TABLE region (
    r_regionkey int       NOT NULL,
    r_name      varchar(55)  NOT NULL,
    r_comment   varchar(152) NOT NULL
);

CREATE TABLE nation (
    n_nationkey int       NOT NULL,
    n_name      varchar(25)  NOT NULL,
    n_regionkey int       NOT NULL,
    n_comment   varchar(152) NOT NULL
);

CREATE TABLE supplier (
    su_suppkey   int            NOT NULL,
    su_name      varchar      NOT NULL,
    su_address   varchar    NOT NULL,
    su_nationkey int            NOT NULL,
    su_phone     varchar       NOT NULL,
    su_acctbal   DECIMAL(12, 2) NOT NULL,
    su_comment   varchar      NOT NULL
);
