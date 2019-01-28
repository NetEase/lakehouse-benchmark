/******************************************************************************
 *  Copyright 2015 by OLTPBenchmark Project                                   *
 *                                                                            *
 *  Licensed under the Apache License, Version 2.0 (the "License");           *
 *  you may not use this file except in compliance with the License.          *
 *  You may obtain a copy of the License at                                   *
 *                                                                            *
 *    http://www.apache.org/licenses/LICENSE-2.0                              *
 *                                                                            *
 *  Unless required by applicable law or agreed to in writing, software       *
 *  distributed under the License is distributed on an "AS IS" BASIS,         *
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.  *
 *  See the License for the specific language governing permissions and       *
 *  limitations under the License.                                            *
 ******************************************************************************/

package com.oltpbenchmark.benchmarks.seats;

import com.oltpbenchmark.api.AbstractTestLoader;
import com.oltpbenchmark.api.Worker;
import com.oltpbenchmark.util.RandomGenerator;

import java.util.List;

public class TestSEATSLoader extends AbstractTestLoader<SEATSBenchmark> {

    @Override
    protected void setUp() throws Exception {
        super.setUp(SEATSBenchmark.class, null, TestSEATSBenchmark.PROC_CLASSES);
        SEATSProfile.clearCachedProfile();
    }

    /**
     * testSaveLoadProfile
     */
    public void testSaveLoadProfile() throws Exception {
        SEATSLoader loader = (SEATSLoader) this.benchmark.makeLoaderImpl(conn);
        assertNotNull(loader);
        loader.load();

        SEATSProfile orig = loader.profile;
        assertNotNull(orig);

        SEATSProfile copy = new SEATSProfile(this.benchmark, new RandomGenerator(0));
        assert (copy.airport_histograms.isEmpty());

        List<Worker<?>> workers = this.benchmark.makeWorkers(false);
        SEATSWorker worker = (SEATSWorker) workers.get(0);
        copy.loadProfile(worker);

        assertEquals(orig.scale_factor, copy.scale_factor);
        assertEquals(orig.airport_max_customer_id, copy.airport_max_customer_id);
        assertEquals(orig.flight_start_date.toString(), copy.flight_start_date.toString());
        assertEquals(orig.flight_upcoming_date.toString(), copy.flight_upcoming_date.toString());
        assertEquals(orig.flight_past_days, copy.flight_past_days);
        assertEquals(orig.flight_future_days, copy.flight_future_days);
        assertEquals(orig.flight_upcoming_offset, copy.flight_upcoming_offset);
        assertEquals(orig.reservation_upcoming_offset, copy.reservation_upcoming_offset);
        assertEquals(orig.num_reservations, copy.num_reservations);
        assertEquals(orig.histograms, copy.histograms);
        assertEquals(orig.airport_histograms, copy.airport_histograms);
//        assertEquals(orig.code_id_xref, copy.code_id_xref);
    }

}