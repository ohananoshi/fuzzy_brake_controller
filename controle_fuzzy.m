% ============================= main ===================================

while true
    pressao_pedal = input('Insira o valor da pressão no pedal: ');
    if pressao_pedal >= 0 && pressao_pedal <= 100
        break;
    end
end
while true
    velocidade_do_carro = input('Insira um valor para a velocidade do carro: ');
    if velocidade_do_carro >= 0 && velocidade_do_carro <= 100
        break;
    end
end
while true
    velocidade_das_rodas = input('Insira um valor para a velocidade das rodas: ');
    if velocidade_das_rodas >= 0 && velocidade_das_rodas <= 100
        break;
    end
end

[aplicar, soltar] = fuzzificar(velocidade_do_carro, velocidade_das_rodas, pressao_pedal);

plotar_resultado(aplicar, soltar);

% =========================== FUNÇÕES ==================================

% Funcoes que caracterizam a pertinencia das pressoes no pedal

function pressao_baixa_pertinencia = pedal_baixa(pressao)
    if pressao <= 50
        pressao_baixa_pertinencia = -0.02*pressao + 1;
    else
        pressao_baixa_pertinencia = 0;
    end
end

function pressao_media_pertinencia = pedal_media(pressao)
    if pressao >= 30 && pressao <= 50
        pressao_media_pertinencia = 0.05*pressao-1.5;
    elseif pressao > 50 && pressao <= 70
        pressao_media_pertinencia = -0.05*pressao+3.5;
    else
        pressao_media_pertinencia = 0;
    end
end

function pressa_alta_pertinencia = pedal_alta(pressao)
    if pressao >= 50
        pressa_alta_pertinencia = 0.02*pressao-1;
    else
        pressa_alta_pertinencia = 0;
    end
end

% Funções que carcterizam a pertinência das velocidades das rodas

function v_roda_baixa_pertinencia = v_roda_baixa(velocidade)
    if velocidade <= 60
        v_roda_baixa_pertinencia = -(1/60)*velocidade + 1;
    else
        v_roda_baixa_pertinencia = 0;
    end
end

function v_roda_media_pertinencia = v_roda_media(velocidade)
    if velocidade >= 20 && velocidade <= 50
        v_roda_media_pertinencia = (1/30)*velocidade - (2/3);
    elseif velocidade > 50 && velocidade <= 80
        v_roda_media_pertinencia = -(1/30)*velocidade + (8/3);
    else
        v_roda_media_pertinencia = 0;
    end
end

function v_roda_alta_pertinencia = v_roda_alta(velocidade)
    if velocidade >= 40
        v_roda_alta_pertinencia = (1/60)*velocidade - (2/3);
    else
        v_roda_alta_pertinencia = 0;
    end
end

% Funções que carcterizam a pertinência das velocidades do carro

function v_carro_baixa_pertinencia = v_carro_baixa(velocidade)
    if velocidade <= 60
        v_carro_baixa_pertinencia = -(1/60)*velocidade + 1;
    else
        v_carro_baixa_pertinencia = 0;
    end
end

function v_carro_media_pertinencia = v_carro_media(velocidade)
    if velocidade >= 20 && velocidade <= 50
        v_carro_media_pertinencia = (1/30)*velocidade - (2/3);
    elseif velocidade > 50 && velocidade <= 80
        v_carro_media_pertinencia = -(1/30)*velocidade + (8/3);
    else
        v_carro_media_pertinencia = 0;
    end
end

function v_carro_alta_pertinencia = v_carro_alta(velocidade)
    if velocidade >= 40
        v_carro_alta_pertinencia = (1/60)*velocidade - (2/3);
    else
        v_carro_alta_pertinencia = 0;
    end
end

% Funções de pertinência para aplicar ou soltar o freio

% Soltar o freio

function soltar_freio_pertinencia = soltar_freio(pressao)
    soltar_freio_pertinencia = -0.01*pressao + 1;
end

% Aplicar o freio

function aplicar_freio_pertinencia = aplicar_freio(pressao)
    aplicar_freio_pertinencia = 0.01*pressao;
end

% Logica fuzzy

% Fuzzy AND

function output = fuzzy_and(pertinencia_a, pertinencia_b)
    if pertinencia_a <= pertinencia_b
        output = pertinencia_a;
    else
        output = pertinencia_b;
    end
end

% Fuzzy OR (para o caso do problema, o autor sugere a soma)

function output = fuzzy_or(pertinencia_a, pertinencia_b)
    output = pertinencia_a + pertinencia_b;
end

% Função para aplicar as regras de fuzzificação do problema

function [aplicar, soltar] = fuzzificar(v_carro, v_rodas, pressao)
    % Regra 1
    aplicar_1 = pedal_media(pressao);

    % Regra 2
    aplicar_2 = fuzzy_and(pedal_alta(pressao),fuzzy_and(v_carro_alta(v_carro), v_roda_alta(v_rodas)));

    % Regra 3
    soltar_1 = fuzzy_and(pedal_alta(pressao), fuzzy_and(v_carro_alta(v_carro), v_roda_baixa(v_rodas)));

    % Regra 4
    soltar_2 = pedal_baixa(pressao);

    aplicar = fuzzy_or(aplicar_1, aplicar_2);
    soltar = fuzzy_or(soltar_1, soltar_2);
end

% Funçao auxiliar para gerar a curva poligonal das intersecções entre
% as pertinencias de soltar e aplicar o freio e as funções de pertinencia

function curva = aux(aplicar_freio_pertinencia, soltar_freio_pertinencia, pressao)

    if soltar_freio_pertinencia > aplicar_freio_pertinencia
        if soltar_freio(pressao) >= soltar_freio_pertinencia
            curva = soltar_freio_pertinencia;
        elseif soltar_freio(pressao) < soltar_freio_pertinencia && soltar_freio(pressao) > aplicar_freio_pertinencia
            curva = soltar_freio(pressao);
    
        elseif soltar_freio(pressao) <= aplicar_freio_pertinencia
            curva = aplicar_freio_pertinencia;
        else
            curva = 0;
        end
    elseif soltar_freio_pertinencia == aplicar_freio_pertinencia 
        % Como são iguais, o gráfico será simétrico independentemente dos
        % valores de pertinência, logo, farei a função retornar um valor constante.
        curva = 0.5;
    else
        if aplicar_freio(pressao) < soltar_freio_pertinencia
            curva = soltar_freio_pertinencia;
        elseif aplicar_freio(pressao) >= soltar_freio_pertinencia && aplicar_freio(pressao) <= aplicar_freio_pertinencia
            curva = aplicar_freio(pressao);

        elseif aplicar_freio(pressao) > aplicar_freio_pertinencia
            curva = aplicar_freio_pertinencia;
        else
            curva = 0;
        end
    end
end

% Função para plotar o grafico do resultado

function plotar_resultado(aplicar_freio_pertinencia, soltar_freio_pertinencia)
    t = linspace(0,100,101);
    n = (0:1:100);
    
    % Criando curvar as curvas de pertinência

    pressao_baixa_pertinencia = zeros(size(n));
    pressao_media_pertinencia = zeros(size(n));
    pressao_alta_pertinencia = zeros(size(n));

    v_roda_baixa_pertinencia = zeros(size(n));
    v_roda_media_pertinencia = zeros(size(n));
    v_roda_alta_pertinencia = zeros(size(n));

    v_carro_baixa_pertinencia = zeros(size(n));
    v_carro_media_pertinencia = zeros(size(n));
    v_carro_alta_pertinencia = zeros(size(n));
    
    ar_aplicar_freio_pertinencia = zeros(size(n));
    ar_soltar_freio_pertinencia = zeros(size(n));
    
    curva = zeros(size(n));

    aplicar = ones(size(n)).*aplicar_freio_pertinencia;
    soltar = ones(size(n)).*soltar_freio_pertinencia;

    centroide_numerador = 0;
    centroide_denominador = 0;

    for i = 1: length(n)

        pressao_baixa_pertinencia(i) = pedal_baixa(i);
        pressao_media_pertinencia(i) = pedal_media(i);
        pressao_alta_pertinencia(i) = pedal_alta(i);

        v_roda_baixa_pertinencia(i) = v_roda_baixa(i);
        v_roda_media_pertinencia(i) = v_roda_media(i);
        v_roda_alta_pertinencia(i) = v_roda_alta(i);

        v_carro_baixa_pertinencia(i) = v_carro_baixa(i);
        v_carro_media_pertinencia(i) = v_carro_media(i);
        v_carro_alta_pertinencia(i) = v_carro_alta(i);

        ar_aplicar_freio_pertinencia(i) = aplicar_freio(i);
        ar_soltar_freio_pertinencia(i) = soltar_freio(i);

        aux_2 = aux(aplicar_freio_pertinencia, soltar_freio_pertinencia,i);
        curva(i) = aux_2;

        centroide_numerador = centroide_numerador + (i*aux_2);
        centroide_denominador = centroide_denominador + aux_2;

    end

    centroide_x = centroide_numerador/centroide_denominador;
    
    % Plotando pertinências em relação a pressão no pedal

    subplot(4,1,1);
    plot(n,pressao_baixa_pertinencia, 'r', 'DisplayName', 'Pressão Baixa');
    hold on;
    plot(n,pressao_media_pertinencia, 'b', 'DisplayName', 'Pressão Média');
    hold on;
    plot(n,pressao_alta_pertinencia, 'm' ,'DisplayName', 'Pressão Alta');
    hold off;
    
    % Plotando legendas

    legend('Location', 'northeast'); 
    %nomes declarado aos eixos
    xlabel('Pressão');
    ylabel('Pertinência');
    %Titulo do gráfico individual
    title('Pressão aplicada no Pedal');
    
    % Plotando pertinências em relação a velocidade das rodas

    subplot(4,1,2);
    plot(n,v_roda_baixa_pertinencia, 'r','DisplayName', 'VRoda Baixa');
    hold on;
    plot(n,v_roda_media_pertinencia,'b','DisplayName', 'VRoda Média');
    hold on;
    plot(n,v_roda_alta_pertinencia,'m',  'DisplayName', 'VRoda Alta');
    hold off;
    
    % Plotando legendas

    legend('Location', 'northeast');
    %nomes declarado aos eixos
    xlabel('Velocidade');
    ylabel('Pertinência');
    %Titulo do gráfico individual
    title('Velocidade da Roda');
    
    % Plotando pertinências em relação a velocidade do carro

    subplot(4,1,3);
    plot(n,v_carro_baixa_pertinencia, 'r', 'DisplayName', 'VCarro Baixa');
    hold on;
    plot(n,v_carro_media_pertinencia,  'b','DisplayName', 'VCarro Média');
    hold on;
    plot(n,v_carro_alta_pertinencia,  'm' ,'DisplayName', 'VCarro Alta');
    hold off;

    % Plotando legendas

    legend('Location','northeast');
    %nomes declarado aos eixos
    xlabel('Velocidade');
    ylabel('Pertinência');
    %Titulo do gráfico individual
    title('Velocidade do Carro');
  
    % Plotando resultados

    subplot(4,1,4);
    plot(t, curva, 'DisplayName', 'Curva de pertinência');
    hold on;
    stem(centroide_x, 1, 'r', 'DisplayName', 'Centróide');
    hold on;
    plot(n, aplicar,'--r', 'DisplayName','Aplicar');
    hold on;
    plot(n, soltar,'--b', 'DisplayName','Soltar');
    hold on;
    plot(n, ar_aplicar_freio_pertinencia, 'k','DisplayName','Função Aplicar');
    hold on;
    plot(n, ar_soltar_freio_pertinencia, 'y', 'DisplayName','Função Soltar');
    hold on;
    x_fill = [t, fliplr(t)]; % Referencia para preencher eixo  x
    y_fill = [curva, zeros(size(curva))]; % Referencia para preencher área sobre a curva 0 no eixo y
    fill(x_fill, y_fill, 'g', 'FaceAlpha', 0.3', 'DisplayName',' '); % 'g ' para cor em ingles da area sombreada e Facealpha para determinar que é uma superficie transparente
    hold off;
    
    % Plotando legendas

    legend('Location','northeast');
    xlabel('Pressão do freio');
    ylabel('Pertinência');
    % %Titulo do gráfico individual
    title('Area de atuação do freio');

    disp(aplicar(1));
    disp(soltar(1));
    
    
end
