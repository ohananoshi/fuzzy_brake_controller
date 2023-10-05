### Uso da Lógica Fuzzy para controlar o acionamento dos freios de um carro baseando-se na velocidade do carro, velocidade das rodas do carro e na pressão aplicada no pedal de freio.


#### Exercício feito para a disciplina de Inteligência Computacional
#### Regra do exercício: Não usar a Toolbox de Lógica Fuzzy do MATLAB
#### Método de Defuzzificação: Centróide
#### Objetivo: O programa deve receber os inputs da velocidade do carro,   velocidade das rodas, pressão no pedal e calcular a pressão adequada a ser aplicada nos freios.

###  Dados do problema

#### Pressão no pedal do freio. Considerando que a pressão vai de 0 a 100.
```
- Alta = {(50,0),(100,1)}
- Media = {(30,0),(50,1),(70,0)}
- Baixa = {(0,1),(50,0)}
```

#### Velocidade das rodas. Considerando que a velocidade das rodas vai de 0 a 100.
```
- Alta = {(40,0),(100,1)}
- Media = {(20,0),(50,1),(80,0)}
- Baixa = {(0,1),(60,0)}
```

#### Velocidade do carro. Considerando que a velocidade do carro vai de 0 a 100.
```
- Alta = {(40,0),(100,1)}
- Media = {(20,0),(50,1),(80,0)}
- Baixa = {(0,1),(60,0)}
```

#### Pressão do freio. Considerando que a pressão do freio vai de 0 a 100.

```
- Aplicar = {(0,0),(100,1)}
- Soltar = {(0,1),(100,0)}
```

#### Regras para o controle dos freios

- #### Regra 1
    Se a pressão no pedal for MÉDIA então aplique o freio.
- #### Regra 2
    Se a presão no pedal for ALTA, e a velocidade do carro estiver ALTA, e a velocidade das rodas estiver ALTA, então aplique o freio.
- #### Regra 3
    Se a presão no pedal for ALTA, e a velocidade do carro estiver ALTA, e a velocidade das rodas estiver BAIXA, então solte o freio.
- #### Regra 4
    Se a pressão no pedal for baixa então solte o freio.

### EXEMPLO

#### Para o input:
```
Pressão no pedal: 60
Velocidade do carro: 80
Velocidade das rodas: 70
```
![](imagens/ex.jpg "Result")

