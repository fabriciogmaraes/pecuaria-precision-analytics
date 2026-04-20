
-- Script de Criação das Tabelas (DDL)
-- Gerado com base nos dados reais de simulação

CREATE TABLE IF NOT EXISTS animais (
    id_animal INT PRIMARY KEY,
    brinco VARCHAR(20) UNIQUE NOT NULL,
    raca VARCHAR(50),
    lote INT,
    peso_entrada FLOAT,
    gmd_base FLOAT,
    data_entrada DATE,
    status VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS pesagens (
    id_pesagem INT PRIMARY KEY,
    id_animal INT,
    brinco VARCHAR(20),
    raca VARCHAR(50),
    lote INT,
    data_pesagem DATE,
    dias_conf INT,
    peso_kg FLOAT,
    gmd_periodo FLOAT,
    arroba_atual FLOAT,
    preco_arroba_rs FLOAT,
    valor_mercado_rs FLOAT
);

CREATE TABLE IF NOT EXISTS sanitario (
    id_evento INT PRIMARY KEY,
    id_animal INT,
    brinco VARCHAR(20),
    data_evento DATE,
    tipo VARCHAR(50),
    produto VARCHAR(100),
    dose_ml FLOAT,
    custo_unit FLOAT,
    custo_total FLOAT
);

CREATE TABLE IF NOT EXISTS estoque (
    id_estoque INT PRIMARY KEY,
    lote INT,
    n_animais INT,
    data_ref DATE,
    insumo VARCHAR(50),
    consumo_kg FLOAT,
    preco_rs_kg FLOAT,
    custo_total_rs FLOAT,
    estoque_kg FLOAT
);

CREATE TABLE IF NOT EXISTS performance (
    id_animal INT PRIMARY KEY,
    brinco VARCHAR(20),
    raca VARCHAR(50),
    lote INT,
    peso_entrada FLOAT,
    gmd_base FLOAT,
    data_entrada DATE,
    status VARCHAR(50),
    data_pesagem DATE,
    peso_kg FLOAT,
    gmd_periodo FLOAT,
    arroba_atual FLOAT,
    preco_arroba_rs FLOAT,
    valor_mercado_rs FLOAT,
    dias_conf INT,
    custo_sanitario_rs FLOAT,
    custo_racao_lote_rs FLOAT,
    n_animais_lote INT,
    custo_racao_animal_rs FLOAT,
    gmd_total FLOAT,
    ganho_peso_kg FLOAT,
    custo_total_animal_rs FLOAT,
    custo_por_kg_ganho FLOAT,
    margem_bruta_rs FLOAT,
    conversao_alimentar FLOAT,
    classe_performance VARCHAR(50)
);
