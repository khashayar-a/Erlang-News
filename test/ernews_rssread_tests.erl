%%% @author Magnus Thulin <magnus@dhcp-198246.eduroam.chalmers.se>
%%% @copyright (C) 2012, Magnus Thulin
%%% @doc
%%% E-unit test for ernews_htmlfuns
%%% Covering TC6, TC4, TC9
%%% @end
%%% Created :  3 Dec 2012 by Magnus Thulin <magnus@dhcp-198246.eduroam.chalmers.se>

-module(ernews_rssread_tests).
-compile(export_all).
-include_lib("eunit/include/eunit.hrl").


%--------------------------------------------------------------------------------%
%%% @test Case: TC6 & TC7
%%% @requirement: BE-FREQ#1 & BE-FREQ#7
%--------------------------------------------------------------------------------%
rss_source_test()->
    [{R1,_},{R2,_},{R3,_},{R4,_},{R5,_},{R6,_}] = get_first(),

    ?assertEqual({ok,ok,ok,ok,ok,ok},{R1,R2,R3,R4,R5,R6}).
%--------------------------------------------------------------------------------%


get_first() ->
    List = [{google,"http://news.google.com/news" ++
		 "/feeds?hl=en&gl=us&q=erlang&um=1&ie=UTF-8&output=rss"}, 
	    {iocoder,"http://coder.io/tag/erlang.rss"},
	    {reddit,"http://www.reddit.com/r/erlang.rss"},
	    {hacker,"https://news.ycombinator.com/rss"},
	    {twitter,"http://search.twitter.com/search.atom?q=%23erlang"},
	    {dzone,"http://www.dzone.com/links/feed/search/erlang/rss.xml"}],
    get_first(List,[]).
get_first([{Atom,Source}|T],New) ->
    Item = read(ernews_defuns:read_web(default,Source),Atom),
    URL = element(2,Item),
    get_first(T,[{ok,URL}|New]);
get_first([],New) ->
    New.


read({error,Reason},_Atom) ->
    {error,Reason};	
read({success,{_Head,Body}},Atom) ->
    [H|_] = ernews_rssread:iterate(Atom,Body),
    H;
read(_,_) ->
    error.


