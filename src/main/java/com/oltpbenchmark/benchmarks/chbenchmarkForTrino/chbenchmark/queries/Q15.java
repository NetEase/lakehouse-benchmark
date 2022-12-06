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

package com.oltpbenchmark.benchmarks.chbenchmarkForTrino.chbenchmark.queries;

import com.oltpbenchmark.api.SQLStmt;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Statement;

import static com.oltpbenchmark.benchmarks.chbenchmarkForTrino.chbenchmark.TableNames.order_line;
import static com.oltpbenchmark.benchmarks.chbenchmarkForTrino.chbenchmark.TableNames.stock;
import static com.oltpbenchmark.benchmarks.chbenchmarkForTrino.chbenchmark.TableNames.supplier;

public class Q15 extends GenericQuery {

    public final SQLStmt query_stmt = new SQLStmt(
            "SELECT su_suppkey, \n" +
                " su_name, \n" +
                " su_address, \n" +
                " su_phone, \n" +
                " total_revenue \n" +
                "FROM " + supplier() + ", (\n" +
                "  SELECT mod((s_w_id * s_i_id),10000) as supplier_no, \n" +
                "         sum(ol_amount) as total_revenue \n" +
                "  FROM " + order_line() + ", " + stock() + " \n" +
                "  WHERE ol_i_id = s_i_id \n" +
                "        AND ol_supply_w_id = s_w_id \n" +
                "        AND ol_delivery_d >= TIMESTAMP '2007-01-02 00:00:00.000000' \n" +
                "        GROUP BY mod((s_w_id * s_i_id),10000)\n" +
                ") \n" +
                "WHERE su_suppkey = supplier_no \n" +
                "AND total_revenue = (\n" +
                "    SELECT max(total_revenue) \n" +
                "    FROM\n" +
                "       (\n" +
                "          SELECT mod((s_w_id * s_i_id),10000) as supplier_no, \n" +
                "                 sum(ol_amount) as total_revenue \n" +
                "          FROM " + order_line() + ", " + stock() + " \n" +
                "          WHERE ol_i_id = s_i_id \n" +
                "                AND ol_supply_w_id = s_w_id \n" +
                "                AND ol_delivery_d >= TIMESTAMP '2007-01-02 00:00:00.000000' \n" +
                "                GROUP BY mod((s_w_id * s_i_id),10000)\n" +
                "       )\n" +
                ")\n" +
                "ORDER BY su_suppkey"
    );

    protected SQLStmt get_query() {
        return query_stmt;
    }

    public static void main(String[] args) {
        System.out.println(new Q15().query_stmt.getSQL());
    }
}
