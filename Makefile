#Diretórios Base
SIM_DIR=sim
#Arquivos
RTL_FILES=../list_file_dut.lst
TB_FILES=../list_file_tb.lst
#WAVE_CONFIG =
#Top do testbench
TOP=tb

CLK_PERIOD ?= 20
 
#Passo 0: Criar diretório de simulação
init:
	mkdir -p $(SIM_DIR)

#Passo 1: Verificação de Sintaxe

syntax:init
	cd $(SIM_DIR)				&& \
		 vlogan -full64 		\
		 -sverilog			    \
		 -kdb     			    \
		 +lint=all			    \
		 -timescale=1ns/1ps		\
		 -f $(RTL_FILES)		\
		 -f $(TB_FILES)		

syntax_pos_impl:
	cd $(SIM_DIR)				&& \
		 vlogan -full64 		\
		 -sverilog			    \
		 -kdb     			    \
		 +lint=all			    \
		 -timescale=1ns/1ps		\
		 ../$(PKG_FILES)	    \
		 ../$(LIB_FILES)	    \
		 ../$(RTL_FILES_IMPL)   \
		 ../$(TB_FILES)

synthesis:
	sed -i '8s/.*/create_clock -name sys_clk -period $(CLK_PERIOD) [get_ports clk]/' constraints/vending.sdc
	cd sim && CLK_PERIOD=$(CLK_PERIOD) dc_shell -f ../synth/synth.tcl


#Passo 2: Compilação/Elaboração
compile:syntax
	cd $(SIM_DIR) 				  &&\
	vcs -full64 				\
	-debug_access+all 			\
	-kdb $(TOP)

compile_pos_synth:syntax_pos_synth
	cd $(SIM_DIR) 				  &&\
	vcs -full64 				\
	-debug_access+all 			\
	-kdb $(TOP)
compile_pos_impl:syntax_pos_impl
	cd $(SIM_DIR) 				  &&\
	vcs -full64 				\
	-debug_access+all 			\
	-kdb $(TOP)	
#Passo 3: Rodar Simulação
run:compile
	cd $(SIM_DIR) && \
	./simv
run_gui:compile
	cd $(SIM_DIR) && \
	./simv -gui
run_pos_impl:compile_pos_impl
	cd $(SIM_DIR) && \
	./simv
run_gui_pos_impl:compile_pos_impl
	cd $(SIM_DIR) && \
	./simv -gui
#Passo 4: Abrir o waveform no Verdi
waves:run
	cd $(SIM_DIR) &&\
	verdi -ssf waves.fsdb -sswr tb_vending_machine.rc

#Passo 5: Executar o Formality
formality:synthesis
	cd $(SIM_DIR) &&\
	fm_shell -f ../fm/formality.tcl
#Limpeza
clean:
	cd $(SIM_DIR) &&\
	rm -rf * ../reports/*	      	\ 
			 ../synth/impl.v*  	\
			 ../synth/synth*	\
			 ../work/*				\
			 ./default.svf			\
			 ./filenames.log		
			 *
#Passo Extra: Ajuda
help:
	@echo "======================================================================"
	@echo " Makefile - Fluxo de Verificação/Síntese"
	@echo "======================================================================"
	@echo ""
	@echo " Uso: make <target>"
	@echo ""
	@echo " --- Setup ---"
	@echo "  init                  Cria o diretório de simulação ($(SIM_DIR))"
	@echo ""
	@echo " --- Passo 1: Verificação de Sintaxe (vlogan) ---"
	@echo "  syntax                Analisa RTL + TB (pré-implementação)"
	@echo "  syntax_pos_impl       Analisa PKG/LIB/RTL_IMPL + TB (pós-implementação)"
	@echo ""
	@echo " --- Síntese ---"
	@echo "  synthesis             Executa dc_shell com synth/synth.tcl"
	@echo ""
	@echo " --- Passo 2: Compilação/Elaboração (vcs) ---"
	@echo "  compile               Compila após 'syntax'"
	@echo "  compile_pos_synth     Compila após 'syntax_pos_synth'"
	@echo "  compile_pos_impl      Compila após 'syntax_pos_impl'"
	@echo ""
	@echo " --- Passo 3: Simulação ---"
	@echo "  run                   Compila e roda a simulação (./simv)"
	@echo "  run_gui               Compila e roda a simulação em modo GUI"
	@echo "  run_pos_impl          Compila (pos_impl) e roda a simulação"
	@echo "  run_gui_pos_impl      Compila (pos_impl) e roda em modo GUI"
	@echo ""
	@echo " --- Passo 4: Waveform ---"
	@echo "  waves                 Roda a simulação e abre o Verdi"
	@echo ""
	@echo " --- Passo 5: Formality ---"
	@echo "  formality             Roda síntese e depois fm_shell (formality.tcl)"
	@echo ""
	@echo " --- Limpeza ---"
	@echo "  clean                 Remove arquivos gerados (sim, reports, synth, work, etc.)"
	@echo ""
	@echo " --- Ajuda ---"
	@echo "  help                  Mostra esta mensagem"
	@echo "======================================================================"

.PHONY: help init syntax syntax_pos_impl synthesis compile compile_pos_synth \
        compile_pos_impl run run_gui run_pos_impl run_gui_pos_impl waves \
        formality clean
