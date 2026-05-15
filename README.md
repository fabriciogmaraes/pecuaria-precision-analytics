# PecuárIA — Precision Livestock Analytics

> Pipeline completo de dados para pecuária de precisão: do brinco ao abate, do dado bruto ao insight executivo.

![Python](https://img.shields.io/badge/Python-3.13-blue?logo=python)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-16-336791?logo=postgresql)
![Power BI](https://img.shields.io/badge/Power%20BI-Dashboard-F2C811?logo=powerbi)
![Prophet](https://img.shields.io/badge/Prophet-Forecasting-00C896)
![Scikit-learn](https://img.shields.io/badge/Scikit--learn-ML-orange?logo=scikit-learn)

---

## Sobre o Projeto

O **PecuárIA** é um ecossistema completo de dados para gestão de rebanho bovino de corte, integrando dados reais do **CEPEA/ESALQ** com dados simulados de 500 animais em confinamento. O projeto cobre todo o pipeline: ingestão, modelagem relacional, machine learning, séries temporais e visualização executiva.

**Problema de negócio:** Como identificar automaticamente animais de baixa performance e otimizar a compra de insumos com base em previsão de preços?

---

## Resultados Principais

| Resultado | Valor |
|---|---|
| Clusters de performance identificados | 3 grupos distintos |
| Silhouette Score (Hierárquico ward k=3) | 0,344 |
| Animais de Baixa Performance identificados | 132 (26,4%) |
| Economia potencial na compra de milho | **R$ 59.138** |
| Janela de compra recomendada (milho) | Jun/2026 |
| Valor total do rebanho simulado | R$ 2,86M |
| Margem bruta total | R$ 317.392 |

---

## Arquitetura do Projeto

```
Dados Reais (CEPEA/ESALQ)          Dados Simulados (Python)
        ↓                                    ↓
    Python ETL ──────────────────────────────┘
        ↓
  PostgreSQL (5 tabelas + 7 views)
        ↓
  Python ML (Clustering + Prophet)
        ↓
  Power BI (3 telas executivas)
```

---

## Estrutura de Pastas

```
pecuaria-precision-analytics/
│
├── data/
│   ├── raw/               # Arquivos brutos CEPEA (.xls)
│   └── processed/         # CSVs limpos e enriquecidos
│
├── notebooks/
│   ├── 01_simulacao_dados.ipynb      # Simulação do rebanho + CEPEA
│   ├── 02_etl_features.ipynb         # ETL + carga PostgreSQL
│   ├── 03_clustering_rebanho.ipynb   # K-Means e Hierárquico
│   ├── 04_previsao_insumos.ipynb     # Prophet + janela de compra
│   └── 05_analise_final.ipynb        # Views SQL + exportação Power BI
│
├── sql/
│   ├── 00_create_tables.sql          # DDL das tabelas
│   └── 01_setup_integridade.sql      # Chaves primárias e estrangeiras
│
├── powerbi/
│   ├── data/                         # CSVs exportados para o dashboard
│   └── pecuaria_precision_analytics.pbix
│
└── README.md
```

---

## Machine Learning

### Clustering do Rebanho (Notebook 03)

Comparativo entre **K-Means** e **Hierárquico Aglomerativo** (k=2 a 10) avaliado por Silhouette Score e Davies-Bouldin Index com **Final Score normalizado**.

**Features utilizadas:**
- GMD Total (Ganho Médio Diário)
- Conversão Alimentar
- Custo por kg Ganho
- Margem Bruta
- Peso de Entrada
- Dias em Confinamento

**Resultado:** Hierárquico Aglomerativo com `ward` e `k=3` produziu a melhor partição interpretável:

| Cluster | Animais | GMD Médio | Conv. Alimentar | Margem Média |
|---|---|---|---|---|
| Alta Performance | 118 (23,6%) | 1,62 kg/dia | 3,61 | R$ 738,59 |
| Performance Média | 250 (50,0%) | 1,32 kg/dia | 4,38 | R$ 652,80 |
| Baixa Performance | 132 (26,4%) | 0,93 kg/dia | 6,38 | R$ 507,87 |

> **Insight crítico:** Animais de Baixa Performance ficam em média **291 dias** em confinamento vs **136 dias** dos de Alta Performance — quase o dobro do tempo consumindo ração sem atingir o peso de abate.

### Previsão de Preços (Notebook 04)

Modelos **Prophet** treinados sobre 6 anos de dados reais CEPEA (2020–2026) para previsão de preços de milho, soja e boi gordo nos próximos 90 dias.

| Insumo | Melhor dia para comprar | Preço previsto | Economia potencial |
|---|---|---|---|
| Milho | 29/Jun/2026 | R$ 54,81/saca | **R$ 59.138** |
| Soja | 07/Abr/2026 | R$ 127,42/saca | R$ 5.541 |

---

## Modelagem de Dados (PostgreSQL)

**5 tabelas principais:**
- `animais` — cadastro dos 500 animais
- `pesagens` — 4.148 registros de pesagem
- `sanitario` — 6.181 eventos sanitários
- `estoque` — 540 registros de consumo de insumos
- `performance` — métricas calculadas por animal

**7 views analíticas** alimentando o Power BI:
- `vw_resumo_rebanho`
- `vw_performance_por_raca`
- `vw_performance_por_cluster`
- `vw_evolucao_peso_mensal`
- `vw_custo_sanitario_por_tipo`
- `vw_estoque_atual`
- `vw_animais_criticos`

---

## Dashboard Power BI

**Tela 1 — Visão Executiva:**
KPIs do rebanho, evolução do valor total, GMD por raça e margem por cluster de performance.

**Tela 2 — Performance Animal:**
Scatter GMD vs Margem Bruta com clusters coloridos, ranking por raça e tabela de animais críticos com margem negativa destacada.

**Tela 3 — Logística e Supply Chain:**
Histórico de preços CEPEA + previsão Prophet, janela de compra recomendada, custo por insumo e nível de estoque.

---

## Como Executar

### Pré-requisitos

```bash
pip install pandas numpy matplotlib seaborn scikit-learn prophet sqlalchemy psycopg2-binary python-dotenv xlrd openpyxl
```

### Configuração

1. Clone o repositório
2. Crie o arquivo `.env` na raiz:
```
DB_PASS=sua_senha_postgresql
```
3. Crie o banco no PostgreSQL:
```sql
CREATE DATABASE pecuaria;
```
4. Execute os notebooks em ordem (01 → 05)
5. Abra o `.pbix` no Power BI Desktop

### Dados CEPEA

Baixe os dados históricos em [cepea.org.br](https://cepea.org.br):
- Boi Gordo — Indicador CEPEA/ESALQ
- Milho — Indicador ESALQ/BM&FBovespa
- Soja — Indicador CEPEA/ESALQ Paranaguá

Período: **01/01/2020 a 31/03/2026** | Periodicidade: **Diária**

---

## Stack Técnica

| Ferramenta | Uso |
|---|---|
| Python 3.13 | ETL, ML, simulação |
| Pandas / NumPy | Manipulação de dados |
| Scikit-learn | K-Means, Hierárquico, PCA |
| Prophet | Previsão de séries temporais |
| PostgreSQL 16 | Banco de dados relacional |
| SQLAlchemy | ORM e conexão com banco |
| Power BI Desktop | Dashboard executivo |
| DBeaver | Interface gráfica PostgreSQL |
| Git / GitHub | Versionamento |

---

## Autor

**Fabricio Guimarães Alcântara da Silva**
Analista de Dados | Mestrando em Inteligência Computacional — PPgTI/UFRN

[![LinkedIn](https://img.shields.io/badge/LinkedIn-Connect-0077B5?logo=linkedin)](https://linkedin.com/in/fabriciogmaraes)
[![GitHub](https://img.shields.io/badge/GitHub-Follow-181717?logo=github)](https://github.com/fabriciogmaraes)

---

## Licença

MIT License — sinta-se à vontade para usar, adaptar e dar os devidos créditos.

---

# PecuárIA — Precision Livestock Analytics (English)

> End-to-end data pipeline for precision livestock management: from ear tag to slaughter, from raw data to executive insight.

---

## About

**PecuárIA** is a complete data ecosystem for beef cattle herd management, integrating real **CEPEA/ESALQ** price data with simulated data from 500 feedlot animals. The project covers the full pipeline: ingestion, relational modeling, machine learning, time series forecasting, and executive visualization.

**Business problem:** How to automatically identify underperforming animals and optimize input purchasing based on price forecasting?

---

## Key Results

| Result | Value |
|---|---|
| Performance clusters identified | 3 distinct groups |
| Silhouette Score (Hierarchical ward k=3) | 0.344 |
| Low Performance animals identified | 132 (26.4%) |
| Potential savings on corn purchasing | **R$ 59,138** |
| Recommended buying window (corn) | Jun/2026 |
| Simulated herd total value | R$ 2.86M |
| Total gross margin | R$ 317,392 |

---

## Machine Learning

### Herd Clustering (Notebook 03)

Comparison between **K-Means** and **Agglomerative Hierarchical Clustering** (k=2 to 10) evaluated by Silhouette Score, Davies-Bouldin Index and normalized Final Score.

**Result:** Hierarchical Clustering with `ward` linkage and `k=3`:

| Cluster | Animals | Avg ADG | Feed Conversion | Avg Margin |
|---|---|---|---|---|
| High Performance | 118 (23.6%) | 1.62 kg/day | 3.61 | R$ 738.59 |
| Average Performance | 250 (50.0%) | 1.32 kg/day | 4.38 | R$ 652.80 |
| Low Performance | 132 (26.4%) | 0.93 kg/day | 6.38 | R$ 507.87 |

### Price Forecasting (Notebook 04)

**Prophet** models trained on 6 years of real CEPEA data (2020–2026) to forecast corn, soybean and cattle prices for the next 90 days.

| Input | Best buying date | Forecasted price | Potential savings |
|---|---|---|---|
| Corn | Jun 29, 2026 | R$ 54.81/bag | **R$ 59,138** |
| Soybean | Apr 7, 2026 | R$ 127.42/bag | R$ 5,541 |

---

## How to Run

```bash
pip install pandas numpy matplotlib seaborn scikit-learn prophet sqlalchemy psycopg2-binary python-dotenv xlrd
```

1. Clone the repository
2. Create `.env` file at root: `DB_PASS=your_postgresql_password`
3. Create PostgreSQL database: `CREATE DATABASE pecuaria;`
4. Run notebooks in order (01 → 05)
5. Open `.pbix` in Power BI Desktop

---

## Author

**Fabricio Guimarães Alcântara da Silva**
Data Analyst | MSc Student in Computational Intelligence — PPgTI/UFRN
