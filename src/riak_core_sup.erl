%% -------------------------------------------------------------------
%%
%% riak_core: Core Riak Application
%%
%% Copyright (c) 2007-2013 Basho Technologies, Inc.  All Rights Reserved.
%%
%% This file is provided to you under the Apache License,
%% Version 2.0 (the "License"); you may not use this file
%% except in compliance with the License.  You may obtain
%% a copy of the License at
%%
%%   http://www.apache.org/licenses/LICENSE-2.0
%%
%% Unless required by applicable law or agreed to in writing,
%% software distributed under the License is distributed on an
%% "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
%% KIND, either express or implied.  See the License for the
%% specific language governing permissions and limitations
%% under the License.
%%
%% -------------------------------------------------------------------

-module(riak_core_sup).

-behaviour(supervisor).

%% API
-export([start_link/0]).

%% Supervisor callbacks
-export([init/1]).

%% Helper macro for declaring children of supervisor
-define(CHILD(I, Type, Timeout, Args), {I, {I, start_link, Args}, permanent, Timeout, Type, [I]}).
-define(CHILD(I, Type, Timeout), ?CHILD(I, Type, Timeout, [])).
-define(CHILD(I, Type), ?CHILD(I, Type, 5000)).

%% ===================================================================
%% API functions
%% ===================================================================

start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

%% ===================================================================
%% Supervisor callbacks
%% ===================================================================

init([]) ->

    Children = lists:flatten(
                 [
                  ?CHILD(riak_core_vnode_sup, supervisor, 305000),
                  ?CHILD(riak_core_eventhandler_sup, supervisor),
                  ?CHILD(riak_core_handoff_sup, supervisor),
                  ?CHILD(riak_core_ring_events, worker),
                  ?CHILD(riak_core_ring_manager, worker),
                  ?CHILD(riak_core_vnode_proxy_sup, supervisor),
                  ?CHILD(riak_core_node_watcher_events, worker),
                  ?CHILD(riak_core_node_watcher, worker),
                  ?CHILD(riak_core_vnode_manager, worker),
                  ?CHILD(riak_core_gossip, worker),
                  ?CHILD(riak_core_claimant, worker)
                 ]),

    {ok, {{one_for_one, 10, 10}, Children}}.
