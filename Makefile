.PHONY: all compile run test doc clean

REBAR=$(shell which rebar3 || echo ./rebar3)

all: compile

compile: $(REBAR)
	$(REBAR) as dev compile

run: $(REBAR)
	@$(REBAR) as dev shell --apps pooler --config config/demo.config

test: $(REBAR)
	$(REBAR) eunit --cover skip_deps=true verbose=3
	$(REBAR) cover

doc: $(REBAR)
	$(REBAR) as dev edoc

clean: $(REBAR)
	$(REBAR) as dev clean
	$(REBAR) as test clean
	@rm -rf ./erl_crash.dump

dialyzer: $(REBAR)
	$(REBAR) as dev dialyzer

# Get rebar3 if it doesn't exist. If rebar3 was found on PATH, the
# $(REBAR) dep will be satisfied since the file will exist.

REBAR_URL = https://s3.amazonaws.com/rebar3/rebar3

./rebar3:
	@echo "Fetching rebar3 from $(REBAR_URL)"
	@erl -noinput -noshell -s inets -s ssl  -eval '{ok, _} = httpc:request(get, {"${REBAR_URL}", []}, [{ssl, [{verify, verify_none}]}], [{stream, "${REBAR}"}])' -s init stop
		chmod +x ${REBAR}
