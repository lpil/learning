-module(algodub_infer_test).
-include_lib("eunit/include/eunit.hrl").

% id_test() ->
	% {"id", OK "a -> a"},

% one_test() ->
	% {"one", OK "int"},

% x_test() ->
%   check("x", {error, {variable_not_found, "x"}}).

% x_in_y_test() ->
%   check("let x = x in y", {error, {variable_not_found, "x"}}).

% let_id_test() ->
%   check("let x = id in x", {ok, "a -> a"}).

% id_fun_literal_test() ->
%   check("fun y -> y", {ok, "'a -> 'a"}).

% let_id_fun_literal_test() ->
%   check("let x = fun y -> y in x", {ok, "'a -> 'a"}).

% let_id_fun_literal_recur_test() ->
%   check("let x = fun y -> y in x(x(x))", {ok, "'a -> 'a"}).

% 	% {"pair", OK "(a, b) -> pair[a, b]") ,
% 	% {"pair", OK "(x, z) -> pair[x, z]") ,

% fun_x_let_y_fun_z_test() ->
%   check("fun x -> let y = fun z -> z in y",
% 	{ok, "'a -> 'b -> 'b"}).

	% {"let f = fun x -> x in let id = fun y -> y in eq{f, id)", OK "bool"},
	% {"let f = fun x -> x in let id = fun y -> y in eq_curry{f){id)", OK "bool"},
	% {"let f = fun x -> x in eq(f, succ)", OK "bool"},
	% {"let f = fun x -> x in eq_curry(f)(succ)", OK "bool"},
	% {"let f = fun x -> x in pair(f(one}, f(true))", OK "pair[int, bool]"},
	% {"fun f -> pair(f(one}, f(true))", fail},
	% {"let f = fun x y -> let a = eq(x, y) in eq(x, y) in f", OK "(a, a) -> bool"},
	% {"let f = fun x y -> let a = eq_curry(x)(y) in eq_curry(x)(y) in f",
	% 	OK "(a, a) -> bool"},
	% {"id(id)", OK "a -> a"},
	% {"choose(fun x y -> x, fun x y -> y)", OK "(a, a) -> a"},
	% {"choose_curry(fun x y -> x)(fun x y -> y)", OK "(a, a) -> a"},
	% {"let x = id in let y = let z = x(id) in z in y", OK "a -> a"},
	% {"cons(id, nil)", OK "list[a -> a]"},
	% {"cons_curry(id)(nil)", OK "list[a -> a]"},
	% {"let lst1 = cons(id, nil) in let lst2 = cons(succ, lst1) in lst2", OK "list[int -> int]"},
	% {"cons_curry(id)(cons_curry(succ)(cons_curry(id)(nil)))", OK "list[int -> int]"},
	% {"plus(one, true)", error "cannot unify types int and bool"},
	% {"plus(one)", error "unexpected number of arguments"},

% another_id_test() ->
%   check("fun x -> let y = x in y",
% 	{ok, "'a -> 'a"}).

% funky_hof_test() ->
%   check("fun x -> let y = let z = x(fun x -> x) in z in y",
% 	{ok, "(('a -> 'a) -> 'b) -> 'b"}).

% hof_test() ->
%   check("fun x -> fun y -> let x = x(y) in x(y)",
% 	{ok, "('a -> 'a -> 'b) -> 'a -> 'b"}).

% hof_2_test() ->
%   check("fun x -> fun z -> x(z)",
% 	{ok, "('a -> 'b) -> 'a -> 'b"}).

hof_3_test() ->
  check("fun x -> let y = fun z -> x(z) in y",
	{ok, "(a -> b) -> a -> b"}).

hof_4_test() ->
  check("fun x -> let yy = let y = fun z -> x(z) in y in yy",
	{ok, "(a -> b) -> a -> b"}).

% const_test() ->
%   check("fun x -> let y = fun z -> x in y",
% 	{ok, "'a -> 'b -> 'a"}).

	% {"fun x -> fun y -> let x = x(y) in fun x -> y(x)",
	% 	OK "((a -> b) -> c) -> (a -> b) -> a -> b"},

% recursive_type_test() ->
%   check("fun x -> let y = x in y(y)",
% 	{error, recursive_types}).

% recursive_type_2_test() ->
%   check("fun x -> x(x)",
% 	{error, recursive_types}).

% extra_arg_identity_test() ->
%   check("fun x -> let y = fun z -> z in y(y)",
% 	{ok, "'a -> 'b -> 'b"}).

	% {"one(id)", error "expected a function"},
	% {"fun f -> let x = fun g y -> let _ = g(y) in eq(f, g) in x",
	% 	OK "(a -> b) -> (a -> b, a) -> bool"},
	% {"let const = fun x -> fun y -> x in const", OK "a -> b -> a"},

% apply_test() ->
%   check("let apply = fun f x -> f(x) in apply",
% 	{ok, "('a -> 'b, 'a) -> 'b"}).

% apply_curry_test() ->
%   check("let apply_curry = fun f -> fun x -> f(x) in apply_curry",
% 	{ok, "('a -> 'b) -> 'a -> 'b"}).

% curry_test() ->
%   check("fun f -> fun x -> fun y -> f(x, y)",
% 	{ok, "(('a, 'b) -> 'c) -> 'a -> 'b -> 'c"}).

% uncurry_test() ->
%   check("fun f -> fun x y -> f(x)(y)",
% 	{ok, "('a -> 'b -> 'c) -> ('a, 'b) -> 'c"}).

% {type_arrow,[{type_arrow,[{type_var,{tvar_ref,4}}],{type_var,{tvar_ref,5}}}],{type_arrow,[{typ e_arrow,[{type_var,{tvar_ref,6}}],{type_var,{tvar_ref,7}}}],{type_arrow,[{type_var,{tvar_ref,8 }}],{type_var,{tvar_ref,9}}}}}

check(Source, Expected) ->
  {ok, Tokens, _} = algodub_tokenizer:string(Source),
  {ok, AST} = algodub_parser:parse(Tokens),
  case algodub_infer:infer(AST) of
    {ok, Type} ->
      ?assertEqual(Expected, {ok, algodub:type_to_string(Type)});

    Error ->
      ?assertEqual(Expected, Error)
  end.
