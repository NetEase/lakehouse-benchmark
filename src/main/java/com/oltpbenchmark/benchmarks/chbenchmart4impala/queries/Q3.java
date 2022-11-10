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

public class Q3 extends GenericQuery {

    public final SQLStmt query_stmt = new SQLStmt(
            "SELECT ol_o_id, ol_w_id, ol_d_id, o_entry_d, sum(ol_amount) AS revenue "
            + "FROM (SELECT t1.c_id,t1.c_w_id,t1.c_d_id, o_entry_d,o_c_id,o_w_id,o_d_id,o_id "
            + "FROM (SELECT c_id,c_w_id,c_d_id FROM "
            + "" +customer() + " "
            + "WHERE c_state LIKE 'A%') t1 join " + oorder() + " "
            + "WHERE o_entry_d > CAST('2007-01-02 00:00:00.000000' AS TIMESTAMP) "
            + "AND t1.c_id = o_c_id AND t1.c_w_id = o_w_id AND t1.c_d_id = o_d_id) t2 "
            + "join + " +new_order() + ", "  +order_line()  + " "
            + "WHERE no_w_id = t2.o_w_id "
            + "AND no_d_id = t2.o_d_id AND no_o_id = t2.o_id AND ol_w_id = t2.o_w_id "
            + "AND ol_d_id = t2.o_d_id AND ol_o_id = t2.o_id "
            + "GROUP BY ol_o_id, ol_w_id, ol_d_id, o_entry_d "
            + "ORDER BY revenue DESC , o_entry_d"
    );

    protected SQLStmt get_query() {
        return query_stmt;
    }

    public static void main(String[] args) {
        System.out.println(new Q3().query_stmt.getSQL());
    }
}
