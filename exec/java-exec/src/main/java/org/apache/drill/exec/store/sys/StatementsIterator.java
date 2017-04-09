/**
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 * <p/>
 * http://www.apache.org/licenses/LICENSE-2.0
 * <p/>
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.apache.drill.exec.store.sys;

import org.apache.drill.exec.coord.store.TransientStore;
import org.apache.drill.exec.ops.FragmentContext;
import org.apache.drill.exec.proto.UserBitShared;
import org.apache.drill.exec.server.rest.profile.ProfileResources;
import org.apache.drill.exec.work.WorkManager;
import org.apache.drill.exec.work.foreman.QueryManager;

import javax.inject.Inject;
import java.util.Collections;
import java.util.Iterator;
import java.util.Map;

public class StatementsIterator implements Iterator<Object> {

    private boolean beforeFirst = true;
    private final FragmentContext context;
    ProfileResources.QProfiles qProfiles;
    @Inject WorkManager work;

    public StatementsIterator(final FragmentContext context) {
        this.context = context;
    }

    @Override
    public boolean hasNext() {
        return beforeFirst;
    }

    @Override
    public Object next() {
        final StatementsInfo statementsInfo = new StatementsInfo();


        final TransientStore<UserBitShared.QueryInfo> running = work.getContext().getClusterCoordinator().getOrCreateTransientStore(QueryManager.RUNNING_QUERY_INFO);
        final Iterator<Map.Entry<String, UserBitShared.QueryInfo>> runningEntries = running.entries();
        while (runningEntries.hasNext()) {
            try {
                final Map.Entry<String, UserBitShared.QueryInfo> runningEntry = runningEntries.next();
                final UserBitShared.QueryInfo profile = runningEntry.getValue();

                statementsInfo.queryText = profile.getQuery();//runningEntry.getKey(), profile.getStart(), System.currentTimeMillis(), profile.getForeman().getAddress(), profile.getQuery(), profile.getState().name(), profile.getUser()));

            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        return statementsInfo;
    }

    @Override
    public void remove() {
        throw new UnsupportedOperationException();
    }

    public static class StatementsInfo {
        //queryid, user, sql, current status, number of nodes involved, number of total fragments, number of fragments completed, start time
        public String foreman;
        public String queryId;
        public String queryText;
        public String user;
        public long startTime;
    }
}
