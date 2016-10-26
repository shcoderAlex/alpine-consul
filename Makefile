all: consul

consul:
	@docker build -t shcoder/alpine-consul .