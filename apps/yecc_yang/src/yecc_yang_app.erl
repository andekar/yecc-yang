%%%-------------------------------------------------------------------
%% @doc yecc_yang public API
%% @end
%%%-------------------------------------------------------------------

-module(yecc_yang_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).

%%====================================================================
%% API
%%====================================================================

start(_StartType, _StartArgs) ->
    yecc_yang_sup:start_link().

%%--------------------------------------------------------------------
stop(_State) ->
    ok.

%%====================================================================
%% Internal functions
%%====================================================================
