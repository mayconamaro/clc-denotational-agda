target: all

all: Summary.agda Syntax.agda Utils.agda Standard.agda
	@echo "Iniciando verificação dos módulos, essa etapa requer o Agda 2.6.1 instalado e configurado para utilizar a biblioteca padrão 1.4"
	agda Summary.agda
	@echo "A verificação terminou sem erros"

clean: 
	-rm -f *.agdai
