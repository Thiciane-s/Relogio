# Relógio

## Requisitos
Para executar o projeto é necessário fazer o download dos seguintes softwares: SimulIDE, para simulação do circuito, e o Microchip Studio, para compilação do código em Assembly. O Microchip Studio é indicado para dispositivos Windows. Para computadores com Linux, é necessário abrir o terminal no diretório com o arquivo e por fim utilizar o comando avra  para compilar o arquivo .asm e transforma-lo em um arquivo em tipo .hex.

## Configuração do Circuito no SimulIDE
Para visualizar o circuito é necessário abrir o SimulIDE. No menu principal, vá em File > Open e selecione o arquivo do circuito (um arquivo .sim1). Em seguida, verifique se o circuito está configurado corretamente: O ATmega328 deve estar conectado aos componentes do relógio (display, cristal, resistores, etc.).

## Compilação do Código em Assembly no Microchip Studio
Para fazer a compilação do código no Windows é necessário abrir o Microchip Studio. Em seguida, crie um novo projeto: Vá em File > New > Project. Selecione Assembler como tipo de projeto. Nomeie o projeto e escolha um local para salvá-lo. Adicione o arquivo .asm ao projeto: Clique com o botão direito na pasta Source Files no Solution Explorer. Selecione Add > Existing Item e escolha o arquivo .asm do repositório. Configure o projeto para o ATmega328:Clique com o botão direito no nome do projeto no Solution Explorer e selecione Properties.Em Tool, selecione o dispositivo ATmega328P. Compile o código: Vá em Build > Build Solution (ou pressione F7). O arquivo .hex será gerado na pasta Debug ou Release do projeto.

## Carregar o Firmware no SimulIDE
No SimulIDE, clique com o botão direito no ATmega328 no circuito. Na janela de propriedades, vá até a seção carregar firmware. Selecione o arquivo .hex gerado pelo Microchip Studio. Clique em OK para carregar o firmware no simulador.

## Executar a Simulação
No SimulIDE, clique no botão Play (ícone de play) para iniciar a simulação. Verifique se o relógio está funcionando corretamente: O display deve mostrar o tempo conforme programado.
