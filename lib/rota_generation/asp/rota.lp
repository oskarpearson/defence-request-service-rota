%%%%%%%
% LUA %
%%%%%%%

#begin_lua

  -----------------------------------------------------------
  -- Lua is necessary here as ASP only deals with integer  --
  -- division. In order to fairly distribute slots we need --
  -- to round up the average number of slots to create an  --
  -- upper bound.                                          --
  -----------------------------------------------------------

  -- 1) The maximum total slots allowed for each firm
  function max_total_slots_allowed(num_slots, num_firms)
    return math.ceil(num_slots / num_firms)
  end

  -- 2) The minimum total slots allowed for each firm
  function min_total_slots_allowed(num_slots, num_firms)
    return math.floor(num_slots / num_firms)
  end

  -- 3)
  function min_slots_per_shift_firm(slots_for_shift, num_firms)
    return math.floor(slots_for_shift / num_firms)
  end

  -- 4)
  function max_slots_per_shift_firm(slots_for_shift, num_firms)
    return math.ceil(slots_for_shift / num_firms)
  end

  -- 5)
  function max_slots_for_date(num_firms_required, num_firms)
    return math.ceil(num_firms_required / num_firms)
  end

  -- 6)
  function min_slots_for_date(num_firms_required, num_firms)
    return math.floor(num_firms_required / num_firms)
  end

#end_lua.

%%%%%%%%%%%%%%
% GENERATORS %
%%%%%%%%%%%%%%

% Generate enough allocations such that each shift has
% the required number it needs for each date.
N { allocated(S, Da, D, M, Y, F) : firm(F) } N :-
  slots_per_shift_date(S, Da, D, M, Y, N),
  date(Da, D, M, Y),
  shift(S).

%%%%%%%%%%%%%%%%%%%
% UTILITY CLAUSES %
%%%%%%%%%%%%%%%%%%%

% Define a clause which states the total number of
% slots to fill for the entire rota.
total_slots(N) :-
  N = #sum [ slots_per_shift_date(_, _, _, _, _, X) = X].

% Define a clause which states how many slots a firm
% has been allocated in total.
total_slots_for_firm(F, N) :-
  N = #count { allocated(_, _, _, _, _, F) },
  firm(F).

% Define a clause which states how many slots a firm
% has on any given date.
firm_slots_for_date(F, D, M, Y, N) :-
  N = #count { allocated(_, _, D, M, Y, F) },
  date(_, D, M, Y),
  firm(F).

% Define a clause which states how many slots are required across
% shifts for a given day of the week.
total_slots_required_on_date(D, M, Y, N) :-
  N = #sum [ slots_per_shift_date(_, _, D, M, Y, X) = X],
  date(_, D, M, Y).

% Define a clause which states how many slots are required across
% all days for a specific shift.
total_slots_for_shift(S, N) :-
  N = #sum [ slots_per_shift_date(S, _, _, _, _, X) = X],
  shift(S).

% Define a clause which states how many times a firm has been
% allocated on a day of the week.
slots_for_firm_on_day(F, Da, N) :-
  N = #count { allocated(_, Da, _, _, _, F) },
  date(Da, _, _, _),
  firm(F).

% Define a clause which states how many times a firm
% appears on a particular shift.
slots_for_shift_for_firm(F, S, N) :-
  N = #count { allocated(S, _, _, _, _, F) },
  firm(F),
  shift(S).

% Define what it means to have two consecutive dates.
consecutive_dates(D1, M, Y, D2, M, Y) :-
  date(_, D1, M, Y),
  date(_, D2, M, Y),
  D1 + 1 == D2.

consecutive_dates(D1, M, Y, D2, M, Y) :-
  date(_, D1, M, Y),
  date(_, D2, M, Y),
  D1 - 1 == D2.

consecutive_dates(D1, M1, Y, D2, M2, Y) :-
  date(_, D1, M1, Y),
  date(_, D2, M2, Y),
  D1 == 1,
  last_day_of_month(M2, Y, D2),
  M2 + 1 == M1.

consecutive_dates(D1, M1, Y, D2, M2, Y) :-
  date(_, D1, M1, Y),
  date(_, D2, M2, Y),
  D2 == 1,
  last_day_of_month(M1, Y, D1),
  M1 + 1 == M2.

consecutive_dates(31, 12, Y1, 1, 1, Y2) :-
  date(_, 31, 12, Y1),
  date(_, 1, 1, Y2),
  Y1 + 1 == Y2.

consecutive_dates(1, 1, Y1, 31, 12, Y2) :-
  date(_, 31, 12, Y2),
  date(_, 1, 1, Y1),
  Y2 + 1 == Y1.

last_day_of_month(M, Y, X) :-
  X = #max[ date(_, D, M, Y) = D ],
  date(_, _, M, Y).

% Identify when a firm is on the same shift on two consecutive dates.
allocated_on_consecutive_dates(F) :-
  allocated(S1, _, D1, M1, Y1, F),
  allocated(S2, _, D2, M2, Y2, F),
  consecutive_dates(D1, M1, Y1, D2, M2, Y2),
  S1 == S2.

%%%%%%%%%%%%%%%
% CONSTRAINTS %
%%%%%%%%%%%%%%%

% Ensure that the total number of slots allocated to each firm
% is within a fairness window.
% This window is the range
%   floor(X/F)..ceil(X/F)
% where X = total number of slots
%       F = total number of firms
:- total_slots_for_firm(_, N), total_slots(X),
  N > @max_total_slots_allowed(X, num_firms).
:- total_slots_for_firm(_, N), total_slots(X),
  N < @min_total_slots_allowed(X, num_firms).

% Ensure that the total number of slots allocated to each firm
% on any specific date is within a fairness window.
% This window is the range
%   floor(R/F)..ceil(K/F)
% where R = total number of slots required for that day
%       F = total number of firms
:- firm_slots_for_date(_, D, M, Y, N), total_slots_required_on_date(D, M, Y, R),
  N > @max_slots_for_date(R, num_firms).
:- firm_slots_for_date(_, D, M, Y, N), total_slots_required_on_date(D, M, Y, R),
  N < @min_slots_for_date(R, num_firms).

% Ensure that the total number of slots allocated to each firm
% on any specific shift is within a fairness window.
% This window is the range
%   floor(K/F)..ceil(K/F)
% where K = total number of slots required for that shift
%       F = total number of firms
:- slots_for_shift_for_firm(_, S, N), total_slots_for_shift(S, K),
  N > @max_slots_per_shift_firm(K, num_firms).
:- slots_for_shift_for_firm(_, S, N), total_slots_for_shift(S, K),
  N < @min_slots_per_shift_firm(K, num_firms).

%%%%%%%%%%%%%%%%%
% OPTIMIZATIONS %
%%%%%%%%%%%%%%%%%

% Minimize (don't completely disallow) the same shift on
% consecutive days. This is a soft constraint to ensure that
% in small scenarios (for example when num_firms < num_shifts)
% there is a still a valid solution.
#minimize { allocated_on_consecutive_dates(_) }.

%%%%%%%%%%%%%%%%
% PRESENTATION %
%%%%%%%%%%%%%%%%

#hide.
#show allocated/6.
% #show total_slots_for_firm/2.
% #show slots_for_shift_for_firm/3.
% #show slots_for_firm_on_day/3.
