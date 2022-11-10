/*
 * Copyright 2020 by OLTPBenchmark Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 */

package com.oltpbenchmark.benchmarks.chbenchmart4impala.queries;

import com.oltpbenchmark.api.SQLStmt;

import static com.oltpbenchmark.benchmarks.chbenchmart4impala.TableNames.*;

public class Q10 extends GenericQuery {

    /*public final SQLStmt query_stmt = new SQLStmt(
            "SELECT c_id, "
                    + "c_last, "
                    + "sum(ol_amount) AS revenue, "
                    + "c_city, "
                    + "c_phone, "
                    + "n_name "
                    + "FROM " +customer() + ", "
                    + "" +oorder() + ", "
                    + "" +order_line() + ", "
                    + "" +nation() + " "
                    + "WHERE c_id = o_c_id "
                    + "AND c_w_id = o_w_id "
                    + "AND c_d_id = o_d_id "
                    + "AND ol_w_id = o_w_id "
                    + "AND ol_d_id = o_d_id "
                    + "AND ol_o_id = o_id "
                    + "AND o_entry_d >= CAST('2007-01-02 00:00:00.000000' AS TIMESTAMP) "
                    + "AND o_entry_d <= ol_delivery_d "
                    + "AND n_nationkey = ascii(cast(substring(c_state, 1, 1) as varchar(1))) "
                    + "GROUP BY c_id, "
                    + "c_last, "
                    + "c_city, "
                    + "c_phone, "
                    + "n_name "
                    + "ORDER BY revenue DESC"
    );*/

    public final SQLStmt query_stmt = new SQLStmt(
            "SELECT c_id, c_last, c_city, c_phone, n_name, sum(ol_amount) AS revenue " +
                    "FROM (SELECT o_id,o_c_id,o_w_id,o_d_id,o_entry_d,c_id, c_last,c_w_id," +
                    "c_d_id,c_state,c_city,c_phone,n_name,n_nationkey " +
                    "FROM (SELECT o_id,o_c_id,o_w_id,o_d_id,o_entry_d FROM " +oorder() + " " +
                    "WHERE o_entry_d >= CAST('2007-01-02 00:00:00.000000' AS TIMESTAMP)) t1 " +
                    "JOIN " +customer() + ", " +nation() + "  WHERE c_id = t1.o_c_id " +
                    "AND c_w_id = t1.o_w_id AND c_d_id = t1.o_d_id " +
                    "AND n_nationkey = ascii(cast(substring(c_state, 1, 1) as varchar(1)))) t2 " +
                    "JOIN " +order_line() + " " +
                    "WHERE ol_w_id = t2.o_w_id AND ol_d_id = t2.o_d_id " +
                    "AND ol_o_id = t2.o_id AND t2.o_entry_d <= ol_delivery_d " +
                    "GROUP BY c_id, c_last, c_city, c_phone, n_name ORDER BY revenue DESC"
    );

    protected SQLStmt get_query() {
        return query_stmt;
    }

    public static void main(String[] args) {
        System.out.println(new Q10().query_stmt.getSQL());
    }
}
