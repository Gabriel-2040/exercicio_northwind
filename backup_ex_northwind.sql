PGDMP  *                    |            da_15_gabriel    15.4    16.2 e    �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            �           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            �           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            �           1262    41216    da_15_gabriel    DATABASE     �   CREATE DATABASE da_15_gabriel WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'Portuguese_Brazil.1252';
    DROP DATABASE da_15_gabriel;
                postgres    false                        2615    41570    data_warehouse    SCHEMA        CREATE SCHEMA data_warehouse;
    DROP SCHEMA data_warehouse;
                postgres    false            �            1259    41771    dim_cliente    TABLE     �   CREATE TABLE data_warehouse.dim_cliente (
    id integer NOT NULL,
    nome_empresa text,
    cidade text,
    regiao text,
    pais text
);
 '   DROP TABLE data_warehouse.dim_cliente;
       data_warehouse         heap    postgres    false    6            �            1259    41770    dim_cliente_id_seq    SEQUENCE     �   CREATE SEQUENCE data_warehouse.dim_cliente_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 1   DROP SEQUENCE data_warehouse.dim_cliente_id_seq;
       data_warehouse          postgres    false    228    6            �           0    0    dim_cliente_id_seq    SEQUENCE OWNED BY     Y   ALTER SEQUENCE data_warehouse.dim_cliente_id_seq OWNED BY data_warehouse.dim_cliente.id;
          data_warehouse          postgres    false    227            �            1259    41789 	   dim_local    TABLE     t   CREATE TABLE data_warehouse.dim_local (
    id integer NOT NULL,
    cidade text,
    pais text,
    regiao text
);
 %   DROP TABLE data_warehouse.dim_local;
       data_warehouse         heap    postgres    false    6            �            1259    41788    dim_local_id_seq    SEQUENCE     �   CREATE SEQUENCE data_warehouse.dim_local_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 /   DROP SEQUENCE data_warehouse.dim_local_id_seq;
       data_warehouse          postgres    false    232    6            �           0    0    dim_local_id_seq    SEQUENCE OWNED BY     U   ALTER SEQUENCE data_warehouse.dim_local_id_seq OWNED BY data_warehouse.dim_local.id;
          data_warehouse          postgres    false    231            �            1259    41780    dim_produto    TABLE     h   CREATE TABLE data_warehouse.dim_produto (
    id integer NOT NULL,
    nome text,
    categoria text
);
 '   DROP TABLE data_warehouse.dim_produto;
       data_warehouse         heap    postgres    false    6            �            1259    41779    dim_produto_id_seq    SEQUENCE     �   CREATE SEQUENCE data_warehouse.dim_produto_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 1   DROP SEQUENCE data_warehouse.dim_produto_id_seq;
       data_warehouse          postgres    false    230    6            �           0    0    dim_produto_id_seq    SEQUENCE OWNED BY     Y   ALTER SEQUENCE data_warehouse.dim_produto_id_seq OWNED BY data_warehouse.dim_produto.id;
          data_warehouse          postgres    false    229            �            1259    41834 	   dim_tempo    TABLE     �   CREATE TABLE data_warehouse.dim_tempo (
    id integer NOT NULL,
    data date,
    ano integer,
    mes integer,
    dia integer,
    dia_da_semana text,
    mes_extenso text
);
 %   DROP TABLE data_warehouse.dim_tempo;
       data_warehouse         heap    postgres    false    6            �            1259    41833    dim_tempo_id_seq    SEQUENCE     �   CREATE SEQUENCE data_warehouse.dim_tempo_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 /   DROP SEQUENCE data_warehouse.dim_tempo_id_seq;
       data_warehouse          postgres    false    6    234            �           0    0    dim_tempo_id_seq    SEQUENCE OWNED BY     U   ALTER SEQUENCE data_warehouse.dim_tempo_id_seq OWNED BY data_warehouse.dim_tempo.id;
          data_warehouse          postgres    false    233            �            1259    41843    fato_vendas_estoque    TABLE     u  CREATE TABLE data_warehouse.fato_vendas_estoque (
    id integer NOT NULL,
    id_tempo integer,
    id_produto integer,
    id_cliente integer,
    id_local integer,
    unidades_em_estoque numeric(18,2),
    nivel_reabastecimento numeric(18,2),
    valor_venda_real numeric(18,2),
    valor_custo numeric(18,2),
    lucro numeric(18,2),
    quantidade_vendida integer
);
 /   DROP TABLE data_warehouse.fato_vendas_estoque;
       data_warehouse         heap    postgres    false    6            �            1259    41842    fato_vendas_estoque_id_seq    SEQUENCE     �   CREATE SEQUENCE data_warehouse.fato_vendas_estoque_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 9   DROP SEQUENCE data_warehouse.fato_vendas_estoque_id_seq;
       data_warehouse          postgres    false    236    6            �           0    0    fato_vendas_estoque_id_seq    SEQUENCE OWNED BY     i   ALTER SEQUENCE data_warehouse.fato_vendas_estoque_id_seq OWNED BY data_warehouse.fato_vendas_estoque.id;
          data_warehouse          postgres    false    235            �            1259    41880    vw_clientes_mais_lucrativos    VIEW       CREATE VIEW data_warehouse.vw_clientes_mais_lucrativos AS
 SELECT dc.nome_empresa AS cliente,
    sum(fve.valor_venda_real) AS total_vendas,
    sum(fve.valor_custo) AS custo_total,
    sum(fve.quantidade_vendida) AS qtd_vendida,
    sum(fve.lucro) AS lucro_total
   FROM ((data_warehouse.fato_vendas_estoque fve
     JOIN data_warehouse.dim_produto dp ON ((dp.id = fve.id_produto)))
     JOIN data_warehouse.dim_cliente dc ON ((dc.id = fve.id_cliente)))
  GROUP BY dc.nome_empresa
  ORDER BY (sum(fve.lucro)) DESC;
 6   DROP VIEW data_warehouse.vw_clientes_mais_lucrativos;
       data_warehouse          postgres    false    236    236    236    236    236    236    230    228    228    6            �            1259    41890    vw_controle_estoque    VIEW     �  CREATE VIEW data_warehouse.vw_controle_estoque AS
 SELECT dp.nome AS produto,
    dl.cidade,
    dl.pais,
    dt.data AS data_inteira,
    sum(fve.unidades_em_estoque) AS und_estoque,
    sum(fve.nivel_reabastecimento) AS esp_estoque,
    ((sum(fve.unidades_em_estoque) - sum(fve.nivel_reabastecimento)) >= (0)::numeric) AS "Excesso"
   FROM (((data_warehouse.fato_vendas_estoque fve
     JOIN data_warehouse.dim_produto dp ON ((dp.id = fve.id_produto)))
     JOIN data_warehouse.dim_local dl ON ((dl.id = fve.id_local)))
     JOIN data_warehouse.dim_tempo dt ON ((dt.id = fve.id_tempo)))
  GROUP BY dp.nome, dl.cidade, dl.pais, dt.data
  ORDER BY dp.nome;
 .   DROP VIEW data_warehouse.vw_controle_estoque;
       data_warehouse          postgres    false    236    232    232    232    234    236    236    234    236    236    230    230    6            �            1259    41871    vw_desempenho_vendas_atual    VIEW       CREATE VIEW data_warehouse.vw_desempenho_vendas_atual AS
 SELECT sum(fato_vendas_estoque.valor_venda_real) AS total_vendas,
    sum(fato_vendas_estoque.valor_custo) AS total_custo,
    sum(fato_vendas_estoque.lucro) AS lucro
   FROM data_warehouse.fato_vendas_estoque;
 5   DROP VIEW data_warehouse.vw_desempenho_vendas_atual;
       data_warehouse          postgres    false    236    236    236    6            �            1259    41885     vw_distribuicao_produtos_estoque    VIEW     �  CREATE VIEW data_warehouse.vw_distribuicao_produtos_estoque AS
 SELECT dp.nome AS produto,
    dl.cidade AS cidade_produto,
    dl.pais AS pais_produto,
    dt.data AS data_inteira
   FROM (((data_warehouse.fato_vendas_estoque fve
     JOIN data_warehouse.dim_local dl ON ((dl.id = fve.id_local)))
     JOIN data_warehouse.dim_produto dp ON ((dp.id = fve.id_produto)))
     JOIN data_warehouse.dim_tempo dt ON ((dt.id = fve.id_tempo)))
  GROUP BY dp.nome, dl.cidade, dl.pais, dt.data
  ORDER BY dt.data;
 ;   DROP VIEW data_warehouse.vw_distribuicao_produtos_estoque;
       data_warehouse          postgres    false    236    236    230    230    232    232    236    232    234    234    6            �            1259    41910    vw_previsão_demanda    VIEW     �  CREATE VIEW data_warehouse."vw_previsão_demanda" AS
 SELECT dp.nome AS nome_produto,
    dt.mes,
    dt.ano,
    sum(fve.quantidade_vendida) AS qtd_vendida
   FROM ((data_warehouse.fato_vendas_estoque fve
     JOIN data_warehouse.dim_produto dp ON ((dp.id = fve.id_produto)))
     JOIN data_warehouse.dim_tempo dt ON ((dt.id = fve.id_tempo)))
  GROUP BY dp.nome, dt.mes, dt.ano
  ORDER BY dp.nome, dt.mes, dt.ano;
 1   DROP VIEW data_warehouse."vw_previsão_demanda";
       data_warehouse          postgres    false    236    230    230    234    234    234    236    236    6            �           0    0    VIEW "vw_previsão_demanda"    COMMENT     �   COMMENT ON VIEW data_warehouse."vw_previsão_demanda" IS '-- possivel ordenação  de produtos para cada 6 meses
-- CASE 
--         WHEN dt.mes BETWEEN 1 AND 6 THEN ''primeiro semestre''
--         ELSE ''segundo semestre''
--     END AS semestre,';
          data_warehouse          postgres    false    244            �            1259    41875    vw_produtos_mais_vendidos    VIEW     �  CREATE VIEW data_warehouse.vw_produtos_mais_vendidos AS
 SELECT fve.id_produto AS id,
    dp.nome AS nome_produto,
    sum(fve.valor_venda_real) AS total_vendas,
    sum(fve.valor_custo) AS custo_total,
    sum(fve.quantidade_vendida) AS qtd_vendida,
    sum(fve.lucro) AS lucro_total
   FROM (data_warehouse.fato_vendas_estoque fve
     JOIN data_warehouse.dim_produto dp ON ((dp.id = fve.id_produto)))
  GROUP BY dp.nome, fve.id_produto
  ORDER BY (sum(fve.valor_venda_real));
 4   DROP VIEW data_warehouse.vw_produtos_mais_vendidos;
       data_warehouse          postgres    false    236    230    236    236    236    236    230    6            �            1259    41900    vw_variação_sazonal    VIEW     v  CREATE VIEW data_warehouse."vw_variação_sazonal" AS
 SELECT dp.nome AS nome_produto,
    sum(fve.quantidade_vendida) AS qtd_vendida,
    dt.mes,
    dl.pais,
    dl.regiao,
    dl.cidade,
    ((sum(fve.unidades_em_estoque) - sum(fve.nivel_reabastecimento)) >= (0)::numeric) AS "Excesso"
   FROM (((data_warehouse.fato_vendas_estoque fve
     JOIN data_warehouse.dim_produto dp ON ((dp.id = fve.id_produto)))
     JOIN data_warehouse.dim_tempo dt ON ((dt.id = fve.id_tempo)))
     JOIN data_warehouse.dim_local dl ON ((dl.id = fve.id_local)))
  GROUP BY dp.nome, dt.mes, dl.pais, dl.regiao, dl.cidade
  ORDER BY dp.nome, dt.mes;
 2   DROP VIEW data_warehouse."vw_variação_sazonal";
       data_warehouse          postgres    false    236    236    236    236    236    236    234    234    232    232    232    232    230    230    6            �            1259    41905    vw_variação_sazonal_2    VIEW       CREATE VIEW data_warehouse."vw_variação_sazonal_2" AS
 SELECT dp.id AS id_produto,
    dp.nome AS nome_produto,
    sum(fve.quantidade_vendida) AS qtd_vendida,
    fve.unidades_em_estoque AS qtd_estoque,
    dt.dia,
    dt.mes,
    dt.ano,
    dl.cidade,
    dl.regiao,
    dl.pais,
    ((sum(fve.unidades_em_estoque) - sum(fve.nivel_reabastecimento)) >= (0)::numeric) AS "Excesso"
   FROM (((data_warehouse.fato_vendas_estoque fve
     JOIN data_warehouse.dim_produto dp ON ((dp.id = fve.id_produto)))
     JOIN data_warehouse.dim_tempo dt ON ((dt.id = fve.id_tempo)))
     JOIN data_warehouse.dim_local dl ON ((dl.id = fve.id_local)))
  GROUP BY dp.nome, dt.mes, dl.pais, dl.regiao, dl.cidade, dp.id, dt.dia, fve.unidades_em_estoque, dt.ano
  ORDER BY dt.ano, dt.mes, dt.dia, dl.pais;
 4   DROP VIEW data_warehouse."vw_variação_sazonal_2";
       data_warehouse          postgres    false    230    232    232    232    232    234    234    234    234    236    236    236    236    236    236    230    6            �           0    0    VIEW "vw_variação_sazonal_2"    COMMENT     ,  COMMENT ON VIEW data_warehouse."vw_variação_sazonal_2" IS '-- fazer uma consulta de pedido por DATA
-- comparar com uma consulta de estoque por data
-- apontar os locais proximos na cidade ou regiao onde os estoques estão vazios naquela data
-- de maneira a balencear as cargas nos estoques EX:';
          data_warehouse          postgres    false    243            �            1259    41597 
   categorias    TABLE     �   CREATE TABLE public.categorias (
    id smallint NOT NULL,
    nome character varying(15) NOT NULL,
    descricao text,
    imagem bytea
);
    DROP TABLE public.categorias;
       public         heap    postgres    false            �            1259    41602    clientes    TABLE     �  CREATE TABLE public.clientes (
    id bpchar NOT NULL,
    nome_empresa character varying(40) NOT NULL,
    nome_contato character varying(30),
    titulo_contato character varying(30),
    endereco character varying(60),
    cidade character varying(15),
    regiao character varying(15),
    cep character varying(10),
    pais character varying(15),
    telefone character varying(24),
    fax character varying(24)
);
    DROP TABLE public.clientes;
       public         heap    postgres    false            �            1259    41607    empregado_territorios    TABLE     �   CREATE TABLE public.empregado_territorios (
    id_empregado smallint NOT NULL,
    id_territorio character varying(20) NOT NULL
);
 )   DROP TABLE public.empregado_territorios;
       public         heap    postgres    false            �            1259    41610    fornecedores    TABLE     �  CREATE TABLE public.fornecedores (
    id smallint NOT NULL,
    nome_empresa character varying(40) NOT NULL,
    nome_contato character varying(30),
    titulo_contato character varying(30),
    endereco character varying(60),
    cidade character varying(15),
    regiao character varying(15),
    cep character varying(10),
    pais character varying(15),
    telefone character varying(24),
    fax character varying(24),
    site text
);
     DROP TABLE public.fornecedores;
       public         heap    postgres    false            �            1259    41615    funcionarios    TABLE     q  CREATE TABLE public.funcionarios (
    id smallint NOT NULL,
    ultimo_nome character varying(20) NOT NULL,
    primeiro_nome character varying(10) NOT NULL,
    titulo character varying(30),
    apelido character varying(25),
    data_nascimento date,
    data_contratacao date,
    endereco character varying(60),
    cidade character varying(15),
    regiao character varying(15),
    cep character varying(10),
    pais character varying(15),
    telefone character varying(24),
    ddd character varying(4),
    foto bytea,
    observacoes text,
    relatorios_para smallint,
    caminho_foto character varying(255)
);
     DROP TABLE public.funcionarios;
       public         heap    postgres    false            �            1259    41620    pedido_detalhe    TABLE     �   CREATE TABLE public.pedido_detalhe (
    id_pedido smallint NOT NULL,
    id_produto smallint NOT NULL,
    preco_unitario real NOT NULL,
    quantidade smallint NOT NULL,
    desconto real NOT NULL
);
 "   DROP TABLE public.pedido_detalhe;
       public         heap    postgres    false            �            1259    41623    pedidos    TABLE     �  CREATE TABLE public.pedidos (
    id smallint NOT NULL,
    id_cliente bpchar,
    id_funcionario smallint,
    data_pedido date,
    data_requerida date,
    data_enviado date,
    id_transportadora smallint,
    frete real,
    nome_navio character varying(40),
    endereco_navio character varying(60),
    cidade_navio character varying(15),
    regiao_navio character varying(15),
    cep_navio character varying(10),
    pais_navio character varying(15)
);
    DROP TABLE public.pedidos;
       public         heap    postgres    false            �            1259    41628    produtos    TABLE     f  CREATE TABLE public.produtos (
    id smallint NOT NULL,
    nome character varying(40) NOT NULL,
    id_transportadora smallint,
    id_categoria smallint,
    quantidade character varying(20),
    preco_unitario real,
    unidades_em_estoque smallint,
    unidades_em_ordem smallint,
    nivel_reabastecimento smallint,
    interrmpido integer NOT NULL
);
    DROP TABLE public.produtos;
       public         heap    postgres    false            �            1259    41631    regiao    TABLE     ^   CREATE TABLE public.regiao (
    id smallint NOT NULL,
    nome character varying NOT NULL
);
    DROP TABLE public.regiao;
       public         heap    postgres    false            �            1259    41636    territorios    TABLE     �   CREATE TABLE public.territorios (
    id character varying(20) NOT NULL,
    nome character varying NOT NULL,
    id_regiao smallint NOT NULL
);
    DROP TABLE public.territorios;
       public         heap    postgres    false            �            1259    41641    transportadoras    TABLE     �   CREATE TABLE public.transportadoras (
    id smallint NOT NULL,
    nome character varying(40) NOT NULL,
    telefone character varying(24)
);
 #   DROP TABLE public.transportadoras;
       public         heap    postgres    false            �            1259    41644 
   us_estados    TABLE     �   CREATE TABLE public.us_estados (
    id smallint NOT NULL,
    nome character varying(100),
    sigla character varying(2),
    regiao character varying(50)
);
    DROP TABLE public.us_estados;
       public         heap    postgres    false            �           2604    41774    dim_cliente id    DEFAULT     �   ALTER TABLE ONLY data_warehouse.dim_cliente ALTER COLUMN id SET DEFAULT nextval('data_warehouse.dim_cliente_id_seq'::regclass);
 E   ALTER TABLE data_warehouse.dim_cliente ALTER COLUMN id DROP DEFAULT;
       data_warehouse          postgres    false    227    228    228            �           2604    41792    dim_local id    DEFAULT     |   ALTER TABLE ONLY data_warehouse.dim_local ALTER COLUMN id SET DEFAULT nextval('data_warehouse.dim_local_id_seq'::regclass);
 C   ALTER TABLE data_warehouse.dim_local ALTER COLUMN id DROP DEFAULT;
       data_warehouse          postgres    false    232    231    232            �           2604    41783    dim_produto id    DEFAULT     �   ALTER TABLE ONLY data_warehouse.dim_produto ALTER COLUMN id SET DEFAULT nextval('data_warehouse.dim_produto_id_seq'::regclass);
 E   ALTER TABLE data_warehouse.dim_produto ALTER COLUMN id DROP DEFAULT;
       data_warehouse          postgres    false    229    230    230            �           2604    41837    dim_tempo id    DEFAULT     |   ALTER TABLE ONLY data_warehouse.dim_tempo ALTER COLUMN id SET DEFAULT nextval('data_warehouse.dim_tempo_id_seq'::regclass);
 C   ALTER TABLE data_warehouse.dim_tempo ALTER COLUMN id DROP DEFAULT;
       data_warehouse          postgres    false    233    234    234            �           2604    41846    fato_vendas_estoque id    DEFAULT     �   ALTER TABLE ONLY data_warehouse.fato_vendas_estoque ALTER COLUMN id SET DEFAULT nextval('data_warehouse.fato_vendas_estoque_id_seq'::regclass);
 M   ALTER TABLE data_warehouse.fato_vendas_estoque ALTER COLUMN id DROP DEFAULT;
       data_warehouse          postgres    false    235    236    236            �          0    41771    dim_cliente 
   TABLE DATA           U   COPY data_warehouse.dim_cliente (id, nome_empresa, cidade, regiao, pais) FROM stdin;
    data_warehouse          postgres    false    228   Z�       �          0    41789 	   dim_local 
   TABLE DATA           E   COPY data_warehouse.dim_local (id, cidade, pais, regiao) FROM stdin;
    data_warehouse          postgres    false    232   ��       �          0    41780    dim_produto 
   TABLE DATA           B   COPY data_warehouse.dim_produto (id, nome, categoria) FROM stdin;
    data_warehouse          postgres    false    230   ��       �          0    41834 	   dim_tempo 
   TABLE DATA           `   COPY data_warehouse.dim_tempo (id, data, ano, mes, dia, dia_da_semana, mes_extenso) FROM stdin;
    data_warehouse          postgres    false    234   ��       �          0    41843    fato_vendas_estoque 
   TABLE DATA           �   COPY data_warehouse.fato_vendas_estoque (id, id_tempo, id_produto, id_cliente, id_local, unidades_em_estoque, nivel_reabastecimento, valor_venda_real, valor_custo, lucro, quantidade_vendida) FROM stdin;
    data_warehouse          postgres    false    236   �      �          0    41597 
   categorias 
   TABLE DATA           A   COPY public.categorias (id, nome, descricao, imagem) FROM stdin;
    public          postgres    false    215   �      �          0    41602    clientes 
   TABLE DATA           �   COPY public.clientes (id, nome_empresa, nome_contato, titulo_contato, endereco, cidade, regiao, cep, pais, telefone, fax) FROM stdin;
    public          postgres    false    216   ��      �          0    41607    empregado_territorios 
   TABLE DATA           L   COPY public.empregado_territorios (id_empregado, id_territorio) FROM stdin;
    public          postgres    false    217   ��      �          0    41610    fornecedores 
   TABLE DATA           �   COPY public.fornecedores (id, nome_empresa, nome_contato, titulo_contato, endereco, cidade, regiao, cep, pais, telefone, fax, site) FROM stdin;
    public          postgres    false    218   v�      �          0    41615    funcionarios 
   TABLE DATA           �   COPY public.funcionarios (id, ultimo_nome, primeiro_nome, titulo, apelido, data_nascimento, data_contratacao, endereco, cidade, regiao, cep, pais, telefone, ddd, foto, observacoes, relatorios_para, caminho_foto) FROM stdin;
    public          postgres    false    219   4�      �          0    41620    pedido_detalhe 
   TABLE DATA           e   COPY public.pedido_detalhe (id_pedido, id_produto, preco_unitario, quantidade, desconto) FROM stdin;
    public          postgres    false    220   �      �          0    41623    pedidos 
   TABLE DATA           �   COPY public.pedidos (id, id_cliente, id_funcionario, data_pedido, data_requerida, data_enviado, id_transportadora, frete, nome_navio, endereco_navio, cidade_navio, regiao_navio, cep_navio, pais_navio) FROM stdin;
    public          postgres    false    221   ��      �          0    41628    produtos 
   TABLE DATA           �   COPY public.produtos (id, nome, id_transportadora, id_categoria, quantidade, preco_unitario, unidades_em_estoque, unidades_em_ordem, nivel_reabastecimento, interrmpido) FROM stdin;
    public          postgres    false    222   ;      �          0    41631    regiao 
   TABLE DATA           *   COPY public.regiao (id, nome) FROM stdin;
    public          postgres    false    223   �C      �          0    41636    territorios 
   TABLE DATA           :   COPY public.territorios (id, nome, id_regiao) FROM stdin;
    public          postgres    false    224   D      �          0    41641    transportadoras 
   TABLE DATA           =   COPY public.transportadoras (id, nome, telefone) FROM stdin;
    public          postgres    false    225   YF      �          0    41644 
   us_estados 
   TABLE DATA           =   COPY public.us_estados (id, nome, sigla, regiao) FROM stdin;
    public          postgres    false    226   �F      �           0    0    dim_cliente_id_seq    SEQUENCE SET     I   SELECT pg_catalog.setval('data_warehouse.dim_cliente_id_seq', 91, true);
          data_warehouse          postgres    false    227            �           0    0    dim_local_id_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('data_warehouse.dim_local_id_seq', 70, true);
          data_warehouse          postgres    false    231            �           0    0    dim_produto_id_seq    SEQUENCE SET     I   SELECT pg_catalog.setval('data_warehouse.dim_produto_id_seq', 1, false);
          data_warehouse          postgres    false    229            �           0    0    dim_tempo_id_seq    SEQUENCE SET     J   SELECT pg_catalog.setval('data_warehouse.dim_tempo_id_seq', 12042, true);
          data_warehouse          postgres    false    233            �           0    0    fato_vendas_estoque_id_seq    SEQUENCE SET     S   SELECT pg_catalog.setval('data_warehouse.fato_vendas_estoque_id_seq', 2155, true);
          data_warehouse          postgres    false    235            �           2606    41778    dim_cliente dim_cliente_pkey 
   CONSTRAINT     b   ALTER TABLE ONLY data_warehouse.dim_cliente
    ADD CONSTRAINT dim_cliente_pkey PRIMARY KEY (id);
 N   ALTER TABLE ONLY data_warehouse.dim_cliente DROP CONSTRAINT dim_cliente_pkey;
       data_warehouse            postgres    false    228            �           2606    41796    dim_local dim_local_pkey 
   CONSTRAINT     ^   ALTER TABLE ONLY data_warehouse.dim_local
    ADD CONSTRAINT dim_local_pkey PRIMARY KEY (id);
 J   ALTER TABLE ONLY data_warehouse.dim_local DROP CONSTRAINT dim_local_pkey;
       data_warehouse            postgres    false    232            �           2606    41787    dim_produto dim_produto_pkey 
   CONSTRAINT     b   ALTER TABLE ONLY data_warehouse.dim_produto
    ADD CONSTRAINT dim_produto_pkey PRIMARY KEY (id);
 N   ALTER TABLE ONLY data_warehouse.dim_produto DROP CONSTRAINT dim_produto_pkey;
       data_warehouse            postgres    false    230            �           2606    41841    dim_tempo dim_tempo_pkey 
   CONSTRAINT     ^   ALTER TABLE ONLY data_warehouse.dim_tempo
    ADD CONSTRAINT dim_tempo_pkey PRIMARY KEY (id);
 J   ALTER TABLE ONLY data_warehouse.dim_tempo DROP CONSTRAINT dim_tempo_pkey;
       data_warehouse            postgres    false    234            �           2606    41848 ,   fato_vendas_estoque fato_vendas_estoque_pkey 
   CONSTRAINT     r   ALTER TABLE ONLY data_warehouse.fato_vendas_estoque
    ADD CONSTRAINT fato_vendas_estoque_pkey PRIMARY KEY (id);
 ^   ALTER TABLE ONLY data_warehouse.fato_vendas_estoque DROP CONSTRAINT fato_vendas_estoque_pkey;
       data_warehouse            postgres    false    236            �           2606    41663    categorias pk_categories 
   CONSTRAINT     V   ALTER TABLE ONLY public.categorias
    ADD CONSTRAINT pk_categories PRIMARY KEY (id);
 B   ALTER TABLE ONLY public.categorias DROP CONSTRAINT pk_categories;
       public            postgres    false    215            �           2606    41665    clientes pk_customers 
   CONSTRAINT     S   ALTER TABLE ONLY public.clientes
    ADD CONSTRAINT pk_customers PRIMARY KEY (id);
 ?   ALTER TABLE ONLY public.clientes DROP CONSTRAINT pk_customers;
       public            postgres    false    216            �           2606    41667 -   empregado_territorios pk_employee_territories 
   CONSTRAINT     �   ALTER TABLE ONLY public.empregado_territorios
    ADD CONSTRAINT pk_employee_territories PRIMARY KEY (id_empregado, id_territorio);
 W   ALTER TABLE ONLY public.empregado_territorios DROP CONSTRAINT pk_employee_territories;
       public            postgres    false    217    217            �           2606    41669    funcionarios pk_employees 
   CONSTRAINT     W   ALTER TABLE ONLY public.funcionarios
    ADD CONSTRAINT pk_employees PRIMARY KEY (id);
 C   ALTER TABLE ONLY public.funcionarios DROP CONSTRAINT pk_employees;
       public            postgres    false    219            �           2606    41671    pedido_detalhe pk_order_details 
   CONSTRAINT     p   ALTER TABLE ONLY public.pedido_detalhe
    ADD CONSTRAINT pk_order_details PRIMARY KEY (id_pedido, id_produto);
 I   ALTER TABLE ONLY public.pedido_detalhe DROP CONSTRAINT pk_order_details;
       public            postgres    false    220    220            �           2606    41673    pedidos pk_orders 
   CONSTRAINT     O   ALTER TABLE ONLY public.pedidos
    ADD CONSTRAINT pk_orders PRIMARY KEY (id);
 ;   ALTER TABLE ONLY public.pedidos DROP CONSTRAINT pk_orders;
       public            postgres    false    221            �           2606    41675    produtos pk_products 
   CONSTRAINT     R   ALTER TABLE ONLY public.produtos
    ADD CONSTRAINT pk_products PRIMARY KEY (id);
 >   ALTER TABLE ONLY public.produtos DROP CONSTRAINT pk_products;
       public            postgres    false    222            �           2606    41677    regiao pk_region 
   CONSTRAINT     N   ALTER TABLE ONLY public.regiao
    ADD CONSTRAINT pk_region PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.regiao DROP CONSTRAINT pk_region;
       public            postgres    false    223            �           2606    41679    transportadoras pk_shippers 
   CONSTRAINT     Y   ALTER TABLE ONLY public.transportadoras
    ADD CONSTRAINT pk_shippers PRIMARY KEY (id);
 E   ALTER TABLE ONLY public.transportadoras DROP CONSTRAINT pk_shippers;
       public            postgres    false    225            �           2606    41681    fornecedores pk_suppliers 
   CONSTRAINT     W   ALTER TABLE ONLY public.fornecedores
    ADD CONSTRAINT pk_suppliers PRIMARY KEY (id);
 C   ALTER TABLE ONLY public.fornecedores DROP CONSTRAINT pk_suppliers;
       public            postgres    false    218            �           2606    41683    territorios pk_territories 
   CONSTRAINT     X   ALTER TABLE ONLY public.territorios
    ADD CONSTRAINT pk_territories PRIMARY KEY (id);
 D   ALTER TABLE ONLY public.territorios DROP CONSTRAINT pk_territories;
       public            postgres    false    224            �           2606    41685    us_estados pk_usstates 
   CONSTRAINT     T   ALTER TABLE ONLY public.us_estados
    ADD CONSTRAINT pk_usstates PRIMARY KEY (id);
 @   ALTER TABLE ONLY public.us_estados DROP CONSTRAINT pk_usstates;
       public            postgres    false    226            �           2606    41859 7   fato_vendas_estoque fato_vendas_estoque_id_cliente_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY data_warehouse.fato_vendas_estoque
    ADD CONSTRAINT fato_vendas_estoque_id_cliente_fkey FOREIGN KEY (id_cliente) REFERENCES data_warehouse.dim_cliente(id);
 i   ALTER TABLE ONLY data_warehouse.fato_vendas_estoque DROP CONSTRAINT fato_vendas_estoque_id_cliente_fkey;
       data_warehouse          postgres    false    3304    228    236            �           2606    41864 5   fato_vendas_estoque fato_vendas_estoque_id_local_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY data_warehouse.fato_vendas_estoque
    ADD CONSTRAINT fato_vendas_estoque_id_local_fkey FOREIGN KEY (id_local) REFERENCES data_warehouse.dim_local(id);
 g   ALTER TABLE ONLY data_warehouse.fato_vendas_estoque DROP CONSTRAINT fato_vendas_estoque_id_local_fkey;
       data_warehouse          postgres    false    236    3308    232            �           2606    41854 7   fato_vendas_estoque fato_vendas_estoque_id_produto_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY data_warehouse.fato_vendas_estoque
    ADD CONSTRAINT fato_vendas_estoque_id_produto_fkey FOREIGN KEY (id_produto) REFERENCES data_warehouse.dim_produto(id);
 i   ALTER TABLE ONLY data_warehouse.fato_vendas_estoque DROP CONSTRAINT fato_vendas_estoque_id_produto_fkey;
       data_warehouse          postgres    false    230    236    3306            �           2606    41849 5   fato_vendas_estoque fato_vendas_estoque_id_tempo_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY data_warehouse.fato_vendas_estoque
    ADD CONSTRAINT fato_vendas_estoque_id_tempo_fkey FOREIGN KEY (id_tempo) REFERENCES data_warehouse.dim_tempo(id);
 g   ALTER TABLE ONLY data_warehouse.fato_vendas_estoque DROP CONSTRAINT fato_vendas_estoque_id_tempo_fkey;
       data_warehouse          postgres    false    3310    234    236            �           2606    41701 7   empregado_territorios fk_employee_territories_employees    FK CONSTRAINT     �   ALTER TABLE ONLY public.empregado_territorios
    ADD CONSTRAINT fk_employee_territories_employees FOREIGN KEY (id_empregado) REFERENCES public.funcionarios(id);
 a   ALTER TABLE ONLY public.empregado_territorios DROP CONSTRAINT fk_employee_territories_employees;
       public          postgres    false    219    3288    217            �           2606    41706 9   empregado_territorios fk_employee_territories_territories    FK CONSTRAINT     �   ALTER TABLE ONLY public.empregado_territorios
    ADD CONSTRAINT fk_employee_territories_territories FOREIGN KEY (id_territorio) REFERENCES public.territorios(id);
 c   ALTER TABLE ONLY public.empregado_territorios DROP CONSTRAINT fk_employee_territories_territories;
       public          postgres    false    224    217    3298            �           2606    41711 #   funcionarios fk_employees_employees    FK CONSTRAINT     �   ALTER TABLE ONLY public.funcionarios
    ADD CONSTRAINT fk_employees_employees FOREIGN KEY (relatorios_para) REFERENCES public.funcionarios(id);
 M   ALTER TABLE ONLY public.funcionarios DROP CONSTRAINT fk_employees_employees;
       public          postgres    false    3288    219    219            �           2606    41716 &   pedido_detalhe fk_order_details_orders    FK CONSTRAINT     �   ALTER TABLE ONLY public.pedido_detalhe
    ADD CONSTRAINT fk_order_details_orders FOREIGN KEY (id_pedido) REFERENCES public.pedidos(id);
 P   ALTER TABLE ONLY public.pedido_detalhe DROP CONSTRAINT fk_order_details_orders;
       public          postgres    false    3292    221    220            �           2606    41721 (   pedido_detalhe fk_order_details_products    FK CONSTRAINT     �   ALTER TABLE ONLY public.pedido_detalhe
    ADD CONSTRAINT fk_order_details_products FOREIGN KEY (id_produto) REFERENCES public.produtos(id);
 R   ALTER TABLE ONLY public.pedido_detalhe DROP CONSTRAINT fk_order_details_products;
       public          postgres    false    220    3294    222            �           2606    41726    pedidos fk_orders_customers    FK CONSTRAINT     �   ALTER TABLE ONLY public.pedidos
    ADD CONSTRAINT fk_orders_customers FOREIGN KEY (id_cliente) REFERENCES public.clientes(id);
 E   ALTER TABLE ONLY public.pedidos DROP CONSTRAINT fk_orders_customers;
       public          postgres    false    221    3282    216            �           2606    41731    pedidos fk_orders_employees    FK CONSTRAINT     �   ALTER TABLE ONLY public.pedidos
    ADD CONSTRAINT fk_orders_employees FOREIGN KEY (id_funcionario) REFERENCES public.funcionarios(id);
 E   ALTER TABLE ONLY public.pedidos DROP CONSTRAINT fk_orders_employees;
       public          postgres    false    221    219    3288            �           2606    41736    pedidos fk_orders_shippers    FK CONSTRAINT     �   ALTER TABLE ONLY public.pedidos
    ADD CONSTRAINT fk_orders_shippers FOREIGN KEY (id_transportadora) REFERENCES public.transportadoras(id);
 D   ALTER TABLE ONLY public.pedidos DROP CONSTRAINT fk_orders_shippers;
       public          postgres    false    3300    221    225            �           2606    41741    produtos fk_products_categories    FK CONSTRAINT     �   ALTER TABLE ONLY public.produtos
    ADD CONSTRAINT fk_products_categories FOREIGN KEY (id_categoria) REFERENCES public.categorias(id);
 I   ALTER TABLE ONLY public.produtos DROP CONSTRAINT fk_products_categories;
       public          postgres    false    215    222    3280            �           2606    41746    produtos fk_products_suppliers    FK CONSTRAINT     �   ALTER TABLE ONLY public.produtos
    ADD CONSTRAINT fk_products_suppliers FOREIGN KEY (id_transportadora) REFERENCES public.fornecedores(id);
 H   ALTER TABLE ONLY public.produtos DROP CONSTRAINT fk_products_suppliers;
       public          postgres    false    3286    222    218            �           2606    41751 !   territorios fk_territories_region    FK CONSTRAINT     �   ALTER TABLE ONLY public.territorios
    ADD CONSTRAINT fk_territories_region FOREIGN KEY (id_regiao) REFERENCES public.regiao(id);
 K   ALTER TABLE ONLY public.territorios DROP CONSTRAINT fk_territories_region;
       public          postgres    false    223    224    3296            �   #  x�}W�r9<���IZ�MIJ�4�C�f��\��&p �d�>2����F��9��lMJ�dkV���P��Y]���u�z1�C`�T>0��ie�K:e���R��������V����dj�x��D��'�Xq|8<��/8��R��`����:6V��_sv��֊���M*B���:CckR[f�~TiR��}�c'�_�l�����F�����5�s�ſc���S6�6��Db�,�Y���=���d�V��� ��OS�ź�ñ� n��4N����"�:i�t�_|�*�b`W*�^��f�8!u*-�YKe*�#�[#�z��gԘ�6�V�>�:8�ZK'������{Y&��@�^����;�
�x'�s �EO9�'�܂MP��4���"�+v��x%�7��M��dv}�s~�L�%{̶�*l�$i�J�IH�xľ�┳4�V\�\���Nn��T[4ޢv $�:Uf�
�j�����a)�Q�Px!]�G�ڡc'���\��%ҽ���]:��*B-b]�ѥ4a[��#:��gPac8	ʾ"h�J'�� �b��Nq��ڹN�J�FC�RZI�s��j.u��r��4<�N{b(�N%R�#w(�R'�J2�;=�~G�Z���!{� 3W1���j��6��m�Y��ql�9Y�^��Z�p��;Y������O�BF�Ӎu��r���tʈ%4�GJ`���kj]�(���D�L�����E7����M�5�օ|!u�~D�R��"Pp� @��j��R_��ѽ�[u�U:�Q�6QQ׊/k��|���������n�p��@��X����ׁ2��DՇ֦�6��=�t5���^�ޠ����d<�LvE)�'h�-�����Z�7	�N	�Fs��n�$�4�������{��˃�ׇO%(���W0�n�߁������,7��6�8_�QS1Pj:���Sޝ�Ы{-zZ\�Eĩ�	�D׺%�����q���.����r�{�G�V���eG4*�4j��jq�5yk�;i}bH�Jc	�BAD�N��y���X)�O�F-���P��]�+1�d��o�Fa�
���K2��2%�����ݓ�F�6b$Fp���l�6�X#ʿ4��k4i��7��E �h��nsT\^��dl[�ť�BfK@˄�O,v[�i���k����Hz�W`�E�/@ot���� ja�0�qi�̠�*H��a��^��F�c�ױ>�(\vc���1�#��Bn6�(���<Q�QA�>-W{ѬbA	�1����?��}�U�Y�lD���XK�2]X�x�΋�9'O 5�xn+ק�1,���Zo�Z5t�d��<d�&�&]%8�K/��wX�pRy���lѕN��:�}�v�<QK��B�ѶVm�
A��=*>�8Q!-�_�c�Cר!F�u�=Z���oۣs�K��@�ǀy{%�3oѵJ��.�^+��7O���^�*]C���#/����d��H�[5�RNX�������1����0���������� vr���NޯP�I�R�Ţ������Bh(��hCb������<Ω�G�%J�6Mx�P�DAƜv���)���п����e�I�3I9#�}�n�BI�N�*�[��;~=N��h�4��sa�ɿ�ը���Y$y�����{�Pi�s��@��<V���8��wnף-�)�D[x5��4U����lp���3 �+��ĻT�M$�GZ��&����n!Ab�ǜ�����8�����ڄJ��+�<-�_ћ3�0	X�/���S���R9��Ū�-#0�%���O ����|�9�m� �k�lo�9ďL0Q\^|,T���/�����Ԩ���?ſ�8S�D���:��4��e���v��q�[��[����O���e���	�o��N�I>���W`�H�4~�¼���B�Ɓ�@��>�A&�j�Ǳӆ��vA�n���*�y�L��N�fPx�.>w���aW�Gn�]�K�LaFh?���=�t��͔b$�g��2K�j�J3d�TB�S~��4��7���JW��a�R�?J�      �   X  x�]T�nb9]���~�>�%�C��LHw4Ro
�c��kH��iF��G�U��M]G�K 8�r��s\1�q�%��Q���s�@_-�wO�?�yч�L��׫���y���A���z7��hwun�+RF#,�P�,j�N�4��4�<)�)Z������DtkH�+V�Ӱ8���A����00ҽr߈8����^�OҚB�8a�H/��4/�S��gR�߯6������6.�Kˡ�ݐ.%7U�I_��5g".`��'����I*X܉�è����onE܅��"k�U��b-\I>O`�=���0�vl)�<4��D��#s�c�(2ߢG�ٖ"I`�5Q��J�F\Nޟ�E���s_��p�s�}󶌰5k]e�OW��I>p�����2�(��o���;	�R������)�!+ne����=0�'�%��iw!����i�$�Ńnz.M`R�TWnIS6+n_��iS�O'y���T�����`�-��ߠ
h�F����]����+��i�,�����ܕ�a�k+ח���i�%�o����wd�f�˳\��uۂտC$��ѥ�^��5�~��˒V"�9�~���"��_M�s�%;�Q����M��ܱd�Sy;��M#�P�=m6�D��Tl��7�'�����!G,S����s:��#j�֜c�E���)����a�]Y���\\�P���J^3y'
ե�!֌�}�w7�ze�4z� ,KEg�mF,Ps�Ű(�P/���G�	��C5�K�E�8/v~�����X���bB�5�P������Y��P��G�gM��c�eXn�[z���E���uڌZw��YԳ�_[B������      �   �  x�mV�VG]���w^�=�Ĳ!$D�sr�)͔f�iu+� ��q��>��w�c��	�H�$uݮ�ǭ[�IAJ��[v������7N��(Ϝ���ō�X��5��;C�y%�M�捗��F.��5
>�Qy�K+�꾉�SG&[ ��ֳY�s[��8���L�o&���K��Q�|���39/��f1�Ρ�Y�;k3��O.	Ʀ�#1U�P��.Y�TŔ)��ۨ��vz]qVFGɭ���_#{����4{��x{�'��LZpn��9�`�e;��,��������Eo$N�0j[ظ���{c1�[mo�>]q�58NıV)�i(�N6�bBΐ��F^��Q�秏�5��.'�M���:+�F|�~W,��W63�E��֤)�6��F-Rkx�Q_�Fh󹩾�%/]���tPƿ�0�����h��!|�[}�'dB���R��#1��8!9��烙�9�����N��!�Y}u5Kת���6(���y�d�Y����U��=X
��+����>�\T������ ���|h�jЭ	�\����׷��5�S�rk>!y�Z�˯A_Lɧ�6�=ʳTV�=� S��Y�bA��H!-��6��"0k�"�`�a�6gFS�PZ��Խ��Lj�9%�A�lӴm=rTk���g��д����1�KYW���'~���f|'?�\C_�DӺ&�]���OMNB��-K��;yԔ)�.�q�����Պ[��LD+���4��\�ĕ�)z�����b�a�m&�"��K�����֏��a�:F�JS[磮�H���KMm��p�ܨu�<���fS�����ŉ�?${�����'ţ�)�ixTKYtAU�8�1�ļ�;T�dZ��j�&��6�)i�1$5m/�D\�m�i엜���5�s�#�Pns����6J '�f (�؝�q¹�5�H�s�Ub�1��g72{S}#ukό��TfI}H]�}��ȹ�����C�Z�!�2���`�Х���Mx<6*�5;A�[�f��[~�q^�9���.s4+������"֘��!�ц��*/�ɗu.m�aH�e��}��_Q��+.cX��@�'�^o_����>�c�1uN��1{��j���9�C/J�E�V+��-�`|��^@_�<�x��R�CC)�,I��z�\�U��K�reHCWȔ+�����;tya�ϭ���S�����W      �      x�t���d=r\ן�B/ �2xyI.^�������`���z{߮jFd���L}F3�d�����X����������3~����?������?�����ǿ����_��� �o����?���7�l"�M�?����_�?/�c���������g979��_���6�~��_�����A2^�|>��?��_�pB�� e��PEY����o��me�~��Y�z>U�
�
�z>U�
�
�z>U�
�z>U{>U%9:{>�5�5��󩬙��ڞOe����|�jy�=���A�@oϧ�f�7���<��z{>U5���ޞOU� o���SU3����T�L��=�ʚ�[���SY��m���7���S��������_���K(6�OfBCh�h>�	��k��\&�	���2���{��T&�͇2��й�Yk]]u�&�}��_iY-�
銲\�|}�z]�,�%cAcq���,�,zY�K΂��.kvIZPZ��f���Ŭk&mAm������f�zC�5���3�5��z{>U5��z{>U5��z{>U5��z{>U5��z{>U5��z{>�5�7��󩬙�5z{>�5��Foϧ�f���x�>��T������?�����?��B��|2
�m��`&�	�6��eB/�}��X&��7�OeBo�c��P&t��u��е�Uk�W��u�V���e��|}�z	
�Vl�X�X\eņ��E/K6�,�,�fC҂�b�5�����uͤ-�-V]3y��U�l��Q�l�t�P�l����T�l����T�l����T�l����T�l����T�L�@o��������ޞOe��������-^���T������/��K`�Y��%bٖj��&�"{��%����T��v�7�;�,���Av��%v��dg]�)v�]u��}O���WY�x�\$sQ�-^rr�|�
/����%�(]��/���X/^22��>���KC��U�%�!���Ͳ����|�+(�!��Ǻ�r	������`�%���XV0����`�%���XV0�r���`�%���`�%�w]��K�%ơ�r	��<TP.!�X�
�e����+�lr٢���D��}�5�?���}_տ`�|�3�7��g�|�'8�]p'�p�o�7�|~3<���fx
���tK�"������"�����vM
#)��xMCu��$�$F���d1d1��~MC��l������PA���y��T�Tƪ+x�%�����\B.u/�D:��+x�%����%��K\u/��\����r��PA��\b*(��K�C�r�UW��e����+��0]��������H�A8��p����_�s �]p'�[ �߄s �C� �� ��'�y(����t����Z�̀LKa$�Q�ÐCkdZC�%�iYY��@��1�����ǐGkdZ"C"�5�i����@��2����r	��A��ri-�L�%�yD]�!��KkdZ.!��(ȴ\B.�U�i��\Z� �r	��vA��ri�L�%��Z��r��Қ���&�-�
~z8㹅_�������O��������M,6�Opf/�m���f���6�Oofo�}���fv��7�Onf�ر�|n3����κf�·]�]u�>=�7���.^uіą�E]�%sAs��lK���u[rtW]�%yAy���������������_�_̲txI`P`��tx� h��tx� hQ�/�����%��A��tx� hWY:�d4�~(��qJ'��A�C�d4�Y�.d4�U�.d��`{եl4آ.]l��M��'^V�?�����������.�m6����b���Ú�!�o6���N��f�Q��;6�Ojb�;7;�!Įͮ�f �}Ӿ�A�,$.$.�A��u� uAu��A���:N��*'{A{qJ'}A}1��5���Y��I`P`��tMA�xեk2Dԥk2�=ԥk2D�K�d4��P:�J'��A܇�� h�.�%��A̺t�6�x�5����O����LQ]���+.�Ml�l��2{��6����v�}�����-��l��2;Ď��+.�S���<�l�]�]u�����_q�������e.hή�K]P�]q���;��2,yAyv�eX����˰����a���+.�hW\�o��a��a�����2�+.�2�+.�2�+.�2�+.�2�+.�2�+.�2ĪK7d��`{ե2�h�E]��^�i/������?���l�����Kl�l>���b���Ú�[l�l>��b��棚�)vl6���.�s����|�]�]u�f��7��������6e.h��2,uAu6�a�����K^P�dX���l& ���g#���?�H���@Ȱ�m �2�q�� t�P�n� hІ2,��A�Ȱ�m �2�I�� h�2,��A��^2�1��`�A���6�yyv��������b����^b�f��� ���6{��bo�}���b;�ޛ���T�S��찿Q�.�s���.��g�I���}yv�ϰą�E]����9�ϰ���4��.����3,yAy6ϟa�ڳ��K_P�M�gX���l�?����@��ϰ�m�?�2���� t�P�2���� h��3,��A��ϰ�m�?�2���� hІ��d4h����F�6ޟal4آ./7o���������^b�Y_��Ŷ��:��[�Y_�;����:��)�ެ�É]b�f}�,;.7o��g�5c���M{���fl�ܼio�q?�u�.�����3,uAu��~��.��~�ϰ��������=�Y?���g��'��_П���a	
���3,��A�I?�2�_�3,���C]�.��A�=?�2���3,��A�5?�2��3,��A�-?������� h�~�ϰ6��3�^�þ�x�]/�a��3�Ŷ�ڏ����^���;����O���b���/��]b�f�A��^�þ�g6Įͮ�f�^�ÿ�gX�B⢮ڐ��9���a��������;���a�ʳ�����=���a����	���g��3,�A��?�2����AР}�ϰBgu���;~�e4�:-�M��1e4�:3�M���hKA���3ڒA� ����d��`��3ڒ�F���hl�L޴����:y��ZK.��ضY��%v��6k��N�}�֏K�{o��qi��%vlֺq��s����ņ��M;m�?���i���gX�B⢬�����9�ϰ���l��.��F�3,yAy6ٟa�ڳ���H }A}6ןa�����K`P�M�gXA�6ԟa��ӸB��Wj\!��AԑW� hu��2D�q��Qk\�A� �h�2D�qAA���5.�`��V�k\��F�������M�k��~��wY�i��W��.�7����jc�b�e�]A��%�o6��Ĳ�x�.���l���'5�;7;뚱�x�.���Evߴ��2,q!qQW��\МEReX��,�*�rtg�T���<K�J�%{A{K�a��\��_ПSeX�-�*�2�h�� hu��u� t�꼍�A� �č�A� �̍�A� �ԍ�� hu���e4�:y��2D��qu�N߸�6lu�Ƶ/��<�j��ڍ�O @��z���'�Z�vㅑ �	Pm
_���L��;�X�vㅡ �
P�	_���T��I�ք��xa,�����ۍ��O.@Y��ya0��P���H
�.�-�!�6��iII���L�bȢM�gZCmt?�CCmv?�i����ɐI��ϴT�T��~��ri����K�%�|�k�%�y�:�!��K�אK�%ꔎk�%�uN�5�r�:��r	�D��qM��\�N븦\B.Q�u\S.�\�:��r��Ձ���DZ�
tժ��2����&]3<7��gx	����ݗ��86��|��7�<���&x�u�v_&��T��k�;a^������H
�P<99���LKbH��fZCm�    UtIcH���fZCm�5�i����ɐI�|ʹT�T��k��ri����K�%ꠎ��K��X'u��\B.QGu��\B.Qgu��K�%갎r	�D���C.!���:z�%�u^G��\���!�M.[��w�&�%��V]��ڄ֤�� զk�]�О�;�Z�kZ�zT��}wmB�R�`�jQ��MhU�P�	�ݵ	�J}��5Ά6�e�w0@Y�ݵ	mK������Mh]�P�RIa�'�!��,ȴ$�$Z� Ӳ�h�D7ii�~A��1����ȐH�dZ&C&�e�i����A��riM�L�%�uPGor�t뤎��r�:��7��\����\B.Q�u�K.!���:�%��K�q��K�%꼎~�%�u`G���e�;�%�M.[��?M��`����`���30�� �l��t���;�Z �T0������Й
��`�j}��9S� �Pm�O;g*`��������L�w0@Y�O3g*`��ʚ}z9S� �PM�B��P5���!�K]P��&����;�Ͱ��ِl�e/hφd3,}A}6$�a���!�K`P��fXA�6$�a���Bg�N���Q�r�!��AԹ}� hu0G2D��ч�QGs�!��A��}� hu8G2�h���}�`��V�s���7�Gaiö�%���5��%�m6��̆�k���fb�f�Y�l{o6��^b�f�I�l;7;��[���:�l��7�WV�%.$.U���9�M𒺠:�Ͱ��ِl�%/(φd3,{A{6$�a��!��_П�fX�mH6�2�!�� hu(G_2��:��~� hu,���A� �\��%��A���KA���9��QGs�/���_�`��~|og��ޯ!����Sl۬o�]b�����x�����!�ެ�숅رY������κfq�]�]u͢��W\�+.����\М]q����h���]�]\u� yAy���A����K��Q����.$0(0V]:� h��t�A� �P�2��:���Q�rܐA� �\��� hu0��d4�:��n2D�q7��減�Q�s�M�:��n2�h���w�/޴��h�nS,6k��$v�m��Ws�^/��f�՜ĆؾY{5'�{o�^�Il;6k��$�;7;�]]���kv�d�M{�d@�%.$.U���9�Ȱ���X@�����T@�%/(φ2,{A{6�a�곑��_ПMdX�m  �2�y�� hu(��e:{u*��e4�:��e4�:��e4�:��e4�:��e4�:��e4�:��e4�:��e��`��9n6^:/���:����N�جG�]b�f=A�,�.��g�� �!�o��s�B�Y���Ď�zz��K���kƆK���V]3�[:/��{ ����8TM��l �RTg{ 	�rtg{ ���<�Ȱ���@��/��� 2,A��a	
�=�� h�� 2,��Aԡ��A��թ��A� �X�{� hu.ǽd4�:��^2D��q/��渗�Qgs�KA���9�%��[�q/l4��p�����7����u{�f���M{ۏ�b�.7o��Ƿ�Ć�k��\'b�f}�Nl{o�W��^b�f}�Nl;7;˚6\n޴�ף�b�}����R����8TM�澞�&RT��6�`���z�Z���}�N-X������,}A}_�S������K`P��Ղe4��D�`��!��٫S9d4�:�c@A��s9d4�:�c@A���9d4�:�c@A���9d4�:�c@�:�c��2xy����������9<�_,�.������Ć�k��!b�f=�Cl{o�c9�^b�f=�Cl;7;뚱�2xy��O� �/��ٟ`���C�d.h�3�_RT��	���;��O���yf�e/h�3�,}A}�ٟ`�����K`P�g�'XA��ٟ`���Bg�N�]A��c9F�A� �\��e4�:�ct�N�]A���9F�A� �l��e4�:�ctl4��p��e��`��9/�7���߲�L޴���3b�f�#�X��6k��6�}�֏K�%�ެ���Ŏ�Z7.��ع�y���6�5�d�M;}�?�uՆ���p��.��f�3,wAw6ڟa�ʳ���^О�gX���l�?���gc����@��ϰ�m�?�2D�1�Bg�N�SA��c9ƔA� �\�1e4�:�cL�N�SA���9ƔA� �l�1e4�:�cLl4��p�1e��`��9/�7������y��f�q�,Ķ��Ӛ�&��l>������泚�.��l>���Ŏ�據�!vnvj6ŮͮC��}�.��o�K\H\�U�/�����K]P��]eX��,�*Ò�gaW���=�ʰ��Y�U��/��®2,�A�v�aZ�U�CA��C9f� t��T�2D�1CA��s9f� hu0��N�!��A��3d4�:�c��Q�s̐�F��瘻��`��	�V]�n�0`~��M׹/��`�jUx�����`�bSx����'�Z����`��	����n�0`~��5�/��`��tS�"��[�9����D7)��0��599���LKbH��gZCmr?���h����ǐG��ϴD�D��~�e2dҦ�3-�!�6��i��\��~�/��\�ꘗ\"��:�c^r	�D�1/��\��ꘗ\B.Q�u�K.!���:�%��K�q�K�%꼎y�%�u`Ǽ��e�;f��&��옻/ii*l�U��s�e"mM�M�f�	n����%�"�Op���N8�߂o���fx�����<	�C��Exեۍ�H�S�����H
�.�-�!�6�iII���L�bȢM�fZCm�5���hs���ȐH|ʹL�L��k��2��F_=�ri����K�%ꠎ9��<�Is�%�uT�r	�D��1�\B.Q�u�!��K�is�%�u\�r	�D��1�\B.Qv�)�M.[�1w�&�%��V]��ڄ֤�� զ��]�О�;�Z��kZ�zT��swmB�R�`�jQx�MhU�P�	�ݵ	�J���5ṻ6�e�w0@]�%x^u�v�&�.�	(k��0�¨���0�К��ĐD�dZC�]�iii�~A��1����ȐH�dZ&C&�e�i��������Kȥ52-��K�A�%�H�N�X/��\���X/��\���X/��\��X/��\�N�X/��\���X/��\���X/��\��X!�M.[رB.�\�:�c}�R0�zT{��s���;�Z�]����>� ���å`�������.�w0@�>�>Gp)`������9�K� �P-���[
X�`��f�÷��� e�>Go)`�������j���9�Ͱ��ِl��.�Άd3,yAy6$�a�ڳ!�K_P��fX���lH6�M�mH6�2�!�� hu(�j2��:�c5���XMA��s9V�A� �`��d4�:�c5���XMA���9�%��A����F���X�6lu8Ǻ�A��(,mخ������.�m6����b���Ú�!�o6���N��f�Q��;6�Ojb�K���k�C���k�Avߴ_	X�������e.hΆd3,uAu6$�a���!�K^P��fX���lH6���gC�	��/�φd3,�A�6$�aڐl�e4�:�c�2��:�c�2D˱n���X��Qs�[A���9�-��A��k� hu6��`��~�7�׀Xl��v�6�m���#�{m֗v�v�}���#�{o�Wv��c���#v������-�k����|��W\�+.�uզ���M���V�m�]�]\u���E�+7e/h/�C�/�/ơt���P:	
�U�n� h��tKA��C9֒A��թk� hu,�Z2D�˱��Qs�%��A��k� hu4�Z2D�ͱ��Q�s��%��
[����r�����%^�l/��*�7�ذ=���Kp۰=�    ��.�ڰ=���[p߰=���!�ް=���)xl؞���<7<�����u(]�}�^>%`��ơx!�A�6%`�$%ڔ�Ѳ�hSFKcP�M	-�A�6%`�DEڔ��24iS��TUڔ��r	��)��t�:���:�uZ�C�%�u^�C�%�ub�C�%�uf�C�%�uj�C�%�un�C�%�urG��\�.Qgw<�\6�lux�Co��Wk���~�&���_�ۆ=d'�]�a�I�-�o�Cv<����O�c����%xnxJ��L���֡t��t^��7���8�àC�0Z�mi�hYZ����1�����ǠG�0Z"�"mq�h���́Lw������ti�F�%�u��C�%t�,���K�%�4���K�%�<���K�%�D���K�%�L���K�%�T���K�%�\�x�r	�D����r����-��.[������͋��z4{��>�%���w�mþ���[�a��K��7��y	����~^���a�����͋��z;;�!xmxJ���͋��~=;�RR��9:�z?;ђ����v�e1h���DKcP��ډ�Ǡǯ7�-�A�_�h��24���v��2����D�%����D�%�u��C�%t먏��K�%갏��K�%긏��K�%�����K�%�ȏ��K�%�Џx-�]���xh�]��xh�lt��䏇�.���S�����`lؓ?��{�G�o�׆=�#�Cp߰'$x
�7��	^�ǆ=��p��3x� �!xmxե�t����4@��0�0���K��q�LKbP���iYZ��2-�A��>@��1��ȴDE�����'2-�A��F@��t�dZ.A��c@Z.��X�<�\�.QG�<�\�.Q��<�\�.Qǁ<�\�.Q�<�\�.QG�<�K�%�P���K�%�X����F���yh�lt��`���.'/��S?���]06l-�߂ۆ���!�ڰ5 3<�[�/�K�ak�%�m�ɋxڒ��!xnxJǦ��E<m���Fx_�ӗ���8��aС--�A��d`�,-ڒ����hKF�cУ-d��ȠH[20Z&�&m��h���%��tiKF�%�uJ�C�%t뜐��K�%ꤐ��K�%꬐��K�%괐��K�%꼐���]�Nyh�]��yh�]�Nyh�lt��ؐ���F���y��r�"^ĥ��c��<��#l�|m8�`����|�3̾��E�,���<6����<7<�cSg�"^�e�Ex_������8�àC��2Z�-��hYZ�T.��1��b�2=�1��r���ȠH�2Z&�&-��h���h.��ti�\F�%�u��C�%t����K�%� ���K�%�(���K�%�0����t�:N��t�:P��t�:R��t�:T���e�SE��KF�O�A���зh��M@���F:7���/ҹ	h��I�&`�ws���kP�9?t��s�h���硂���h���6�+��;�6X;۠,��H2�P�%�!��|`�t�t������i�KhH�� $/�%å4����ӐS[D0\RCRm�pY���2��
YE;�ಊtF����U�*���U�*���U�*���竿�BVQ�<��BVQG�<��BVQ��<��BVQǐ<��6YmuɃ�j��V�<������&x����C4H�m��H�sm�}���:ӻ�i+,l���}�·�h���6����硂��i;,l���N��t�L��If�j(�!�6�k�t�t�d����i��ojӽ��hȨ��.�!�6�k����ڌ���jS���*d��|�U�*�T��U�3Z�<��BVQ'�<��BVQg�.Y���N'ypY����'ypY���N(ypY����(ypY���N)ypYm��ꘒ�V���C�6|z���}0z�n�s���%�"���ޝ�В�'�ؑ~�}���!z��-���Iz*�;C�e�w.B]��
��}��vɌ$3N5�͐M�C.�!�ֈ0\>C>���[BCB�a����Z/�p))�f��rrj��%5$����*d����*dufɃ�*��SK\V!��sK\V!���KCV!���K\V!���K\V!���K\V!��L\V!��3L\V���:���e��j�SL��O�����<~��x
Ɔ-�?�Kp۰E�'x�_�����a���0����7�c����K���<�nv�k��P�y���N���8O�m2�hIJ���L/YZ��`��1��&���ǠG�6Z"�"m2�h����`��2��&���KХM-��K��%-��y�LZ.A��#L���t�:���t�:���t�:���t�:���t�:���t�:����e��LZ.]�:�䡷K�"��0�%?���3��x	n�G��|m8�`�!�o8`���{���|	����.xnxJ���u*� �/��0��0�0NœàC��4$1(�&���ŠE�6Z�m2�hyz��`�%2(�&���ɠI�6Z*�*m2�h�]�d��r	�D�n��r	��:�$Z�K�%ꄓ��K�%ꌓ��K�%ꔓ��K�%꜓��K�%ꤓ��K�%ꬓ��K�%괓��./��s�+nm
Ɔso��%�m8�2|�_Ν�Cp�pn,���s_��&xl8����C�.xmxJw݄�eټ�`��Ʃxrt8UO����e1h1�C��45F?��c�c܇
v���q�`�ɠɘ�
v���u�`�K�%^�
�%�q��\B��
�%��P�[.A����t�~��-��K܇
�r	��8T�K�%桂�\�.����e{�*(��.[�*�]^��/�L[��^��a-L�x	n�����k�6X�a����7���m�0×�a�*�p<7<����u*� �/���)�LKaHa��'�A��Y��$%�kd��ŠE�,�����eZ��A�LKdP��H�i���'�2-�A��&Y��t鏒eZ.A��*Y��:�8Tp�%���%˴\�.�a�L�%��_&˴\�.�i�L�%���&˴\�.�q�L�%��_'˴\6����2�]v^���W����Z�W�ይ�Ϋ���%8_���Cp߰�%�	�7�d	��{Y����Y��bS��j�_d	���ڿC�-�!�q*�~Ő�IJ��!K�,-~�%Z����-�A�_Qd��Ƞȯ,�D�d��WY��2��+�,�r	���#K�\�.���-��yġ��K��W"Y��t�I�h�]~e�%Z.A�_�d��K��W*Y��t�K�h�]~�%Z.]~�%Z.]~�%z��y�_���B��۹y�_��	�mþX�`�6��	n���}�8���{þX��.xl��|�����k��T�Ix_���bq��0�0Ż�0��k�8ђ���X�hYZ�Z,N�45~-'Z���-�A�_�ŉ�ɠɯ��DKeP��bq��t��X�h�]~-��r	�G*��t��X�h�]~-'Z.A�_�ŉ�K���bq��t��X�h�]~-'Z.A�_�ŉ��F�_�ŉ�.���s�+����Z�Od8���A�!�ڰMd�	���_����A���a�>��-xnx�J7��S�&�}����LKaHa�7�0�Ч2-�A�>}�iYZ��LKcP�OdZ�}� �����ɠI�>ȴTU��A��t����KХO$z�%tq���KХOdZ.A�>}�i�]��A��t����KХOdZ.A�>}�i�]��A��ѥOdZ.]��A��ܙ����a��bog�"�6}`0�[0�M�ak f��7l��w�������[�ذu�2<��S���u*�"�/�����/))��x�%�A�6}`�$%��Ѳ�h�FKcP�M-�A�6}`�DE���24i�FKeP�M-��K�>�t�%�Ҧ��K�<�P��KХM-��K�>0Z.A�6}`�\�.m��h�]���r	�����ti�F�e�K�%�4�ѥ�^f�v�x/�+N[ȝ��ŋx�Z��Mp�p>�_���lp�7�    ����{���<���k�<7<O�[�׆סtl�,^��׉���8��aС--�A��Kl�,-�*����h��F�cУ--�A��Gl�LM���RTi[ę��tiK�F�%��v���K�<�P�K.A��Al�\�.m��h�]����r	���a��ti��F�%�Җ���KХ�g��e�K[6���OfÛ~g6���}7w>���M@���F:7��D_�s��.���M@�o�7��4z��s��)z���
.ы�:Tpww>���:���H2�P�[6C6-��p�鴐2��3��R��АP�)3\FCF-��p))��2��4�Ԓ��ԐT�*���UȪe�.��U+3\V��(��
Y��2�e�jye��*d���UȪ%�.��U�,3\V!��Yf��BV-�,�SV��Zj���d�b��V�JZ�toZ4��i'-l���Kt#�ϵ�]�E:k�oѝt>�F�7�|�����|��^�'�y����DZM��5:H��5\2#ɌC�l�lڠ����i����gȧ��.�!�6�k����ڰ��RRjӾ��iȩ��&�~IjH���.��U�5\V!�6�k��"�Qԅ�_�
Y��_�e�jC���*dզ~�UȪ��.��U��5\V!�6���UȪM�.�MVm���mU+h�̆rs�ޝ���;�����wg(����l(���
m��3���{w�Bkh�̆r��ޝ���;��ܾ�wg(����l�����
m��3�
��Ph��PWpw�B�h�̆����H2�PC�fȦ�!�ΐNkD.�!�։0\BCB�a����Z/�p))�f��rrj݈�7II�v��
Y�~��
Y���ᲊtFq(d�UȪ�$�UȪ�$�UȪ5%�UȪu%�UȪ�%�UȪ�%2~�*d���j�U�L.�MV-���PfC�x�Y�+�?}�PfC�x���]p۰=Y��[�a{�$�Cp߰=X��)�ް�W��%xl؞+I�c�l�338��C�>��PfC�|E�-�!�q(^�àC�6Z�m2�hYZ��`��1��&���ǠG�6Z"�"m28ӷLM�d��RTi��F�%��&���KХM-��yġ��\�.m2�h�]�d��r	���`��ti��F�%��&�3=�ti��F�%��&����F�6l�\6���`��K�"�M���{t��p>�߂ۆ�6x�6�O��Sp�p>�/�������|	����<7<���6�������FKaHa�7�0��&���ĠD�6Z�m2�hij��`��1��&�3�$2(�&���ɠI�6Z*�*m2�h�]�d��r	���`��:�8Tp�%��&���KХM-��K�6Z.A�6���KХM-��K�6z�l��ڏo7qSx��`lؗ�|	n�ݦw�׆}�)���a�lJ�|o��<��^S����y(]���C�"����g��ơx!�A��C�B�����ס~!�A��O�ǠǸO�Ƞ��
�d�d�C!�A���\�.�:Tr	��!e@.��x�E�K�%�(r	��!e@.A�8$��%��h��]␍2 ��K�QF�K�%�(��e��vHGM.]�C:�h��ŋ��״W<�%��2��ۋk�_��2<�ۋk���ۋk^�ǆ�ŵ_/�s��P�+��C�.�����Z��0�0Ż�0��_\˴$%��k��ŠEq-����/�eZ��ŵLKdP�����.�A���Z��2��_\˴\�.�ŵL�%��T���:��X���t�C.��r	��!et�]␌2�\�.q�F].A�8d��[.A�8���[.A�8���[.]�C:�`s��j�?�l�����c�l��.�m�s�|�6�F	���=�(�S�a5J�<6�F����Z��<��M�Ϋ���C����Z�/F-�!�q(ސàC[�0Z�m1�hYZ����1��#��ǠG[�0Z"�"m1"�S&�&m1�h������ti�F�%��T�1�:��X�1�t�C.ʘr	��!eL�]␌2�\�.q�FS.A�8d��%��K�QƒK�%�(c�e��vHGK.]�C:�`s��E|��j"��{;7/���7|n����׆}/1�Sp߰�%&x	�7�[��'�:7/��Ǘ��g]�ɦ�͋��Yu�&�:7/��G��¨�7_rth	FKbP��#-�A�6�`�45�4����h�����Y�e2h�F��ʠJ�D0Z.A�6�`�\�.qHE�!��y<Ģ̐K�%�(3�t�C0��]␌2C.A�8D�L�%��l�	�]��2!��K�Q&��e;��L6w�����(����^��ǳQ|n�h��׆=%�Sp߰�$x	�7�(����ZǏǢ$8��C����Z��:��=���ux��h))�C��k���T>YZ��T?ij�~*�<=�}��%�A�1�d2h2桂�TU�:T�K�%^�
^r	��!e^r	��C,ʼ�t�C.ʼ�t�C0ʼ�t�C2ʼ�t�C4��r	��!ev�]��2�\�.qHG�].]�C:��r���Q&�;��Ň�)<�ۙ����=<�[0�S�ak fx	���_��י����<�ǆ���a���ұ�3yO[x0�"�/���FKaHa�w�aСm;-�A���`�,-ڮ����h����h�FKdP�-:-�A���`�TUښ��r	��-��t�C*�r	��C,�r	��!e�]��2�\�.qHF�S.A�8D��)��K�Q�K�%�(s�%��t�9��e;���)��.�!e���x/�%K{œ��ŋxY.��Sp�p>�/�׆�	�0;��\2�C��|~���||n���tl�,^��r���E�<��h))�S��0��rɌ�ĠD�%3Z�-�,��%�A��Kf�<=Z.��i�dF�dФ�-�A��Kf�\�.-��h�]␊�^r	��C,�z�%��\���K�%�(+�t�C2�
�]���B.A�8d���K�%�(+�t�C:�
�lt��(k7w����rux��S��Pn���a
C|R�쵛;La�O
C���vs�)�Ia(���n�0�!>)������0���j�z��S��PWp7w�������������P��If�j(�!���`�t�t�&����i�oj���hȨ-3.�!���`�����:���j���*d��U�*I)��*�=D��&��U�RV�U�*a)�U�*i)�U�*q)�U�*y)�U�*�)�U�*�)��&�퐘�.Ym���)k�~����rux��S��P�`���a
C|R��{?La��)��ڽ�0�'��ܿ^������0���k�~����r�z��S��PWp�~�������������p(�dF���fȦ�.�!�6��[>C>m��p		�Y_�e4dԆ}�ҐR��5\NCNm��pII�y_�e�j���*d���u�*�=D��[V!�8d��!��U�R֐U�*i)k�*d���5d��C^��
Y�!0eY��␘���6Ym�Ĕ�;C���w
C�:�vg(�U�Ia�6�������)��ڝ��^�;��\�^�3Z,{�0���kw�B�e��r�z��Ph���Pn_��
햽S�
��Ph���PVpw�B�e��C	%3��8�P6C6�a�t�tZ#"�K>C>�a����Z+�p�^��RRj���4�Ժ�KjH��#�UȪ�#�U�*I)k�*�=D��%��U�Y)x�d��:,����euZ��ǲ
YE�����BVQ�<,��Uԁ)��*dub��ǲ�d�Չ)��j��V'�<��/�0���P�?�c���A�?�w
C����!�ڰ=z�a��72���'2|	�2���C�>�	�w
át���*~R���8O�m28ӐĠD�6Z�m2�hij��`��1��&���ȠH�6Z&�&m2�h����`��ti��F�%�u*�C�%t�X��\�.Q�<�\�.Q�<�\�.Q'�<�\�.QG�<�\    �.Qg�<�\�.Q��<�\�.Q��<�\6�lu:�C�e��V��<�v	^ĞZ��e���`l8�a�Cp�p>�C��|�n����6�|o8�_����||���S���u*�$�/⯰2��0�0��rth��FKbP�M-�A�6l�45�d����h��FKdP�M-�A�6l�TU�d��r	���`��t�:�[.��XǢ<�\�.Q�<�\�.Q�<�\�.Q'�<�\�.QG�<�\�.Qg�<�\�.Q��<�v�x���������a_nJ��6�M��K�a_mJp��ͦC�a_lJp<6�{M	���C�F�6��7�}�5�����8O���IbPb�C��,-�u�ߔƠ��Nyz��P�)�A�1�24�P�)�A���r	���TA�]�NEyh���c���r	�D���גK�%�`���K�%�d���K�%�h���K�%�l���K�%�p���K�%�t����F��NGyh�lt��t���./^ė6h����`l؞l���a{�)�!�ڰ=ؔa����2����2|	�ך2��Ϻt���S��}_>�`��Ʃxrth��IJ�a�e1h�f��ƠFe0Z�m��h���A�e2h����ʠJc0Z.A�6�`�\�.Q��<�\B籎EA@.A��sQZ.A���QZ.A���QZ.A���QZ.A���QZ.A���QZ.A���QZ.]�:塷�Ϋ����?��{��`�v:����F	�׆=�(��7�F	n��{�Q�/�cÞi��.xnxJǦN���֩t��Z�/F-�!�q*��bD�/IJ���e1h�#��ƠF[�0Z�m1�h�����e2h�#��ʠJ[�0Z.A��a�\�.Q��<�\B籎EAt�]��Eyh�]�Fyh�]�NFyh�]��Fyh�]��Fyh�]�Gyh�]�NGyh�lt��t����F��NGy����E|=ؾ����ܼ����ۆ}11�|m�����Zb�/���}+1�]�ذ/%&�<7<O��׆שt�����-�!�q(ސàï�-�A�_�'Z��lO�45~=؞hyz�z�=���`{�e2h����DKeP�׃퉖K��׃퉖K�%�TĔK�<ֱ(-��KԹ(-��K��(-��K��(-��K��(-��K��(-��K��(-��K��(-��.[��������:~�����^��_u�pn�h�C�aOFIp�7��(	���\�w�c����[���<�n^^��M��j_�:dZ
C
�.^rt�:dZ��U�L�bТ��iij�W2-�A���C�%2(�_uȴLM����ʠJ�!�r	��W2-��Kԩ(@�%t�X���K�%�\���K�%�`���K�%�d���K�%�h���K�%�l���K�%�p���K�%�t����F��NGyh�lt��t�͝ɋx���?pƆ��an�`���k�� ��%�o����[�/÷�a��ex����M�k��T�Ex_���2ݤ0�0�krth�FKbP�-;-�A���`�45ڪ����h�FKdP�-:-�A���`�TUښ��r	��-�L_r	�D����r	��:��t�:��t�:��t�:��t�:��t�:��t�:��t�:���e��Q��G.]�:塷�ŋxY.������|�n�ۆ�6�|m8�`����|�������!xl8_����y*��6��cSg�"^�Kf��ơx�Z.�ђ�h�dF�bТ�-�A��Kf�<=Z.��i�dF�dФ�-�A��K��!��K�%3Z.A��SQZ.��XǢ<�\�.Q�<�\�.Q�<�\�.Q'�<�\�.QG�<�\�.Qg�<�\�.Q��<�\�.Q��<�0%��.[���п]2���ju��!�s��&���M@�/���4���s��[�M:7����4z���穂K�"����0�w
C]�%��dơ�K6C6m��p��M��3��V�АP�e0\FCFm��p))�m��4����ԐT�gHx{�*d��U�*ꤔ�U�3ZG�<��BVQg�<��BVQ��<��BVQ��<��BVQǥ<��BVQ�<��BVQ�<��BVQ'�<�e��j�S\V���:1���մd6ݫ��n�A:l�/эt>�Fw��|���Ew��T=Dߤ�6z���6z���硂��i�,l��� �{:|��pɌ$35�l�lڠ����i����gȧ��.�!�6�k����ڰ��RRjӾ��iȩ��f�IjH���.��U�5\V!���R\V��h���
YE����
YE���
YE����
YE���
YE����
YE��v�*dubʃ�j��V'�<��
]���_d�&�s���Kt#��Fw���0��I���C�M:w ����܂0z���硂�3�|R�
��S�;��.a��H2�P�.�!�և0\:C:�a�|�|Z'�p		�V��22j�å4�Ԛ��iȩu#2~KjH��#�UȪ�#�U�*ꤔ�U�3ZG�<��BVQg�<��BVQ��<��BVQ��<��BVQǥ<��BVQ�<��BVQ��Y���NLypYm���Ĕ��&��NLy𷛦��Na(��ۧoԔ���)�Zq����R�;����n��QS
C{�0�k���4jJah��j+�}zFM)��P.e�O˨)���Sʝ���5�0�w
C]�Oè)���S��}�EM)��P�nJaHa�7�0��&���ĠD�6Z�m2�hij��`��1��&���ȠH����ɠI�6Z*�*m2�h�]�d��r	��!�-����!�-�]␋Җ\�.qFiK.A�8$��%��K�QڒK�%�(�K.A�8��\/�]␎r���e;��\/�lt��(�k�/b�dp�Y�^]06�ϰ����|����l��7���K��|~3/�c������t�k��P�h��E�6Z
C
�P��àC�6Z�m2�hYZ��`��1��&���ǠG��4$2(�&���ɠI�6Z*�*m2�h�]�d��r	��!�\B���rA.A�8�\�K�%�(�t�C2��]��r5�]␍r5�]��r�����k?�{��cþܔ�Kp۰�6%��6�M	���fS���{þؔ�)xl������C鮗��u(�������3Z
C
�P�K���]���P�K��:��Ơ���c�cܧ
JdPd�Se2h2桂]*�*c*��t�ס�].A�8��\].��x�E��\�.q�E��\�.qF��\�.qHF��\�.q�F��\�.q�F��\�.qG�n�]␎r�r���Q�[.]�C:�uo�/���^�u_��a{�)�]p۰�ؔ�[�a{�)�Cp߰�ה�)�ް=ה�%xl�^kJ�x	���ҍ�6�� �/������8o�aСM3-�A�6�`�,-�,����h�F�cУM2-�A�6Ȑ�)�A�6�`�TU���r	��)��t�C*�5�:��X�k�%��\�k�%��`�k�%��d�k�%��h�k�%��l�k�%��p�k�%��t�k�e��vHG����Z�O�^�_��a6Jp�6�F	�_�X��}Þj��)�ް�%x	�L#]�Ϋ��̺t�M�Ϋ����t�=�Ϋ��b��RRu��K�m1�hIJ���e1h�#��ƠF[�0Z�m1�h���ňL�LM�b��RTi�F�%��#��K�%�(=�:��X�r	��!��\�.qF�!��K�Qz�%��h�r	��!�C.A�8��t�%��t��lt��(r���Q:�;7/����v�w�vn^��׃�	���bb���kþ���)�o������D�l�ܼ������tl�ܼ�������~�=�RR��59:�z�=ђ���`{�e1h����DKcP�׃퉖Ǡǯ�E_��`{�e2h����DKeP�׃퉖K��׃퉖K�%�(��K�<bQ�%��KrQ�%��K�Q�%��K�Q�%��K�Q    z�K�%�(��%��p���t�C:J�r���Q:�;�W����k�.�l�߂ۆ=%�C�aOFI��7��(	^��{.�`�u���:d8��C����Z����Fx_���U�LKaHa�w�aС��iIJ�W2-�A���C��1��_uȴ<=����:dZ&�&�U�LKeP���i�]����K�%�(}�%t�(}�%��\�>�t�C0Jr	��!��]��ҧ\�.q�F�S.A�8���)��K�Q���F�퐎ҧ\6�l�t�����E<�����[0�Cp۰u 3<_�`���a��%�}�ɋx�΃�!xlغ���y(�:���/��"���`��ơxK�m��hIJ�e�e1h�v��ƠF[uH���ǠG�t0Z"�"m��h���=��2�����KХm9-��KRQ�\B���r��t�C.���K�%�(�K.A�8$��!��K�Q�K�%�(w�%��p�;�t�C:�r���Q��F�퐎r���x/�%K{�7{;��\2����|�^����a6v/�e�d��{����c������C���Y�����	�xy.��RR���aС�-�A��Kf�,-Z.Y��45Z.����h�dFKdP��-�A��Kf�TUZ.��r	��\2��t�C*���:��X���%��\���%��`���K�%�(�%��K�Q�K.A�8d�ܗ\�.qG�/�]␎r_r���Q���a
C��0����n�0��}R���{7w���>)����;Lah��r����0��)�����;Lah��r�����0�O
C�}}��S�'����n�0��}R�
��S�����]2#ɌSe3d��ΐN�d0\>C>m�!㷄���.��22j��KiH�m3.�!���`�����>��
Y���e��CR�}�*�=D�ܷ�BVq�J�oY����rY��␖rY����rY��␗rY����rY��␘rYm���)���&�퐘r��O�%���޴:|��O�-���^���F:��L��O�=��_�Ct'�O��}�·��&z��g��K�$=ܽ�H�faS�FߤyO���.��dƩ���i���KgH�M�f|�gȧ��.�!�6�k����ڰ��RRjӾ��iȩ��.�!�6�k��BVm��pY��␔r/YE:����{�*d����U�*a)�%��U�R�KV!�8ĥ���BVq�K/Y����2^�
Y�!1e�d��j;$���
-��S���;C���w
C�9<vg(�V�Na(7�������)��؝��b�;��ܿ�3�,{�0���cw�B�e��j�z��Ph���PWpw�B�e�����3�.��0J(��dƩ���i}å3���|�|Z'�p		�V��22j�å4�Ԛ��iȩu#�ԐTkG.��U�G.��U�Rd��Rd��CV�h�
Y�!,���u/9��J�ǵ�t����ݸ6fn)|T�ӭ�2Z���M��*�i)�IRE1.e6�B�(��&UH���٤
����2�T�T[11e6�6��bb��nuMa�S����wߨk
C���p�V<��F]S�������5��пSnײ�wӨk
C���p��=�{F]S�������2�����0\�d��Q���7��t���)�o
C�t����ܿS��a�0�œa��N��b�N[-Š���Z�AF;l���v2�jA!�d�ՒJ��`�E����V�����V��D1e>��~��X�9d	Z���2�,AK�Q�%h�b2��-Q�F�C��%��(s��D1eY��(���!�F�VLG�C������2Ǳ?�>�,�Y��'οa�Cq;q�	[����lqS��8��-�ǉ����G�<q��Z<��j��}�]-�b|>�?�ʬa�0��[2��`��D���VK1�h'��c��N[-Ǡ���Z�AH;l�$��v2�jQ)�d�ղ-�d�ղ-QLE�[����2�,AKsQ�%h�b0�ܲ-QLF�[��%��(s��D1enY��(���-K��t���e�ǲ�+�Ͻ��yo!���Q�N��,���yg�b(~N�7,n�ǉ��]�<q�V��Q�N��K�>C�>�n2>��{
V�0D���0h(V/�D�V,_H1��X�c�1�bC�A��
� ��1�I%c+�RƮVP��%>�
��DT+(K���b!K��XA��D/V�-�+Y���
B��%f���%h�U� d	ZbW+(�F���VP���-�<����/���j�8�-�q(n'���9��~b;X���9��+�qW<Nl�
s�(�'�S�9�׉W�tS�>�n1>����Z�E"�b�����Z��D��r-Š����k1�ŵ\�1��/��Z�AHq-גJ��k�e��_\˵,AKq-ײ-�ŵT?��~�(V�%h�/��Z������kY����Z�e	Z��k��%h�/��Z������kY����Z�e�h�/���X>��>��{ŋ{;?���\���vb�K�b(�'��d)n���\�w���>�,ŏ�yb�K��x�xUK7��j���i}~璥Z�!�(o�0h�3�,�B"��%K���?s�R-� ��\�T�1��3�,ՂB��%K�$��?s�R-� ��\�T����K�jY��?s�T/YB�G+�d	Z��%K�,A˟�d��%h�3�,ղ-撥Z����\�T����K�jY��?s�R-�F˟�d��e���\2�������ż����3�!?�S���~�8�Mq?�_,NqW���/��Q<N��S<����O��īZ��x�xWK�����X�zD"������?�S-� ����TK1��s�8�b2�\,N���?�S-� ����TK2(�s�8բR�\,N�,A˟�ŪC������T��=�X��%h�s�8ղ-.�Z������T����X�jY��?�S-K���bq�e	Z�\,N�,-.�����u�+�o��L~Z��>�1���7���v� �]�sb;}��G�8��>��P<Ol�r<��j��}�]-�f|>����A��C�Q,^�a��O�Z�AD?}�k)��A��d����c��O�Z�AH?}�kI%��A�E�����%h�R�e	Z��\��=�X�.K��O�Z����>ȵ,AK?}�kY��~� ײ-��A�e	Z��\������e���>H�#�FK?}��c��!^��{ś{;��e�,n�ۉm0�]q?�m ��Q�����r<���_���yb����R�N���ۊ��w�t��Y�/?}`�C�Q,ސa��NX-� ��>�Z�AE;}`���v��j9��ՂB���%���V�2Hi�r=e	Z���e	Z���e	�Q���%hi���%hi���%hi���%hi���%hi���%hi���%hi�r�d�hisɬ�e����f����o�W�n!o��l~��]+��+n'�?a�����l�P��8��-��ǉ����x�8�|-ފ׉W�t����o�Olq0>��׉�a�0���2�eb��D���VK1�hW��c��n[-Ǡ�]$�Z�AH�Gl�$��v�Xu�|D��[�V���K�V���;�V��=⺂��%hi7���%hi���%hi����%hiׇ��%hi����%hi��s�-��ղl����V�gə�;��vs���j�Λ�VwՍu���Q�Y�M@���u��z���&��K�d�7�ު�U�����̆���p_���Ù����%�0#aF���fH�f�Y.��)�\�!O�Rf�@C�6��r��DmN��"�ڠ2�e2�Ie9oB�ڨ2˥
�ڬ2˥
�ڰ2˥��E��M����+�\����+�\���,�\���M,�\����,�\����,�y�*�jC�,�j��M-�\�M�6��򣚮�����E���:���~T7��wm�P�Y矵�S��:���^�����z����o:�g�'�ʹ�C�V���z+x6"�M?�k�0#aF���4C�v��rq�8�����y�Q_�����K4$j�}-i��N��|�4dj�}-j���Z.    UH��Z.UH�N�Z.U��(��R�T�̯�R�T�Я�R�T�ԯ�R�T�د�R�T��oΧT!U;�k�T!U;�k�T�T���GUW��f6�n�uW�y���Guc����;��`�T���V/Ճuށ�z����D���P�&��̆�
����U��̆�
����]��̆�.aFb�4C��a�8C��a�<C��a�@C��a�DC��a�HC����-Ӑ��FX.��mGX.UH��#,�*�j�K�7�b!�T!Uے�\����IX.UH�6%,�*�j��KR�m���G����KX.UH�6&,�j���LX.�&Ujf��b?�����f�W�Əb���,��P�NlO��x*�'�Kr�?'�Kr���{%)�~�lx��43�C�:�*���!|4�����,n�����ef�C�Q,^�0hh'��b�N[-Š���Z�AF;l���v28�d�N[-ɠ���Z�AJ;l�,AK;l�,AK;l�,��#��,AK;l�,AK;l�,AK;l�,AK;��&K��N[-K��N[-K��N[-�FK;l�,-�d�����N����8q�[<�矰�Kq?q�[�?'�?����q����8�矯�P�N����M�>�.��w��C?l�C�Q,^�a��N[-� ���Z�AE;l���v28׏��v2�jA!�d�ՒJ��`�E����V�����V�����V��=�ZAY��v2�jY��v2�jY��v28�C�����Z�����Z������X6~��?��tn
�qW���?�ۉ�nS���~b�ڔ��9��lJ�R<N��R����&��x�xK7C�>�.�n����5��Y-�a�7e4�7�D�V,ߔbP1z�~b2�S-���1�d2f��K�A�X�
.Q)c+�d	Z�S���%h��T���%�{��EykY����EykY���FykY���OFykY����FykY����Fi�e	Z�>�e	Z�>�e�h���Q�Z����>孏e燸��k�W�Əb��^\��P�Nl/��x*�'��r�?'��r��ۋk���(�'��r�׉�}����}�}_:|��!�?/��Z�!¸/>2��k�b�_\˵����Z��d��r-Ǡ�����d�_\˵$����Z�E���r-K��_\˵,AKܧ���,���},�[���}.�[���}0�[���}2�[���}4Jd	Z�>�e	Z�>�e	Z�>�e�h���Q��X>��>�|�����/~��>�(�Cq;��5J�T�O�c�R�?'��F)ފǉ}��bn�<��>�|�Q�C�:�*���:?�Ͽ],�t~Z�a�C�Q,^�a��.FX-� �]��Z�AE�a���v1�j9�bD�� ��v1�jI%�b�բR���e	Z���e	Z�>�e	��cQ�Z��%�sQ�Z��%�Q�Z��%�Q�Z��%�QY����FykY���GykY���OGykY6Z��t���e�e�OGy�c9�!��j�W��C1N�7S<����/���~/1�[�sb�����:����o%�8����C�:�*���:���oK�M����#	V�0D���@��B"�y��T��V�1�h�r=�t��V2ig��dPҎ"X-� ��D�Z���D�Z��%�SQ�Z����>�e	Z�>�e	Z�>�e	Z�>�a���}4�[���}6�[���}8�[���}:�[˲Ѳݧ��������>��~�'��()��ۉ}4J���~b�����9�FQ�}��O���sQR��},J��x�xK�M��O��������u����"F�x[�A�@�zB"F��O�A�����1��}�G�A��lA!c�W�}$��u_��e�2�}�G��%>�lY���OEykYB���X���%h��\���%h��`���%h��d��B��%�Q�Z��%�Q�Z��%��Q�Z��%��Q�Z����>�e�h���Q��X.~��]|�M�7��qb���R�Nl;�9ފ��m0���Y�/��`q('���C�<����)^'^��qSg�C�����!^~��j��Z<����B"�e��T���nb2�U��t��V2i��dP��9X-� �]s�Z����r�Z��%�SQ�Z����>�e	Z�>�e	Z�>�]Y���OFykY����FykY����FykY���GykY���OGykY6Z��t���e�e�OGy�c��!�6�,�+n����o�Kf�V�N��9����x�\2�C�s����ǉ����x�8�|-�׉W�t����o�Kf�`|>���Y-�aT�'à��%�Z�AD�K��!Š��%�Z�AF�Kf���6��jA!m.�ՒJ�\2�E���dV����dV���}*�[��=�Ǣ��,AK�碼�xY���FykY���OFykY����FykY����FykY���GykY���OGykY6Z��t���ϒS������v6w8���o
���p;�;���|�0\o`����)�w
��v;�;���|�0\�_����)�w
���u;�;���|�0\o_����)�w
�}���0<�Ma��������)�
3fTk(͐�]d�\�!N�ɐ�-ϐ�]e�\�!P��`�DC�v��r��H�6��2��u˅B���KR��KRE1)�m�"�F�Q)mKRE1+��
����?R�TQLK��B�(ƥ�T!U�R�G��*��)�#UH�Ĕ��j�j+&��T�T[11����H���N�������D�ev�7�g�'�5���V���:�����u�U[�T��GmuW=Y�ߴՏ��z+x�~"]6;�k�d��t�1_˅	3�5�fH����q�I_��򴣾�4jg}-�hH��Z.�����\�!S;�k�PC�v��r�B�v��r�B�(&�tH�7Z�J�M��*�Y)�IRE1,�7�B�(���&UHŸ�ޤ
����қT!USz�*��bbJoRmRm�Ĕ~v�B����0\���3�U�7��zs����е��)������}�0�.`��3�X�7��z������Ͳ�)���������Ma�޾�gg(t��o
�}��P�r���b'k~x��3fTk(͐��C��g��6",�g��v",hԶ",�hH��",i��6#,�i��v#,jն#,�*�j��KRE1)�?RE���R��*��bVJR�TQK�C��*�i)}HRE1.��B�(��!UH���>�
����҇T�T[11��6��bbJ�nMa�)�{���o44�a�Ma�^+��m��)�o
��^v��MaS�ײ�w�hh
����p��ݿ{FCS�������2��0��0\�d�������p_��x�xWK�?��;��X;��X�%à���Z�AD;l���v2�j1�d��r:��`�����VK2(i'��e��N[-K��N[-K��T��e	���(}��D1�oY��(��-K��d��e	Z��ҷ,AK�Q��%h�b8J߲-QLG�[������ҷ,-[1��K�C�S�ҝ���q����ۉ�O�⦸�8��-��ŏ�q����x(�'�?_���u�U-�R�O���یχ�gXY�C�!�(/d4���V1�h'���bP�N[-� ���Z�AG;l� ��v2�jI%�d�բR��`�e	Z���\C��%��(d	���(d	Z����@��%��(d	Z����@��%��(d	Z����@��%��(�e��������[1N엛���vb�۔�P�O�W�R�ω�fS���qb�ؔ�x���5��Q�N���kC�>�n2>���?�E"�j�d4��_����ъ��R*F/֯�1�O��]�A��
vA!c+�%��U�`e�2v���-�VP��%��(O�%�{,Ƣ<�,AKsQ�G��%��(�#K��d��%h�b4����D1�yd	Z���<�-QLGyY6Z�b:��ȲѲ�Q��Xv~��lH����Q�ۓM9����bS�����l�qS����k�qW<Nl�5��Q<Ol�5�x(^'^��M��ĻZ���|���g�Z�!�(o�0hh��b�3X-    Š��e�Z�AF;�`���v��jA!� �ՒJ�9�E��cV���SV��D1�Y��~��X�g��D1�Y�-QFy�,AK�Q�%K��h�g��D1�Y�-QGy�,AK�Q�%�F�VLGy�������������<��>�|�Q�Cq;��5J1��X�7�ω}�Q���qbj��G�<��4J�P�N�������w�t����>~1�j��x�#à�]��Z�AD�a���v1�j1�b��r:������VK2(i#�e��.FX-K��.FX-K��T���~��X��-Q�E!K��`��-QLF!K��h��-Q�F!K��p��-QLG!�F�VLG!�F�VLG������y�xpog�C<~lO1����7���~/1�]�sb����G�8��JL�P<O�S<��j��}�]-�f|>����v�M�!�(��0h��`{��D�y�=�R*�<؞j1lO���?��Z�Aȟ�S-ɠ�σ��e�����T���y�]u�%h�b*�貄~��X��e	Z���2�,AK�QF�%h�b2��-Q�F]��%��(���D1etY��(���.�F�VLG�ܙ�������8��>%�P�N�QR���d�w�ω}0J����>%�C�<��EI�T�N���[���w�t����ΟWR=D"�b�����C��D�Wr-Š���k1�U�\�1��:�Z�AH�!גJ���e��_uȵ,AK�!�S��%��(c��=cQƔ%h�b.ʘ�-QFS��%��(c��D1eLY��(f��)K��p�1e	Z���2�,-[1e,Y6Z�b:�����x������P��`���vb��qW�Ol�9~?'�����Ķ���x��v�r���j��}�],7u?���;X-�a��e4��V1�h���bP��:X-� �]u�Z�AG��`� ��v��jI%힃բR�5�TϏ,AK��`�,AKSQ�G����2?�-Q�E�Y��(�̏,AK�Q�G��%��(�#K��l���%h�b8����D1e�,-[1e�,-[1ersg�C�m.Y�W<����!�6��⮸�8��-~��_��C�s���x*'ο_���y���x+^'^��qSg�C�m.����|���%�Z�!�(2�\2��D��dVK1�hsɬc���Y-Ǡ��%�Z�AH�Kf�$��6�,�M�AJ�Kf�,AK�Kf�,AKSQf�%�{,Ƣ�&K��\��d	Z��2�,AK�Qf�%h�b4�l�-Q�F�M��%��(���D1evY6Z�b:�<�;��0���p�:<���0������y6w8�a|�0\o`ϳ��)�;��z{��Na�)����l�p
��Na�^��gs�S�w
����<�;��0���p]����)�;�ᾂgw�S�S�K�3fk�H3�i,g��n2X.ϐ�]e�\�!P��`�DC�v��r��H�6��2��u����P�>��R�T�B��R�TQLJ�C�H��bT�R�TQ�J�C��*�a)sHRE1-e�B�(ƥ�!UHż�9�
���2�T!US�j�j+&��)�&�VLL�g�'�%��ӽ���<{?�n����Q�X�ߵ�Cug��VO�����z�����z�ο�\���Hw���Z�7�]�����t�,������.i�4�����q�I_��򴣾�4jg}-�hH��Z.�������i�Ԏ�Z.�����\�����\��*�I)sK�7Z�J�[��*�Y)sKRE1,en�B�(���-UHŸ���
�����>R�TQLY�B�(&���T�T[11e���Х��)׫����n��Ma��^gg(t��;��v{���н��)�����.��Ma�޿^gg(t��o
����:;C��eS�����
�-���p_��3�\�7�ᾂgg(t��)�%aFbC�!Mۇ�\�!Nۈ�\�!Oۉ�\�!Pۊ�\�!Qۋ�\�!Rی�9d2��˅B��˥
��~��R�TQLJY�*�o��� UHŬ��B�(��,HRE1-eA��*�q)R�TQ�KYM��*��)�IRE11e5�6��bb�jRmRm�Ĕ��8���0��0\�������7��z�x}����0̿)�{��k45�a�Ma�^�^�M��)�o
��V���MMa�S����w�hj
��Na���^���)�o
�}�FSS�����}����0�����u��X�.à���Z�AD;l���v2�j1�d��r:���\?�B��`�%����V�2Hi'���%hi'���%h�b*�zd	���(�%h�b.�zd	Z���Y��(&��G��%��(k��D1eY��(���!K��t�5d�hي�(kȲѲ�Q�8���ا��;�k�8q�[<�矰�Kq?q�[�?'�?�Ϗ�q����8�矯�P�N����M�>�.�nv��C�3��j��X�)à���Z�AD;l���v2�j1�dp����v2�jA!�d�ՒJ��`�E����V�����V��D1e-YB��b,�Z�-Q�EYK��%��(k��D1emY��(F��-K��l��e	Z�����l����{�kw�8�_nJ񣸝��6�x(�'��M)����ͦ/���~�)�[�<��kb�?����t�����}��������j��x�#àa�z�#� b������ѫ�c�1�j�t�Q�� ��1�I%c+�R�.V0d	Z�S�`��D1e�,��c1e�,AKsQv��D1e�,AK�Qv��D1e�,AK�Q6d	Z���!K��t�Y6Z�b:ʆ,-[1e�Xv~��lH��7�8�=ٔ㡸��^l��T�Ol6�x)~Nl�5�x+'��R�>�������u�U,]��}�],]k�χ��y�E"�b���v��j!�0��R*�Y��d��V�1�h'r����VK2(i��e�Ҏ1X-K��N1X-K��T��e	���(���D1ewY��(��.K��d��e	Z���Y��(f��G��%��(��%h�b:�~d�hي�(��;?�Ͽ��ͽ�����6J�P�N�s�R<��X�/�ω}�Q���qbj���:?��?�i��P�N������O��oK�=�����/FX-�a�7d4��V1�h#��bP�.FX-� �]��Z�AG���)� �]��Z�AI�a�(��v1�jY��v1�jY��(���)K��X�E�S��%��({��D1eOY��(&��)K��h��d	Z�����,AK�Q��%h�b:�^�l�l�t��d�hي�(��;����`;�o��~��σ�)��ۉ�bb���~b�����9�_KT�}����y�=šx��/%��׉W�t������S����}�=�"F�x[�Aß�S-� �σ���bP����T�1���`����#Ǡ�σ��d����TK2(��`{�E��y�=ղ-lO�,AKܧ���G����>�>�-q���ֲ-q��ֲ-q���?!K���(o-K���(o-K���(o-K���(o-�F�v�����r��:���k�'��()��ۉ}4J���~b�����9�FQ�}��O��Wr��},J��x�xK�M��O��Wr��O��y�!�"F�x�a��_uȵ����C��T�Wr-� ����&Ǡ���kA!�U�\K2(�:�Z�AJ�!ײ-�U�\���}*�[��=�Ǣ��,AK�碼�,AK����,AK�'��O�%h��h���%h��l���%h��p���%h��t���e�e�OGykY6Z��t��>������^�O�8�m�x)n'��o��Ķ�bn�,~��]z�8���_��x��v�r���b鸩��!^v�����/��`�C�Q-���v��j!����R*�]�\1����r:�M����VK2(i��e�Ү9X-K��n9X-K���(o-K��x��ֲ-q���ֲ-q��?S��%�Q�Z��%�Q�Z��%�Q�Z��%��Q�Z��%��Q�Z����>�e�h���Q��Xn~���%ӽ�7^�q���x+n'�?�sgg    �C�m.�š�9q�[�����kqS<O��w��īX:n�l~���%�x0>��sɬa�0�œa���Y-� ��%���bP��Y-� ��%�Z�AG�Kf� ��6��jI%m.�բR�\2�e	Z�\2�e	Z�>�e	��cQ�Z��%�sQz|d	Z�>�e	Z�>�e	Z�>�e	Z�>�e	Z�>�e	Z�>�e�h���Q��?KNa��)���o�T�u��z�n��&`����0�������	h5T�y��z�Λ�VwՋ�*V�l�p
��Na����������b	�	3�5�fH�.2X.���d�9���4jw,�hH�.3X.���f�\�!S��`�PC�v��r�B�v��r�B��OJys�"�F�R�\��*�Rz4�B��Kys�B��OKys�B���Kys�B���Kys�B��Lys�B��OLys�6���Ĕ7�j�j�OLy�.�������ު�:��s}�~"]3;�ku�����j�~X�_��M�`��VwՓu�M[��^�W��g�'�e��S�VO��N��\��0�ZCi�4��o�q�8�����y�Q_�����K4$j�}-i��N�Z.Ӑ���\�!T;�k�T!U;�k�T!U�'���T�~��Q)=�T!U�g���T!U܇���T!Uܧ���T!U�ǥ��T!U�祼�T!U����T!U�'���T�T�}bʛU]*���p�:��[5X�݇\���е��)��o�;��`5T?����M�`�w ��'�a��z�^�
��������
N����w!,f$̨�P�!Mۇ��g��6",�g��v",hԶ",�hH��",i��6#,�i��v#,jն#,�*�j��KR�}RʛK�7z��cKR�}VʛKR�}XʛKR�}ZʛKR�}\ʛKR�}^ʛKR�}`ʛKR�}bʛK�I��'���T�T�}bʛ����0��)�{��}��)�o
��Z���vb{� �P�Ol��)~Nlo�+'�'r�(�'�r<��j��}�]-�b��<���b�D"�b�B�AC;l���v2�j)�d��b2��`��t���V2i'���dP�N[-� ���Z�����Z��%�SQ: K��x��ֲ-q���ֲ-q��ֲ-q���ֲ-q��ֲ-q���ֲ-q��ֲ-q���ֲl�l��(o-�F�v���ю%�!��e���ơ'οa����8��-n����/���9q�[�('ο_���y���x*^'^��-��ĻZ���|���庋0D��u�d��B"��`��T���V�1�h'���c��N[-� ���Z�AI;l�(��v2�jY��v28׏,AKܧ���,���},�[���}.�[���}0�[���}2�[���}4�[���}6�[���}8�[���}:�[�Əe�w�W�1>�q⼷`q(n'�[Cq?q�Y��)~N�7,�ǉ�ŏ�y⼭`�P�N�������w�t���X6�S�Z�!�(o�0h(Vo
1��X�)Šb�b�����8�t�Q��d2f��S�A�X�
�2H�ZAY���T+(K�Q���%�{D��K��%Z��K��%z��K��%�b�,AK�b�,AK�b�,AK�je	ZbW+(�F���VP���-��ǲ�C���5�B~�P����Cq;��,�qS�Ols�?'�s�9~�۱����v�0�S�:�n)�'���m��C�^\S�>"�}��G�ACq-�B"��k��bP�_\˵����Z��t��r-� ����kI%�ŵ\�2H�/��Z�������%h�/��Z����
�,AKq-ײ-�ŵ\����r-K��_\˵,AKq-ײ-�ŵ\����r-�FKq-���y�i}����q(Ɖ}.Y�����璥�)�'��d)�\�?�ǉ}.Y���yb�K��x�xUK���j�6��i}~璩n"F�xM�Aß�d�b�g.Y��T��K�j1撥Z�Aǟ�d�d�g.Y�%���K�jQ)撥Z����\2�]����\�T��=�X�.K��g.Y�e	Z��%K�,A˟�d��%h�3�,ղ-撥Z����\�T����K�jY6Z��%S�Ȳ��g.Y�����x�\,�-�ƽ�����X�⦸��/��+�'���)~?'���)�ǉ�bq���yb�X��x�xUK���b鸩3�!��S-�a�7d4��X�j!.�Z�Aş�ũc���bq��t��X�jA!.�Z�Aɟ�ũe���b��)K���bq�e	Z�\,N�,��#���-.�Z������T����X�jY��?�S-K���bq�e	Z�\,N�,A˟�Ū�,-.��XN~Z��^q����u��7���v� �]q?��>���9��>��P<Nl�r<���/��īZ��x�xK�=��O��9}�k��X�-à��>ȵ��~� �R*��\�1��r-Ǡ��>ȵ ��~� גJ��\�2H�T��,AK?}�kY��~� ײ�~���`�������%h�r-K��O�Z����>ȵ,AK?}�kY��~� ײ-��A�C���~� ײl����>������Wܹ���!^v��⮸��v s�(�'���ωm�/�S�8�m��x)�'�ݿo��īX:n�,~���>�8����V�0D��A�AC;}`���v��j)���b2����t��V2i���dP�N争2Hi���%hi���%hi���%�{D��M����>�Z����>�Z����>�Z����>�Z����>�Z����>�u�%hi���e���%�Z����*���r�C��^q��ܹ���!�v���Gq;q�	[<��_��S�s���x)'ο_���y����1wu6?��.[���w�t����o�Nl�C�Q,�#à�]&�Z�AD�Kl���v��j1�&��r:�Eb���{Ĺ�J�5b�E��[�V���K�V���;�V��=�X�!K��n[-K��.[-K���[-K�Ү[-K��n�z�����V�����V˲�Ү[��%g6��̆���~6w8�a�7��v����lXߙ���l�pf���l�޿�gs�3�wf���u?�;�ٰ�3�������̆���p�|���g6��̆�
���lX��l������̆��̆�.aFb�4C�6��rq�8mH���yڔ2��1e�K4$js�,i����|�4dj��,j�F�Y.UH�f�Y.UHՆ�Y.U��(���R�Tm\��R�Tm^��R�Tm`��R�Tmb��R�TmdYʟ�T!U�Yf�T!UZf�T�Tmj��RmR��e��t%-�to�h����Hw��Z=T7��wm�T�Y矵�K��:���ު��������t1-쌯աz�^�
���HW��N�Z�X�;~��raFbC�!M;�k�8C�v��ry�<������Y_�%�þ9�HC�v��r��L����B��y_˥
�ځ_˥
�ډ_˥��E���*�jg~-�*�j�~-�*�j�~-�*�j�~sޤ
�ڹ_˥
���_˥
���_˥ڤjG-?����7��zs�9;C�;h3�7���3���7��z�9;C�[hߙ�����
]C���p�~�����=��������
]D���p�|�����M����<;C��h3�+xv�BwѾ3�K؅	3�5��i�>���q�F���y�N����V����^D���Hm3�r��Lm7�r��Pm;�r�B��a�T!Uې�\�H�Q�HR�-	˥
�ڞ��R�TmS�r�B��+��!UHն%,�*�j��KR��	˥ڤj;�K�IՆ�Y��z[3�?�i��?�}������4�x*n'�'Kr��ۋ%9ފ�ۃ%)��m�l��|��šx�؞+�1��b�F[3�?�efqg��<�?�̬a�0�ś2��`��D���VK1�h'��c��N�z�1�h'��d�N[-ɠ���Z�AJ;l�,AK;l�,AK;l�,��#��%hi'���%hi'���%hi'�s�e	Z��`�e	Z��`�e	Z��`�e	Z��`�e�hi'���e�����X�b���tg��S1N��/����'l�V�O��)���    ���lq('ο_��x�8�|-n�׉�}�Ƨ+�'��������O[-�aT�'à���Z�AD;l���v28�!� ���Z�AG;l� ��v2�jI%�d�բR��`�e	Z��`�e	Z��`�e	�Q��,AK;l�,AK;�k�����V�����V�����V�����V���_�緛xSx�Q������~�)�Sq?�_mJ�R���o6�x+'��M��G�<��kJq(^'^��5(�'��ҵ��|����a�0��k2���j!�U�'Šb�j��d��Z@9c+���Y�`�dP2V��]�A���
vY���+�e	Z���2�,��c1etY��(梌.K��`��e	Z���2�,AK�Q�#K��l����D1e<�-QLG�,-[1e<�l�l�t����q��t�x<C1Nl/��x*n'��r��ۋk9ފ�ۋk)�����Z�C�<����c(^'^�ҍ�x�xK7:��!�?/��Z�!�(o�0h�/��Z�ADq-�R*��k�c��_\K��c��_\˵ ����Z�%���r-� ����kY����Z�e	Z���2�,��c1eLY��(梌)K��`�1e	Z���2�,AK�Qƒ%h�b6�X�-QGK��%��(cɲѲ�Q7w~Z�>�����8�6J�T�N�s�R���X�o�ω}��b��<��>�|�Q�C�<��4J1��b鸩��������qO����V�0D��m�b��B"����T��V�1�h#R=?r:������VK2(i#�e��.FX-K��.FX-K��T���%�{,Ƣ̏,AKsQ�G��%��(�#K��d��-Q�F�!K��l��-QG�!K��t��l�l�t��l�l�t��͝����Wy�xrog�C<�h��Kq;�_LL�V�O��scg�C<������qb���b(�'�K�)n�׉W�t�����X:n�~��I�Z�!¨O�AC;�`���v�j)�8B����v�j9�0�ՂB�Y�%���V�2Hi'��%hi��%h�b*�l��~��X��d	Z���2�,AK�Qf�%h�b2��-Q�F�]��%��(���D1evY��(���.�F�VLG��ܙ���>�7�'�v&?�Ӷ,^�ۉ}4J���~b����;�������8��\�C�<��EIqS�N������u����qOg��:}��j��Z<��	1��Z>)��7�d��X�!Ǡc�b� ��1��J�*Vp�2H�X�!K��b�,AKSQ�%�{,Ƣ�!K��\�9d	Z��2�,AK�Q�%h�b4ʜ�-Q�F�S��%��(s��D1eNY6Z�b:ʜ�l�l�t��͝��������xٽ���vb�L1wv?��n=X����_��x�ض�r����_���u�U,7u?��.<X<����V�0D���0hh��b�.;�zK1�hw�c�Ѯ:X-Ǡ��t�Z�AH��`�$��v��jQ)횃ղ-햃ղ-QLE�[����2�,AKsQ�G��%��(�#K��d���%h�b4����D1e}d	Z���>�-QLGYY6Z�b:��ȲѲ�Q7w6?��撥{ŋ{;��ms�r̭���d��~��������M�8q��Z��矯ŏ�u�U,7u6?���Y<����dV�0D���0hhs�r!m.��R*�\2��d��dV�1�hsɬd��Y-ɠ��%�Z�AJ�Kf�,AK�Kf�,AKSQd	���(���D1e5Y��(��&K��d��d	Z����,AK�QV�%h�b8�j�-QLGYM����������0������u6w8�a�0\o����)�;��z{��Na��Ma�]�^gs�S�w
����:�;�°�S�ׯ��������p�}����0����
��Na��)�
Nּ���k�3fTk(͐�]d��#���d�\�!O��`�@C�v��r��D�2��"��m�e2���5�j�,�*�j,�*��bR�z���-F��!UHŬ�5�
�����T!U�R֐*��b\�R�TQ�KYC��*��)kHRE11e�6��bb�RmRm�Ĕu�~"]2;ݛ�����Y��^�Cuc��VCug��V7�����������G�d��VՋ��Vp�ެw���5����|-f$�(�pI3�i}-g��N�Z.ϐ���\�!P;�k�DC�v��r��H����2��q_˅B��KR���KRE1)em�"�F�Q)kKRE1+em�B�(���-UHŴ���
�����T!U�R֖*��b`��R�TQLLY[�M�������P�R������}v�B����0\o�3�V�7��z{���н��)�����.��Ma�޿�gg(t��;��v�z����ղ�)��������Ma(Vp�ެw���5?��]˅	3�5i�4m�rq�8m#�ry�<m'�r��@m+�r��Dm/�r��Hm3�r��Lm7�r��Pm;�r�B��a�T!U�R6���-F�lHRE1+eC��*�a)R�TQLKِ*��b\ʆT!U�R6�
����!UH�Ĕ�6��bbʆT�T[11e��+�v1���]�?{�)�[(Ɖ�كCq;��z�㦸��=�qW����<��x�؞<��P<Ol/�x*^'^��-��ĻZ��8>D�k�E"�b���v2�j!�d��R*��`��d���V�1�h'��d�N[-ɠ���Z�AJ;l�,AK;��G��%��(��%�{,Ƣ�G��%��(��%h�b0�~d	Z����Y��(F��G��%��(��%h�b8�~d	Z����Y6Z�b:��l�l�t�=�%�!��e���P��߰�Mq;q�	[���_�ŏ����l�P<N��O�����k�R�N���ۊ��w�t���|���Y-�a�7e4���V1�h'���bP�N[-� ���Z�AG;l� ��v2�jI%�d�բR���\/Y��v2�jY��(���%K��X�E�K��%��({��D1e/Y��(&��%K��h��d	Z�����,AK�Q�:������x�}�b��/7�8��ݦCq?�_mJqS���o6��+'��M)~������īZ��x�xWK���_�ϟ�"�u��G�A��u��Z�A�h��{k)�_���d�纀o-Ǡc��
�� ��1�+�֒JƪVP�A���
��ħZAY���OEy>!K��x��ֲ-q���ֲ-q��ֲ-q���ֲ-q��ֲ-q���ֲ-q��ֲ-q���ֲl�l��(o-�F�v���|p,;?��6�^��b�؞l�1�ۋM9n������w�ω���?�ǉ�������ZS���u�U-�R�O���یχ��y�\7��X�&à��f�Z�AD;�`���v��j1�(��r:�I����VK2(i��e�Ҏ1X-K��N1����}*�[��=�Ǣ��,AK�碼�,AK����,AK�'���,AK�G���,AK�g���,AK܇���,AKܧ���,-�}:������O����^��b����ۉ}�Q���~bk���9�O5J�x�؇�x(�'��F)��׉W�tK�>�n3>���/F�z�0D���b��B"����T��V�1�h#��c��.FX-� �]��Z�AI�a�(��v1�jY��v1"�S��%�SQ�Z����>�e	Z�>�e	Z�>�e	Z�>�e	Z�>�e	Z�>�e	Z�>�e	Z�>�e�h���Q�ϒe�e�OGy�c9�!?��{�o�8��LLqS�N�S�����?��������~+1�S�<�_JL�R�N���ۊ��w�t������S-�a��e4�y�=�B"�<؞j)lO���?��Z�Aǟ�S-� �σ���dP����T�2H��`;�����y�=ղ-q���ֲ�~���(o-K���(o-K���(o-K���(o-K���(o-K���(o-K���(o-K���(O�,-�}:�[��O��w����'��()n�ۉ}4J���~b����G�sb���x��碤x*�'��()    ^�׉W�t[�>�.��{:�����C�E"�b� à���k!�U�\K1��:�Z�AF�!�r:���d�_uȵ$����C�E��WR�d	Z����%h��T���%�{��EykY����EykY���FykY���OFykY����FykY����FykY���GykY���OGy�˲Ѳݧ���,-�}:�[����w����b�ض s���`���Ķ���9����x*'���/��Ķ���x�xK�M�����!^~��j��X�G�AC��`���v��j)����b2�U��t��V2i��dP��9�z�2Hi���%hi���%h��T���%�{��EykY����EykY���FykY���OFykY����FykY����FykY���Gyb���}:�[˲Ѳݧ���,-�}:�[���d�W��]1N��?�ۉ�O�⡸�8��-������K�8q��Z���o�����!�6���P�O������x�\2�E"�b���6��j!m.��R*�\2��d��dV�1�hsɬd���zK2(isɬe���Y-K���Y-K���(o-K��x��ֲ-q���ֲ-q��ֲ-q���ֲ-q��ֲ-q����#K���(o-K���(o-�F�v�����Y��8'l?��/��uW�y��Guc�7��;�	h�T��Λ�V/Ճu��z����&`������X�b����]���݉�n1|������4C�v��rq�8�&���y�U����K4$j�,i��n3�2��u˅B���KR��KR�}RʛK�7z���R�Tq����R�Tq���R�Tq����R�Tq���R�Tq���IR�}`ʛKR�}bʛK�I��'���T�T�}bʛ�t�,�t��������꡺�οk����:���^���Wm�V=X�u���O��fag|�Ջ�*V���D�lv���ƚ���c��3fkإҴ����3�i'}-�g�ӎ�Z.�����\�!Q;��G�!R;�k�LC�v��r��P����R�T����R�Tq����RE���G���T!U�g���T!U܇���T!Uܧ���T!U�ǥ<R�Tq����R�Tq���R�Tq����RmRm��)o~Tu��o
����[?��:�>X=T7�y��ꩺ���V/��a�V=X��\����ղ�)���o��U���
].���p_��3�]���p_�)�H�Q��fH��!,g��6",�g��v",hԶ",�hH��"r�D"���e2��˅B��˥
��~��R�Tq����RE���G���T!U�g���T!U܇���T!Uܧ���T!U�ǥ<�R�Tq����R�Tq���R�Tq����RmRm��)o.�&�v�������Sn���x(Ɖ�كO�����A���~b{� �[�sb{�@q����0���ۥ�7�����A��x�xݗ������)��k�-��0�w
�u��G�!¸/^��0hh'��b�N[-Š���Z�AF;��c��N[-� ���Z�AI;l�(��v2�jY��v2�jY���OEykYB���X���%h��\���%h��`���%h��d��A��%�Q�Z��%�Q�Z��%��Q�Z��%��Q�Z����>�e�h���Q��X�b�Z�;�o<���7l�R�N��o�������Q��8��-�����k1�矯�M�:�*��u��ĻX��0>�aeV�0D���0hh'��b�N[-Š���uc��N[-Ǡ���Z�AH;l�$��v2�jQ)�d�ղ-�d�ղ-q���ֲ�~���(o-K���(o-K���(O{d	Z�>�e	Z�>�e	Z�>�e	Z�>孏e�������Əb��/7�x(n'��M)�����jS�����~�)�[�8�_lR<>���^S�C�:�*�n@�>�.�n4������g�C�Q,ސa�0P��b1Z�|R*F��O�A�x��c�1F��S�AȘ�
NI%c+8E��]���%h�O��S��%�SQ�Z����>�e	Z�>�e	Z�>�e	Z�>�e	Z�>�iK��%�Q�Z��%��Q�Z��%��Q�Z����>�e�hي�(m��q���^q[C1NlO6�x*n'��r��ۃM9ފ��{M)�����\S�C�<��֔c(^'^����x�xK�;��!�~��j��X�-à��f�Z�AD;�`���v��j1�(C��G�AG;�`� ��v��jI%��բR�1�e	Z�)�e	Z����?��~��X���%h�b.J���D1�d	Z����C��%��(=d	Z����C��%��(=d	Z����C������ҹ�����������C1N샍R<��\�/���>�(�[�sb�j���:?��?j��P<O�3�R��īX:n�<��>�v�t��y�i}�b��"F�x�a��.FX-� �]��Z�AE�a���v1"�M�AG�a� ��v1�jI%�b�բR���e	Z���e	Z���қ,��c1�7Y��(��&K��`��d	Z���һ,AK�Qz�%h�b6J�-QG�]��%��(�˲Ѳ�Qz�e�e+��tn�~��σ��Wܹ�3�!?��x)n'���)ފ���^�bn�~��σ�)���~+1�P<O�S���b鸩3�!?���a|>�����T�0D���0h��`{��D�y�=�R*�<خz�1���`{��t�y�=ՂB�<؞jI%lO�(��?��Z���σ���%h�b*J��~��X�>d	Z���҇,AK�Q��%h�b2J��-Q�F�S��%��(}��D1�OY��(���)�F�VLG��ܙ�������x*Ɖ}6J���vb��⭸��'�(����u��9���>%�P<O�cQR���b鸩3�i���C����:^uȵC�Q-�����C��D�Wr-Š����-� ���k9�U�\2�:�Z�AI�!עR����%h�:�Z��%��(}��=cQ��%h�b.J߲�]�#ɮ��q�&E���؋WyM�	kԓ4J'� 1@�(�Q�G.A�(�Q�G.A�(�Q�G.A�(�Q�G.A�(�Q�G.A�(�Q�G.]�"���e+�Q:�;���w�^�/�8�� 3���0���,>�ˮ���6��0���/�M�<�M�2�^^E�8�Y|��<<��x����RRU��0�Ю��ĠD;v�4d1h�n��ƠF;u0Z����h���C�e2h����ʠJ;s0Z.A�v�`�\�.Q��t�%ԏE,J�\�.Q��&��K�(��%�E2Jor	�D�қ\�.Qd��&��K�(��%�E:Jor���(��e��V��tw6�m�d鮸s���o�%�0G;��\2�C�s���Cp?pn`���q�ܿ?��s�����t�l>��r����C�=��h))��xrth�d���h�dF�bТ�-�A��Kf�<=Z.��i�dF�dФ�-�A��Kf�\�.-��h�]�HE�].�~,bQ��K�%�\�>�t�"��]�HF�C.A�(�Q��K�%�l�>�t�"��]�HG�C.]�"���S��p=�g����/��v9��p�)�Ma�^`�3�a
C|S���w������u?��0�7��z~��p�)�Ma�^_�3�a
C|S�<��0�)�
NҼb����IfT5�͐M;d���ΐN�d0\>C>��p		�[�e4dԎ�ҐR�f0\NCN��pII�{�e�j��*dERJ_��ԣETJ߲
YE��ҷ�BVQ���-��Ui)}�*dE\J߲
YE��ҷ�BVQ��-��U�)}�j��V$��-�MV[���������ö{���8���� ����H�6�ҹ��n�;���F?����Fwѓt�i���EzU��7�]Up��;��k�dF�EC6C6m��p��M_��3��V}�АP��5\FCFm��p))�m_��4���}�ԐT��5\V!���k��BVQ$��*R�Q)�
YE��2 ��Ua)�
YE��2 ��Uq)�
YE��2 ��U�)�
YE��2 �MV[��2�d(tT��    �p=g2�*�Ka�^�3
����0\/�Ǚ��ʾ)��q&C�ò�����8���e�_
���z��P��/��z}=�d(t[���PTp�ޤwU�E�/|
a�dF�E�ٴ9����i���3��&�KhH��"�ѐQ�E.�!�6�0\NCNma�����8�pY���<�pY���HJ]V�z��J]V!�(�RF�U�*����e��"-etY����K]V!�(�RF�U�*����e��"1etYm�ڊĔ�e��j+S�wp�0���p�+߹����Y�������0\��wj�0�/��z�=�C#(�)׫��A)�Ka�e���Ja�_
��&{|'FP
�)��-����*�&�}��Ma��nJaHaśrth��FKbP�m-�A��l�45�f����h��FKdP�m-�A��l�TU�f��r	����L/�]�HEK.�~,bQƒK�%�\���t�"e,�]�HFK.A�(�QƒK�%�l���t�"e,�]�HGK.]�"el�ltيt���K�!�Բt�<6����n�ہs�~�;��.�87��C�8p�_���y�ܾ/����*���拏������-�!�q/���aСm-�A��l�,-�f����h��F�cУm-�A��l�LM�f��RTi����]�f��r	�D��2C.�~,bQf�%�E.��]�F�!��K�(3�t�"e�\�.Qd�̐K�%�p�r	�D��2q\6>��_qW<�q�<[0�ہ�h��&�9p�,��΃���q�<W0x��c���u�U�n	��U�6��X6�)d�IaHa�krt(��$1(1ZQ�&�A���k���(`�Ǡ�E�DEƬ*(�A���
JePe쪂r	�ħ��#��KDQ�G.�~DQ�G.A�hE�]�)*��%����#��K����\�.1�
�%����\�.��
�e���)*���e�����|�?��5]!��8��f�	n���?���ba���~`�+��<lk����m�0�K�:�J���t��<|���/�eZ
C
�(ސàC-�A��ŵL�bТq-����_\˴<=��2-�A��ŵL�dФq-�RT�_\K��KХq-�r	��/�eZ.�~DQ�)��K��Z��t�_\˴\�.��k��KХq-�r	��/�eZ.A��ŵL�%�ҿ���%��.��k�>.;�����+���t>��'�,�Mp;��%���s���{.Y���q`�%K�<�d	^�ׁWU�-xx��L��i���d���(���0�0PToKbP�O.Y�e1h�'�,�����K�hyz��%K�DE��%Z&�&r�-�A�?�d��G.A�?�d��K��O.Y���G�+�>r	���%K�\�.r�-��˟\�D�%��'�,�r	���%K�\�.r�-��˟\2�!��.r�-��.r�}\>��簘Wȋ����x�'����	�aq���~`?,N�<��	^����8�[�:�*Jǡ��C<~���C<~�-�!�Qrt(�IJ�9,N�,-�'Z��-�A�?�ŉ�Ƞȟ��D�d���a��&�A�?�ŉ�K���aq��t�sX�h���E�\�.�-��˟��D�%���8�r	��9,N�\�.�-��˟�bя\�.�-��.�}\N>��_qW�8ۙ|Z�od��l���A���~`�>��<l�^��m� �[�:�*Jǡ���:}� �A�<��g� �RRE���uIJ��L�bТodZ�}� �������ȠH�>ȴLM��A��TU��A��t����KХodZ.�~DQ�!��K�>ȴ\�.}� �r	���L�%�ҷ2-��K�>ȴ\�.}� �S.A��}�i�lt�����F��}���r�!^��������C�l���.��&���� 0�Sp?���2����/�[�<�M�̩��C�l�������q���/�>0Z
C
�(ޒà�@Q�%�A��}`�,-������h�F�cУm-�A��}��-�A��}`�TU����r	�����ti�F�%ԏ(*��ti�F�%�Ҷ��KХm-��K�>0Z.A��}����KХm-��K�>0Z.]Z.��r��Ҿ�f�q��o�+NWț��͇x�Y��Cp;pna�������^���s�����0�:��b�C�:�*Jǡ��C����F�<��ω���(�rt(���h��F�bТ�-�A�vIl�<=�!q�!�A�vGl�LM���RTiW�F�%�Ҏ���KХ�-�P?�� �ti�F�%�����KХ�-��K;�t�KХ]-��K;6Z.A�v;l�\6���a��s��|3����w�ـof��{��3��l�`�3�af��l��_�3�af�����}�;�l�7��z}��p���f6\����0��̆{�p���f6�+x�;�l���>�If5|d3d3P�ΐN)3\>C>-��p		��2�e4d�r�2ޥ4�Ԃ��ӐSK*3\RCR-��pY��ZV��
Y��2�e�GQ��*d����UȪ�.��U,3\V!��X��!��U�,3\V!��Yf��BV-��pYm�j�e��j�U�-3�XM'ia۽��x��O�����^���F:���K�C:���[t'��:�g��.-l���=I�6��UT��~"���m����;��k�dF�E�l�l�"JgH�m�.�!���k����ڮoƗ���ڲ��RRj۾��iȩ��.�!���k��BVm��pY���Ưᲊԣ�
)��U��5\V!���k��BVm�7�[V!���k��BVm��pY�����
Y��_�e�ɪ��~�B/����L��O�t�>=E7�y�`��������N: D�ϙ������=I����H�k_��ޤ���/�����B.��dƵ�/.�!�6�0\:C:ma�|�|�$�p		�QD�CFCFma�����0�p99�i���j��e�j��e�j	�e�GQRV!�6�0\V!�6�0\V!�6��8d�jS	�e�jc	�e�js	�e�j�	�e�ɪM&��&�jf�_9�2�?�4�]�O�8�}�$�Kp;�}�$�[�s`�bI��eh�lh�<���<l�+�0���J2����t߁QSfC��Yfw�������23Z
C
�*���IbP�m-�A����G�m3�hyz��`�%2(�6���ɠI�6Z*�*m3�h�]�f��r	���`���GT�KХm-��K��t�KХm-��K�6Z.A��l�\�.m3�h�]�f��r���6����F��l�q	>İ�`�,����6xn�-����8w��!�87��<����&x8�����u�U�nt����(���C�6Z
C
�*���IbP�mgz�bТm-�A��l�<=�f��i��F�dФm-�A��l�\�.m3�h�]�f��r	�#�
�%��6�3��ti��F�%��6���KХm-��K�6Z.A��l�q����~�t.�_xƁ��)�Sp;��6%x	~�M	ނ����I���æ��y`�kJ0���t�	��E��C�<͟?��0�0��m9:TՓĠ�hU�d1h1��~���^���c�c�{�#�A�1���LMƺW0>RT�^���%��{�#��K�SQ^Z.�~�Ǣ��\�.q�Eyi�]����r	��=eD�%��h���K�%��(/-��K��Q^Z.A������\6�l�t����F�힎����Ç��/�����`ؾ���%�ؾ���-�9�}q-����/�e8���2����ŵ7����(����(:��??_\˴�FU<9:�m�%1(і��ŠE��Z��45��2-�A��ŵLKdP�q-�24�_\˴TU��2-��K��Z��t�{*�K�%ԏ�X���K�%�(/-��K܃QF<r	��=��t�{4�K�%��l���K�%��(/-��K��Q^Z.]�{:�K��Ok���F�����`؃���{�Q�����k$���Χ��    �T���q`5J0�{�Q���u�U��C�Χ���E�8��|Z�F-�!�QO�U�$1(1ZU>YZ�ÈLij����1��#��ȠH;�0Z&�&�0�h������ti�F�%��T���K��(/-��K�sQ^Z.A�����r	��=��t�{4�K�%��l���K�%��(/-��K��Q^Z.]�{:�K�e��vOGy��r�!��4������eb���v`?L����C<��]b�Cp?��%&�ǁ�*1�M�<�%&�����q�3���(�:�����0�0���aС-$-�A�ъ�mYZ�u��1�Ѷ��ǠG[F0Z"�"m�h���U��2��6��KХ-"-��K�SQ^Z.�~�Ǣ��\�.q�E��%��`���K�%��(/-��KܣQ^Z.A��g���\�.qGyi�]➎��r����Q^���|Z�?G9��/�������-�أQs�3����������(	��q`�EIp<�(	~���t�L>���.JǙ���:}|`��FU<9:TՓĠ�hE� �A����45F/
yz�QT�� d2h2VQAHePe좂�K�%>U�t�{*�K�%ԏ�X���K�%�(M.A�����\�.qOFyi�]����r	��=��t�{8�K�%��t����F�힎��r����Q^��\|��>�R���`�F�	�hg�!^v�`p~l�Cp?���2����/Ï�y`��e�^^E�8�Y|��<<	��x����RRU��0�Ю2�%1(1ZQ�.�A�v�`�45ک����h�FKdP�:-�A�v�`�TUڙ��r	��+��t�{*�K�%ԏ�X��!��K�sQ^Z.A�����\�.qOFyi�]����r	��=��t�{8�K�%��t����F�힎��r����Q^���|����x���͇x[.��!�8����8w��Mp?pn`�������s�<���tS�>�J���x{.��RRE���-IJ�V�o�bТ�-�A��Kf�<=Z.��i�dF�dФ�-�A��Kf�\�.-��h�]➊2����{,�K�%��\���K�%��(/-��KܓQ^Z.A��G���\�.q�Fyi�]����r	��=���e�����.��о)�����p�)��p�~��H�!�����C@���N:�~D�yht=I�!��C�"��
Nћ��*�H���g�Kf$�Q�0d3d��ΐ�hEC>C>��p		�[�e4dԎ�ҐR�f0\NCN��pII�{�e�j��*d���� �H=z�JyqY��➕��
Y�=,��e��{Zʋ�*d����U�*�y)/.��U�S^\V!��'����6Ym�Ĕ��&�힘2ڙ�D:2�����K�h�΍m4D7ҹ��n�ҹ��~Dwҹ������Fѓt�i���EzU\�7�]Up��;���G2#Ɍ���l�lڢ�������#�!���k����ڮ��22j˾�KiH�m�.�!���k����ھ��
Y��ߌwY��➔�Ⲋԣ����U�*�Y)/.��U��R^\V!�������BVq�KyqY��➗��
Y�=0��e��{bʋ�j��vOL�L�BGe����p;���U�_
��r���P��/��z���d(tW���p=�ng2:,�Ka��_�3
]���0\ϯۙ�N��R����L�B�e��{��MzWܤ��§��If5���iså3����gȧM"�АPE.�!�6�0\JCJma�����4�pII�q��
Y�yDƗ�BVqOJyqYE��{Tʋ�*d����U�*�a)/.��Ui)m�*dE\J[�
YE��Җ�BVQ��%��U�)m�j��V$��-�MV[��Ҿ��G)�_
����}�F�R����Yq����0<)׻���=Jax�R�g��;4z���|SnW��;3z�����0\���wd�(���Ka��d����Q
���P�n����=�yѣ���p���¸���aСm-�A����{>��h��FKcP�m-�A��l�DE�f��24i��FKeP�mg:�ti��F�%�E*�r	�c��\�.Q�<!��K�(O�%�E2�r	�D��\�.Qd�<!��K�(O�%�E:��ltيt�r���(�K�!�Բt���	Ɓs�n�-lp�8w��Cp?pn`���q�ܿ/����}ނׁWQ�����ҵ |⟰2��0�0��59:��`�%1(1ZQ�&�A��l�45�f����h��FKdP�m-�A����G*�*m3�h�]�f��r	�D���<r	�c��<r	�D���<r	�D��<r	�D���<r	�D��<r	�D���<r	�D������k���k���qS�!��o��?�Ӧ?�����)�]�8�6%x����O����*�����m���k��ezHaHa�rt(�7$1(1ZQ�!�A������(��Ǡ�E�DEƬ*(�A���
JePe쪂r	�ħ���K�%�T�g�%ԏE,�3�t�"�r	�D��L�]�HFy�\�.QD�<S.A�(�Q�)��K�(ϔK�%�t�g�e��V��<K.]�"�Y��Ç��ņtW�,Ɓ�Mn�ہ�M~?�6e����5ex��5ex
���5ex	^^U��}�]�n����}��0�0��m9:�m�%1(і��ŠE�e0Z�m��hyz�M�%2(���ɠI�c0Z*�*m�!��#��K�b0Z.A�(RQ�G.�~,bQ�G.A�(rQ�G.A�(�Q�G.A�(�Q�G.A�(�Q�G.A�(�Q�G.A�(�Q�G.A�(�Qz�e��V��tw:��������`؃���{�Q��ρ=�(�]p?��%x�P�O����i��%xxU�ۂ��wQ:�t:���FKaHaŃ�a�ђ��(d1h1��~�ƠF;�0Z��0�h�����e2h�#��ʠJ;��t�KХF-��K�(��%ԏE,Jor	�D��қ\�.Q��&��K�(��%�E4Jor	�D��қ\�.Q���&��K�(���F��HG�\6�lE:J�pg�!?l�]q�lg�!?lO�#���?������~���)xد���Qb���u�U��C���x�|�=�A�<����퉖�(���0�0PT�KbPb��|]��)�ץ1���퉖Ǡǟ�'Z"�">؞h����`��!�A�?lO�\�.>؞h�]�HE�C.�~,bQ��K�%�\�>�t�"��]�HF�C.A�(�Q��K�%�l�>�t�"�O�]�HG�S.]�"�s�3����ﵿp�{6J�������.�9�'�$x��`�O�������%x�cQ����t�L>�ӿ�� |����U�LKaHa�[rt�_uȴ$%F+ʷd1h1��~K�����ǠG��C�%2(ҿ�i����:$zKeP��!�r	���:dZ.A�(RQ��K��X���t�"�o�]�F�[.A�(�Q��K�%�h���t�"�o�]�G�]�HG�ltيt���F��HG�,>����{�/�Ɓm��.��&���� 0�Sp?���2����/�[�<�M�̩��C���������q���/�w0Z
C
�(^�aС];-�A�v�`�,-�S�O����hyz�K�%2(�2���;��2�����KХ]9-��K�(r	�c�2 ��K�(r	�D�2 ��K�(r	�D�2 ��K�(��%�E8�hr	�D��2�\6�lE:�hr���(�Ý͇x[.Y�+��l>��r��ہs<?�l�����-x8�o�9��|����ׁWQ:u6�m�d7��!ޞKf��FQ�G�-��hIJ�V�O���'�A��Kf�<=Z.Y��DEZ.��24i�dFKeP��-��K�%3Z.A�(RQF�K��X���t�"et�]�F].A�(�QF�K�%�h�1�t�"e�]�GC.A�(�QƐ�F��HGg�����p=g�����    p�g�����p��g�����p=�g��������8��0<�����8��0<�����8��0<��{�p�)�7��^�3�a
��_
ý�S2#Ɍ��S6C6��p��K��3�3���j���hȨ3d|IiH�]3.�!�v�`�����=��
Y���e��")e,YE��"*e,Y����JKV!�(�RƒU�*����d��".elY����K[V!�(SƖU�*�Ĕ�e��j+SƖ�&��HLg���,l�7��3��te��k��H�6z�~H�6z��sW'z��O�K��_�C�$�{�h�^�׽���~"��m����;��k�dF��Ώl�lڢ����i����g�g<U%4$�v}322j˾�KiH�m�.�!���k����ھ��
Y��_�e��")e��"�h�2CV!�(�Rf�*dEX�Y���HK��U�*���	Y����K��U�*���	Y���HL���&��HL�g2:*�Ka���3
]���0\/������R���L�Bwe)��y&C�ò�����<���e�_
���z��P���p���g2�-�Ka�W�L�B�e)�
��P���p/a��H2��a�͐M�C.�!�6�0\>C>ma�����("㏌���,�p))�a��rrj��%5$����*d����*dER�|d�G�����*dEV�|d��",e>�
YE��2��BVQĥ�.��Uy)��*dE`��
YE��2��6YmEb���d��)�;8�Ja�)׻���u�0����Y�����R�_
��.{~�F])���p;˞ߡQW
C�Ka�^e��̨+����0\���wdԕ���R�7��;1�Ja�)��}F])�/��^�Ｈ+��S�RRU��0��6���ĠD�6Z��)�7�1��6���ǠG�6Z"�"m3�h����`��2��6���KХm-��K�(s�%ԏE,ʜr	�D��2�\�.Q��%��K�(s�%�E4�\r	�D��2�\�.Q���%��K�(s�e��V���%��.[��2�q	>ĞZ�n��Z�q���o�����3�?���68��6�ǁs�����5������.xx�ۃ�y��ʌ�¨�'�A��l�$%�fp��G���o}�1��6���ǠG�6Z"�"m3�h����`��2��6���KХm-��K�(�#�P?�(�#��K�(+�t�"e�\�.Q$���K�%�h�r	�D���B.A�(�QV���_�W|�}���qS���v`�mJ���O����e�`|��aS�C�<��5%�ׁWQ:4����(���k��-�!�Qrt��'�A�Ѫ��b�b<U��1�1zQ�&�A�1�
6���YT��d�d���M*�*clr	�ħ�`�K�%�T�����"e5�]��EYM.A�(�QV�K�%�d���%�E4�z�t�"e=r	�D���]�HGY�\6�lE:�z��e+�Q�s\>|�[lHw�뙂q`�dS���v`�bS�����������~`�^S�C�8�}�)�<l_k�p�����G�>�.J�;��?��`��FU<9:�m�%1(і��ŠE�e���ƠF[e0Z�m��h���E�e2h����ʠJ[c0Z.A���`�\�.Q���!�P?�(k�%�E.�r	�D���\�.Q$��)��K�(k�%�E6ʚr	�D���\�.Q���)��.[���8��|Z���{틳�Χ���`�/����k��-�9��	�`��i��<�(�!x�C�����i��&xx��P��i��vQ:�t:���FKaHaTœàC;�0Z��0�hYZ���ߖƠ��E�<=�a��i�F�dФF-�A�va�\�.�0�h�]�HEY[.�~,bQ֖K�%�\���t�"e�t�"e�t�"e�t�"e�t�"e�t�"e��e+�Q�G.]�"es�3�����xs�3����'xn��D���>����	���~��`���7���~���G�:�*Jǡ��C<~>؞�A�<����퉖¨�'�A�?lO�$%F+�YZ����1�1zQ@�c����-�A�?lO�LM�|�=�RT����D�%���퉖K�%�T������EِK�%�\���t�"e7�]�HF�M.A�(�Qv�K�%�l���t�"e7�]�HG�M.]�"es�3������7g;�O���:dxn�h���L>�ӿ�����(	��q`�EIp<�(	~���t�L>�ӿ��A�<�����¨�'�A��U�LKbP��!�]��)�ץ1�1zQ�.�A��U�LKdP��!�24�_uȴTU�W2-��K��C��t�"ew�����E�].A�(rQ��K�%�`�=�t�"e�]��F�C.A�(�Q��K�%�p�=�t�"e�ltيt�=��e+�Q6�;���W|�}s���/�{�0G;���C�s` f���m���&x��~���/�]�:�*Jǡ��C�����I�<�����¨�'�A�v��%�A�v�`�,-ڭ�����(��ǠG�t0Z"�"���h���;��2�����KХ]9-��K�({�%ԏE,��r	�D����\�.Q��-��K�({�%�E4��r	�D����\�.Q���-��K�({�e��V���-��.[���9��|����x~8��|����ہs�ρs���6�<����.x8���C�:�J7��t��y���-�!�Q/�0��rɌ�ĠD�%3Z��)����(`�cУ�-�A��Kf�LMZ.��RTi�dF�%��rɌ�K�%�(��������r	��=��t�{0�K�%��d���K�%��(/-��KܳQ^Z.A������\�.qOGyi�lt���(/��K�0�o
��tx~�p�)���p�~��H�!�����C@���N:�~D�yht=I�!��C�"��
Nћ��*�H���g�Kf$�Q��͐M;d0\:C:��p���S�%4$4zQ�GFCF��p))�k��4����ԐT�g0\V!�v�`��BVqOJ��.�H=z�JyqY��➕��
Y�=,��e��{Zʋ�*d����U�*�y)/.��U�S^\V!��'����6Ym�Ĕ��&�힘2?g���,l�W��/�A:7���H�6��~H�6��I�6���sS=DOҹ�����UUp�ޤwU�M��t��oƧdF�E�l�lڢ����i����gȧ��.�!�ы:N�e_å4�Զ}�ӐS[�5\RCRm��pY����oƗ�BVqOJyqYE��{Tʋ�*d����U�*�a)/.��U��R^\V!��ǥ���BVq�KyqY������
Y�=1��e��j�'��ϙ����Rn��/�A:O���F:��n��y�`�#������A:O ��'�<�0z�^�WU�%z��U7i>��)D��#��dƽ��͐M�C.�!�6�0\>C>ma�����(�p�Y��RRj���4�Ԧ�KjH��#�UȪ�#2�
Y�=)��e�G�Q)/.��UܳR^\V!�������BVqOKyqY������
Y�=/��e��{`ʋ�*d�Ĕ��&�힘2��d��S^��Ja)����`�>{��&�ؾz��G�s`��A���~`��A���q`��A���y`��A���u�U�n��E龞�R�)��5))��xM�m3�hIJ��`�e1h�6���Ơ��E�<=�f��i��F�dФm-�A����G.A��l�\�.qOEyi�������r	��=��t�{0�K�%��d���K�%��(/-��KܳQ^Z.A������\�.qOG����e�����\6�l�t��>.���S�t���M0�{��Gp;pna����������s<���5x	���k����ҍ��}�]�n�����-�!�Qo�aСm-�A��l�,-�f�����*�<=�f��i��F�dФmgzJeP�m-��K�6Z.A������\B�x�Eyi�]➋��r	��=��t�{2�K�%�    �h���K�%��(/-��K��Qf,�]➎���e�c����_�q�<[0�	nΣ��ρ�d��.�8�ǁ�\��)x8�^�ׁWU�-xx����l>S0Z
C
�(ޖà�@Q�-�A�ъ�mYZ���ߖƠ��E�<=ƨ*(�A�1�
�d�d���RT�^A|�t�Ͻ���%�q� >r	�#��G.A�h�
�#��K<�
�#��K�{�K�%FUA�]bV�K�%VUA�]b�lt�>EC.]�(*��Ç��/��
���`�V3�n���w�ρm�0�Cp?��fx
���/����U��-xx��G�>�.JǙ�Ç����Z��0�0��A���k��ĠD��Z�e1h��FKcP����ǠG-�A��ŵL�dФq-�M*�*��k��KХq-�r	��/�eZ.�~DQ�&��K��Z��t�_\˴\�.��k��KХq-�r	��/�eZ.A��ŵD?r	��/�eZ.]��2}\v>��������`�s��n�\�w�ρ=�,�Cp?��%x
�\�/����K��-xx��P��i�?�d	��i���d���(���0��'�,ђ���K�hYZ��%K�45F�
(�A�1�
JdP�O.Y�e2h�'�L��ʠʟ\�D�%��'�,�r	���%K�\B����C.A�?�d��K��O.Y��t��K�h�]��%Z.A�?�d��K��O.��)��˟\�D�e�˟\�D�e�˟\�D����9,>W�/�Ɓ��8�]p;�'x~��	������8�K�8�'x���b���>���8�!xx��Pg�!��ŉ��(���0���8ђ��sX�hYZ�9,N�45F�
(�A�1�
JdP��a��-�A�?�ŉ�ʠʟ��D�%���8�r	��9,N�\B����[.A�?�ŉ�K���aq��t�sX�h�]�'Z.A�?�Ť�G.A�?�ŉ�K���aq�����aq���ɧu�����#��w����}��!�9�mdx
���/����}��-xض̩���:}� �!xx��Lg�i�?����(�rt����ĠD�>ȴ,-��A��1�ѷ2-�A�1�
JdP�o$24����ʠJ�>ȴ\�.}� �r	���L�%ԏ(*�]��A��t����KХodZ.A��}�i�]��A��\�.}� �r	���L�e�K�>ȴ\6���L����w�+~�.�`���v`� fx
~l�/���6���<l�s���/�>08���t�,>�˶n��C�|��h))��x����ђ�h�F�bТm-�A��}`�<=�(*�%2(Ҷ��ɠI�>0Z*�*m��h�]����r	������G�r	�����ti�F�%�Ҷ��KХmdz�%�Ҷ��KХm-��K�>0Z.]Z.��r��Ҿ�f�q��o�+NWȍ��͇x�Y��Sp;pna�������ނ��sg�s�͇x�I��!x8�������q���o�'6�!|����FKaHaśrth��FKbP��-�A�vJl�45�%q��<=�(*�$2(��ɠI;#6Z*�*��h�]���r	��b���GT�KХ]-��K; 6Z.A�v?��-��K;6Z.A�v=l�\�.�x�h�]����r���N����%3�7��z9��p����p��ng��̆��l�`�3�af��f6\���0�a|3�����0�a����
�'�<4��u��s�;�l�̆k�3�af��/��Z��#��dƽ��G6C6-��p�鴐2��3��R��А��ECFCFc�))��2��4�Ԓ��ԐT�*3\V!��Uf��BV-��pYE�QT��UȪŕ.��U�+3\V!�X�q�*d���UȪE�.��U�,3\V!�Zf��6Y��2�e�ɪŖ~�������th���O�����^���F:���[�C:�u���'�YZ؆��!z��Mm4DOҹ��n��UT��~"���m��I�_�5\2#Ɍ����i���KgH�m�.�!����GBCBm��p�Q�ҐR��5\NCNm��pII�}_�e�j���*d�6~�U�EUHY���ί�
Y��ߌwY���֯�
Y��_�e�j{���*d��UȪm�.�MVm���cU'h���1]?g2�A��l�^`?g2:B��l�`?g2�B��l��_?g2:C��l��_?g2�C��l�^_?g2:D��l�_?g2�D�f6\+x&C�S��̆{�d(t���l��pHf$�Q�P6C6ma�t�t� �p���IDƧ����(�p�Y��RRj���4�Ԧ�KjH��#�UȪ�#�UȪ$�U�EUHY���H�pY���L"�KV!�6�0\V!�6�0\V!�6�0\V!�6�0\V!�6�0\V���d�pYm�j�f���}S��g�����;7��l��<���-��>Y����h*�a��@3�Cp?�}�$�<l�+�p<l�+��#xx����2�?�23x�>���O���RRU��0��6���ĠD�Nt��bТm-�A��l�<=ƸW�$2(�6���ɠI�6Z*�*m3�h�]�f��r	���`���GT�KХmg:�ti��F�%��6���KХm-��K�6Z.A��l�\�.m3�h�lti��F�e�K�6��b�fp�Y�����3���v�����������~���7����~���5�^^E�0��t��y���FKaHaTœàC��t�ĠD�6Z�m3�hij��`��1�1FQ�&�A��l�LM�f��RTi��F�%��6���KХm-�P?���#��K�6Z.A��l�\�.m3�h�]�f��r	���`��ti��F���_���M�����qS���v`�mJ���O����~`�lJp�æC�<��5%�	^^E��#xx���y��?FKaHaTœà�@U=IJ�V�O��)�7�1�1zQ�!�A�1�
���YTp�d�d���C*�*cr	�ħ���K�%�T�>���"��]��E�C.A�(�Q��K�%�d�>�t�"�O�]��F�S.A�(�Q��K�%�t�>��e+�Q���F��HG��|�?��5������ŵo����ŵ������ŵ��~`��Z�!xؾ���&xؾ���G�:�*J���}�]�n��!~~���i))��xrt�_\˴$%���e1hѿ��iij�U��1��6��ȠH[d0Z&�&��k��ʠJ��Z��t�_\˴\�.Q���-�P?�(}�%�E.���%�E0���%�E2���%�E4���%�E6���%�E8���%�E:���e��V��w:���ϓ������{�Q���v`�5��N����y�Q�Cp?��%�ǁ=�(�M�<�g%�����q������(g:�Ok����0�0���aСF-�A�v�i�bТF-�A�va�<=�(*���YT24i�FKeP�F-��K;�0Z.A�(RQ���"e@.A�(rQF�K�%�`���t�"e4�]��FM.A�(�QF�K�%�p���t�"e4�ltيt����e+�Q�;���秉�+��>��_&
�hg�!��01�!�9��%&����,1�M�8�_%&�<�G�	�ׁWQ:u��oW����C<|%�h))��xrth	���h�F�bТ�#-�A���`�<=�2����`�ɠI[E0Z*�*m�h�]�"��r	�D��2�\B�XĢ�!��K�(c�%�E0�r	�D��2�\�.QD��!��K�(c�%�E8�r	�D��2�\6�lE:��pg�i��<����ɧu��l��L>��G�$8?�d�Cp?��$�	�\�?��=%�]�:�*Jǡ���:���t��yZ����¨�'�A�6>���Ġ�hE��,-�S�oIcPc���K�c\����ɠ�XE�TUƮ*(��K|�
�%�E*�Xr	�c�2�\�.Q䢌-��K�(c�%�E2��r	�D�2�\�.Qd��-��K�(c�%�E:��r���(c�e��V��w�e��Rxr���    /�{08��0����n���m���G�8���2����/�C�:�J7��t��y���;-�!�Q/�0�Ю��ĠD;v0Z����hij�S��1��.��ȠȘEC&�&���h���3��tiWF�%�E*ʄ\B�XĢL�%�E.ʄ\�.Q�L�%�E2ʄ\�.QD�L�%�E6ʄ\�.Q��L�%�E:ʄ\6�lE:ʄ\6�lE:��pg�!ޖK��'g;��\2�!�8���M�s���?���s����5x���k�����-����*�&|���d�~�0�0��=rth�dFKbP��-�A��Kf�45Z.�������#�A�1�
�dФ�-�A��Kf�\�.-�,�].A�(RQf�K��X���t�"ev�]�F�].A�(�Qf�K�%�h���t�"ev�]�G�].A�(�Qf��F��HG�g����_
��tx��S�7��z9<�p�)��p���g����Ma�`�3�a
���0\���0�a~S����w��0�)���y�;La���0�+�Doһ��&�+���1d|Jf$�Q�p�fȦ2.�!�v�`�|�|�)��j���hȨ3.�!�1�B�iȩ�3.�!�v�`��BV��!�KV!�(�R�U�-�R�U�*����d��",e.Y���HK�KV!�(�R�U�*����d��"0e.Y���HL�KV���"1enYm�ڊĔyf?���¶{���<��HWfa�F7эt�k�����Fwѝt�j���A:7��S�$�{��%z�^U��Mz�+���'ҵY����If�k�>��i���KgH�m�.�!���k����ڮ��22j˾�KiHi̪�rrj뾆KjH���f<d�j���*dER�
YE��"*e��BVQd���U�*����
YE���BV!�(�RV�*dE^�
Y���LY!��U�)��d��)�L�BGe)���u&C��������:���Y�7��v���d(tW���p=�^g2:,�Ka��_�3
]���0\ϯי�N��R����L�B�e)E��Mz<���u�)�6Ɍ$3�6�ٴ9����i���3��&�KhH��"�ѐQ�E.�!�6�0\NCNma�����8"㏬BVma��BVQ$��GV�z��JY��BVQd��GV!�(�R�#��Ui)�U�*�����*dE^�zd��"0e=�
YE�����6YmEb���d��)�;8ZJaX)׻���-�0����Y�����R�_
��.{}�FK)�/��z���C������p��^ߙ�R
��Ka�e���h)�a}Sn7��;1ZJaX)��}FK)�/��^��h)�a}S�RRE��f�ђ�h��F�bТm-�A��l�<=�f�����LM�fp��TU�f��r	���`��t�"eM�����EYS.A�(rQ֔K�%�`�5�t�"eM�]��FYS.A�(�Q֔K�%�p���t�"e-�ltيt����e+�Q�:.���S����Z�`8���]p;pna�����������s����5x��������������m>�OX��RRE��f�ђ�h��F�bТm-�A��l�<=�f���^���ɠI�6Z*�*m3�h�]�f��r	�D���?r	�c��?r	�D���?r	�D��?r	�D���?r	�D��?r	�D���C.A�(�Qv���_�W|�}��~ܔ�&��o��~�M	�����)�C�8�6%x
����/����*������C�<͟?��0�0��A�E� �A�ъ�A��)�ij�^�����DEƬ*(�A���
JePe좂M.A��lr	�D����\B�XĢ�&��K�(��%�E0�nr	�D����\�.QD��&��K�(��%�E8�nr	�D����ltيt���e��V����|�?�ؐ������ɦ?�ہ�M��2<����2<���2���ך2����t�#xx��A�<ď�3-�!�Q��aСm3-�A���`�,-�.����h�F�cУm2-�A���`�LM�C��TU���r	��-��t�"e�����E�C.A�(rQ��K�%�`�=�t�"e�]��F�C.A�(�Q��K�%�p�=�t�"eO�ltيt���N�����kߜ�t>��#~�{�Q�����k��!��S�<�{�Q���y`�4J�����q������(g:�Ok����0�0��-9:���%1(�#��ŠE;�0Z��0�hyz���%2(2fUA���UTpKeP�F-��K;�0Z.A�(RQ��K��X���t�"eo�]�F�[.A�(�Q��K�%�h���t�"eo�]���>�]➎��r����Q^Z.]�{:�K�����`��+~�G0엉	�ہ�01�C�s`�KL���g�	^�ǁ�*1�[�<�%
�Tg�!?lOp��E�8�|����-�!�Q/�0���퉖Ġğ�'Z�>؞hij��`{��1�1FUA���YT24�� �2���퉖K����-��K�SQ^Z.�~�Ǣ��\�.q�Eyi�]����r	��=��t�{4�K�%��l��ir	��=��t�{:�K�e��vOGy��r�i����k�G0��(	�ہ=%�C�s`OFI����(	^�ǁ=%�[�<�Ǣ�Tg�i��U���}�]��3�ɧu�|�!�RRE�9:��:dZ�����ŠE��C��1�ѿ�iyz��:dZ"�"c�24��`�ʠJ��C��t�_uȴ\�.qOEyi�������r	��=��t�{0�K�%��d���K�%��(/-��KܳQ�g�%��p���K�%��(/-��.�=���e�����q����ﵿp��0�Cp;�M 3<?�`���~`��ex��_�9�Y|���<�ׁWQ:u�e7��!^~�`��FQ�)�A�v�`�$%ڱ�Ѳ�h�FKcP��:-�A�v��%�A�v�`�LM�**��2�����KХ]9-��K�SQ^Z.�~�Ǣ��\�.q�Eyi�]����r	��=��t�{4��l�]➍��r	��=��t�{:�K�e��vOGyi�lt���(/}\n>��r�tW��C0�{��)�8���K�s���o�������l>��r�����}��u�u/]p���o�%3�!|���dFKaHa܋9:�\2�%1(�rɌ�ŠE�%3Z�-�,�!�A��Kf�DE�,*24��`HeP��-��K�%3Z.A������\B�x�Eyi�]➋��r	��=��t�{2�
�%��h���K�%��(/-��K��Q^Z.A������\6�l�t����%S�7��v:��C4H�!��St#���F/��<4z���0�g����Ma��_�t�����h�^�WQ�3�a
���0�+x�;LaX��0�K�$3��(j�d3d��ΐN�d0\>C>��p		�[��?22j��KiH�]3.�!���B>��j���*d��U�*�I)/.�H=z�JyqY��➕��
Y�=,��e��{Zʊ.��U��R^\V!��祼��BVqLyqY��➘���d��S^\V���{bʋ���,l�W��/=E�tnl���F:���[�C:�u���'ҡY؆��!z��Mm4DOҹ��n��UT��~"��m��I�_�5\2#Ɍ����i���KgH�m�.�!����)�!���k����ڲ��RRj۾��i�i���SRCRm��pY���¯�
Y�=)��e�G�Q)/.��UܳR^\V!�����X�
Y�=-��e��{\ʋ�*d����U�*�)/.��U�S^\V���{bʋ�:*�Ka�����y�`��H���[�C:�2}&C�ò�����K��A:O ���I:� �n��UT�L�B�e��k�d(t]�Ma��pKf$�Q�P6C6ma�t�t� �p���ID��АPE.�!�6�0\JCJma�����4�pII�q��
Y�y��
Y�=)��e�G�Q)/.��UܳR^\V!����,��BVqOKyqY������    �
Y�=/��e��{`ʋ�*d�Ĕ��&�힘���d��S^����Ja�)���^�q`��A���v`��A���׭����p;�~��l�<�0��'2���2�^^E龿ҭ����p/��7��°�)E��0�0���aСm-�A����&�A��l�45�f����h��FKdP�m-�A���
6����`��ti��F�%��T���K��(����q$�a �ڽ�b������F!i�sh��$�e	Z�}.�F�%h���(O-K��Q�Z��%�G�<�,AK��FyjY��x��Բ-�>�e�h�ާ�<�,-��t������ا����Ÿq��x|�矰š��8��-��q����)�7ο_���u���x(�7��ҍ����TK���װ2�E"�j�d4�����B"��`��T���V�1�h'���c��N[-� ���Z�A���
NQ)�d�ղ-�d�ղ-�>�e	��Ǣl,Y��x���Բ-�>�e	Z�}2�S����h���%h���(O-K���Q��Z6~����{�O���~�)�[q���mJ�Q�o�W���qc�ٔ�P<o��R���~�)�M��.�nw��ƧX�=��_�ϟ�"F�x2��b1Z�|R*F/��1��X�#Ǡc�b� ����<�J�.V��2H�X�#K��b�,AK�OEyjYB����(O-K��sQ�Z��%�����%h���(O-K��Q�Z��%�g�<�,AK�GyjY��x���Բl�l��Q�Z����}:�S_��q���W��[1nlO6��(n7��R����`S�C񸱽הc(�7��r���kM9���w�t1��b�b2�����a�0�œa��N3X-� �f�5�T��V�1�hG��c��N2X-� �d�Z�AI;�`�(��v��jY��v��jY��x���Բ�~��cQ�Z��%����d	Z�}0�S����d���%h���(O-K��Q�Z��%އ�<�,AK�OGyjY6Z���(O}-?������'ފqcl�⣸���)����u��X���qc�j�b(�7��F)n�׍}�Q���}�],7u?���K�=��O���V�0D���0hh#�b�.F�zH1�h#�c��.FX-Ǡ�]��Z�AH�a�$�����R�)Vp����V����T���%�{|��Բ-�>e�)K��Q�Z��%�'�<�,AK��FyjY��x���Բ-�>�e	Z�}:�S˲Ѳ�OGyjY6Z���(O}-'?����v�+n�ۙ�ϯ�skg�C<�lOq(�7�{�)��qc����x��o%��+^7�K�)���w�t�ԙ�ϯ�S����~�=�"F�x2~=خz1���`{��T�z�=�b2~=؞j9�lO� ����ܒJ�.Vp�2H�ZAY��_��Z��%��(m��=cQڑ%h�b.J;�-QFiG��%��(���D1�Y��(f��#K��p�vd	Z���Ҏ,-[1�qsg�Ӻ~��k�7��(�;�v?��_u�q(�7��()��qc���x��碤�+^7��()������un�,~Z������~Z�׫�a�0�œa��_uHu1��:�Z�AE�!�b2����c��_uȵ ����C�%��]�`�2H�ZAY����C�e	Z����C�����!K��\�Y��(�t��D1�C��%��(�-Q�F�%h�b8J�,AK�Q:d�hي�(�l�l�t��͝���y�}w��l~���{�8��`�����6 s����_���yc����P�nl�9����w�tK��n3�����a�0���2�m��D��VK1�hw�c�Ѯ:X-Ǡ��t�Z�AH��`�$��v��jQ)�T+(K��n9X-K��T�>d	���(}��D1�Y��(��!K��d�>d	Z��҇,AK�Q��%h�b8J�-QLG�C������҇,-[1�ss��C|l.Y�Wܹ�s�!>6��b(n7�?a���~����+7�?`���y����x*^7�?_���}�]-�V|n|��;����\�\/��X�%à��%�Z�AD�Kf���6��j1m.��r:�\2����dVK2(�ZAQ)�T+(K����z��D1�oYB��b,J߲-Q�E�[��%��(}��D1�oY��(F��-K��l��e	Z��ҷ,AK�Q��e�e+������)�o
����~7w8���Max�9����0��)�7�������7���v��;��p��0�޿�ws�S��Sޮ_����)�o
����~7w8���Ma(Vp�>�O���5o1|�C��G��0�}�G�!M��`�8C�v��ry�<�*����]�%����4Dj�,�i�Ԯ3X.�j�j!�
�څ���T!U�RFH�7Z�J!UHŬ�R�TQK!UHŴ�R�TQ�K!UHż�R�TQL!UH�ĔRmRm�Ĕ�6��bbʸ{?�.����MW�����t�,�x��Muc��Vw՝u�Y[=T��Wm�T=Y���K�b��Vo՛��V�>�O��w�'�m��c��3fkؤҴ����3�i'}-�g�ӎ�Z.�����\�!Q;�k�HC�v��r��L����B��)�KR���KRE1)et�"�F�Q)�KRE1+et�B�(���.UHŴ�ѥ
���2�T!U�RF�*��b`��R�TQLLC�M����2��P�R���������n��Nax�9<��P�Z����������Nax��=��P�b���������n��Nax�~=��P�j�����������Max_����>�
ޝ�����)�K8�	3�5��i�>���q�F���y�N����V����^��"��f��2��n��B��vDΗT!Uۏ�\��*�I)cI�7Z�JK��*�Y)cIRE1,e,�B�(���%UHŸ���
����2�T!USƒ*��bb��RmRm�Ĕ��ڤڊ�)�w�Na��w
����o��۳9�ۍ�Ճ�����A���qc{� �K�=y��x��^<��Q�o�����0�?>7>�ҝ`�|��;"F�xG�AC;l���v2�j)�d��b2��`��t���V2i'���dP�N�z~D����#K��N[-K��T���%�{,Ƣ̏,AKsQ�G��%��(�#K��d���%h�b4����D1e~d	Z��2C��%��(3d�hي�(3d�hي�(3�%�!��e���7οa���v���x*�7ο`���q���x+�7ο_���u����1>���w�t��ƧX:���+�Z�!�(2��`��D���VK1�h'��c��N[-Ǡ���Z�AH;��&ɠ���Z�A�8�
6Y��v2�jY��(���&K��X�E�M��%��(���D1e6Y��(&��&K��h��d	Z���2�,AK�Qf�%h�b:��ײ�c�~�{ų7Ÿq�[��+n7�[���yg��x�8o,X���}���u㼭`�Q�o�����ƧX���ǲ����"F�xC�A�@�zC�A�h��)��7�d�Q-���1�d2V���J�.Vp�2H�X�)K��b�,AKD��S����
NY��h�
NY����
NY���
��ĬVP��%V���-��\�-q�\�l�l�b�,-[+��e燸��k��<WW�������v�0�Sq��,��R<nl�
s��۱����v�0���x�xK�C��)��{:�����Z�E"�b�����Z��D��r-Š����k1�ŵ\�1��/��Z�AHq-�G�AI�>�Z�AJ�>�Z���mX-K��_\˵,��#�<�-�ŵ\����r-K��_\˵,AKq-ײ-��5��#K��_\˵,AKq-ײl���r}-?�㧸W���3�i_s�R<��\�O���>�,�K��%K�V<o�s�R|��\2��������d)��ƧX:��~Z��\�T�0D����_s�R-� ��\�TK1��5�,�b2~�%K���_s�R-� ��\2ՐdP�k.Y�E��S� d	Z�S� d	Z~�%K�,��#�    �,A˯�d��%h�5�,ղ-�撥Z����\�T����K������K�jY��_s�R-�F˯�d��e���\�T_�����X�[ȋ{;���u�8�Sq��_,N�R�o��S��������~�X1�u&?���bq�C��.���:���u�8ō����ũa�0���2~],N���_�S-Š����T�1��u�8�r:~],V=���X�jI%�.�Z�A�8�
Y���+8d	Z~],N�,��#��-�.�Z������T����X�jY��_�UOY��_�S-K���bq�e	Z~],N�,-�.��Z.~Z�Oq�xqog�Ӻ��A���vc;}�㥸��N�x+7��9>����A�����i]~� ǡx�xK�M��O���9n��u}�>ȵC�Q,ޒa��O�Z�AD?}�k)��A��d����c��O�z2�r-ɠ��>ȵ(��~� ײ-�)Vp������%�{D��[����>ȵ,AK?}�kY��~� ײ-��A��,AK?}�kY��~� ײ-��A�e�h�r-�FK?}��k��!�?Ž�Ž����/��ƶ�㭸��6 s|������}������uc���1���������o;}`qg|?��OX-�a�/���0hh��b�NX-Š��>�Z�AF;}��c��NX-� ��>�Z�AI;}`�(��v��jY���+�-��ղ�~��VP����>�Z����>�Z����>�5d	Z���e	Z���e	Z���e	Z���e�hisɬ�e����f��<��W�n!o��~��]+�x+n7�?a���~���17v?���[�����b(^7�?_���}�],7u?���[<�����V�0D���0hh���b��[-Š�]%�uc��n[-Ǡ�]$�Z�AH�Gl�$��v��jQ)��ղ-�)V����;�V��=�ZAY��v��jY��v�8�C�����Z���]�Z�����Z���]�Z�����Z���vu���-��|����vsx�͝;��Λ�VoՍu������&`���Ν��W�M@�C�d�7����:oZ�ToֻX���sg6�էX���sg6���)�p
3fTk(͐��(�\�!NRf�<C�6�,�K�!PSf�DC�6��r��HmP��2�ڤ2˅B�S,�*��O��K���+�\�H�QT)UH�ƕY.UH���|KR��e�KR��e�KR��e�KR��e�KR��e�K�Iզ�Y.�&U[f�UMW��N�������D��v��꣺�ο�\߽�H����Z������'������^��o��z���
޽�HW��N�Z=Y�;~��raFj�Ҵ����3�i'}S~>�y�Q_�����K4$j�}-i��N�Z.Ӑ���\�!T;�k�T!U|���*�j'~-�*�o�BJR�3�9�B�v��r�B�v��r�B�v��r�B�v��r�B�v��r�B�v��r�6���_˯�����lx�9|��P���̆�����.���lx��}��P���̆����������lx�~}��P���̆������.���lx�|}��P�&��̆��;C��h�3�W�����?��}	�	3�5�fH��!,g��6"r�������%���E"���e2��˅B��˥
��~��R�TmC�r�"�FQ-�T!Uے�y�*�j{�KR�M	˥
�ڮ��R�Tm[�r�B��/a�T!Uۘ�\�M��3a�T�Tm���phfC��L�t�����f6ď�4��߶QhfC��D3�Cq���X�c(7�Kr���{%9�׍�����ƻX����̆��Yf/�����ef�C�Q-���v28�S�AD;l���v2�j1�d��r:��`�����VK2(i'��e��N[-K��je	Z��`�e	�Q���%hi'���%hi'���%hi'���%hi'���%hi'���%hi'���%hi'���e����Z���v2��k	~�a'�ӝ�?�q���8�矰�P�o��7����lqW<o�������k�T�o���[�ύO�t����O[-�a�wd4���V1�h'���bP�N[-� ���Z�AG;l� ��v2�jI%�d�բR��`�e	Z�S��,AK;��|>��~�x]���%hi'���%hi'���%hi'���%hi'���%hi'���%hi'��������㷛�M�'ފqc�ܔ⣸���6)���~c�ڔ�P<n�7�R���~�)�M��kJqW�o��������K����5��Y-�aT�'àa�Z=!��)��1c9c+A!c+I%c+Q)�+Y���T+(K��SQ�Z����},�S����\��i�-�>�e	Z�}2�S����h���%h���(O-K���Q�Z��%ާ�<�,-��t���e�e{����ײ�C���5�+~�7��R�?�ۍ�ŵ��~c{q-�P<nl/��)�7��r��ۋk9���w�t}*>7>��-��Cܿ^\˵C�Q-�����Z������Z��T��r-� ����k9�ŵ\2�/��Z�AIq-עR�1�e	Z�)�e	Z�}*�S��=��E9�)K��sQ�Z��%��<�,AK�OFyjY��x��Բ-�>�e	Z�}8�S����t���e�e{�����r��:~|�ѿ��|��>�H1�v?�����8��X�C�O5JqS<o�C�R���L���ƻX:n�~Z�ϩ�n1����#�a�0�œa��.F�z1�h#��bP�.FX-� �]��Z�AG�a� ��v1�jI%�b�բR���e	Z�S��,AK�OEyjYB����(�sd	Z�}.�S����`���%h���(O-K��Q�Z��%�g�<�,AK�GyjY��x���Բl�l��Q�Z����}:�S_������^�	��L~���LLq(n7���)��~c����x�د%��+�7�[�)�׍�Rb���}�]-�R|n|��ی�x���E"�b�B�AC;�`���v�j)�8��b2�i��t��V2ig��dPҎ"X-� ��D�Z���D�Z��%ާ���,����X���%h���(O-K��Q�Z��%�'�<�,AK��FyjY��x���Բ-�>�e	Z�}:�S˲Ѳ�OGy�k��i]?>��>����O����()���>%�P�o�QR���`�w���>%�C񺱏EI�T�o���[�ύO�t����.�>�Z�!�(��0h(V�1��X�.Šb�b����1��r:�,V�2�X�.ɠd�jE��S��,AK|��%h���('�,����X���%h���(O-K��Q�Z��%�'�<�,AK��FyjY��x���Բ-�>�e	Z�}:�S˲Ѳ�OGyjY6Z���('����!�v�A7��8�ƶ�c(n7��7��ƶ��x����r<���_���uc����R�o���ۊύO�t���o���%�a��d4��V1�h���bP��:X-� �]u�Z�AG��`� ��v��jI%힃բR�5�e	Z�-�\oY��x���Բ�~��cQ�Z��%��<�,AK�FyjY��x���Բ-�>�e	Z�}6�S����p���%h���(O-�F��>�đe�e{�������C|l.��?1���7lqS�n��w����l�P<n��O�����k�R�n��o��ƻZ������/��s�!>>��j��}��a���Y-� ��%�Z�AE�Kf���6��j9m.�ՂB�\2�%���dV�2His�r�-�)V0d	Z�}*�S��=��EyjY��x���Բ-�>�e	Z�}2�S����h���%h���(O-K���Q�Z��%ާ�@����}:�S�o�)�7�����SC5X�M@����:oZ�Uw�y��z�Λ�VOՓu��z�^��&��[�f��<��S�������S^��	3fkؤҴ���3�i7,�g�Ӯ2X.���e�\�!Q��`�HC�v��r��L�:��B��}��w�B�v��r�B�x����RE����Jyr�B�x����R�T�>,�ɥ
��}ZʓKR����'�*���y)    O.UH�S�\��*�'��6����)O.�&��>1�ɯj�;v�WW������ö��n����꡺��?k����:���^�'����z�^��o��z���
޽Na��)�+x78�!����S��0�X�)͐���\�!N;�k�<C�v��r��@������a_�E"�Ӿ��4dj�}s��B��KR���KR����'�*�o�}TʓKR����'�*���a)O.UH��R�\��*�ǥ<�T!U��Kyr�B�x�r��
��}bʓK�I��OLy�Ke�Sޮ?uS�y��ꮺ���V՝u��z�����K�d�w �ު�a�Q�Y�b��P�r�����;C��eSޗ�3fkx�Ҵ}��ⴍ�������%���E"���e2�݈���PC��a�T!Uۏ�\��*�'�<�T�~��R�\��*�g�<�T!U�Kyr�B�x����R�T�>.�ɥ
��}^ʓKR�����B��*�'�<�T�T��Ĕ'�j�j{����6��Nax�W��]1nl��x(n7�Wr<�ۣ9^�Ǎ�̓o�����A���uc{� ��1h
~�0�/��/��)�K�����0�o
���A�!�(2��`��D���VK1�h'��c��N[-Ǡ���Z�AH;��&ɠ���Z�AJ;l�,AK;l�,AK�OEyjYB����(O-K��sQ�Z��%��<�,AK�OFyjY��x��Բ-�>�.K���Q�Z��%ާ�<�,-��t���e�e{�������Բtg���7οa���v���x)�7ο`���q����(�7ο����u���8��b���b�Fc|?�_�ʬa�0��2��`��D���VK1�h'��c��N[-Ǡ����d�N[-ɠ���Z�AJ;l�,AK;l�,AK�OEyjYB����(O-K��sQ�Z��%��<�,AK�OFyjY��x�rڒ%h���(O-K���Q��Z6~����{�O���~�)�]q���mJ�P�o�W�R<��ͦ/���~�)�[��kJ�Q�o������ƧX�������j��X�-àa�X�-� b�b����ы��b2ƨP�Aǘ�

2�ZAI%c+xD��S���%h�O��G��%��(���=cQڑ%h�b.J;�-QFiG��%��(���D1�Y��(f��#K��p���%h�b:J�ȲѲ�Q�G�������?ײ�C��`C�W�?]1nlO6�x(n7��r<�ۃM9^�Ǎ���o����\S���uc{�)��Q�o����P|n|��0�����a�0���4��B"�a��T��V�1�hG��c��N2X-� �d�5$��sV�2Hi���%hi���%h�b*J�,��c1�C��%��(�-QF�%h�b2J�,AK�Q:d	Z���қ,AK�Qz�%h�b:Jo�l�l�t��͝�O��y����b���x(n7��F)����}�Q���qc�j��x�؇��(^7��F���3�i?�X:n�~Z��)��{:����#�a�0���2����D��VK1�h#�c��.FX-Ǡ�]��Z�AH���!ɠ�]��Z�AJ�a�,AK�a�,AKSQ��%�{,Ƣ�!K��\�>d	Z��҇,AK�Q��%h�b4J�-Q�F�S��%��(}��D1�OY6Z�b:J��l�l�t��͝���z����;�v&?�����O���~11�Kq���KL�V<n��S|���D��֙�ϯ�S���w�t�ԙ�ϯ�S����~�=�"F�xK�Aï�S-� �׃���bP����T�1���`{��t�z�]�d����TK2(��`{�E��z�=ղ-�)Vp��D1�oYB��b,J߲-Q�E�[��%��(}��D1�oY��(F��#K��l�~d	Z��ҏ,AK�Q��e�e+��tn�,~Z���{�O<��>%�Sq���FI�R�o�QR���`����>�����u��9����}�7u?��_u�qc|?���U�\�0D�7>2���b�_uȵ����C��d�Wr-Ǡ����d�_uȵ$����C�E��Wr-K��_uȵ,AKSQF��=cQF��D1e�,AK�QF��D1e�,AK�Qd	Z���2 K��p�Y��(��ȲѲ�Qd�hي�(��;�����^�OŸ�m�x)n7��o��ƶ��x����R�}���;��uc���1��b鸩��!�v�����~���w�Z�!�(��0hh��b�.;X-Š��u�Z�AF���.Ǡ��t�Z�AH��`�$��v��jQ)횃ղ-햃ղ-QLE]����2�,AKsQF�%h�b0��-QLFC��%��(c��D1eY��(���!K��t�1d�hي�(cȲѲ�Q7w?��撥{Ń{;��cs�,ފۍ�O�⣸�8��s̍���d��y�����׍����x�xK�M���d��C||.��"F�x2�\2��D��dVK1�hs�r��d��dV�1�hsɬd��Y-ɠ��%�Z�AJ�Kf�,AK�Kf�,AKSQƒ%�{,Ƣ�%K��\��d	Z��2�,AK�QƖ%h�b4�ز-Q�F[��%��(c��D1elY6Z�b:ʸ�;��)�W������?�����;��)�7������Max��=���0�o
����q7w8�S^�_����)����z�z��Na������;���0�������?��}	�0#aF���i�E��ⴛ��3�iWR>?��]�%����4Dj�,�i�Ԯ3X.���g�\���]h�\��*�I)�#U��h1*e~�
����2?R�TQK�!UHŴ�R�TQ�K�!UHż�R�TQL�!UH�ĔRmRm�ĔRmRm�Ĕy�~"]2;ݛ�ϻ��Y��^����:��s}�~"�3;�ku����j������z�οi����z+x�~"]6;�k�d��t�1_˅	3�5�fH��Z.�����y�g�ӎ�Z.�����\�!Q;�k�HC�v��r��L����B��y_˥
�ځ_˥
����2�T�~�Ũ�٤
����2�T!U�Rf�*��bZ��R�TQ�K�]��*�y)�KRE10ev�B�(&��.�&�VLL�wg�S�7�����;C��)�7�����Max��=���0��)o�����Max�=���0�o
����yw�8�S^o_ϻ3�)����wg�S�7��}���0��)�
3fTk(͐��CX.��mD�|�3�i;�4j[�K4$j{��4Dj���4dj��5�j��KR��˥
����2�T�~�Ũ�9�
����2�T!U�R�*��bZ�\R�TQ�K�K��*�y)sIRE10e.�B�(&��%�&�VLL�K�M����2�6���0��)o���߾Q���;���Z���6j���~�0��˞�FMS����k��oӨi
C����z+{��5Mah�S^/eϿ-��)�w
�����c�4���Max]����)�w
C�t�����Ma(�N�!¨O�AC;��#� ���Z�AE;l���v2�j9�d�ՂB��`�%����V�2Hi'���%hi'���%h�b*�<��~��X���%h�b.����D1e}d	Z����>�-Q�FYY��(f���,AK�Q�G��%��(�#�F�VLGYY6Z�b:��\K�C;��,��(ƍ�o��P�n��Cq�q�[�����]�q��Z<�矯�S��n)>7>��m��C?l�C�Q,d4���V1�h'���bP�N[-� ���Z�AG;l� ��v2�jI%�d�բR��`�e	Z��`�e	Z�����,��c1e5Y��(梬&K��`��d	Z�����,AK�QV�%h�b6�j�-QGY�Z6~��O�^�j[1n엛R|���&�����د6�8��ͦC�_lJqS�n���R���b��P|n|������5��Y-�aT�'àa�Z=!��7�T�^��c�1F��C�Aǘ�
A!c+8$��]��e�2N��    C��%>�
��D1eYB��b,��-Q�EYS��%��(k��D1eMY��(F��)K��l�5e	Z����,AK�Q֔e�e+���)�F�VLGY�Zv~��lH���<�qc{�)�룸��^l�q(�7��r����^S���yc{�)�]񺱽֔�x�xK���s�S-�b|?���3X-�aT�'à��f��b�3X-Š��e�Z�AF;�`���v��jA!� �ՒJ�9�E��cV���SV��D1emYB��b,�:�-Q�EYG��%��(���D1eY��(F��#K��l�ud	Z����,AK�Q֑e�e+��,n�~Z�O�^�����u��`#ƛ[;�����s�R���}�Q��x�ا��)�7��F)�׍}�Q���}���t��:����s��[��u���E"�j�d4���!�b��R*����d��V�1�h#�d�.FX-ɠ�]��Z�AJ�a�,AK�a�,AKSQv��=cQ6d	Z����!K��`�Y��(&�l��D1eC��%��(�-QGِ%h�b:ʆ,-[1eC���������3�!�_��^�����x~=؞�P�n�S���~/1�M�_KLqW<o�S<����O��ƻZ�����TK����~�=�"F�x]�Aï�S-� �׃���bP����T�1���`{��t�z�=ՂB~=؞jI%�lO�(��_��Z���׃���%h�b*���~��X�=d	Z�����,AK�Q��%h�b2��-Q�F�C��%��({��D1eY��(���!�F�VLG���Y������ͽ��O��Wr�ۍ}4J�����'���)7��()��}.J���uc���x�xWK���j�6��i]_�:�Z�!�(o�0h�:�Z�AD�!�R*���c��_uȵ����C���Wr-ɠ���kQ)�U�\���Wr-K��T��e	���({��D1eoY��(��-K��d��e	Z����,AK�Q��%h�b8�޲-QLG�[��������,-[1essg�C����7�v6?���=X��ƶ�㦸��6 s����_���yc����T�nl�9^���w�t[���0����R}>"��❏��v��j!����R*�]��d��V�1�h7�d�.:X-ɠ��s�Z�AJ��`�,AK���%h�b*�	YB��b,�	Y��(梜�%h�b0�	Y��(&���%h�b4�	Y��(f���%h�b8�	Y��(����e�e+��ȲѲ�Q7w?��撥{Ň{;��cs�,n�ۍ�O�⮸�8��-�Ǎ���x�8�~-^�׍����x�xWKw��b鸩s�!>>��j��X�&à��%�Z�AD�Kf���6��j1m.��r:�\2����dVK2(isɬe��������dV��D1�tYB��b,��-Q�E9]��%��(���D1�tY��(F��.K��l��e	Z��r�,AK�Qΐe�e+������)��)oW�������7�����;�����0���>ws�S������n�p
C����z����NahS^�_����)�o
����s7w8���?��}����+xww8���?��}	�0#aF��S�!M��`�8C�v��ry�<�*����]�%����4Dj�,�i�Ԯ3X.���g���*�j,�*��bR�YRE���RΒ*��bV�YR�TQK9K��*�i)gIRE1.�,�B�(楜%UH�����
����r�T�T[11�l�6��bbʹ{?�.����MW�����t�,�x��]uc��V՝u�Y[=U��Wm�R=Y���[�b��V՛�.V���D�lv���`��t�1_˅	3�5<�i�A_��ⴓ���3�iG}-h���Z.ѐ���\�!R;�k�LC�v�Wy|>��T����r�\�ȯ���`�>,�_/Y�������h!Z�L������Ȕ�p!\�M��K���ؔ�x!^�N������蔧�B�x��o�o{��򯿾�a�;����)��yWޘ��χ��<�Gx>��yG��|2�{�o�yޕ��(��w��w�(t��w4C��w�(t�����+	�Fb�j)!א��Ox/���Px/ِ��Qx/���Rx/ې��Sx/���Tx/ݐ��UX����
����~���|�>J�_/_����0��|!_��S������@��|!_��T������P��|!_��U������`����|�>Z�_/�&��>[�_/�&��>\�_���5���Nlx�����qk{#�꡺���H�z�7�^�ǭ����yk{#��z���H���&S����;��X��M����wrC���L]����b	�0C�Q��fP�{.� ��(�\�AO;R�@��v��s�E�P��"�کb˧L��v��s�Q�\��RU�`��RU�>U�_.U�7�>W�_.UP�U��RU�>[�_.UP��U��RU�>_�_.UP�V�|IT�����TAU�OY��K�Q���Y��K�Q���Y��_U�;��t��_=T������T�n��^/����g��V=n��^����Gm���^�οi�C����VpC����Vp7��;�5 �sa�0�Z�-͠��7�\�AN;p�<��v��s�A�ȱ��ڙcˏH��v��s�M�Ա�B�ڱcϥ
�ڹcϥ
��}�ʿ\��o�}�ʿ\��*���˥
��}�ʿ\��*އ��˥
��}�J|�#UP�X��RU�>��_.UP�CX��W��K�~��/���j�:o[x=T�[�]���~�i��R=n��,�ު���G��uޱ�:>���w���ϭO����K�|��sa�0�ZÐfP3P-b�3��ZŐg�3z����(�Q�Aј�B�4H�ZH�4h�ZH5��ZHHTŧZHHTET	�B�QT	���h�BB��*z��RU1ʅ�*��Y.�TAU�j!�TAU�j!�TAU�j!�TUۧZ�&�F��B��������/C���j�ڎ8Z=U�[�G���~k;�h�V=nmG�>���c��G���q�:T�[�j;T�[�j�o����_/�Y.�fTkإ��7�,g����\�AO�r�A�8�%�w�r>D$���,�i��_��\�AT
�r������RU�18˥
�FQ-�*�j;�KT��	ϥ
���p�KT��r>�
���p�KT�7�,�*���Y.�FU��:��?��C5n���r=U�[���\/���>?-�[���P��Q=o��Rͭ�������P�o�������w|Q�uc}?��{�Z΅j�4��_s�r.� �� ���3��5I-��~�R˹D��_��R�E$���s�M����\�Aԯqj9�*��5O-�RU���\��o�Bn���h�BJTE/R����P��KT�����#UP�k�ZΥ
�~�U˹TAկ�j9�j���d��K�Q�k�Zί��wz~]��7���S5n���s�T�[���\o���~?:�G���_�V�M~����\��uk�"�k�޷��
�G����uI:ם��N��[�9f3�5�G�Aͯ{�9g���t�����)�s�A��J�<$��+�s�I�.K�\�Aӯ��9j��tΥ
�~ݗιTAկ�9�*�E��RU�ʅ�*��^.�TAկK�)�TAկ[�9�*��um:�RU��M�\������K�Q���tί��w��ߜ�WOո����z�n��3Vo���vf��z���L�{G���g&����vf�j�޷��
r�h�û�̄՝���3�3��6i5�̄��r��	����3�4�g&r�%�3��4H�g&,�i���LX.� ����\������\������\��o�BJT�3�KTE/R��������*��g&,�*��g&,�*��g&,�*��g&,�j�����\���~f�����?����K5nm[�Vo��ֶ�h�Q�om������wzۙ	�C���m7Z��ֶ�huS�o������wzۙ	�����~f�sa�0�\Ci5�̄��rڙ	����3�/�A�̄��ڙ	�E$�3��4hjg&<j��Lx.UP��Lx.UP    ��Lx.U�7�r!�
�ڙ	ϥ
��W��
�ڙ	ϥ
�ڙ	ϥ
�ڙ	ϥ
�ڙ	ϥ
�ڙ	ϥڨjS�<�j��=��U=�N�w�[�����?l���v������G���c�������W�5T�[���M��u�M{�U�[�j�qt��>v�����~��߻�\�!�(�P�AM�w��8��v�:��#Ϡ�ݻ�\�AP�w��D��v��s�I�޵�2�ڽkυD�{מKT�{מKT�{מK���\H���v���*��^-dHT�{מKT�{מKT�{מKT�{מKT�{מK�Q��]{��*'^���o����[9��MGϏ��<o:Z~7�8����x���/�y�t��'���yS���MGϻ��|Wy7�8���M�(�� q�E��/��k$�(�R�!W��`C�6���&ِ�|�^�!Z��lC�6��{�pm������7����o����o����o���w�r=���U�����W�����8���� 8����(8����08����88����k἗o��������;|aG����v��"]�;�l��_�t�/�P�硼3Ͽuϡ|0�?uϛ��<��=����C�|(��w��w)�]���͞/�����m�^��X�\J��\�t��S�!X;��dC�v��{цh퀳����	g�µ#��K7�kg��o��9{/_��N9{/_�׎9{/_��-��\�|�����|ѫ�\�|�����|�����|�����|�����|�����m����__]�����~��ݧН��	����}
]�����~���ݧЭ��	�����}
]�����z���ݧн��	����}
]�����~���ݧ�ͽ�	�B�ݧ�ս�	�B.��,�78�k$�(�R�!W���6k{�K6$k�ދ6Dk���6dk��7�k��K7�kދ7�k;�������^���E�ݢX���/�k���������~���|m��{�B����|!_���^����yx/�&_���^�M�6m���?bhB���is��v���M�?>m��P�nm��X�������M���='cuW=om��X=T�[�s2VO��ֻ\������+�Y���?_��<f3�5�4��v�sq9�8���z�qh���ОK4(jǡ=i�ԎC{.Ӡ���\�AT;��TAU;��TAU;my�*�E��M�����\��*z��M�����\�����\�����\�����\�����\���v�s�6��qh��U�Ӱ���x���?l����:���n�������z�:��������z�:���^���w��[���)W��i�qhˇ0C�Q��fPӎC{.� ���\�AO;��@��v�s�E�8��"��qh�e4��О5�jǡ=�*�jǡ-�RU�8��R�~��rJT��ОKTE�rJT��ОKT��ОKT��ОKT��О_��Oc��;`�x��Q�[��T���vk���P�o��r���~�+�M���_��uW�n���r=T�[�j�T}n}�\�隣���sa�0�\Ci5�"nq9�U����^-�h4F��[�Aј�Bn�IcU�e4�]-�j5N��RU�)R��*��4}K��Vsi��*��j0M?RUQM��G��*��4�HTE5���������#UP�t�~�
��OӏTU[5���6��j<M?W��;����tO{|>�qk{f��P�nm��Y����О�M�����guW=omO�Y=T�[�[{VO��ֻ\������+�Y��t�zn�ra�0�ZÐfP�ܳ\�ANq�ry=��=��7�,�hP�ݳ\�ARu�r�M��=˅D�w�,�*���Y.UP�X��B��j.̀TAUT�i�
���L3 UP�h�����f�HTE5�f@��*��4RUQ���j�j���n ~xǏϛ��'�_s�h��;~|�T�Cu��O��5T�[���\7���>k*�]�������P�n퓦r=U�[�r��s�S��f}?��o�x.�fTkإԴ�"��3�i7E<�g��n�x.� ���\�AQ�)�H��vS�s�M����B��Mϥ
��Mϥ
��K3�T��h5�f����ӌ!UP�d�1�
��M3�TAUT�iƐ*��j8�RUQM�C��*��4cH�Q�U�iƐj�j���n M~�����=���������K����vk�ә릺�گt溫�������Bg���uk�ϙ�z�z�+�U�[�r����~���%�fTk��Դc��3�i�(<�g��Qx.� ����\�AQ;B�H��v��s�M� ��B���	ϥ
���	˷TAUTciƖ*���Ҍ-UP�`���
���L3�TAUT�iƖ*��j6��RUQ�[��*��4cKTE5�fl�6��j<����w��t]��?Z��N�k�n���4�n���}4M���qk�L��z����z�^���4�^���w��[���)W���;9�a�0�X���fP3P,���3��X���g�3z���#� h�b�G�Aј�BΏH���ʅ�i�4v��B��)R��*>�B�TAUTcifH��VsifHTE5�f�TAUT�ifHTE5�f�TAUT�ifHTE5�f�TAUT�ifHTE5�f�TU[5�fB����O3������v$_���?��No��uS�nm;�Vw��ֶ�h�P=nm��VO��ֶ�h�R�nm��Vo��ֻ\�����T+ȍ����� �3��6i5�����r��������4jw?<�hPԮ~x.� ����\�AS���P��v���.UPծ}x.UP�X�٥
�F��4�KTE5�fv����&��.UP�h�٥
���M3�TAUT�if�*��j:��RUQ���C����O3�TU[5�fr��;}l�\��=�t��>6B�뮺�:����������z�:���^�����z�:���>���w���8:�N!�u�����#�<f3�5��j�9���r��3�i#�<h�F�y.Ѡ����\�AR!�L��6B��%� ����\������\��*��4sI��Vsi�*��j0�\RUQM��K��*��4sITE5�f.�������%UP�t���
��O3�TU[5�f�$��#/ޯbϻ�đ�o���M�y7�8�b���x��>�G^��������@�ȋ��ȋ�k��n q���y�~�}�$��#/�/�ϻ�đ�o�E��w�#/��ȋb!�G^��G^+y��5��<r��������K6$kw;�m��.wx/ې����^�!\���tC�v�#��#��]��^������^��/�Q5�#_��m5�f}���V�>�|QM�Y�B���լ�|!_T�j�G��/��5�#_��Ě�|Q��Y!�&�V��Y!�&�V��Yw)ҥ��#��*���K�n兝i�|(o����3Ͽuϗ��<��=��'��K��(_�����n^��f�C�a~���L�n煟m�^��X�ZJ�5�j���l֎7{/ِ��o�^�!Z;��lC�v��{�p툳�M�!];��xC�v��{�B�v��{�B��Fլ&_��m5�f5�B���լ&_�մ�����W��|!_T�jV�/�j`���|QM�Y]��/��5�˷ɷU#k��}
���y�~{�ݧ�%�ߑ�7���}
���y�~�}�ݧ�5�ߑ�����}
���y�~�}�ݧ�E�ߑ����}
���y�z�}�ݧ�U�ߑ�B�ݧ�]�ߑ�B�ݧ�e����J�Fb�j)�\C����`C����dC����hC����lC����pC���a��nH�6:�o��v:��/�k[���E5�fM�"�n�Y5k��E5�fM�B���լ)_�ո�5����W��|!_Tk֒/�jb�Z�|Q��YK�M��Y��|�|[5�f�mNM����#/��i�������w���5���555�b���x���v��F^̿���������ȋ�;������ۗ�y1G^��u_�RS#/��ȋ����oWjj���yQ��ߦ��ȋ�;�X��=����o�E��[�!̨�pK3�iǡ=g�ӎC{.Ϡ���\�AP;��D��v��#� ��    �\�AS;��P��v�s���v�s�����Ҭ#U�7ZͥYG��*��4�HTE5�f����FӬ#UP�l���*��j8��HTE5�f�
��O�?RmTm�x���j�j�����U��>`.�ߟ���?l���v����z���?k���q����:>�����P�n��^C����V0��s�S�`t��;�5W�sa�0�ZÐfPӎC{.� ���\�AO;��@��v�rH4(jǡ=i�ԎC{.Ӡ���\�AT;��TAU;��TAUTci6�
�F��4RUQ�ِ*��j2͆TAUT�iv�*��j6�nRUQ��M��*��4�]��Oc��;`�x�[W�[��\���~,�Su��_ ��R=n���r�U�[���\���~�+���z�zW+�C����V����46�4z.�fTkإ�T����V�b�g�3z����(�Q�Aј�B�4H�Z�!Ӡi�j!�P��q��RU�rHTE5�f�B��j.�RUQ��C��*��4{HTE5�f����f��!UP�p�=�
���N��TAUT�i��j�j����)�F�V����v~��������qk{��ꩺ��^��z�ǿ�ުǭ��/���yk{�+��z��^��:T�[�jT�[�jWc}���Oax.�fTk��Դ3��3�iG0<�g��N`x.� ���\�AQ;a�i�Ԏ_x.Ӡ����\�AT;|�TAU;{�TAUTci��*�����-UP�`���
���L��TAUT�i��*��j6�>RUQ��G��*��4�HTE5�f�6��j<�����w������z�ƭ}�T���vk�6�륺�ڇM�z���YS�>��}Ԕ�í�����IS���ֻX�Í����9�
�~x���\�!�(��|�Դ�"��3�i7E<�g��n�x.� ���\�AQ�)by�4Hj7E<�i��n�x.� ���\�����\��*��4'�
�F��4'�
��LsB��*��4'�
��MsB��*��4RUQ�9�*��j:́TAUT�i�ڨڪ�4RmTm�x��������[���}�4���?~�3�Ku������V�o�W:s}T�[���Ts�h�;=�Bg�C������5T�[�j�q4���?�ZAnM~����\�!ְ̨I3�i�(<g��NQx.Ϡ���\�AP;Cay�hPԎPx.� ����\�AS;@�P��v~�s���v|�s�����Ҝ.U�7Zͥ9]��*��4�KTE5��t����FӜ!UP�l�3�
��Ns�TAUT�iΐ*��j<�RmTm�x������w?���������w?�^�ۭ}6M���~kM��z��'Ӥ�{G����~X�׭}.M��z�zW+ȍ����w?���w}��a�0C�Q��fP����\�AN��ry=����w?r�$�w?,i�����\�AS��r�Q��˥
����KTE5��,�B��j.�YRUQ�9K��*��4gITE5��l����fӜ-UP�p���
���Ns�TAUT�iΖj�j��Ӝ-���:��Hz�Y^ϻ�3U?��|�_�)ۏ2�sn;��&�԰����<n M��36A�������{z�"H�z,::�A?�Ǣ���nM��3�@�.�k��nZ�����􀞋�]�8���gl�$}�^����đYȬ���,ی����Y�����3�?6���Z��c�l4V?GiYil~$�Ӳ�X�H�e����8Ve����8Ve�jbi^��6�4/�U٪�`�ǪlUM2M}Ve�j�i^��U5�4/�U٪�p�ǪlUM:͋cU��&��ű:lu4�4/��a����y�e��=�D�ܶ���Z��v��X�~��v���=�D�\�}.z?�I�Z�~������3��==�
�q���~"B.��������K���jk�Ͳ͈�K�e�!��g�gD�%�вЈ�K�e�!�8J�J#B.q���F�\�H-K��ı*[��ı*[UK���-8g�ɥ�~)�V��|?�	n�j�i��v�U5�4�o�۪�l�����mUM8��sgඪ&���-p[UO��B��a�����~�w���y��*���2�2�7�����j 9���/�⯽����O�{�1q�_���c��6�7?����r5�yq�F^4�\$G^\�E^t�DkmZ�-%^��ّ<b�������l�v$��Bm,w$���mlw$��Bn�w$���n�w$��Bo,x$�_�76<�ǯ�&��;�~;�MV�w�<~Մ�|gF��WMZ�w<~���|/���WM^���4<~��|����WMb��V'<~�D�|o	��Md���<~GY����-�U�4o���k3�2����W���������0����~ߏz��2�������~�?����r��j[ΫmN�6�k�r�9y�֦��R�����?�-��xs�-��|s�-�ƀs�-�Ƅs��-�ƈs��-�ƌs��-�Ɛs��~c�9y�
�j�j��N�۹m�j����UV���2<~դ�|�1�_5q5�_���&���$<~��|/�ǯ�Ě��s��UY�}q��Md�����g�'���U�o��2�76_ݧb�'��������񽵑��O�{o#�~ߛ��񽻑�	>�Ϯ���T���D^t����ZV68�GkmZ�-%^���^�-�F�#y�f�ɑ<j���H���hs$��Bn�9��na7ɣ������+�F�#y�
�j�j^���m�U��
�j�j^�¯����ǯ�&����+��ɫyy�
�jk^�¯�Ě�ǯ�&����;�;�Ț�����h"k^��?qyq�D^�����l_�Zt��tA�EǃA�Xt���>�a}@_���0�>��E�cA_�sѳ���,�i+8M�����M	�YȬ��'6�6c:qt�u�8t��,��q��Z�Љc�l4ơGiYi�C'�Ӳ��N�e�1�8Ve�1�8Ve�jbi��Xg�ɥyq��V�Ӽ8Ve�j�i^��U5�4/�U٪�l�ǪlUM8͋cU��&��ű*[UO��X�:�x������Ӽ_�U��΀�m��Z��v҂���u��X�~��>��E�:��Z�~�����E�g:�z.z���Ϣ�����uO��>�YȬ���e�1�8:�:c:q|�}�8t�-�q��1Z6�Љ���4ơ�i�i�C'�Բ��N�������lUM,͋cU��&��ű*[UL��X���I�yq��V�DӼ8Ve�j�i^��U5�4/�U٪�t�_V����/w��x����+`��������.�cѹ �ӂ>��_;=��E���N���s�k�O���TP_��觭�mz]�#��đYȬ���,�,uE,t�u��X�,���+c!�,�ή��ѲѺ�BJ�J��
Y8-;����Z�ZO[H��V����U5�4/�UqF�\���*[UL��X���I�yq��V�DӼ8Ve�j�i^��U5�4/�U٪�t�ǪlUM<͋cu��h�i^��VGO�����{��q�mO�4����x�+���׿����x�+�}.:��
���O}Bߋ�������g[��Y��Vp�^���S�#��Y]l�m�F��,����Y��#�,40�h�h�_$�Ҳ��H�e�1}�8R�Rc�"q��Vc�"q��V��ҔN��3��Ҽ8Ve�j�i^��U5�4/�U٪�h�ǪlUM6͋cU��&��ű*[U�N��X�����yq�[M<͋/��/��_�M}����G�/��_�M�tA�Eg��N�Xt�M��>�YS;}@_�Ψ��>��Eg��N_�sѳ���,�i+8M����M�đYȬ��76�6cS$qt�uƦH��,��M��Z�"�c�l46EGiYil�$�Ӳ��I�e��)�8Ve��)�8Ve�jbiJ��6�4/�U٪�`�ǪlUM2͋cU��&��ű*[U�M��X���	�yq��VդӼ8Ve�j�i^��VGO��X�:�x��H����_nuzO��Z�ΥΝ�Xt�t��>�+�;}@��΍Ν>��E�B�N_���s�s�o���VpB?�~�
>��=}� Ŏ�/d2�����f�f�Q$�βΘ�H�e�1D�8B�Bc�"q����E�(-+�	��qZv    �#�,5�'Ǫl5�'/��V��Ҽ8V�mri^��U5�4/�U٪�d�ǪlUM4͋cU��&��ű*[UN��X���I�yq��V��Ӽ8V���&���H�/�;��`���Z��p���Xtf���>��4;}@���d��>��Eg0�N_���3�f�o���VpB?�~�
>���{��������j8�Y���~�β�|�#p|�}��#�,4���e���G�(-+�w?�i�i��8R�R�ݏ��*[�w?v���lUM,͋cU��&��ű*[UL��X���I�yq��V�DӼ8Ve�j�i^��U5�4/�U٪�t�ǪlUM<͋cu��h�ij�X�:�x�_V���� ���p�h���������c����h8}B���~c����h7}Cߋ�nc�z.z�|��E?]�8���g.�$��Bfu5��Y������3�?�g�g,$�в���H�e����8J�Jc�#q�����G�H-K����o��Vc�#q��V��Ҽ8V�mri^��U5�4/�U٪�d�ǪlUM4͋cU��&��ű*[UN��X���I�yq��V���ԘX�:�x������Ӽ�����~"Bn���=�����K�����u�'����X'}A���Ou�7����P'=��E�g:�z.zvt���=�D�\�ez��OF�%��Bfu5|�Y�r����3"��g�gD�%�вЈ�K�e�!�8J�J#B.q���F�܎_H-K��ı*[��ı*[UKs|aU��.���ªlU]0��U٪�d����Uu�4�Ve��i�/��VՅ�_X���K�9
��Uu�4Gau����i��@r���y��*��H���#/���>Vɑ��.����ȋ�7����c5�yq�F^���~��#/��ȋ��ڏ�@r���y��R��H���#/�B��#/��ȋ�����ȋ{E^�]I��6�ՕRx-��fG�-��jG�-��nG�-��rG�-��vG��-��zG��-��~G����X�H��olx$�_�W]T�1���vY5����.���~ե��¯���c�W�U�Ws�
��k��_�W]b�q�W�UYs��]d�q�w�wt�5��/ն�W1Ҽ�b��T�V^�Ls�'�0���/���~���O��QO|�_�����~�z૿T�n^�ds���B�Sm�y���ɣ�6�Օ��k�5���Gl!6ƛ��la6曓Gm�6���m�6&��Gn!7F����[؍���[�!���+�Ɣs��~�E�~���.���+���9.�
���j��¯����¯�.���+���9n�
��k��¯�Ț������"k��}*v�~"/�^�>V��X�����{�Xݧb�'�����cu��5��ȋ��ڏ�}*��~#/�\k?V��X�����{��Xݧb�'����cu��U��ȋ����T���D^4�\ݧb�7��DkmZ�+��k�5Z�#�=��1[��&G�-�F�#y�n�͑<r�����na7ɣ������+�F�#y�
��j����m�Us<�~Յ�~�_ui5ǃ_�W]\���W�U�Ws<�~�֜_�~�%֜_�~�E֜_��]d���߁��E֜���$�b�D^���}�ޖ�ȋ�y����{YN"/�O�������]9���?�o���W�$�b�D^���~�ޔ�ȋ�y�����{QN"/�O��߫���59���?�M/�I���������W�$�b�F^4%,d2��aa�l3ơGgYg�C'�ϲ��N�e�1�8F�Fc:p���4ơ�i�i�C'�Բ��N����N��Uu�4��*�h�Ks
��Uu�4��*[U�Ls
��Uu�4��*[U�Ms��VՅӜ��Uu�4���lU]<�9�:lut�4������ӜcY����۷��qAk���N�����u��X�~��~��E�:���Z�~��.�{���NZ�sѳ��1��E?]�����?r�Gf!���,یq���Y��Љ��3ơGhYh�C~b�l4ơGiYi�C'�Ӳ��N�e�1�8Ve�1�8Ve��bi���v�4�U٪�`��ĪlU]2�ybU��.�漰*[U�Ms^X����9/��VեӜVe���i�kY�IǿnO��Nh-zo[$}A�E�]��o�c�{�"�	}.z�Y$�@_��[A�_�����E�==�
ނ~�t���u��lW$��Bfu5��Y�Y�x����F[E|�}�і�e�u�u�h�h]]!'J�J��
9qZvZ�+�DjYj=]!'Ve���
9�*[Uu��XgT]!'Ve�m!�*[����U�m!�*[�����lUwW���Uͮ�Ve�z�B>X�:��B>X�:�+䳬���|�o[�>�Z���ɠo�蘜zB���ɠ�s�17�����������E��dЂ���M���,�i*x�ot��>>�����jjx}a�l3���e���_��,��'�GhYh>��Ѳ�|�/p����~���4���e���_�X���~�cU��O��UqF����|�/p��V�I���*[�'�v\X��Fg"q��V�3�8Ve�љH���|�/p�[�'�_VO_��nO�r����{~D���=�r;=��Eg��N?��3Bn��;:}�r;]���3Bn�==�
�qt��=?"�v�0�.��3BnǑYȬ���e�r;�βΏ��g��G�܎#�,�#Bn����~D��8J�J?"�v�e�r;�Բԏ�Ǫl�#BnǱ*[����q��3���X��~D��8Ve�r;�U��G�܆�X��~D��8Ve���B�X��jv�<�*[����q�[����q�[�����e��=}},j��}�t���>�wzB�E��N?�ǢsQ{��<�|O_��;]�עsQ{�}/:�wz@�EϮ�n]����E�>M�{��\��qd2��!6�6?�w�e���;�ϲϏE��Z�����-�X��q���~,j�8N�N?�w�e���;�U��Ǣ��cU������XgTm!�*[�X��q��V?�7|bU������X��~,j�8Ve���BN��V5�BN��V?�w��V?�w|Y�}����=������3AO�蘙��>3;�����Ι���Zt�L-�{�13􀞋�]�8�}��93�iz]����D��,dV[Cl�m��D��,�̙���Y��3~!�,4g&�h�h�L�ҲҜ��e�938R�Rsf"p��Vsf"p��Vsf"p��3���X����D�X����ĎVe�938Ve�938Ve�938Ve��]!��՜���Vsf"p�[͙�����{z����o�����3I?�c��q�iw����3I����7-�k��nz@ߋ�nc��\��*����==cf"�����g�L$��Bf�5�f�f�L$�βΘ�|��3f&GhYh�L$�Ѳј�H�e�13�8N�Ncf"q�����D�X����D�X����D�XgTm!�*[������Vcf"q��Vcf"q��Vcf"q��Vcf"q��V5�BX����D�X�r�cu�j<�������~bO{_��?z|O?����G���'���.�c���NZ���S�����{���N�����]�8z|O?����mz��O�g'��Bf�5�f�f,g~���3v��g�g�f'�в���N�e����8J�Jc/;q����Zv�H-K���ı*[���ı*[���ı*Ψ�B�X���Fv�X���Bv�X���>v�X���:v�X���6v�X��jv���*[�]�ı:l5V��Ϫ2�oB�ߛ��j 9!c�&d���~��2�oB��{��j 9!c�&d���~��2�	n�߫�䄌�����R��HNȘ�	�߫�䄌����r5���12�B�ƽ�arɣ�6�Ֆ��׈��Al!6���la6�Gm�6��m�6"�Gn!72��na7B�Go�7R�ǯ��r��W��\����ܪ���¯��r��W��h���+�F�\��~#\.y�
���z�/�
��M=�~��ȗK��0�<~~#a.��w��i�7���/ն�W1Ӝx���aO\�����'>�O��QO� ���'=��6���/�i|�����O[�i��x�ls�h�Mku�^� �  1ݜ<b�1ޜ<f�1ߜ<j�1��<n�1�<r�1�<v�1�<z�1�<~�ߘrN��o�9?��ܪ���������W��I���+�ƨs��~c�9y�
�1�<~�_Ͷ��~c�9y��Ƽs��/+{?	ob��}*v�~2�^l���T,��$d���>W�����I��{�}��S�������V�\ݧbo�'!�����O���oBƟ;�su��ͽ�����7�c�i9��ZV68�GkmZ�+���k�8�Gl!6z�c�0M��Q[��.G�-�F�#y�r�ϑ<v���H����t$�_�7Z��W��^G�~��[u���+�F�#y�
���H��o�;�ǯ����+�F�#y�
���H��o�<����o4=����o���ۜzH�x�e�ܾ�={S	ϿL�KZ�c���M��Xt�p�}.:�	�����}Aߋ��m����g[�	�,�i+�������s�Od2����f�f�C'�β��N�e�1�8B�Bc:q����8t�(-+�q��qZv�Љ#�,5ơǪl5ơ�*[�q�ı*Ψ�B>X���8t�X���8t�X���8t�X���8t�X���8t�X��j��Īl5ơ���������Vc:�eU�������%h-z?�I���\'}@�ޏu�'����T'}A_��u�7����L'=��g[��Y��U��L�{Z9�82��հ�Y��Љ���3ơ�g�g�C'�в��N�e�1�8J�Jc:q����8t�H-K�q���U�j�C'�U�j�C'�UqF�RX���8t�X���8t�X���8t�X���8t�X���8t�X��j��\V����/w�X�~���+`;]�cѹ�ӂ>�`;=��E���N�עs�k�O�{ѹ����\�l+xC?�~�
N��jy5&��Bfu5<�Y�Y�x����FW��e�ute<ZZgW��e�uu�<PZVZwW��e�5�B"�,����X���-$Ve��bi���v�4ωU٪�`��ĪlU]2�sbU��.��9�*[U�M�X����yN��Vե�<'Ve���i���VGO�X�:�x��ZV��G>��i?WAk��_Ђ��'���Ǣ�I���s��_�'���x�/��^t<��==�
N�g�O[�������'�v�Ff!����,��'�GgYg>�8>�>�I��Z�O��Ѳ�|�/p����~���4���e���_�X���~;>�*[UK�L��3���<��Uu�4�ĪlU]2�3�*[UM�L��V�e�<��Uu�4�ĪlU]:�3�*[UO�L�[]<�������yS�?��֢3nj�=�iS;=��Eg��N��3kj�O�k�5�����L���z.z���Ϣ�����u�)����Bf!����c�l36EGgYgl�$�ϲ��I�e��)�8F�FcS$q���ƦH�8-;�M�đZ��"�cU��"�Ve�jbi^��6�4/�U٪�`�ǪlUM2͋cU��&��ű*[U�M��X���	�yq��VդӼ8Ve�j�i^��VGO�~��a����y?^V/��׿����������\���=�;�;}@�ΕΝ>��E�F�N_�עs�s�o�{ѹϹ�z.z�|��E?]�8�|O_9H�82���p`�l3�(GgYgLQ$�ϲ��H�e�1C�8F�Fc�"q����E�8-;��đZ���X����D�X�����yq��3�w.�����������      �      x��][�帎���KvXoi� m*��fM��Q�n#m�E���'�I���Z������\�M}�A�*������~��5�_]{�-���צ���Q�����?��ϼ�������>����{�m����l��իǑ��^�#��i��?mߣ=�1�_�/n~���sO|�:��_yOX���΍��0�w����8�_e��:��k_���l���.�V�o���.\���U�����4��¿�'�#�==QJ��`S>�ቊ�6�o\S����3�'�=c��=�s[z���yOj*S�aR��S��_ۏ|i���y?�~�?��V��9��_-�?�O�/q����p�C���.����Ҿ�wރ�z��ƾ�����u�޿�i���?sOV���j��}#���/i�׾�5]��g�)5��wE�
�W����Ϧ���?��|���e��g�����H��)ZJ6��앶����y=K�Ύ�c�����V����eˌ�n�x�0§-��O��f���gN����J���Sd,]^��R�W��S{��?�w�E��3?�m.N�7� psVϞ��Z�������8�����@h����,|�~�Î���$(ږ�	�f�g��dOJW3��w�M(A��e=7I[H�K�`�~�y�+���{7��e�~�畯�����a����LY�_]�wo��޶��B��C�.ʓ���Qi?Lb_.D�qc���	\�� ��w�J��-�F�g��li����4m�$�z��V�q��F5�Q�W|��H��9H�,ᖃ�`�>��o�rꜞ�}�U5K��>{��C��0�����>��z�\}���K"��f�o�y�m���b���=c�Lދ���6`��7L\2z�+�b��y��vB��U����vV��h7<��&�p̩�)�R_�_JT�p�n�[�^����>���SW+>DǤ���i�iXt[h����
��w[��W�KW�u�k|U@�*ys����Xݒz��Nq���8���-���A�����u�cH�A���˳Ch��Vs���q_��6�Q�w����4)]�|m�=S]��$H�dk����ޚ��-�ty���������M<ʖd��qV%����W׺��W�f*HPC����Ix�!���œA��Tutqm��	������W�����(�[���������K;;���7ü;�z���HyČ��+���p9���g��V��=�ϢG�Ƅe^�3�����J�J-��)X:1���(Un�d����������	pNO���9����sk���L������Ϳ0qmז�u�{�������e:ҧATj�?����Q�*v�ڶG�Q�7���C�������%�G���.�tu��Mt7���w��8t�L$��g+&I�#%�7�+w��>?r�c�P����f��{j&��ٮ���~�y�ፅ�[aS�c=�� �z�����_�����0;���_��e�?Μ�ɜϹ6�Nl�-`uu��}y��0�n���o8?[T�U��6�?O�ݝ�u�R��ԯ��6���[V�q�C�>�{9n�p��u:u��y�7�5�"�V;\�Ya���T�}^����0Iƽ��WZ�x/�x�����&��Ņ{��Q��=��������'���:f�R��%�]�k+�[����X/l��*�|��0#��5�`g��U�x/]��%�WQV��0y�����[�W�]We_]��)[��o�2��/<��k GL�OEʟ�����G�^�ʤi��M����s���Z�sWo��h
�?~J������P��>1R�̻����gw�qe�Z����6��L֦�a
J�{ H\���+��oPhO�=] ���q��x�y�0u&M�h��O��hӁ�bT�$k�䀄��z�5 �~�(�,Uξ��+8�k�'�2�2/������E�$�����C��+}��M�{�����Ȥ�yˤ��0U�Hf�v�=h���)#a�%�p��=C����>�O�,�I0�����+р CF��,�L�����hn8���|N*Q"B��?���T�����
;�AVҶ�rY-�V��G�����I.k_O��V�[�w�F�����Q��2�>¯_q�#.er�X1m$|�����D����������s���Ǒ��)#�,	JE4�(����\���1��v��H��q:'��F-Zc�Z>�n�A��m�����y��6���__w���l�o`�	�p��%T.Z��NǸ7/��s=�o�jK� Q���k���{vR��R��j9��)�)`�85�����Cy��Q�sI�� }�����G�x13�<!Q�"o*h�fY;��U�3Y�~>�^F���d-x�ƶS(�7����ppS��#�W�#U]�Kﮗ�a��[Q��S�����=��C� Q�8�g��F�	�rhߐ7iX��-P�E�%]%E�߯�g���Qn%
u�-<���.�+%,�Z��l�wӖ˦�?�:߽e�u׊�>�{�E�DLr3z�Q��7i�}rA�GI�����/�}�lz��$m8$����_�$�V��[�ڵ ����L��[-�sըg'~��$J��t	�� �K���r&��� ��#���2L@Fޘ�����7��j��k��yu
uL ������\�x�m��.s���I.ȑJ�!��U�p��}j�������j:}�=���l����sH�b?8��������;��0	�S�l-�D�w���[8�'��������E٠�+HXvҨ���n�ăG��y1�̌o>�=����o������e�����DM������N|\!���F|F�ǖ�0@��1��P!���ƫ}-�c
��<]AYU�r���$�Ä��-e��FѨ�:",���L{%O�&~��I������)���LSf�|V$���I����[�g]���+����uR%����m�琬����Z�äB�KSE�`ɴ�Zӥ�L.�`�!F��y��6��Y������*�0��տEn��
���Em�Q�7@2qt(�����>h�d�p��`Ã@�=%"��/��4�EnP�U��UF�������y��k�~��G�ϲ(���a��(�����#WΌC��0<�@i��ߨ�0�n�?����ޖD��m��p��۴%;�}鹏��p����_-U�H!ڮ5Ć��;./�.G�����Eg4ԆS�B�K�%p 8�Ǣ��&0�9&LѴ�sݺ>M5�ֵ��~�@Ҽ�V�Y@NL� 12��%���@%�d����]f7�[W3n��:H��q@��H�J�P H��6��������_�� �|5\_�]�u~�#��jF����c��uO���{���2	
D��^���;L\�U���|~��	� �ǋ��h���?�3j?Q�y�|{d��t�����v��y4��b%x�L|��UX�m�=���$���Z�+J�(8m�:��&]܎�Nk8!:��SM'lX�Ek�2i�- ��Q�a��$h�C!��r]ap��ᚾH��a�--�����[4&�ro�{�#�S���A�o�d:$pu��苬�o��޼ՙ&c�Ua��֟�2���}y����ɀ�* � 	�U&��/�օ��2�^~�+�E�Ȇ˂��
6Ƥz�_�����]2�$뷭�%z;�7�Oa�ܚ\�������2��B��ҵ�8}��B�]���ҧ�7�Dd?O��"�mz�y_�x����Et3ݻ��g��=�4��^j�6K4�u�� �i�b�l���j� 76�Q�^	�����©Ta�6��e���p�E׳��A9�-�G�<���^Q�F:nq�MT��=�<�J���y�Sdw���1(��@懙�xM�gm��[ϱ�ch�F�!�p��xO,g`ƍy���h����]��N<�����pz�A:�8�����oUx}�t}��eý��O���vc�$i�0܋��:�HD��\�[���L�ʵ�]PDC7)N��g���'�7
� �V�s�f�h��&(s��M=G~Uz    e�T��(M�b���6����c�6��;3�ZO�APH�fh����K@Q$ ��[����jt��S�+	̌���dPwa��!�o1�'ôޘ�u2Ѣ�a�y�7�
�������|�4��3X�����8��Lbi�=6Ox̉(�x�]p]Q(�Z�]��?��'��ǳ��A��a/ RA���Bו=a������F�ٜc+l�W�4�"2V�D&���E�i��k;�L	�Y��G��^iJ{q��J��=����7����F��/����F�
y�!0s	�I�t��%]����b5	:�x�mk4�#C�e��% Y!��W��7#��S���)L3�DLv�+fi^a�O ��y*��Q4�>�@�����05���{��6O���˂�2�"�PX:�{�
��|5JΠ�L�Q��k�Ⱦ)�&�`x��L�`�`C� wt��>T��������V���ky�<̚4T�O�T0���T2T~q{gl�"���O��PO48�:���(��.��#-��Q�L/:�����@q��1J[�wA��Ē��̹��X��п�/\�J��I�4���X
���
���ｬg��m��#Ll��A`�k̱khq�ވID���x:m�]�*W��3�J��:p��{n���&Py`[�UL��(�:�
�`�z�M����d^b٘�8�Z��P7�~a�`�&�{�"�tl@%�8�d�ei�9'_ @M�~�&�^�޿)�b�`�&�yҠ�z �数�g�~w�(��*m���qôA��Ǎ&1�2L��|�W�M���1u|.��S�b�qz�G_l����o�
����ѕ�r%"��$nfߺ>��)W&��]FHF��>�R�h�^%
��b����K����p��?����$ouc1�	��iUK��нę�����*�/$� �2f�z^hJ��g�h�� od��Z.,�Na������
N�J���C}҃k4|^%{D����*�S2\�4A4���`Q��M��\��W��/Ǘ�����g�L�\�z޼poV%3�x�J!j)�~��[��1��"��q���[ M�*Q�<��H�R["�<��=z+  �DDٮ��g�W���K_B,|��/�w���
��DI��am�{�2T�Ԝp��Մ@�!=���,S�i�o��aZ�c��ۄOm�K��b�)D	�i���*��5��� ��qz�IkR�p�^��oMf�u�E�.�,^H���}�R��:�6�A��-���njT���"��g��,��/�?�e���%�0�&Ǹ�Rd�Tmt�M��(��d�X��GD���-J�T��<�Q+} V�X@���-��:p�������)�AK0������^����
cX���N����"���j��~�N��pI!�6��*��JAY"ɜE��q"��:㧉8����{��Py��@��>]�㮻�mL&�n�&B8�$g۰R��X���p�g�Ҟ�Yˍ�jt����#�.۽���tq
Y�F\cNZ��A�mp�Ku���f�F2�qu�o��*
ư*_�X�u{�r�<hI{���x
E�3��S��̨�9���������}�P�����I�t�L��_jKg��A~�(� �����z�K����}���n�"-������8�'���Ł?ky}�!�Ɣ��3uBx �'8���5�{���P	)�ՙ<'�H�<���>Y�$�ؑ4�~'Y�Z���tW���Ϙ�29Ŏ�xk��f�}���]>�7�l�3R)�Q�����*8&�P�)A�.��ܙE2��2M w��ӴO��,7 _��<ĩ����M�/~�i����D��WO��c�����:2<�lp)7���' �M���$K� ���h�o���v~Bp| ޚ������|l/�c�m
8�A�.!����y���L��ͤ��3p�0���L�An�����?���D�f��t�t��e1J^�=:��.g�X�7�k���(h���� �����Z�����
S�p��`�։�A_���
���^�!H��ொ���q/�I,^c��_�����^ُ9I!��輁�=�7F��[*$*8=0��t���y^4e˃�����<ł�Yjc���AEJ��A�b�" %GlPR��FL!<L+�R�k0�bTŇ@��FU�ޠ&)X����>���v%��d�R[)F���]@��Kխ�Mt��++��+S��)r�K1L��}�֝��Ip�,����2B���|(�i��{�7J!ȩG�8������q�I�LPo�ԃ%%x�j��~�{���7B�+B�][Ñ����s���GrV�z�{�V�! /9��s�6߉um��2�|�~G�p{SId;~����S���噴倪- ��xa;^"·�WED�@������W�cVpz���FSE1��sMB������
No�,P�r�
d��B��������)�8�B��DL�,�_��U�z������ۥR�+&��Eܕ/���JHwH�7͓U�|f�1�=�oՊ~
���۰Tn�`�׿:��� ��YDeKL�| �z�%e��`C�3 S7�V��$���`
Pd	b�;�5c%fLn����>�
�h)��vH�7��J6堯^#�+H��	3��m,P�~<V�9��l�ֆS#5��0��"6���KQ=��S����6�QoN)z��]+G���>_p�����d��{��x�AH_�5����Բ#�h�_o��������o9�-�B;�A"ó���f,T���c��8ޒl��j�#蘿���4�.�9q/�C���ZM������GQѺ6��ZO@�'�r#f���;p�-e��{�n���ѥ/Pt雳�{hG���J����,z�è�0���k��{>��M���R�po�]\t�p�m����5?��/<Q����D�������=����4ah,^���t����~���%�RZU9�c��Ay�cb]���
���[�
bj�������AL"��
�5ϲ��[,vh�=�E���x��WP_�2�Ȋ����gI#�E�H4ϒφ\ʾ>���9�t���7���b��s����XS��$��ۊ�Y	�2���+�j�U�Q=��\�b�^��D�t�ۅҢm�����8�O.��䑲�U.5�ʌN�"�ۅ/���G,��Nn�gg�*wj��j���ewV�r��K2O����8���l�����μ�
yud/>+���c��|�~��"𙪞i9���0�	��(AM����ݮ�J���R�ql��$g.Dзa|6/1�|��꠵���b�aO���EcR��]���V��W,�I�m(�W�u5�HeL��;��9�p�	z�UNyA���즗��?�56�P�������d��b�%_��Guu#�ݑQ`X%�����s~�֍�+[���P�"5\A�\?�Ho�@9XJ����P�*�p�W��#`��oJ��A�o&����Rn�{d�|����e���S�3t�b��<�a[��������^��tس g�U�{`�d>�S�>=(e�W����W�*D�D�`���J� c�[�,/�kf6Aܷ�j��W,�`h�o��I'�/4l؁f�|�AT�I�#H�����R>T���"7�IuwH�7�h�{ᅲ�U��$�^+��@;���f�$ʩ�!G8):=��&֕`j���� �R{O|	��g�*D�n�cf��Z$h�S4�Dң�,�����߄�!�~�{9����2t�	�)c��V �&�E��;��
rdE�'�����',2�IR�k�=.��$�����lv�ME��Q����լ�JR�nP��}*���N[���6�	=�N����dY)�o�p��d�Xٹ/���u*QЄ/��$��y�.���l��by�9���R���.D�S1F^�#�^�2�tl �nO�.���@d���k,����h��R�󕲕8l����p��*^�dM����"^�t��n�)���    �Y=�&�Y��1*tB�0�L�oq�d�B���YvX,B�Fkqt��P#��K��;;�P����q�<��A��NH��'T����4
F�0�bT�0F�]С�_��3�Ը!���#�`2\B5�L��s=��Osu�����x��L����jȺ[Ѷ鉶��	@#�o��l���g�GW)C��g�F绚u(M���oy���9�U$�U����"7h���z������CR���Ը�Z+@P��*T6�BfJ�]��=h#��^���G!�lA��GDC�=>r3D`i�dW�E�=�FΌ��{����U#J#�����ʺ,<:~7r5�I`��v�1G"f�`,�~\7�vmp����,�`V�� v^+�4h5*3b��:~�7	!Fk[��G��/�_kX�%)�LN¶�L?#�W��X����G�[�ϓ�e��C$lC⒲���^�gep���w�t�zҌZ��ω[��^i�&p#xy���O���=��y�-�
�� U��ڌ3��ϲ���z9ܔ�g�㑌�D�=�ՉW���Uj��ALr��MG��7��k�U��%����	[��Fat��U��V��ok��Y���[�|�S�p�0��C�K%�}����s��6�0�S>���Gq��Th]Z��M�����c�bB
�5Yq�pt!أ?��"�rڠNPs� kMtbjj�[a����++�F35�e�P��=���-�~�{��F	A�nc��^�~E�^ߟ�百�`� ,�ے����RWF�0����+d2�L�43�+7��B-���{����He����TPQ�ئ >��%jβ���C��l�>s@ r�X�ܳ2�ǲ�9��DO}��S���įZH[���L�@�<0f.���e�Z(�����.O��|��j!6���v��+C?��pc�J�h�����D!���%��!���Uƃ��E6���N�;�ZV� �0A�4�6���sC��[��5�]	�O��>!��3:�_eZ�B\�W}K+m �*k�� ��U�Te-I�?�f��`$W�-S��?�Z�� ���������"6�� �*��+�'F,��$��e@�����J念��M*!��3*t_�o�O�[K5}�
�JLߗƛʑ��@�U&|}�+V��7�ȦV(��J��$������x��y�
��,�,Zk�����(>D�{���'Jgh�tŊ���� �Zz�a��u�������a�r�0� ��Q��ǰTrʪ����Y����V�?�C#��y�N ^(�~o`��ڒ�'���Ci��%�k�8��Σ�u�1�C8��ʡWɌ)����5�9��Wl��" Z��qwP{�UO��-H���k�"���oh��G�׊uЩߊg�=���t�-�&���p��E�lừ��S=��j�/^!*�mL'��f؜��!�M�*8 7���9��-NnT7ì��{�"TϾ:a��"���̍A���[m�"��=t4Z ��a:���h�dN���ˀ�k�*H�&~p�u�y�a�i*W�pS9;����0}��z�
��[���c}���^���lp����5U�aLclcW�����Bz���_�1;u�x"Тvn���b1Lį��	�����iߺ6�I������=u;�$��~�wh���b�I,
a�˲�ȝ�dex�����G�9M�c���)�<,�׌���	��Y�/o3iv��>\��pQe���j`a�1�`X�J�E���,b�B3}�{.i�-���).P0�)�1�}�`� d�?�!�� aP}�h��,}f�wP~H/����v�ct�����$��)���T�G�P�)=��P�����߬��Uf��^r�Um�K$;-���N�?�72�'X�@�y�|���������[Z��}L4s��{�R��8̡�����˿�Lh	"��Ar �i�dȇ������bRЦ�S�rE� D]D0�YU�q��n4��VO����p.��@�&/���a*t��݃.�Elu�.j���z%�d\q�7X�VD_���UH��|9`��K'�B㝸�:N�(����Yހ�NtE��	jn���ѡ4g	�~�
#?���e�)����\z�<6��GgY�M��TPӲ�a���� �y���N��|��tL�P�[J����4���K����WnH'�L�!�Y[����P���T9i��p�I̬c����'EȲ������A������Oks��m �'%f�d�)��(шk�xfsw���c��%�?V
8�����z ��Ǩh.tv�K�N�f�7!�>�4`����ӭ�
k6�IP^�&K�2R���7�U���P?|殩�;���2��5�NB`21�Z���_=��~u\���xQx�E ;����_�fh4o�^S��?��:�P�B�R5�Ca��Ү�4\���?t
x�{iqto���X��i[v{�r�v�jR�L�ӗ˭r�ANMEF{�xfl�<�{`��Q�γQ=�/��ޤu��u�R�|{9A��b���}�uؓjo��P�
/�^o� �d��š�Dc���@A��e�A�3O�n^�	d��MBm�ԭt-�Ä��r~`�0'Ӣ@2�K�~OX��_kV\�z묶N@"�v�gY�</j�쒎?�X�]��������=��/��P�V��(��J<|u��F���?�6z/�r4�&߆��'�(�mk�3ދ�nX'����x~�U��k6�3���|����i�B;%�)��)�K��}i��0��"�5�5�~�.���*�5@�~��|�G��i5Kb<��N�d�9 �e�JRG-��y� ��Isl��[̱�0/WMAk�s�JH�@��ղ����1�����6꽽{��*�
�=['䭨_� �k}qQ^���Z`<����0 �	�ea�{�ZP��액�ۗB�<�hX?��o���_3~���1l_u������5�a0�U-�y}4�r��6 0.ă��g�`��.�Y~����啗oF	��������5��}�h�A�6��oϢ�������o�ўJ��I ��Bj��[�IAL��f{[�a}�Z,W�gŗ����ȴ�����)���{�
u�9sѿW�)��������]j��*x~���&
��~}y�NAI7p�8T�1x�d�Ɂ/�%����`[y_�y=�tV��y���08�0��G�i�Q�Fo���3><������B3������&��īWq=ZO��s�zZ~�P( v���i��T���ڃiC�T����Y�O�Hyo�x��h�%�ʰS>�/y_]�L^�)L4��=����.���`F���{v`1oQ���G���t.V1�,/qIw�0g���q^UM��u4�#Ԉ�̘���d	�qV�h׃�����ȺH�N�,��G:��q5Y��{k��>�q�\��~�MʓMܓ�2`�\��Z��>O��Bl)�>9�z��1L:f��h~�sVh~*D�ZI�N�Cn����˛��oղ_jWl�jб�������������ODd�^
7�k��7���_-�%��?����X(��Y�wH���&����:���eb�3��ɹ�8���K�%T&)(�).2�e��g�t��f�p�f�T�B��RE' �Vγ����]�4�Z�_etӼ�p������f
Q8{3.<�Yy�-�^O��f��:�GSR�w�1��DT�ey��,�vk�5 A�u}-��l�.�d|�NM�ʇ�߃b<��x�0�9<hl�����ZL���7]�t},�PeXhi��'&+�Q��Ĕ�|.�R}@���*��<�B���Y����QH��y��U���2tUW"�uG1���'Sxx�2Z�� $$QZ���� �WB�>�!`��q���-��
I�f���Yh�v�6�
Q]]%.��֓.kߍ[�6���ǅ�Rc��@	�$��{���0�}�ɫ_�&��������맩��;���,    ��sL$�c�١$�{����Q408a��g��!�!�]�Q��t�u�ى��A���|����"�=f>�$	O+�=��" ��&L|�U��^����ݒ�%#��>"���e&�n4�����`g�o�2h]qc][�:�ŋ*=��1�Y"Xܦ�7���:23g�@G���*es�R�~���w�֊3J?��h����s���´xZ��"��v,>})"�l��� z->j��z���)�� ��}F�E�����n&b�?���}f%Qڙ|97�����r48�q���Z���6�eo*��=Ŭ�H�;q?���؋�~H��}����Nk�Җ��Y�2Q�S���,݃k��Uf���p!A�����6�!W�U����ؼd+�na��kD5�U<�rRݞ��}�b���8��م*p8�U��#��R�7b�bI>�����s�럃@��4?U~ڗ/^���C!ύ���!�R���rf��7D�d1��/����
T"�x?۸��}���y����$齅R%1�q��M�|���I�cE�=�pC�� �j���nR��58��%�`{�!���'�A�j�fý�yF#ғ�b���db�S�L�9S�K'�X^���=X<�?á�8ի�7.�vo��E֙��O�o�UYum.�u-韼ڭ/ �E��<-�R�U_�U�t�S��0GIM=U*�lMC���^TWU�)���[�j�0��Zh[�H'e��E "���]�w�y�8ޞ�F�F"Z:+�J��2�J�e�M�����[����_������j�V��7�s�,����Ҭ�p�8�6ܤ��c��8�R?�%����J]�Ak�{���0�/4L�_�~�I&�M�����4!�(���;���-l��UJg04j���ߗ���$�^C"�4�.MyC&!�KkD��Z�<�Md	o>�$b�~Ϧ1fچ{��B?B�T�3l�:�W�`j�y�?
(@�:r�Uţ���O��ǭA�q��1�� ��{Y邳^��O�6��TBzv��>�W!�J�5|�V�䤂���H�� n�.����0��l]a���B>�����W�'�!m	ͶN����0�_et���._z&+�{�h�=��b����5����.)�2�r���I�3���5��$���	PE,?
���G�b��E�6Ad�ߎ����@[�v�Jа
8GӰװ�	&��׆�6c�U�vk� k����g��-p�UqM�~��	�I�!��c56ˀ�����HYL��|[6��b���th�P'[Vrd���,�&{B������	���i��VtW��*y�>�`q3�������xTsb�����8Q��}KP���WM��q�DGO��*����`CR��,fa�f�����e�7dRݽu�J��� �[�ĳ�R����}��L7Tu���3p\9��&�{��h潤�bm��`��[��[܀l�\��Z���V��Y��!N��*g�ʆ*O�`�pH��Xa
/ф��8��?�+�������=aq51��\`S�0"bi���6ܷ��l���~Y����E�0�0� �X�|�p��{G$"�C�|yg�'�ַ��
�X�V�����d�'�5�o�lTG}�����mi���V���%�ߎ���<s�� �Y�QU�ŰD���̻ք�qϻ��}1q�{ϔ���6vna�u18+�TD��޻L ��y9���?�@�IE���gm@&�2IU������W��(�0c�D�����	�R,$���@Q*�q��cþ��r�]�u�"�a�����ֵ�˘dU����,`���,� %^3Ba���tz�:&��c�A%���v|/���&*q{���YU�=������@J�n}VEg(oRU�b����V.����`+1�B�������ݵ��)��T�[n ��zg��1m�r	fS�EC7�V�Pt�����:z�U@�aQ�>RU0kX �+VGM��`�D�0�&�~SB�׶N��NBA�rGZ�� �)z,�B��D����k�٢h�rm.��(�B�}��°��.���Q,�����h��>��ض�Á�-�=�9�f�B���Բ �L�/D�1^w�:ajA��Ԧ� 3|��g3�՚���k*��<�PC�r���g��XB����\-��=��ŀ��޲�^�U�e.S�Qݫ"~��=@A��ܵ��Y�u(�wh����y16���VI�f�y�5O�Tb��s�*�=>�Պ���:�-���`f��8k�X)[Yµ{������<�S����m��e�?�"ͱ��K#b�fꕚAb�tx��P��%9�¹��I㟳�ḻw#�T��_��X �z*9�}=�$�S1�h�zƘ��`3���J��*l�p7u-ߘ�+��f���Vd�<��E|BB2������-����#��㓴����@��2xJ�^�}N�8���FM��Q�>�0;rl�n�hz�����#�����}���Ћ!E�A��I��%�C��{۟��!��I(N�{�?쒩(5�N��r�@��5��U��MQ��o�Ē���p&B��/���U$n��Л��uB@�Zߐ��Y���D�J�O�j��:
��\g�1��qt���h[cc��5��p*sW�qn��0o�Y^j�#}QdL�'E#}X����nBp҅b��ЪI}"5�8��&�Zգ���_!R=�-Dr���y�Gh�g���@����C!��[���eiwG���#�v�59�_ۣ;q�6�(��䚍�Dyk��Js�-r�[d���0�u�4�L2H���p�� ������i�}�|O�HaJ��ҺE��'w*D����x���aF,V$1H�4��xk����搃o�?'@���^���n�1�����Q����`S�H��xp��װ!�ٳҾ���3Y���W�<����|�����Pt3��෎��d�૳���Y�t���X�t�/�W�4ƹ�D63�o:s[9���o�ڪݪ��J�������}�@w��?�� �2a�QV/�����u���b~�9�@�y|�w��U�yss�o6!����%ɆJ�\�	��CY��:�L � ��ϩw�*��6�a�`%�
\�+��
�;�k��[z�`���A��+��A$S���p��˛�Ƌ��h���!	�=�.��V׋���=_˨٢*��Y��!��ݑAv��S�{,"�4��mr��M��M��K�
=�a"�Tү�:����3�z��iY,d�X{���_��.7$������"�?X��,��e�啗Ô��*n՟M��Ɛِ���GՆ�"�@t!�!��F%ʄh��ήK:.��|��b���z^�"�������[�~m�o����?�o'�S���f#�+�}k ����6 �ݭ��_�Q�V��hM�����٧B/�@|7mH�Mnm6ڐU���1-�w���a��h�|ڝ��AD^���0��3�י��걁�^T$� �w��u19�(��V1��g�u�^�o�7bh��
�U��Қ�x��X�Ʉx:�QK����XĂY`
#�=����/�b��B�Ar����l��Ґ�͖\��o�4�r/�NH�t��0.X� ��WI/�^�����_}��`L�T����,>��$�n��<˒�1|��ך�
�vI�[��N��5n��[QC#��ƍX-]�=��fS����D��b�1gjY����ߐB���	'����W�*9{��_U��A=���h	Of����-�9�\���1#G�'��7`��g���3u�%|�@��?xr��;#�����GA�_C+҅���#F�!�WK�{ILI���U|���:�]!�.]Km9�
D���u����_
8A�,U��$9�Y�;9G?�5�h(S �)��"W�,�S'�r�q�V�:�6d�^&+٪�1L�ԝ�w5�e�O}7f�s�����yj��s�)��ξ���Rn=�΢}1���o鼌-!��Օ�V    C2!�9�g�~���+&DP皽��[}vo�d��w?���>�l���K�XI����a���wb-{��-&b�A�{n�A��G����l/���esZK��>,�p��@��B���S�£=.:a+5|�[��j3ثs�4������{b�ԤZBn~�[ۂ����.��.yD��BHqH���+ϔ����¶�x�ߠ&P�FaK��xF�1��G���k�����y��F�a����D�z�z�Z�a�1�{\?�2�_LO�7K�/�����CE��~��PX������{N�f�a�����l� �~�:�[��#N����/���V�-!��k�92� ���Aȯq6�w^,33Z["���[@���ɴw�6��@�>��� ��R��E儬gn�v�'!/�ά�������E�[�8���2��k����`~3B�|/��+�Y�i=V6
K�qF�ɢY�-�af���| Pp6�߻���E�A7 �b�U�n.��V_���6U��u�B��qxNoB�{�~f�ӅqN9z\?#k+6�t�U�ɂ�h��1����!Md�c�YD�2�W>�gc���4��uO�{F�F$"�]�Py 9( �bU�� 0�VX+y0Ӵ�Nn�ך���b�i�L+�X�e�nT%���n�w]{��ؠ�ݯ���������V�9�M�%���x��m��[�>�X%[�
��`6X�����=���ݴf��"�s�N^f-���uɢ����{]
4��`%�&"O�Sw#���ZЉ��P�e.���G+���"�*��� *��+��벲YVWn	[��h�Utu�
M�Q�Բ�?>0���C۟�֐��C��X����A�};(Ƚ�c��f,,�`)�ǋ�'Hm�j*�hϯи~�z�2�Y�W/>��]BY	-�JknL"Q	Km��r�d;\�3ݐ,�kdQ�����.��G�����Q�~D��ʱ��@1!%����7�E�4�.*cc�V��Ԇ�;;ra �	�յ��T4TF��bs�VT��z�~|��� �Cq�B< /��JfS]�Ms�C %N��CHLԷ���lI�ҿ�+כ�l|����&��N)ֆp#�:Iz �F�j���,;Џ�3��Чi�4��ŭ�-�d���jf�EC����M�?83�@=BK���s�aw�:�.,��N}V��T ,�� ��޶[;_���������y��}�Y��4���Ҳ��~�AnH!��"����FT!��_�-��OUFeY���w����'L<�����~���G���Lbr����<�R�ًN�-r���"�x��#z#
�K�z��6��/�:F�@%��#��jmH&�U9�{o���=a��V��Z�	�Ge�t���&�l {c0B7U0�)U(�VZ&[�>����
����]'��N��0�%�;}��o^9�N0� �����藷
���EP���P��B��X��<��O�ϊ~�@x�0"� ��u����� 9Sن��؈k>�z}\^x�h^g,��#6��G�����Q�p�`��/e@K���]�@w�c������qOv���Lc#=�!�|�Cx�EN'B�v����{����&v���M6���[M�%tJ�L,�~]MY'DɆB������Q!ĭ�P��t�&5o�O 7(k੮ɓ7l��='hc1��X�V+<�CrG!��0X����iWV��J�n� f�y�_D����Xs�/sSU��|h��8j��>��f���A��X�ɢ���&YA��Gp��0��Z�����Â�ͼ���`ˣ���(v�)pD�����[��bD��5����}���~1���'X�wGd���]=�]��{�qŔ�Yl��w�/]�mԍ�$�,6Y!��S�9�	 ��=�j��!ֆ[g��mW��O�Y�_�

�>�6`;��*q�C��w�����-��'mͭT��ߊ%�oT�Qg'���Q�*z1_G�-��P�"Tu��U��ˇ	�$N�Ĩ'�����#P`�w�"FB��R�v@0v�4Lw����>� c'/��C�啍�������h/�#�8��u��Ec�&RU�����ng�!� ��µ�T�8�A+v:2:JQ.*_�k�2Ɍ+�"T=O�8���B�`X ,8g$ï�6�	3f��W!����dkO{ �l-�ѿ�!�V@��:>$D!m *	�>���]��!�.�ø[l������(2LL���Ab~;��"����޻�"��<E5�t�!]�x�B�Jq�Sbz���$�(��t'�nT!j��b���Iً�6o��qX���7,���(Ѭ�)qo��қ
^ڤ�� ���G��[F��k�C�,����\��ˏD��g��MDG+�n|�M<��}�|Qq�@�?�gmP"赆����L&�{2�P%���8�28�ΐ+��oj��
�T�c�99-����0��d5r�9~���!]N9�ڄ���0/&j����+نLB�"����e��,��(|L/y,6 ��&�b[GY���y	�$�Qg̫|�X�Й�MyV�6Q�kU�_A�]�A�!P��Q��,��{�A~D]~���K������d�y�R���=����#Pg����� ��N�_�3(á�lR��y�k��_��-/� �Fhh���Lq|��g�6�gFc8�;���r�W�db�SM�[�2}����Y֖���*8f��oWT�(���zć����j�]���k���{-�Y�������A{2�y6��B�;�c �[BV�ק�����_��� [c��mo4�V7���o�I�L`s���
�@�@%=ދ�(���g��FOJ�2Q�����0���5����-����G���8�"��H�����5h��J���ӂ�z�<�W�$�yXg#�PM�z~�M�p�,n�}�����x��S=	�9����?���+c�U�d%��A*y�Bp~mز1Iw���
,��f'1PS�I�`�hRI�"Y�e�8�F����p��F�<<�?����]��ե��@����t��}��mZ��I+��.pg�a�𡧻����L^�]0�[�C5�*A&q��8!ot���KMo�/�P�E�D���I�LW�����p+�aǽ�,l��6��E�gЉhD�"���׏��/)�+'Q[l�R	y�@��ؠ5�����.�%7�=��<��"N2�F��ʌf��� K
��bk$�hYW�K<k�|P��@Sn+��O�"���N�f�:�(����V��Φ~���V�%��m���`�Z���9fq�P�XL!U�a�u�{�����{�|	sĘ�Sz�DX��k8iJ	?���<�Zb� ���*l�{��{k��i�����q�1�_Z>�ϋR�U@FFQb�[�����ľ���V!#���nD���'���荮0<�.���`���=ai���-� ��u)����Q\|�$(vI5�
��:���JA8��?f�p�P�a
"lãl��1'����� o�j�&��$�䬏�;�f�X��ǖݬ�d�r��Cdwf�5
T���c�(�<��Ū��C$~�F�g ��<�2�8<� ����2�b�����e��O��ﻍQx��(�?MV�C�p?y��dlF
Y.���ձ�B`DX�����2�:ɱ!�!�P�dA��<�Xa�>��q �Y�����W��G���k���V���|o��[�"\��&̱�L��'y����!)уb�]�>/�G��/���b���I��v�{d��ϠL�E����ї�`��B^5둬�y���o���Txq2/�߭�E��g��u�ӊ+�3E?�?�5X&�_�x�	l7�DN	lsZ�����U�/�7
V�w�1�l�V�xc�0��=k���u'����`Ԗ�2��5<��9��ly��#��ԃ'ݭ J�@�7�X6+;���1	��2҄Jb�O~� �iUr̟���GG[<U�"f�0/�a�9�] ��    �x)�A� Y�oa��[���λ<߻��̿�ΤF��Û8��(ljgóΐ�r����ta�����L��1D|���Yִ�m��b��t	1ze�0�D3���X�>�� o�z�q���SBK-CY�����=��X���	˹�8�K�Y���£ц�]lm^Q7Q��.���|�JH�/Q���x^s�X��3V�������7���ݼ���a9�W���I�+���+���ж� H�{�����&L�rt��({<����074�ן'�Ƅ���.VUO���i�a� ��b �U,<�D��/|�&���#��׵��\�ު�٧o����(��y�G�DS$�-��<HHQ�C�UɎ�qgq��
��	���zz�/�7�;ofZ��&5��� Z�S0���`5���88�;�0t���gDj<߼NB���"$��a�X��pgu�7�+U�3G�i�<!����B,C�S�؄�|�W7�K)&�<Q� �@Qh�
,�SD���^*��*���6]�;Z6�C��X'�_��g�$A�~�>�s�{�U>g����q3�?s�(-6�bd�s�������B���������-�{e���Z�B�b��h�qOW��z�����74uj�>۰�=�e\�3e+W��
T�O�i�j/js�\�k�@@"~��5��6���Oo�A�@�t�}&!�̓~ti�<P�Q�"����<_.#(?I�	�7	U�>���@t��"�Q���^�$��V��XyE��}v�-��H�z!�T��u�e%�]�+�6q�Q����R12DMaG�v�)�m{��s6z3��ݙQ�Cf�$�?U�)�jw1!_]�`�,��,B@w�ɉ���տ��#z 3M�Z|e��� g�Y��O��I�� 6�#~e.Y6:�N�����l���j�7��f������?��N���A�.w����G��wI5�kW�TX���.1���b��>�
��tJ�M�T�K(|����Wt�QHMF��ݺMb셂�n�#���J�$�_"D������-��zS�))b�e�e?]���6Jg�V&B�|�d�Z��q�F40��Eh���榘�l ��]������]Qs��!��O:�[ɍ��)<������	u���W �M��:awd����XAo������A��*1>�A�'��3O����	�"&�2L�{y�ӭ_z�~�opb	S��z��2Fy�A�豨#�N���DX|6�>*�j$o*�~�m����E���QI�q�a�����ʠjJ��#t�� K��b�c<$���^�Ń"�D��z�T^OSh޹3��"`�o���|W�M�2�q��TNӐ����y�H׷0ܟR��{?sp9�������u39�!��
Uw��X��bnP���E���d?�#��[��D������.�(�YU���x�ս!K7j9���	�q��
"�0^��Yɖ^k^�� X��s~���������|)����`���#��]j^��N�~}�H,{��#���6~�~b��A�P�c��t����0��5�-Z=8����h'�c[\�W��V$���'�DR����Z�0��c��IPi�j���x�[*�0�8�٭�a|n�����7j�4���WM�,S�4 2�={��Q��-}�"n�[QNķ����G�ߧ�ӫ��E�T�,5g��#6V��Y �VM���J�U�
��9��p�|x�Pu�=�Dub=�����{����,����ry�s��ǡ]��[멠�;U�A%��\��D[�	R���]�(VՁȺ��=� ����F�ާ��X^Y�P�z�X]6B������fK~�Au�k4�ǿT#�V���k���ME��
�<��o�?��7��kjv���*��$,1�,���(qe�3%��e�CTbp�'�b�4þ���XBM JlZ�[�T���.��sd����� ���_�� ����/�I�X�u�|�dZ�a��4�7k�ٍ
m��3���4]��X���]7��WC>� +��8_+�pKN��n	�<T�-�]�j66/�����|���Xy�[q�p�0�
�!�'�o8� �#X���J�n�10��W��+��x1s`oN%oFS<3�Ld�{�^W-��Ҋ��!:�����P{U����ׂPB�^���T�(���t:�P�K�~�_^�i�@5�UX�Ce%���O���Q��6���R����&����g[P1CK-v|Ԛ�KM��2P��2�<�N�& ��m����^z��+1G��-
3�r��Ur��NE�Y~=�5�"(ԛ�b��,�>!ƠzV��A$�b{��%F�	s�Y�����<�\ ���(�����,�#Tt��~x��m8ƪ����5�Hw�Ĥ�*B[���}��u}�o����W�p�?� ���Z߅|��,��*�[Xb��{c��j`
1��t=]�9�.��Z�?�������0!�2�Y�#��Y	w���C6	��������3!k��ay��:����qB2���_�$�<��)�9��P|6���u{>��P~��S5 |#C�l�I'��0��TVЍ���yڱ%$������5oj��R������%Z~��3�E�x,#��x��������;B���	�w"E��8�atV��/k:˵�QOs)�)��||�;�HcD����eZt�;H��Pxs~M�@Eh�q�.�<�������J�#�Q���gQ��T}"�e�����a"Ol<c�_>���F:� ��Y�@6挪����!���rgz8�qEtgkҾ"FK�.!@�,�l����{s��K}
��6	�X;�A���x���`-�� Jr�D�zӉ�B�]�Eu��
��6�¿��l�G rdM������cD6�D�$U���,����5�o���!��f����a�{���� i��a#.�$)Ɇp��I(B�/!c����n`"�|�]��C93�X�FO�Z��˧Y����U�16<�t�<H&R��R��aX�%���-�b0�D�	,�/H�&������6����G�N��~��:p�[xn�t%/{�\�o�C'�M�Ԙ�Z�2F�7�dA��ї��Ё��L��2L�$oy���f����\�A]��e�	���X�[s�y�G]�6������� ]�c�� f�/��E��GP%��d>H}���<�E�J1�:R$�^�H=� �d�ZtإV��]��(�N
�n_�Nv�Q�3��A-�`�m�X��	U��vm ���p+@奟���A4��f2TԮ/Y�禖��6�1�7��b��Wf�jB2!���Y*���N�A�-Hѓ��9��������A�`��}��M�B��d������/v:�T!|>XvwR�r&3ȼ@�u�͖W��&��A�kW��6��4v��t$J�* ����_�����������@����q���%���:��1�X3�������{L6S����u�0�kuf+��A,�S�rF8�^��T�|���9�ᅞ������ܽx���T 7�CN��#'[my�d^&)p��G�d��[a)U�7ZD��t�*��n�?�V"�~`F0��؀�ؓA
�m6i$魜=��x�$�P��U��n�߳�ث��<w���SK�R*��X�\�^)�z]�}��~��7�M�*�*��^���H����<�(< �لD��{ŞƂ8�vDz
�:��G���8��\Ϯ��ي��iǾ���l�j�1�p%����w@��$��	�\1��A�Q���5gq<L���T_h ��Q��L�	߬[D���ȩh�
�v:Z�ɧl��,הR�+����*&k7�v�bN=܇u���BRx�mk������o� ����� ���&�3���5P�}��LK^
�ު����%�^*� F!?�z�ĂK�"��f��Z��s=��uÛM�K�+CZ�5���
.��_�?�*�P��>%+��,�ƚ;�J۪�7��"P��i����Nm��v��    ��V�;<J�:�y�0�z �E�0�����Y�&��h���Aq��6yz�;����hX�8?:��#��B�_m>l��Β�N��*@k,B����i�Hoy�c}�~{�hő_Y����c�9�Rq�p��n_Dk��� 5��0P���T��Ȣ[�-�S���˾��%�Y�� ��Wb����{O�2q�� aO+$ۆ[M�8�!�[�v�[����P'E�D�2v���|h�(ӎ�m(Ed~���.�v,���"��`����6�7��G���F�!�R%�8�g6>�;(DJ�O��[�?!��ެX]Poj��@!"�˪��ڽ{#&� �w#k���5M=H��QtL�PUlB���[����R8��m�8�,��zmәD��[o����[a4��>��I�m
�!1?����^��� }o�q�ϯ� M7y�+n�H�E*��	z�9��P.���5��D�Ӥ*k̚������`3��ɧ:g��#L� '.�?T~��go�|S7Gb�Y��$������m��$Я�4l��z�Pt<C��_;�D���!�1�t�����u^B�3�҉amy`~����,J)�b^���M�g�&A�y�:
�!\�)$�zU*$�A*�� If�%[Fq�}���B�� ��c��[Ob�>��E�j���Q�L;Ǻ\��YRS̃���\)ՃN� {�ɱ�ǋ.5��D�`����.2�����U�z9;�o��8�'n��4�oۇղE
�zU�nXA*Rc]���fqrKǊ�v���?vЊ�qݱ�������;�E�y�8��B+<�%r���"��=�樲�g��ĝ?����Ӻ�Z�Ü�|�0�|g:�v�<���A,j�,�������6 'C����0�&���cYz׺�y�tW�;��uq�ŝ�	}�ZU�KU�����&��P�Is�!ѭSr!7
��_��ߊL�u�,�͖���x@0�S~w�����A1N�q�[���T�~Э�Q��i�$̅�!Iɚd)#�M��f�%j��Z�`���D�dg��U[�(��i��� �q*�@�p�(�1)��}rC<KpL��ƙ&Pͣ�4z�)��U/�&ˀZ�tb�VKTi'MѱV7�W_��kv)�=��d���q�?r<����n���_���Z�T(;��t�3U9s ���b�I3���fz���up0��h�i2 5����^���dt� �P��\�$�,�:6�N	^���q��/����~��Xf��3҃[z����n����ןذN�r��<b��O��/�q����Cǿζ� j,O\�ed��Y�<����� +�Vأ�l�T=g�������}U Tݳ{~,���.N�9��P=�o���C݋w�&$���k���+*ϧ>��h�יz<��:;.̀1��l�~V��������\�}�qx�i��BX~b�q��Jި���C�F����NB��۾+?0�w4�_�<;l��Ǚ������j����W��&./xv�m�����03S�䦺)��?<0轋�I��,��x�����P���@������e1zM�H�� C�e�ңS��;�+��U�X,�=�3v�	a"1���Bh<n�(��^ ���k��G;K����6�BY{��~�����IL�C�,��ʦ�óh8��P��LA)��)��q/��� ���3���<��f{=�8E�|�v<�3^F�+�!���xt�k��!��t.��Z4������z_Zչ�3�}�u�O����_Zoq �N�rv{��aQ�
�l���G��_\$yIa�!��F���Zۭu�u�����h�8���vƵ�Z}�s,	��7�t����@ +�P�lBΪi��uG�MH�G��g�&�&�4%��R���!������6��{����g�#1M��^�\���n5.Xj=yc�G_H�A\?[��	�@�"�Q7{2`:�?��Έ�Q�0�2n���Ų��D3M��v&���3�7�N-���K������Wz'���}���@f��@�::2=�d>O�� ���:Uɶ!<^#h4+{�E_�A����P�xV�6l���J��AP���VK�i
f
ȴ�X^��c�o���螱��X�Z�mx� F��#|X�����,�ｳ
zѐ6k�����2�@��� p^H����;�Tc����0�x4g"u�n��(���z��/aaz}���eG��OwW�h�
�W~����^�{�Rc�a�,+��u�� ����ȫ8nP�B@�<+�������v������� P	�bO6�MC��j R�/�Q7Ae[qx>l�D�;��~�<.�Uw{�`��Ʒ��t=V�6,q�]U�t�iB�C�㹲Ab�/x�DL=���0�/����7���<Xi�q�)����hBW����`�[�zʞ��m���.�`,��>�8[_��k-|� �u���e���I�E���~g��K��$��V�C���3J��&�F}�@�� E���7|��Dz�]�g�E��ڄD�Ŗ���N{��A^+���b���W�@��E
ɢ����S ��Q�ǋ&��^�V~PEs0u���`�Ɇ�s1#CL�G.'#]zӈyi<��U$��1�����7�b�r����|�6awc[_,�`�~Δ=�V'L�_� j/�0R$(�����fϓ�hX���=��#W�3�����t���R����G1PK��V�gM�U����@�l��K�k��@Ġ5ő������� ��� e�C�M�4�d�-xy��G"��z��\/�R)bQwh�8�E5�'�qk�ZAl��=LwPedA4��G{�+ڑ��Jjc�h�Xb�Z��f};���4)�4�Vg�����\n����B�x:�l�DLq|�Ce��#��zl�mPMe��N�Y�����X�.f�<�dԯB�IT���|���U�&��.ֳ���	$��G��(�lЗ�����?�Zi֝�k���5�<,�M%ضX�eL-d�(,������ġ�����/�E�\��W��=3o@�d�,l%��>8a9���&XsD`f@������u,��8,l�[.���B����g��Qy$i��;-"@��AI���z%2�|�l���3ػ+S���iC�<�:[�n����*w\ �Zr��{;�<�������� �o�ӵ�;���0�V�.�Dv�%���F ��C����#�,|� ,��ǣ�-�B��K�AD*.���㬇9���u���h����_D��߂X�߇u��wB��~�3����z�����",i&���ը�h��LP�vhG��~��V00�'�1������b����#JeB�EU{7n�0A%&y����ϻ`!q���Ĉ�k�fk%f�}�5h���t�&,��]}MZ��j*��Z�=�Ff�銗�u�M�!"HXt?T�����
*[ڔ�]������f5K�}��! 
���=~wN�'�=��1��)�A � �;T�vN���H��ǔ�KO6�zR�KL}b���8��P20���vy�.���>�'�Cz���kL�wH5�,��Jc�P��.vB}@	���=�����Z�,�b7�G�=�K0�Y�v��,���� �ք�҈��r���2Do�9<@b|�NXg���]��o5��9��[<:x�>O���X3�Zʕ��4{ī�!����&8Ü�ꢷE#�{w�Ā2��'R���?6Y|���K����i*܊9��O�޵{e�	�,3�W��N����P��Q9�hZ�`�
��2�4�	�0�'`>���,-X����[֓q������z�t��0@�x+a0a� ��-�b}����*��,�q�]���c�ei/��u\ m*BQ��cu�
�e=)�݄���NL#2���t���WOv91{Gӎ���"�l5+�Q�;�.���V�zߑ���*�o��40=��� ���{ݠ�4�-�r�Q�j;�$�0g���J�LM�~k�|a*�-3/D�0����f�5����    ,���l�N��͋��.SW[Y@��zt,�zMW��="lB-��S��P���K� �2��}�J(��ݚ��E�N���vĝ�B��3i����}g��1蕋#��x�e���{p2f@���x���w��䕡����77�l�NL�諸jt�k���W����^/::�\Ȫ����+�׋)����C���rY�=�-�_��}p8~�r�`0 �K���ce��(H\7:6\�@�P-���V�Sh|q��ևe��$H#d���08�&f�?)a����`�b�'-ٷw����4,\)|��Q{�lP���Ŝ~5��ѫ��\�xf ��S�N!��z�)���q�$/M�b�Ѣ�O�+U�����|�<�M�,,~����5�����(�x&%��LF�-���ꄤ����!urI��m���,�a>�?i�:�|��DYpx'~X���b�<m����k����)&g���=N��/&��N>{��̹�-px��US��"|O���W� ���{�-�/�J`.b\�f�I{�z0�JT�m=�	4v��f�!�34��l��?����a����A.��g��,CLH�t~��@�uP���Ao
!n�
�W������?�	� ^�5��溆Mv0�,������A���,���i��\��;��T]�x�`����(�F�tV}n� �0����`��{�Y�HA96��2�������D��y���XO��3m5�bJs��������<]6�uo�wU=���u����O{�TBf�0L���SzQ�`��)�/Z=	x�&�/���At����S�R�b�L��a���'-�	L��ALW��`�"d��&���eb6
�9d���˚q��� Q�e�X#�;7��p[�Eȥלh���,cG���ge��ImP �@�2,5�{Uh�-j#������r#d��BlO��Ꝧl��~6�s̔���~>tO4dt�Ȫ������ԙM�aX�7��m�lup���qJ��2݊���	Owu�'�ڟ�d�C�6b��A`0�b|�����s�D)�?!w�:�A�D�����r"q0N��K�����Y�q\D!'�$7y�@ri���6,8�0�/�C�y��8���$Q�&Ϥ��BZ��}�'�~��IEc``e��y\�m�=�nˆ���f��K����N�J9�h�8�Ux����
A�,A�f�=OR T�>�lj��D`1�����`%�p�-�=d���cp[BO*M�d*�rh�[���@q�\��>�����;tbf(�P���45�z�OS���	4-���u{����DL2P<��\g��e����f�1K�ܻ�� E�%����V�HS�x�A�b�WD#xZ�0�w&5!!�І��,�a�eo|n�*+!��\�У��a�NB2(ᕶ��8U��ٯN��z��1�ܖ��YH�����-}��y�UUàx6���F�@���}�����mg˸Xq/���0��L����o(�E��c^Cl�LQ��:q����^!��1+[<�"�wB�D�cY�p��8C��X� ���/B��Z��DLx�)&y�|E�&&z��]�61Z�[H���̶G��S>=����.���7�Nؤ��Yt�N��m*�R%�B�����W��ح@,*���J�C��Ou��^ok��}�ha1u}�&�D�r�ۀ�'�A? �@���9�,RT��/�GVD�Y��9"&�^��lɱ�*����79��}(_�`G!)N)F�b.$�Y�J��w��`�W�l�V\h`_ï��D�w�":X��X���y�����j��!z�[� �0gY#���^�@0�t��%�C�U�/��*��
[�$[a� L&�� ��Vyg�9�1���h��#q�a,����?�QBa&/0���MD���k.B�GԆu���@�)��;@1����-�O�����v&�����.�8@0�:H:"J�54�³���u+��}��'bc�-��&XEz�q�8�4m�'�=u�9N�9�����!=�OÎ�	�a��$�Wȏ�����]`�U�NP��/�g�!E� ��q��1�kx��Ϡ2��#���5�� �g�d��$�ݐϾ�	��t��jg��l��( d��.�d�=g~{Fe�"���&K��JH��o�m��Ɍ�m�B�'�"�:����x��������M{1�,��'��P�	eO��k���?��Z�2K�Rمa�ށ8���!��;M�@�S6O|���g�	�����pq��eӫ�I^����������7VӇ��i)m��	���߯�r雲A�.�I��Ea���P@�P�+��w}�W��;��A`�n����rԖ�����sxZx��+Pv�N��q����"�����$XE��n4������٘�_X:�R�]��6Ah�!��r�1�We��i��ķ�6�\�bB.B�E���ܼ�C5i@侈�FO���ҭ���EB�nl��V#Y㡺h̭)��i?`����#��>q
���\��hF�RA�n6���\?n�.� �&���^ Ͻ�UT��(�8��[VzP�aV� ����Y_#�'���7��͒3	�">Ǖ��q(�"tR'���V_­'b�k,Kؿs}"7�^0��_�����v<��F�x�VۊL����d�{Y`21�kMt�<�l���Z�ﭻ�,��JH�*_�?&����vI!�͊g+���|%���.-`+	^K��$�o�ބ�F6#����3���z�g�0s-�AUt���>�2LL"���<��1ݍ��z�i�u6�(�Yf�)�((�_%]'� �\N�G;y�Y�3Xc*�7�_���,G�	���b'��,���g����P�MƵ�s��͓��T'h�v
�>֭�U�]?�g��(�|Э�.�'�>Q���[�3j!T���R��rS;,�^�f>t�7�>F�(�������*odA/�T�ѽ��C�	I���h �H�uCE�F)1��JF���ȹMW�R6#�����u�.�ҝr-,���C��n�����"8���A�j�A`;���v���H��z���ظ�(�N���dF����(!�P=�I^����uB�jX�1˺�*~`f(��0*�a����<������dH�xNL%f���$ �e��\���l%[	������Y`��-�Du�.�g��}21�����nG* �cċ|�����Q}j�`a\�R><c#�	نW��y�5 dރKބ����_ä�.㳤nSjND���o6"��M!��E�lcVr��]lZ~��D�Z���_big"�=�2t	:��K������#����#�;1�l�����W`g,��jB�9�^W'4� Ybs���5YU;���0�e�C��cD�^qy�xk���ؚ<�	�flS/�l�U�i���jl��O�&���a	XF�P��q=]G��k>]���:3dd�:a��߳O� ��W]���P���s�:��� w���`�$d��d��oI��C>%kt��F�yK,#'ߒU�b)�c��S�I�"�/�O��������'IU	=}9A/6
� ��z+n[����E�|@r2 7z�^����h�����w�>��X�) �.w n$jf�����B��O-:���d�N���-�*:zH�o;���3�	��wx>���y+3!�cj	KB��%Q�(Os���������yUѫ\6c	ל�	�GMn��$�DU����x��^*rB!��<n�����& ̥ʙ�~$����9_�O�ml�w�ؿA7��3�(~+��S�P�v�	f��~��h{U3
e�� Vє(��zJ�7{��`6n?�炙3�8(�o��Lx>]�+q��o��Hry��9�x'T%*y��/�2&�V���i�ZG�pt9h�_:D�	C��N�6чQ�7��al�5��P��Y�J�.�����X�ӻG�+��q=�������l���8�q�`|�lq!͘0Q��x�n����P�;��b I  �?��&�0O�-?, ���j���F�����&Y�������_�Ǳ�ң.��x�O��ݧ��B��t��D�?o�lm���>ϻ)���B���-a�0�w�ͥ�����B`��Tt��3�Uԧ�k�}n�ɹ��ao~ϙ���{�m��G��BqO��z7[���iN��n΢�E+�χ�ș��֚�ؤ6	�Up�iP����r݋ ���&Ϫ��L����Z��1�gQ�����\�������f���O����:�A����͝D�ɽ04����45	P7�������k逪��|���s0]��̿����݉��!]m�n\VS{��B���������      �   �   x�5P;n�0��S� E��;�:0�5#=%B� 崹}i9]D�|?ꉶ�B��]���YZ�C �)`{�X��[���6�������(u�|�r�2��/���N'����lN1W��E+����RUHYb6�S=U��^��h^�d?;Kѝ,�=�}	Ǥ����w{'��������*���\6C��"7|{��*�A�#��h� s\�?�S�f��I;p��/����	�u�l��|���      �      x��Zˎ"I�]_aRK��RB���t�<���Ro�/w�D������Lw�T�QI�h�j��9��Hr�KU�x�5�v��^�`p�� ���U��<��6�rɆ"�L36���T�S��8yx�l����<mp�eM�Fa��8b�ah>���N��L3�����i�kǶ�Z0
�SĂ����0�����!VIƟ�FFt��6~�eʂ�J4�J�H�Vgy����k��Æ�/��e�ۍ�MH�5J��}g��۶]�\ÿLW�h>�\��aI*���O�LO��7?�g2���0an��m��[Ӧo��L�s�I�x�����1�o���xW���ێ�?��A�|�S��x�(�?:����g��^�s]ϫ��j���~F{��`<�Y,����{�ڤ��N����)�ȃ�.��S*�$UZ���経9�ؠ���?h��o{�	6{�+3�7��np���j�֚���DAk���enE.3,�a���0I����$T�_	�!n��pG�p<Ss^@����Y�v���ǣ	��}2[����O�e�?�Q���ӗ��K��R�).��Ys�k`����}$�����CL�l��ZM��4�R2�k8ZC��^�6j���f�ӯQ�J �]��Z���%��O��|��v0Q¯�;�@h��7q�*Wd��w��@H~�;�-��2�u��0<
��$�b��� ����\����{��po&�rC��)ea)Uԛ��]V���jXv��*�:���C��dWo'Q$R^:4c�(<���7|��$�Y�\"4^����L<	�oF�U�]Ǭ�bs�{C��p�J��ͪ��u��9kv>��;,I"�` c�%�M̗m��4�|y��� F�,�JvZ�G��A����VК?`z˼�^�{��ǃH�D�i�����>�K��,g-��a�p�4Y� ��R��Ȅ�C���o�n�u�����:�y���4��hZ�"B�-sy,v���0�������BLߧ�Հ�oޤ?�+�3}�:����Vw<��y�}=+$\�	c8�}����P��+�}���	R�65��&̏�@t�Y�Q/����x8�1��L~��a���\a��'����,K�d������܏=z�)�D�'�@�M�6䴺fa'Rq#8�B��喖G�.�� ���>Z��U�7��)��2,q+#8��@�o�~�$��*��A�����b�:�u�z{�ڬ�
�o����5���q�G�\�$�Ge2}�k�|���}�М
���u8���}��j�!�k��;�[N0Ŗ~1���"-by�g�}a�V�T�8������-�B���p�(��|���Z'��A�"&��e�qAc��7fڼOH��	B镓M��=�v�f�neh��Y�Li�;)d	e镌�4!`�T���%����͚�Ç@�T,�{(���]7-þ^9��`��B�0"�J�"Z%  �[iq�D-`�-��ش|��~��o�lΦ��}�Vp���f�I���.�a/�X�r.7��Y#h�v(�	�&X�Gւ��Q�G���9�3�i��\��-�eHߘ�;��{h �5�kd�y�̔��)pq�®���}�=dmL�Ȳ�B��	�����l�/��i��Y�vi�1Mb˓�:�̻ͳx ?���>�i���j�ɧ��[Y�%�"1t�K�O��o(����`�W���*#��Hx����Aѥ�-�H�Gn9�w|	YO�4�%d=��uM��rmٺ2<={���r������ų�f���U��4y�����5����W�5exV޴	�=�j"	�'��m���\$�h��[$J�͑Ρ��Rc�\DX���-�����k,�a�k�����)�"D����� �KDbB7 �.��M@ W�;Nyu>����P�BMQ�&XD��Jͦm�s���}0��=N� q�D����]�:����8 ���0�ED�[�]T��K�<��RB��� 	���g����-~������=�����bi�ʲ�/{� �� �x�P�R���7>A�OIh$�!]�Lcʸ�cS��KM �J:��?L0�І&�X�P�B��;�V�	�Jߠ��t1hp��1�L��N��|Et����l*���wI�:U�M��w>��W� ��pM�A��j� � �M��Z�����ٚy�ϔ��l��3��9�bU��6�r;�>�tb���xp�>�~LD�O�bD�N 7c�;@���G�?�	�6�3�o����[��R���ZҸ$R�I�B��S6YQ
9�%Q���l��JaM?PV��𫳍K��|�e�;�Z�7F���xT@{��C��"���o�>nK!��Y��Q�9��,)��A��ꦍ���2��+�&�����g�Z�x�Que�u �Ժ����:�ZM�<���#��B	�5�@\̌����s���J}���6D��5�1�@���8�kU���:jN�˜�O��>
כ�H�T��kp�/QZ7��l \�H�b�n�O���J%���Fh��#f�7s�˔֙�jVX���ɛy�T���PR8Gi	���O�'y�?�B�dl�ܝ|(U����(���Ψ������:��%k'��=.^��e�CQ,d��
_i ,^�Kw�r݊�U��	Ͱ6Z؝� �-|�N, UZkC�"`�	��72I\�v�T.��u�4�#�Qv'�r��Ur��5l(Z��rm7t�=��N�P�H����B�4) �7|���D�X�� A-�l�L	-�}PU�^1���m��_����}�Z��)��r�����AKRu��#aN����MY�Ci��*���]H´�G�}��z�,"�CUF���c:�g��}b+DB�k\Jү1��j.���s�l�f�:H��=խc\��?��2t.�t�36� &�T��i�+6�1��" ��oq�P���1UXn)�>���r��lë4�����=�z^��3�B�.������PZC������m��L"�z�����1��� ��ґ��d�g�}S�� d[��ϊ=&&ӥ@r&��$>����o�g¶+��L��/���8Tx��$!!�NH���ɰ�<�.��M[�|��0M��l]�a;��h�f�Y��wI/�p��=����Jh�k{3�).��`�d_�Q~���`�BHf��C0(H�:��i�m����o�	��QgB��̠��D�*�t��!��~.�|���%؂O�-HF*>V����7�·]�:t,�6�fԀ�4 ��H�Ӱ�C���09 ��"9 ��ACR{P���{BjaJH��;��Q���mbi��륎��fm<\W[>Iо�@>)�բm
҂֔�M�I������0�u]�.4%�g�c�i$q4ɓWC�6�L�C���R*b�¿��~��W�������"�A%A�BM���&�u�\o�W��3W��^��p<���!Ծ+;�2+��6�rD�3�%�{�x�9_�ԕ�>8�` ��1T	L�t�zC%>_f��x:��u9�D��p���4�U�T7�s�	��}!1�*�W��٣���oO!��+�)��j�V'�1�t�� ���r�� _���@�*���*z������\n�����8���?� 5��.�R^�A�q��ъ?"�W�J�&@�$�����4	�k���[��̂>	���R_s/5�gU����7�y���y��F��sFbt*"�4T�}�IDGu�q>�����g(�HOPCQ٤�\���NA�2�-�8�6���A)B�l�B��0?})�I��S�8ʤ�����4Ɓ����M+�4�M�ٳ� 7[Fô��p��c׭M:�^���	���K|	`d!�4���t�:��-p#o�(�P
dN��7z��#:C���|X0�Zc6	�Ǣ�Ӊ��f�O���`�*[ferݢ_�M�"㥷�؎Qq�+�6��F=6|�2��	T�1�7	�a5R%=��^|��"�f���#�y�&�k;o���i3�������y��`@��U��	��o�d��B��xϱ�   7�B�����_Յ�a�c6�SdH gm��A�4�AD��&'Hے�@���l��{(<߶>=�N��#�l����L}�IR�.�<�>4���x.�#2���_%ﴊX>�h�ĵ���[ae���^V1�`�격jv�G�I>�/������W�@� \ J���i���rRTLe>oa*yc����gd���|f�Bq+o�oY��]>��R}
V����?6B���Y���L�2��j��=J�\�C���@�H���8��ɵ�$�2$&)$KL��}1��I��u�UKʨ��0�
ǥ���F,L륊�`K��A�< SC�v����R,���ܸ�:Q!���W!bZ�Y"f1{�Yl��P�o�7ؐZ��A7��v'�V�trS�����Cy�kh��4�G`@5���a�{Vv��3�A��R�ɏ�;�p�Q��FDPo�<�B���_��a}�Z�m֪#]�͂���Jd"~n���E�^S(�O��˔ԡ�72�Vl�w����������#C�:��y�b��� ��\[.,~��x�uQ���zNM܁t����C�(�fŧOT[�k&!��^�y��3��Ҿ�|u�2�|�̨9
��I���(e�KҼ_P	�z3}�jSQ5�"���mn��o�]�z\eS50���R�e|����Y�:axq+����Q.s�����7~\|Ӗ1���:/_�@��k��6:���ꊤ��i k't�H�YL��vc�.�Hrc�X�+��nö����1d6��������@��_P�AQm#܊8[n�d��o]>i��J�LDJ��=~�<d��g9(E^��mص��d
'�����:}���Ԛ˖DIHh9ucn�P�*����ā9��²�q�m�R��V�:J2����F�ͻ�f��7td��~�t�>�|~Nn,�
� ?}4@����80�֢��׵�锴�����J�R�ɓ�0Y@n�z��%��6RNx<F����*�7�e56�3��ٖ�9gh{t�rz�g���!��<�e|����?� x�N�ΕevcɃ�+Mmy��j��i�W��MGߺa��k��mX��� ���ڧ����"����Kn�1�KA)����||GN��.S]��_N���n�ҞQ/�AF
��S�F%C���������R���~�l�ytl�TvWFM��&F﨩/V>/Ss&1���2:`�������l�,���#e��1K?L�
~ԭS��g��`������]��1��및p�~Dr@R�����P/D�
��N��(Yc�(NJ7�"��Յ�<A�:�\�Lhr�z�yG�]T��]��-��7M���qy窠B����\�]g]����Զ�S�vasԙog�J���Ie��D���\U�I~�ol������x�PK�N-������ ��6��˵^{F�>�@/�)齏~��d�GQ)��Хwi3����;*�'Ƚ��#�w��ڴ鍓�`:�Gz �+���@��%��d[�"�)V��x+�QA&}�D�]+���^G�쀀_.k������c�I�\Bg���EG>o�u>I��Y�L����/�5]�g�M�K�H7�>v{�"�V�^��p[Y���߷�[L��u���l��.�_R@*�_��nxo���x=ĺ{�a���v��,��i���9K��ݢ��̶E����B�ga�U�̀<�x\���=el��8��G {r���QW��sv�[����?�8�O��x^}5�
�4y��!�Q<���@�N�L���2˨��ZueT�c�V��/oسD      �   �   x�%���E!е3'@xB/��:&��
G�h_�ٶ����˲�Ɗ����~%��;V �]������l.G�_c���=�Z��p��#�~F]�p�db����d���\M�Y�����,8|l�~�ȫ�<��	�3���J�D/I�r�,�G�j^/�ci^/N>�c̾T��󿿽�?��@      �   �  x��W�n�J]��� ��>Erv��ȉ�ǵd�"�RGT�n7)G�� �,&�Y�N?6�)�V��5[MR]]��SثϺ�埍,-;�rS�t��Bv՘bʭT:�Op)�i ��05�j��*�b/ث���	{�^ipHI�tB���/�Bv!���T�+K��S��DTr2�-MEU��3�Ҕ�P��K%mmx�q�ң��Li�G��^l�c�){?�!��ob��&��q��������^���r��W�N�\�Z�]��T�����؈W�ҵXa��y-�aR��|�MIץ�zJQόq��7,�?�!
���4Jv�Q����ӳ��w�#Q����T��p+�9�.�y'����9�8��xX��n�q9"i��/�b/|����d�}�6uYp*���-�+��p{�lj����n8�A#Η�4}��(��9n�qO_k�+���R�R���#�eQ��)-�Ĺ� ��]J�����v����~�˩�;����63M��Fwf��|��vI�<B�=�8
:i����Cz��SA��T%�J q+Ƈ�Ӻ^������{o.�����B�_�֖b������Xؗ�v;oZ���Rvŗ�^�#�h�7�u���៩d;��c�k�-�
B����(�ndp%g��d��8�+,ۺ�q�	�8zZu�,sHf�Y�W5H$m���n�t%j��VVD}��Ü�pL t�W8�*����.�i�@��ֈ�mK���>����b&�f���^�����}�ٛ ;��%:�P��Q0h�u�8�.Z�^�B15̳��	ʹ��]c�>8{�D
�ro.�,���ồ�Rf�D�/������?}+�,�qXMW��������"+d�I��n�o��N!a4Z�o����h0��? ����{5�u���Ia&��B���
JX_�Ά�i���0s�V�w U��,N���!�����;c�2���jb���|��̠㽁K�S_`�7
%Q(�V �,㱾F��q����N��S�h]?���tsw�0Mw�����6�B�\@m;���F[O��-*;A�V.� 9-����9�;SB�A%z����M׺̦s#J�1Arv�|�B�Z��4N��L�4Dٳ4�vq�̰��O&�� ���g��c�*�(�n��Q�p��҄]��1g#>{S�ʅGR׏��i�%�}y}��ll-HLv&�\����N�����,�!�)�+��8�nL�r#�A�n�{����<����벾��i]S߈{ʍ¬*�Ū�-8m۫W�Q���cQ��ԡ��R�6�@H��[��*��5���6��[������`��vF�O�w���\�	`B}\4!p}��*�\s��sT�b6��|#<A�Ax��'F��N�?�'��'��Z�0��04�j�%�B��7��~tD׍sKK�Y����������E�4�1B�������"���n��:lϔ�s�+5�PAX#GeJ�R����1pP�[$+�뻇�ly3l]���Z�D,`O(��
!�\
#�_-K'S;�1?��������e���:j(f��w�1b�T+�]d��ʍ�i��#�	l���V����!�k3�p0�I�{�E�`�sf��+5���Jv!!O��sY��#����fh���N+�x"�bq��q�g�A���9-��X�a��b�N��Ѱ)��`[�w	x#�Yҵ���ń����m�?���A5�� �OaTHg᷇�`�f6��rs��S!g3��4j[6E�S�����aՋ�
�כ1*
P��R����1��� o�%_a;dv��H�<���d$��^�����F_:m�!�)\V�J%V�bt��xw��p;P�P��U����4�a�&�`�9��8P�@=��t��[�ot@u�拣�o��]�e���q;ת6��b4��cQ���-���iz�[��^��P[s�ջ�2�3��@6�,䳯Kp��A�kw㈂$j�cT;�d��dp�n��n��*mO��W��f�k�k��7�]�_�
����Gd éG7Z�@(��V��<]�xI�D��0�:����"�휟�V[����s�ݧhӉl�Z@����)��1b�yi��3��>}N�9:̝����D˃�w��U�p�tS��9:q��Ɠ֊P���R�#��6Q:�~�{�c��]��������?E��      �   �  x��W�r�:]#_��Se)"Ej�<��J�,���&!P��}�����*�e.�t/v%�M��.t�c+QK����J'�^=K�tC�̳� I�>��;����|�ӑ���Y����Q/�~��[I�}-�Â�gI���;KG��<���|�OY�M�����.��͕.�D�_,�ߺ]Q��lv|mM�/�ي�����F��)����|:r��$�3�0Ͷ�^��_-��f�=>b��_����pw���F6O�Ң{#�o����W�_:(�!KY���_�>��x�O�d�S�NJ���x��퇔��ֵ�l�K+_�T!�-�U%�=�mve	����d���36���Un�5;v/p#1���L�Y��Y1��r+	�J^��+¤��P�2"�q�K\��^�;ux]��Sz�7B� t@u���� �E���5�뿬�EN���(��g+E��gi��S�5J�R:��z���.�.���o����M�
��8Ĺ߄n��q�4��E�D¶'�ʏ�a�RXT��cTӡ�FTY4�2��w�եO5j
���e%��.#�X���[Q��*��j��fkl��9f�!{�~Zg렬 �1��`�C7��O6��I\�Q���l<MS�4�;~Q?�C���?k��6��(m�%P�8σ�©�
T]�x)7VJB��d����u/��8�Wˍ�g�K���kx�ز��zB���7V4���R��.�1NT`�XI�R�6��Gt��(�y��]A�:�O�UI��S��ح�c����{��O�y㐱c�%Ɉ�au'�Ơ�;��}����fk��<�N;��)Z�s�Zoj�*^+(O���>_ual��!O��c	�d�ρDv4�y�[@Kbo ���u��dҳL����p��7�*�zM���� ��;�|k��Wִ��7�ы�H�6h��E[TP�f+�4;���!�	oX"���ɔ%�,,�����kk%g�>�v�~��ΦI�=�e3��q�=���9�[���Zcȸ�<EW(�'�!�+9���R��	���d�d�w�e'���c��RpM8T�~(�Xc��m�EZGRb�L�ڎK�/���^�}#b1��1������x�'C�pk_�E!�C �{Y�}�
�樓�M��z�j
Қ�U�h�K�oe}��}�����.!hM�ŴNb|Z��`�֮/S>}���t�pHg����حz��W�s��a�>[.ι,�6�*�9����׮t��1���Y ��'��t����y�:lL�� ɽ�	�r�lk������u�3u�y�Tq�A���f����;k����N�G4Z�?^,�c��ߢͶ�+c#^�1d�����h��wt2��#��4$9�Xb���HL`����~��[I�0�l����s���#��|>c�$6�X �b����;��~CӭݺH��`���ڡB�����mB��gL�:�����6B���줰,�Op4K��ǉN�)O��R��[k�2�n��ZZ{�c��{��1����n����0vz�4��v�S>4��R{f�4��(I������,;n�I2��t�e��p�~F?���;�U ̇l==@E���S����.��Cq5�{O��8gW�t/�U��-�8zN�tL�A��)�.1`x�z��z7���X��'��h�O���#��6{#^�Z��h�˟zG��Hޫ����g�o      �      x�m�[���D��Sa�0�;�q\2S�u"��Y{�BH�\�OJ?�������6��g������5������g���>�[*k�OM?�w�E/a���75��~R�_4��|h�C��׵�wwUQ� ��o�&[sX��E�y��Eԟ�<~�����dm�X��oY�Ơ�C�'��b�Ї��ކ���9E:���h��ۤ�O��z�����T:j9j맾�����ۮ��nа����}0������4��.��Xi���F4��M6�N�5��.���.Oo���xl��.*����n���w���c�ۃ��orH��;���B�4��4�%æ�]��^{�hf��?V8�y�^1z{t��3_B'+G�3��EvI껥%Y=6����J�s��d����Q��������� ���4u}��w���
d�5�}��������(���;P{��#a����r9˓K��9>U���@lv����=z��z�R��[[���}#�\Ch� iR>)�K�U��M��z�4�&��O��iI@HǴW�#����A���r���as�2�d.,�����H�=Bo{����+��K�xO�
�,��H�*�?^�q)�1���"T�\e/�D�*��[5���/���+�k(�h��ߦ�KҐ/���'@��"�9�F$=�\�tS��N���_Z�iO���ݰ�=j���nS�g��&������������j������L�[o��	�3 m1|(Q���2M@��DsM�Flh�DuIQ'��u�D ��U9��'#ae Q�$9IB�w7�0�շ=�_��x�^-�g����?BQo�]�:�^�.�k��Y�}7ZZkN�m����w�;[��Vy��Dr���(kث#)�)���@�^r	�Vc���qP�����ԁ�������q!�XhA�����]�Y� l�#��]�.3"g����[֏�C�.t+/�&��*N��{%�~���%7���)��]�- >�UD����&�O�_$���HC�����F�+���t�"C����h?;1\g"#|� T8j��M�	˷�)��R��2x��F�Q
�;��A4��M��= UD''�*I�#�Q��ۤF�_�a\z��%K&�v�c�)��\GX#0,U�����Z UD'�.Yk|l�G3����S��K�yI����l��6Sc��k]Y˴5ȟ���s�����ݘ-���)#���j�iN��ͻ⎪�1d�� ]���0�`Es�>�1ϳ�Y�/�|��~*�k��`�ʇ~��h�s�5&W����F�b�6.lgF0�����x~�W�5�M�=8}oa-�|u�����4~ӶԳ�y���|A����Ƿ%hK�Z6��Xy�k=�ˀ�$�"��K�rïްr�7���d{:�̣��B(c�M'l,�W��\�)/��>uH�&Gԭa�U?�W�s����L�!đ"dN��Z)���{L��}d�;��w�K�غ�x�2hnޏ��%�����C���т>So><6��ms�ۂ������A1�ϠDB�}�<q�>��-vNj:�bo��������I�q,8@�-��B�����ɸj���q�^w���H^�AO^	�W�B�����#�A��I�zֲ��6����b�?.^���~�ƫ;8�겛��N���׺�����K���҅�WN��)�`"�yv@��f`	�+�/�v,��ⱅ=6���3+��B��O����}����)��~g	7P��US2�Ee��W�RSKn����m潦�8��mȀ�;e*��;�ǏǑp��T� cQ�J߾�Fp���ȁ�q`OL���}���L(N��U>F�R~!@�c����͛�>!߃>����B�l��k�_r������=F{@���h�����E�K��m=5�{8��`�8��H{r.w*w!mMMH��?x��z �]�a��qf�MOF�<���Gݶ��+�޼u��� ��º^~��Vâ��q��:SVc��V�r��xd?س�5�_�%G	ޙ5�Q�qs;��Щ��t�`�x�Y�����W�4G�ԞU[n�h���	]����K� q�������W5���@�;[P��l0Z�"���P�*a)�r��b�7U�����7��kCt��S^�M���r;l�Ѩ�z�?����S��G��gz��¦�� 4��2te[S�d�R��M�
mf2 tP3��C�~^�\m�~	�|�'<bH�k�!��zZ�Lr�"1VXM��k�xj7��E4��5�18p{d\���$�>������y��g����U��������m?㚌�h���"3��� �"�U��eq1����H���(xZ��*p$��\�]rhP�
����[m5F)z9P?�c�_BCy��;��U�6y����v���Ra-;S�)��Q% O8O%��y��Go>�a	�g���t�n�`�a�ض���@���V����MyD�S����9�M@�9�j�ׁFGG�7�U��L�j�8��a8���r�\�����K�xX���8A?߾0�狨zt��H���ȨF�/�W�3rNqڛ�;U��t�� 5W-q�O�_��+f�� �#$�jB\�S�Z�>�OFnu���I��������t���(���?�s���	)V�Ρ]DV���*tn�|7��x���=�* J�0+��qԘ�7���kzL�#�"e�<��4��|<_����d��T߽E��]gp .��� 7��)],>V:�c�Gπp��6��~m~�m�>�WC��4����h���}`W�[~�_�+p�L;c��Y
=��g���f����y��J�	��:{��W�h3[Q����Ztl�uor�����,JC�7BV;[�^�>�{O�r(p[�!, =�=�3E>�)�L�19r�}C��\�ʿ�P_�	�O����������mS�<��i6�!k��<���2�+�)��JBw�@���a�*a�rJ�����h@�^u�-�nD*��a���u��[}�BWc���7�\D��q��w6�-r9��L�lU��Y]g����Y�ﭬL�:�x�̩���h�?���areW��7�Y���ᙡ��W)��%
78:+���	|��1D�i��N�6NO[O��/yH�O�Ӽ��4�'�b �����ܻp�Z)�=N��#�A0W�$�bA)v�!=럣�jR?N�#w̥��@l��-b����7»��{��6��g3���E������:[��_ܞ��v&A��(��wv��}���=��_��jĂ�YG)#}�f�g�Xs�͍n�v��r�}��w�����s�v��J��Y�Z�63H�zWH�{l���g$�а���t����;څ�m��[1���@�>��wL�vA���v�뛹���axC��q�#e���޳օƞ���W��V0��z�%D�qt�lio(sG^H��1%�G��q�����p�-=7\���j�fԔVvf=2�����Y��Ě�!V���m�ZP�a�{�7����c��;FRU>���Bo����3͹��}6+)���Έ�G�0�RI-?����pU�琰G����8�E}/u��"��K�GD��[�l��;�A�(��ܸͲ�m⣟D*EtR�|]��MՂ:!�w��F��xڡ�T,��ʏ��ϥ)m���Ш~�A^�M���ǎ��Sg�E��/����E��<5p~�����em@8u�ټݲś'��h��P˖�����	���/A 8��xm����0GdKQ�B��}_~!���k�>E���a����v?Lh�uV��ut�OE;ʘ-�8��'g͖��Ѓ��cw�p���ֹ7��u4n��7H�Q��X�e<�'֑ީb֭' �T'��@Ӫ��<Lh�ܷ�MN�]�Z�8��rϨ��K�!cz��{It����n�1�~����|\�j���uk���B�U��0���"b��F)�����6�Fl`+v��f[gh��K�����ͱ��|5�r^
c�x�D��U�p��Bz�ȻK�	m����:���Z�ܽ	�ψ�iW䨴LM6db�N	3N���عv�����4    �A��p�������q>o:v.cخ[s�Y��M��*��-�Ϳؙ�u#��ѯ�$hN�,���M����i�_$�?��2݈�BG)a_k�%��(M�Q�s�`۠{{�dOh+7����t�7��9,Xh��v/i���̳^%A<��[�k&��1��������|I��v�P�ѳ9��(Bi��HQ%X�^eb�]w�,��_��&�ղ�$�������6+�{4rX���=j�'k��ɉ�|�4:)��@{R�X�d�?���*"�V$���cȈ��.���B���ϼ؟��5:^��@�`��v�]�cP?q�f�� 4������GHoƯ�'L�K�|�V�����X�`8)9�����%��"(�`�&�+����u�`$�������=Z�;��G=��7�0Ts|Fsr����/�I7�٥[x:��#|n˖��V:ff��(Y��2ZY����޵@y~;�g�3��;���"�w�U���"X-�KP���u�o���ްx ����Xz�M	�qY�d�:�p��5�f^>�(4�3�������ϣ��"�BY%��{�h�����Ch�ԉ:%x�<���K���A�B@�_Ɛal�;�m\���s8����ѵc8�4WvP�?�ȭɍP��K-�5<MHO樭�؊��J K��'%+����w�Ҋ�5�����2~d<��k�����r�U�L�$(:��9ME+@Un�U��n�|6��a�X3��&�^yl�J�������P���ʘ4<ljL9O�|g}�!��5���XL4�� �1't*z�Q>s�*�[JC���cǦ��`�q�e�t(��6=u�L��װov����s<�����n����vd�Ñ���(��͐uV�޵�@;����J�|^T���-��j��'@9��l;KD�_C�JQ���r7�j?��U��r�?yh ��]W����/���';.,�B}�T���)�v�0�Aߢ쫺�?��^��Q|x��R���nx4R����\�H*���W����ftGV���-,����˰ .�=��W�G:���I˖T>�T�yd������W!B�:7�W`y.���rW�7y�P#&DG����x��4�������:�A��R�(��w���|�io�h��H�xP��%W��uT��r >HBl����tJr�j�R��~3��hȰ���H�Rm�Qe 
�&��6kLZC���=�&�k-�#j�޺��Nu&�����1z�1e��I(ZsQ�)����-�'��W��Gfٗ?��V:5�Θ��i���Jo�#n��_P���������m���‮T�!�-Upj.$l}b���gK[	�ھ�ON��=++��^�xٹ�����о�:�����{��>�m�?�k�@�b� BG��O�e���ʏ����h�w��QoC���#8'�=F�7�Mƹx���2��\g_�{R����s���b�s/q�3�5���3A�Ɔ�ٙ\y���ۋ�HeU�Y�^`�3xGGCV'�B��3��W�\�>;��nsحRN����;Gs��D ���h$ ���	!'6��a��N_�`7�S0��-{[�óv"�DW1�0�+���O�3<]Em��
�*;�&(��{�啞�&p���<�島�ʌ��=��y�_#�w+�+�Ku8>M�l���{X'U�\z����τ7,�����{�HZ�������C��<�v<�:R�#YFHM�S��T��o�X����b�*��n��k��`��*Tu:�	^�4o�<�SK�F�๘>*SgB�y���:��0�����
�]( ��"���=
|��.�+�*9g����9�1T�:g/�E������*������H�>0y�]Ǵ�:���򙆡r��o4x��>V�#e����h"����+���R��F~j�^��\�>��a���]7`zs�=<�3�+�����tO����˟]y(A9�8��Ү�8cJ,�E�wܮ+#�	��v���t�c�6�$r�#D��e ��zd��<' �Q0J�
��kXq���1m�z1���^���f�d���I:1+��>��F��2ռ����3J�	�����c���p���?�T���2�r3��/���i�ڕ+�X���7���>�� �Yv�2d�( �qt_���Q���OFŔ���]�B�oB]V$xv=Y��l99'hvdģ2gH]�X�٢�sp�Ue������i��ʃXW�����n�{���%KAJ�[��3��'�tk{���[1*(kw������|����v�ԩ�i�j�a9��D��	(�V;�#�X�+*ꡲ�Ax?�r,�O�s����Q��
Y6��+�1��ZG\�W;�3�`Ox��Ɣ��Iݗ��.BSr[�=����J�v�v/_G�a�[=�䴤8k����~4�~�_�+���F��e�ū�_ã��>�>��=�.�o���E�������;�����K����8�s�P�U)�>a�"1�<����R�����3hw�qA	eϐ�l=�H��C�iD��Y���a 4v~oQ����c��{'�P��I_	�czn�ԛ'��{z���0���=[9�;:�\����P����W�)'Coo�ԉ�9%ox�&�h^�`E�ɸ\\a�����1ǁԏ�2s�4	K�s�c���ϵu������EOWR�����Wz���8�|��*�<pC[������Ac감�����e�:b��o���I0�	�-��>(�q1~�ղ��QD!BV­�8�+�~������&b
�B�!��3�>�	c�-�pFqv�}�����!0�ط[d�6��8�Щ�
�#ū����MȺ'����P�U����	Z	�柵d��%�a����y*�ai*�U������̞�r��m��}&R6�e�c��Lů�n��r/6�^��H� �x
~�)w��^�%7��5HG����0Ӹ�����Uc1��k�����><��|��C�ρx��v�͜��[����s��H��9s	��L����|�T+$ճ�o�@�{B7t~n���s����o(,�;W�7f����Dh����䯯k#����x��H��o���G�AVD��{��m�ی�CE�3���^f���Ж|Jkj�LE�tyD}�����'������9�Iv�g��?
�ޢӺ��D���YWY��U�y|.M�����V/�^��Wr���z�x[�����c%И#t`�����'܁ J�k���6*I��e���!�6/n�B��2C�G�V�%Wum�2"tZq��g��g5ˈ��J�rR��5��fp�����;7�{���V�!e��Sgs�(5l��.���x�~����R�e$���X#qR�� �gKQ��I�ԣ�`�6({��,��n�&D�5<����w���|R���*{��?��f�W���4�i����m|�\�̷o���2�_�P���BY�~PGͣF�G׭��s]������]vp'_Ξn��&�4���ѩQ�[{��ً_�����뢐��o�Rփ�/�k0α���9�=2m^a�����M�z&�]7���!u֗���al�dWy����*õ�r:v�;�J�/��	:�laɏ�/z�Or���L��~v�|�C3G��/s�*1�i��������V�!��}�|��侞����7�m��I���� ���]щ9�)��d>����o�X૔���Q��f��ʚ�$cQ���:��L��WŀۭA�_��"�f<e���L���h0����3�}��Ӑ��q���w����ŏP���q��롚+}�gpV�G*��^D���H��R=՜����c���k*���)�sxzWRS�Ok��$��>%��Pצ`��a�G��Ȋ��_���)�둑Õ��t��>�&K.*��VpQu���R�`�s�c�oje���	�Ĵi��+>������3�n=3��� "d�]�w*�}ٌ�֝� �� �  ��&>w�Ҭ4@w6���@����m|�V$&/��L_�)��{�?Þ���5ݴ�Sk���l׺�q�x�s�v� �I��([	���cF��t�R��@�R�����B֨&��`�r�FWη:4p� �\t�;�F��ૐ��t��!ec�o^�n1���ȥ�"���W���|\�+�˽d�p�Ҋ�u���ϋ���>
�,G�
?S�����ovd�;vS\��SCZJ���!dTQ��������D��
T+�	���8���1y9\1;ˢ��0��D�G��$����c3`��R��Ŀ"����#�za%��yU��Ю�x3v9� �ފ��T�@�͋r�_*����K�Me\/KH�f���{��x�vF쩢�O�7»t��^un�2W�?l��t����〗vy	�UyU�"Z���XՃ�\Ԗu���b��#�����U@��!�M�)ԅ�,��J� ���Li�J\h������r��[-��@[��J��G+�1OrѢ�8k��b��s�E�ޗ�E.��QR�'��9�?�{��'}R�ڙ�O)�������ߏ��',b���_q>=�Mo�ߺE_{�&G�^�).]ţ�6��oM�����I�:��%M��hH8q�.����Zy�K��\㛒��턴2�~��c0@a5�|r@֨���x=�������]��Qqp�� >��j��#Y��1�^,~2��zڏ:�����'��XC��ȸ�KI�T!e�`��s�����v�m����r������6��k�ל�yuK)D��<��d�~S_���5�!4��CE�U��-9:T���h��R��w~&�U���=QpwM�r���A�~k�c�M��O7�̏ͼ�¶�G����G{��#77�m.����VH&
6����'����K^rk��=\��`��N��0<��h~<dF8:C�Wmp��\k�#�ʨ5�nt��y��n�FA!;����([�#�	`�+ o�`�g�m����4�tQD�[�mt΄,����6�2�*�=�zH�����a�˷��������U};`ӳ�����Hxx�r�	��1�aLmX�Nz�n������]oAJ�ݼ(�I\��=���#h�_!�e�8/�Ϫl"�HH7�b~a��k�,~4�!ݶ9:��H�R��I��6�����ym�\�ύ���]��S�|j�|�p�/�-���>	?�k��1�j|��"Mm ���NRU����7-h����Ƿ�������x&9��$H�{4H��^0������rM5 �9���>޵��Et�<t�����9��ǫ������F��Z�0�w�2��$�	�mv�ɿ�kc�K��Dv�5���<CsQt;���h���w��@6�E7�.�'� ��nG�����Y���^���?�Ή�!���]U���U��r_� �K�5�@��V^|/�ѹ�ɝ����	��8���Z�8��u�ۨ�\_S��_Ӄ��F�t��9������O�A�͏reH=�Wٴ�`� �>�!��Rm7J�!�|]�>~�篔`�����W��s���ᚓ�q���z�t��C{�V`�	tT�mx$m�y��rL�<���LJ�`[Wh�;���]���opT������3Ӏ��d6&|��Jz�� ��ct'�nt}����/	mB�m�B�H|�����F��s���s����#~�x���0:�����f8.�z��0Zz���ʩ3��0/�!�_�x?��b$��!�j�>���#�q�,��*��U{�s��%�c���]3���7���"C���60�#|���Q�b0H�v�\KR�8���F�;��J��%\�%�����}���c�
�\̑�&5T���!�۰gxYW���Z��qZ��ո9}<��F^ԧIa��{{�����!�#�+1���������V��v      �      x���KoI�'~��,�})儿ݏ$EIl�&U���^Bd���T�&U������ ���j������򋭙y<�#�̮����JU�/����~�rQH���.O�f&!�g�{V��G����
��Lɉ�?0���j�����b��O�ٴZf&��M��U��wG�ߗ_�캚~Ze��23BE�bY�o����W7o2�!�Yt�+�>CL���.>����/S�[?�e]ͳ��tU�W��$��\<��>�.��^V�O��B�"{utyt���w���@�Lf�L��^��r9�O��Zeכ2�[�oʇ�X|�[�]O��ߗ�j�\d׿�
��~�͎��/��哷���{���L��Ұ˷�M9��*��y�Z/n?f����d��S�����/�9�ֆN��_#����\?�&�_�5���l>/��	 �~�Moa�ǋ�Nwy����m�˥1��}��U��q������}�n>���Y%gX�(5�)@��F�f����zsÄY�nɾ��RN���,>?[m�/ �S���S6��$OJ������ ���y���Z�����������,p�i�?U�
�'J�Jn�A>s�k���uv�.�����Cn@Z���
!����C�������Zvid��V(�$��]5�M�֋y~���b�.�˲��"���r��װ��]�������3e�^8���,9���$)����A��������Dx��	/�e�K����TM��g�؋��Y�^W��ϔ�n�y~����_β��~{?�/7 �Pͫ_6լ�/�����ͫL�h�L��D���K�9�]5�^O����ժ�m���'��ۣ��4�����	߀��N�$����;��������V~��]Ç*�И�r�r����C
Tد��.������{Q�o�W�"�z���5���b3�)�w3c& �W��4�*��l�(΋�~yڹZFa�!{��f$�p*p�	��ߟ>?��
<5��PTϫ���`�Q�J�����[��(r�[*�Y�%��x�6�sk�C��p�`���z�s^~�@��%a����K&�p��t�W��r���o�mS-���E������#�V�h�D�jh��5Px��T�o-���������ò�b ��:��b�1_���?>�%u�=�׏��C��[�x��ۏ�Hn�y�Q���\���Ɏϯ.�d�o]�!��2$}v<[�z���cY���q:[eR����U�z���{��7k�������%W$f߂;�~��i0٬9p�D�)��]�\OaY���Ǐ��ӏ�z��/r��m&xf/��FS�]]�[";����B�L~J?�c5�	��5��As��~3+׿�Z�{q{_����$w�g/��n�������R���Z�R��Џ���]��_W��������u#j����gy[���/2Qx��A���^��51|��`�M���5����=�-`����j���Y��\��}���IvS�}��˂ `��pE}���2i|����N�Jr�N�]:?��� �@an>���_��W�����
�L�&���Ϲ~�ۺ���1��1���5
�&��!0鑰!�B��p@��������2���W�"���?��f����-7 ���ˇ�V����l�����tA!T���N� �\���3@#���dG/��`��:���J;A�X~(�e:��A�ᚯ�g��n���>���7w���xN�҂�Uv�Z���Aj���u9�k�@A��~�1_���kA���&^���7ʜ�ף���I~�˺�-���4���u&ܹ������l��Ȕ 9U �Z��b��"r�U�6󻏋�:{U�����~�eJz���%܁?�~y�����S�ʃ��6����*�~������L���i���_�k���U�44�x�����7����HPU�*�U�:���A�P�'���N~JN��j���DprAl����j��+��yd��������yb�%P�'Ag��.�/�z�	���y�����=�U�-�w$����w�F$��d�5q$A�y(8�7Y�
(���z=�]�?�,2�H/Z��0��x�!p��?Y�,��T�"?/��q	�q��K�^���_������e�mBw�5AӋ���(�ej��O��vv^�L�WC4��5\*?\��`��c�a�y�CZ{t��P��{��+��&�F�ՖK`�Gw�[r�W���->�����w��M�����`޾����˗'�\e�3�V�u��D�>| ��
Ɣ�PdK0s�^�t��/�)\�%%��M��n�OȒcl�U�z)Q3�nxP�p�^����#_�p�7����9=���|�}��`�'Wg|�;(uo�aⲓŧ�_�Iq��M�}��ӷ��|W�`�pg�l��#�7ZI0��R����}�ca=&�2{{}��;��v!wDo�L�Ns����W�N�D1;�?��x4�>���rj��Vi�F.f�OD�Ë��11��6��G�OΥ�W�fN���k7��ɻ�v�$���G�����2��lmF��KQt�|��Y1Y�6V$��
.�͇qS�;���	�����˗W|GL�#����Pï6��/���3p�g�.��׵ �2��~q���y~�(�@[,?�?P��g˪�S!�j�]u��3g���al5�`3"��B��k ��7~=.P v�.�w���O�p�6���*G������gG���p��٬��  7��z�H.b:T>������aD�ݏ�T/h�q"�
������%׭�K��p躼\�y9����ۇ�}���N�9���w9趛�'�(�9�{�y�
�(U��w���Hwت	�1����tu���;Z��t�g����.�X�?���2��jU�3 �
�r:��߬A��o�h쳣�Y�R�zUp��_Ζ�]*�@�Yv�斣�Z���=��H�2�hD
�}�jh�p��f>`�\.V����I�� 5Evu�'��kV賣ˣ��Yr?w�KI��vG(7�Ϳ�����\.�;���{�E���ECR���
��7�Ӈ����b�{GH\���*eJ���l_(�U��H��W��gL�dw��]����ʏ�Жb�	��Տ?4X�w��f�a9�?��@��qu���2�-1o+5�����&�o��l"������6x��5y����U�F�vK���JSrinw��,4�@�e��MXLr	kQ%_;:.��@J4.����KGsz"���\ݳ��Yr�-��m�@�|�B!��G��^�U�����f��\�����\���
�y�/~�ߡ�go���ݛ�GR�p%����<��@q��7J�S#��j��Lц5F�jpK�3��	��ykLJ��硶��F�D�- *b�Čc$e���;S�)��Cb�
�B�^�G	�>��q��ÛSpv��6�H$�V� ����-V^ ߞ��og���b��5J2؈���9�p�f�����e�Be&~���3�c>v>� ��}~J��E�y_�(�}iP���5� ���i1P7G?�e�_�Ѥ�I
M�f�S��|6[��|�w`�~����	��S0Zg�3�\�3Q����=�TgR4����������s���'-��%HP�n�<�}6Ӝ��e	NЩ=Z��gTt��^Si|/إ���\p[X��$8����*P|/��>;�R��/7V�F�lԋ���1��}�ɫ��r��K>�e�{�O�O9n (H��|B��O���/�3�/A�]%�o�#L��D)��9�3p
�^vf�%��9>���o0PXtuy��*�e�VR��c�3��ϟ��\���)A[�*����b왻�rqz6q�b�&J�㒘������C��}AP�.������b1_/~-g�6���^����D��a-
A�-� :�!�CdHo�p�u�b7��K���x~�2�He�)ej��NKv�Lm����d�1Po��.ϲ��4GZ�}��2X���'��2?[��!���{ N����[���k�����`��EV���U
�KdƢ�����Px�D    �5_Z)SHvH��*�G&����#c0kǺ8��U���JQ���NP��#��n�.���@��Ë*����f
dp���b������l]�s�����}��<
���j�Ŋ&��GuFW�t_���0��$���(��R-h�	���>�u]P��[|�)R/V���QڤL�;���":�R�8�uuC�_N��lMVP���H�O�1]����Zu��&"{QR�50��aQ�E]-���.�����2��(�����]���#gn���n��d;[P�A����������,�\VZ�����x�`����S9�����V�*���f��zv�X.���������h�����W�>-h=��п�TRY{Ý���R0eG���G����ޜ��\��l���\ ������v1[������%��t5C]D���/�1�L�k��|�N!�c�Q�U�+������o�TX��HL��.�:P��n�b�1Q.?�[��Xޑu�s@*?�E�����\����_j��tq�#n? ��%��ĉn�q5aR�� �4��1��߆���G��$[�|����?�z�k�����]s���_��p�M���`�Vu�
x ����,�*��&ח���ۢ��2/U��l�tB��'E���U�<�L��+le`����F�5H��~Io����F���G'���v�W2�#6����������͚�c�����%�3����q��,�$fBxzt�ŗ[P�Ub�1x��������d1�W��)��2�k� /+�bLx�����w���|{u�w��`�K�&p�Gs�[��f��"[����vr]���Ḱ��Iqu��>:?}δv�T�:;B��&���rF`9��*f�?���8���2��������T�j�Q/���j�&He]��ы�َ`���\ߚ	����f�
[]���O��l�.���uy��|��pG�M�3D��K�Xd~�ٷ���_�6�9�����\Q��Y~�[8�H�2n@+�KU�؇��:F�14��Xvz����5"*�-��|�?l�
o"�����S��,(���r� ?���{�[%wĝ��0Lј�;\�z C¢��0��������
�պ����i���_�_��l�� ��\�\� l�@��R�\F����͢E���e5^DS�^˂��d�e�2�M�@3e'�5��j��$��,�/j:������t�\��i[GD�^y��N�c���0VDĹ�i�������5�虇Z�2�L���лPWS&B��y�<A�Dj�zJ��&1 ٳ5�c��&��.R]�}�D{�;[7	�9�^֖I'����1n4���v��U͋�\$��M��� M��"��^���b!!�`���7�Afο�`�=��x�����֑���s��"ʍ��a�X��K��K����_�N\P�)��_�@*@8A�f��X~��9(�*�����v�d.�\,.�A�U��J��`�?�p�A�+ޯ޾�`�Dv��ܘq,e�^/>={�@��F9��߮� "ȏg?j����${+_��B3����Z.-6#X�"������~E��DG큡�S���`��cD�o`�)��w#'�#
�N�'�Ec�8v�Q3���~p��3����WztgHD�F`!i�A�o���z���8�.fH��ڝ��A]e��aX�HrL)�]�L��RQ�x)��k�����}��>`����jb���M�N�v��qX}q���+�`v&���Uy��G*4�լ��)���͈��0�h�$��	��w�df�8�օ���=�#;BG���h�U�
Ս��q�
t��(�W��Q�v?�砦$.�<k3��D�*2��_�_�MY,�j���l���u�]n����t��\¯t .����� �|v]w�̛!=Yx*�F�5`�i%r<7P,����������K.о5����R�
���mq�،����r�Z=�JmNo�_��)��:�jBQ�8j����7��+!�,�Ưn�;�9Z��}�F);_ߕ��l�a���.�x����7��o�+���Qv���p*G�e,�t�Q|=�����v���'~�KT0�c9w����a��;p��xز.]J廑���+N�A�����S��60�,QS=՘�a{c$Cr����p��!-�c@���:H9z K�}��be�J��9Wv������p��p�}ZO�A�$���ւ�t[���1i�e�/�n%c�1/�:����i,3練��'1A����kj��M���W� x9fhN�X-uî�d�U��5��Y2���i~3�<9����!V���@�B)�/��\�~�_�g;���^�gI�$��9�.�A�bW'�a��Р@�~��dE�F�>s��U�:��v�ʄ���c�H�e̓U��|G&�FE�襏��e��K��]���J`�ʈ�=`1��4���i%PE]в����k�:#P��8=��d�2��K����23�p�E��*�h�b��]����$���E	�{
�Z�5&�r���#�;���E��h���\�T�Hw��V�����<Z�B�f����u
LP�ȀĐ�yrũ5�<�3}��L{a�+p�;��w�����V�6?V��K;�VpsrP���H�yLA���0���+g�jM�Z�ш�:v���\�U{Z��p��.��a�7x��=&_�M�m]���"2��-糍d�tQ��4�h��S�Q�N�:8̦��k�w�&�L4����GW#*[�E�EJ�F�E}��ժ6g>��m��
V�3g:I�=�N�X��68W�����ԞH]5PCjL�|��D%|5�P^��x5��3M�TQ�b"tܙ&>���W�:� �2���k�����9��=���%�C5���<:l��ּ$��\p���G�����[)�Qɏ��o�k�oi#z�9�dv�fd
�!��q�:)^�\�F2�k������6MA�ઠE�f&����@]3�4*��2tc�kp�Cketbbc�-U��2�K�wP��u�!Ѱ>em\�(��1�*������!�g�\$���|�q�ij����i�]���&�U	�����ZL��b��4ı���<�����h.����2Yt��b�����X�:��
<�E��],�F�oM����Q��䟀�\ �����sӂ���.�`����4x.qv���"�����F�q8%Y�>pA��G7k��Fe��u_��>� bHy�Fm��39*:H�ϖJ,�zmծ�$�|O�lU-Җf��������}p�� �U��S�d]���a�X�	B$�T�i��C#hDr3�6IE��A�1g�h�4�m|�0k�2^M���
]|VT�!���;Dr��"��;�z��+�؁ww��3�M|�z-��x�3�UP��$���%�o��E�t4_{���o�Ny��R��ep���8�F��k3J�F[����;Jig��Z?�k�&��5��"��?��u��Ji~�7t��?/����_�[/�ԙsp®�D����7��߁>(s�'ِ���͎��p%{۠�ohƍ���%Q{@���bI١��7�V�E�a���'���+��K�m��N�S7�T�o�弫��_�"+s���7�Ĳ���XN�e�2��������c��<��<$?
�<���b1mN�Uq&Է9u8�ȉ��O��h�KctZ�cג4f�t�̍�Gf�{FJn�f1��k�v�hF��A���c�qȳ�~���Y����_��n~4|멳Rc��y��p�	8�[������ T����"䧳O����P6p-q�P/r�Z���p�|��M��d��w�O����3����8,L�#�4NuO�\F��=��}#Mꈕ�w����P�"�zts�I��E����?É��1����w��E8�{r��}�T�?G�x��C��ViWЋ���K0XP>�c�2��Ǳ�����G*��ia}��w��r�
T��?@��?��D#����՘"���:&&@��z�����;���� �8�{S4I�0�!    +��$�6�p�}ងԱA�C:c���+���\�� o�#���}։�h�Lz�hp��Y4e��l�|lj �.v��4B�"���Q��!��𐠁������-^'�1��|fp����N��\"����|]O-�0�g=˴����.\`�Ft>4�Ĉd�_J�w�Y c2V���FE/�a� �
#���O�����~{�7u���?�D�y	������Y�g��:�
��']�_N�n��w.��1�o5�Dus�t��4�QxTc�T7p#����e��qכh~��c��2v��D�5p��Q-�rC;�)�4�f>�)c��
����s_p�v>�rvR-���"�y�{�\>s�Mٔ�[M���`o�� �tE��n�~�pQ���0�){��FI��_rpՖ�[�Fצd�$;MU�X�t�h~#[E�!S���Θ6�V��.����C.J���Qׅ��UbG��+�q�\��
%����]�d�)	��#8)1�q��c�bk���n��.���M�/�,�#\D����������>�?;�\��q�����,CL��yBǀ4�3^��d�&�:U@Eph�̀"���nZ�� �u[+q�b����~���W�J���7��ci�#,��4r照F�%.Fi�v���{�T�;��U�̾�$4��*����x����_^.��B�q�c,��myb71k$ݎ�����˘�a٩D�To�w<��S��GU-�K[�n�e�N���b邿���ۃ�xo�P~({LS]]g�I@S�s<R`X�rR.��k�ߔ����Gv$�6��w���h�\IM��̗Ǣ@�20���Ǡ}r	H�X��ڲoBԺ~:J��2Eo��I�<e0�Hi]��NK2I�j],Ē��uX�X8 ���pLO:�ۡ���SO����:���~�#Q�c�oܰ.�kߏ�R�s���!QN{pۘ��ʙ�{��V+&5�����i��I2<��`�m��7�N	#�<�L�cwW�c��PR~�<�1ͫ7;h����u�R�C8��u�T��bY`��� �1�h%�?� �K#qyG+q�MR��s�������wI�i2~a����s�����vF��[����ɍڮaL���^��T��@�8�?kFz\�	�+`��sf��/�=��A�#;������"YL���.)Gm��t�YK��Agn��m��o̚5c�����跈��0�=N���M�����y�T���ۑRu����6:���p��d��K�Ӌ}�T��P������h�*�=�{��3�Ϋ7��I5\�Zx�|	�0�+D���03�������X�����{	�\���]��~{�	L]���(��8��
��dx0٩^�"�M2M&��.-��4�!���k'8앛X,C��~�/��k�#Qi����F9p5��?��㱰��R�A��ZP�W�/_3��?N�s�{�p��� �1D��Z��\��٫���0�QM?�2%������:��(Yw��d�(��.2J�k�h��6��-�Z��y��hV%;�!;5{V���l���ۛ��e�o��ֱ]�ajhH����X"��o�1A��{�$���tu��N`�@ݚ�g�=��x�㫥̢3XE9�.xQ���>P�W��D��.�`��� 3yƾ�*9|��1B��GII�����A��a�>��axSObs\XvX�8dV�5k����C"4��l�X���Fs�c���.X�$����4�8�}���q������J>���d*L�>��8�}h24^�	����Z2�X�qL��[��8p�t2��+�5A��C�yκ	H��(E�&�^13#@�c���Z�͒�����ݸ.�C��d���w�3����R�m��[3��է�Jw�q<�E�lp�ip���GA]�R�����r�G�<qF�<�s���T�H|*��}�D��}�7٢������u��k,j챴�������"#u�F-_,����9����Cբ-To>����g_����)ۢ�� ����Q���d�:r��W��r�0^%�-�����s�K�� �����>q��#�Y�@\�6~�M�-�c���Q�00	h��=����.��ܥ�c����&��Nz�B��Z�UÝL���Aj�_�I�]�/V54�ѭh�a|��r��T�s�c�"����>XPP`0���������x�Lp����H�ZC�D;�-R����F�,2;b�~����c[�Dׂ�|wv~���n�t\�����t:]���u���Y��𪚭��4�A��ù�C���z�EJ��y4j(�`�"��J?
��F�B����#4�p$� B/���V�>��g�9/�J�XYԭ���d�l�&I���ZM-��8�E�'�@����X���IF�BG�}�5��3?g�
�XƐg�T��$���8?���I��݈��=�}�;[��Z��7���/�̾�o��#��o@{fo3�- ����X	z���˵��.p��$ �,�l7�
b�Ѡ�岺�Mο�������6l��2��z���N�>�.w�D궠���|Ʀ��2>�@���R�t=;�e�90*��=�`��LC��Sa�(s�/��48ڂ���P��7��!�P_ZF�hc��h%�ZX�U���12xL �(MpMG�𔬛��������:��g�\��m���Mx��ƹ�g/���D�ۡ��ō1WȂ4����I܃��Z�;Ϫ~c`!	E�xZ,�8 maU3@��#0��7'F� c��☟�/tq�Pw���:�9?V�^�����Vћ���,x��� ��A�+�3BS�բǝ������t�mؓ�uu�{��B�����ɂgtt���٩�K�P��~��7ˏ�	�l �ّ�E�+�h�"$�{�&=
��m�Y±rui55��V7�*]��4�o����^��o�(�����-��s�"(��4�ނ��@�ſ8 S��&���$Ba��ܬ�	t���4�
�o#dt9$�X&�6ZS����"�ށ;��X#z�P�t�}A���Ď�J��_��A�Т�i�c��e�����8t���1�s9�Nך�yyOEL�"�L��ܥź��#�3���Xc{=�Fp�(��P��И�q���0�K#���	M���#��ҋ��z"��ThM�\���������,�da�m$�&��c�ѕ"s�� t��	��q�񬡕uS�ڇ�)	�b��:��!HoM�'5+�s�k�)�/u:b0�0vJg��^'jj��4��N�8�����cv��n��$V�*��[pGҘ�c�M�sqHL SPd��%-J'ӱY�Ɣ��a���GQelDU8�k:pX�)&�/(RrE/2�N�5�U��BvM)2ش���Z@i���^/���}"�֮�]����Xv#���ny�!�6.Ӧ"�O�CSdN���AQ����Qs�[Q�L��ݥ�DQ�{�5E�2�5"��P�Ē�1jԭk��m��{�����X��:�%��b~�.����=5�t��ТD�zr�8�{�Q��A��Y�=��pp��Zp���͔k�rY���RO�zYӓ�QAI�}#J�WuqJ������t��6�7-��)�����6`�� X�8}�,��b{M*�������X��M]q���X�j.״���^�a��@Z�y��ו�����zt��^�;�VG{��i�$C��-rs��)��P%�SN+q��'�DZ�ψ���U�̼(�4c g�R�m��-���FfV�����݁Q�м.��!S	�����(�������`�"���P��1A=d_��)��=G��X/^��`�4�1P�
Jќn|9q���4�����K,�0��Ւk��$o�3��6BK'q@�o'���K�j���%��g�����h�B�Ț�8�	t�H�{��R&���,0�0�EqŶ&���N���J�҃4�+�y�/��J	߹�5d6�+t�O�3%�Nw��+L���[p�u�e�F�s\    �� �),~MBC�Dq p8뜆��m�ľӄ9)p���CX���:=>�R�Ԉ{�J���R]���C~r_��_��W�P-1���
���][�P��/�0�,R�>;������Q'���N���ͯ�He�B�O�}�M���Kq��]X�2_4�6�̊����p�,�G�C�胵&ܜ�5w���У/����p'TZ�8sj�et3����Uoo�n4�a�z�$('���*�mc�$���wp����9-<�B��K�/.����O���C�����V'|Z���{jj)}�
Z:��щf���wFP1��!(P�@��2�X��+�ǫ�pR��9c<�b�!v��:��;��d�9�:p=ԃ/��&r�C��K-]�(�@���d��[�i�v��\px���D�S�m�i|��e2gF���];�=�v�3��Z����h����hh�ƫ�p����N�o�E,���X5��,CMh�.t�Ƨ�i���b�N5�8.V�^�!!,7��r|��������>���ޚ�P8��Jl�cpĄ�A7hu�Bd�Yv�*�>�(��1��m�VR� �G�}EKk��Z�N���hmpsǰ��W��ͫ䁒��'cF��~8�<}��=���?0m�¼U9�],f+�U?�3Lv�PX>������
t���oF��p
,�ӓ�Xvj���yv�<�z��]�eʴd�D�F������L
���z�j(Mr�;�r������)zbi0��96���R���U��8.��u�{����O��P��H�:�#��bS�ς8�iZ�#�^׹��t|P��q�y�*��;L��y�4r�pgY���}eβ�����b���.}_�q8j�ݛCӃN�^�Xt!���hZ?()p0 ��T�<�&cK�ȲF�I�X74%F��&��D��䌨+�vĥe
�u�*���|s ��14�$��o
,���˿o�2;ߓa��-�3���@�b޸�pΘ�D��e�����b�7�#�ߜ�]3�!;u��N8�#�o>���_�͏+��+��7�+|��9i?�*���A���j�%�vU%{�����Gw�e��+�tn��i������8����|;[�]1��v���Ʉ�'�6�8+ҁȜ3K%�f�'X�;� /ge�IS��i����N�J��n�e�ݏJ�*���h��]g�?�?�M��?�5�D-+�!!I#�Z�~p�@�I�-=�p2=?a�m`h�������󽨱W��%�|��' �{�u6��C�K�B�+1���\�M�K7�W��!��<���y�ȉRĶ9�o���S��D�z�Ș�/�a>�k
�|r�S�h^.t�B&��)�ǟ#���L��J�����܅�9�!v�t�\3��y���MH��b���ӵZ�=�-�Mr���T��G���/n�dݯ����g�`zhk����q�%�����A���1ńH��Q�����|�~�_��ߍ�y��X���'� �?�@�!��
�����d��S�P��7�E:��%��0ՠ�͆�>�zY?n�'�}��b����Wi�}˵#��K�]�TY1�v�iۇL�vV���ڰ������ݟ��� �?=��m!���5
�9l����^.�{T���6�)�/[g���F��$U��3^�
G��H ��9OQYk*<>ȵ��?�vف�(�3��P��O�5�7��b��(~~(j�a� ���;N�&��$���F1�F�X���*d=�S<��l���r0����zˎ��ĉ¦*3��M��Xҏ�l��X��Ø!��r�>֜b�����`�jO�˝s�%YǶ�oV�\�����y�B���
8�u��0����f��0}W�V��vع���q#��ً��T-6���b�N�����
���`<�[;���c�8=�*��Cq�<����1hjN�sm��ɒ�?�}6����:C�#�;Z�����+�(��;�<��5���u���͔���Cۧ}��	K��T�d��~7k�F��1�IG�����]j�=��f"V(�#y[x��G5�F��#���ZD��~�K5�Q�W'<��إ��A2`��w��\H7[g��{���K>O����/G�\���}�,V���� ���y�퉲��y��kT�y���EtL���
�h���v(�����cN��m�����;E㟇�na�У��zb��)0ߎ/g�zf�U�#�&���{�j�Bm�&���8Ua'p�:8��" ��a�c��0�����z`a1�"�}=6Э+��aWc�M�W�H3�s9���@�G�#4��,>��O {8��R�݇F����J���/�D7m{��!+KO�~����Mp�����i����Hj�$��D]�"��&/-)��#h��E�~�� 8�,�d�m`�#O�p���%^���'p��ru��.�t�xٔN�N�Y1�h4���HN=�'{��ip"Vt����J�㑓$E��o�M�T�G�8_��>�C�
��������Ru�sZ*E���ڽ��)�=����|�S6u������KK�X�z���|r�GD�q�=,��x��|��S0�2���}>�p�����b��z��-J�ޏ��B�5�.�-��_�:g_�(%��}���b�oa�͢��N"eL� ����kY�L��A2�1�1f�y8���v��]��*u(�Ӻ.����4H����m��N0����'�Ĕ��	0�o��I~Zy6�+n���d����ВSh��'2��4z��'W����)�ˢ<������uu�����Џլ��G�hr�����g�Y��Q���~��$D�|=S��Л��)bQm��*^�X�ތ����l�qJ�-��o��`��~��ʴȚ�Ɓ#�fp&��y�;�^v���3
=����I)8����p�~��%����O��,G���+�E`s}0g�=�n�#+��5��q��p���{$n��.�����+��Ցi�����p�X����|J�$MU�9o��N7���
���*�rj��)0�ϋx
���D��'��}�:��dӫx�_oo2l�A�	5��K[�6z۔��mP�)1m+h�M/%�6yj�վ;<VG�[��o���V��'��Q�b�I�-����2�Wh������ _�Z�E{����Oa�6q�3rߑ'P��#�I�1�{��s	����e�C�@c�G+`�8����f|�9�����vE]�������ux���&1
a�(���z�Q �2��;Y��h��ŧ���yѷ#��Y�1u��U�CG\z��׶�&��2~��L�
�^��'ˉr#h,�%�q��5P�+ ��F���K?
G][{PF%.y ����+�z�Y|�f�~��E����>�����7��/�Ԑ��<q�	^)�ސܐu"tG�Zu?�f����A��E	Î3Հ	��X��>��K�XF�G���_q��ރKY�P�4Q�Y����S�>9N��[>��Yۖ3�@��F�+�.����s~�;p�*�IΗ�%�<R��Ŋ�����2F���l��?Q9)L��V�ż�d5p������@-|*�!u��C�u8dG������?)�8>
��`��P�b�8���VB�v��!>���(\+Hޗ�W`��ڗ��_OC�,(��e,�vSoc�A�OCbo
�6q�Znk��>4Ja[�C�~{|+���cjaXD�^Е�y=�����&��lA��M���gW'�G�L^%s$�c|�����W,d9Z��.��"?_ߕ��l�a����,����+��L�j�����?`�C����"��8�⛔�`�E�o��J�V���5b+��B�<�@S�%��|�N(����/����f�x��h:wT�(�#�
�R�q�ջa����uP�B V�.�[��o���Ѥ���͵Ж��4"i�����Ttgw��X;�0���p�c��N�Pj�V4&}�z�P4o��=�1���p�AEI~I�>�x�<� ���d�v�>(� q  ?�o7�������+*pZ�h�4�����>��[��i���A$�?47�E�~lE��7��F���yC/�s��>�9�Xs�Ζ��8�c�����*lD��8����p:����`����&�D�=�4M���M��[�#3�`G�'L�^	X�R�$aĲ&�k��[$�cf�x�q���� �w�:��,v%2V'���o��_ii@�(�f�h��Y"e1��h5H�癴Z��m��t=\���P���H��ݰ14�Q
e�]��X�	��f����������ū�*�?[�G�;J�؜x=2��%9bl.��'#</��jX�C ���5nf{�_��7 q��(�נ�I�;�6Ujb��Q�Dv�k�L�Ňd��`�ṧ�����#���Q��1��!(���6���\�(�w~�dP�w�?�K�/��1��9q�}��`�&����.;ra��R4�g��TP��QL�uׯ�b58�U=$�T�{"�>8+��U�'2�b���8��O�Rt���T?�Y������{ТBv�/ ������vuA�ϐ��8�ld��!/��|�J�K~2]ނc�ժ����\���A�P$zhQ��o���X���4DNock^ �<�"��r��q��<�i׮>�)E���:@������ʣPqx�[ѡ��sN㼗�D���|[�$��7Ì�����a��QG��ؿ9�_2��ɶ���4���d���c�	ѧT���@��H���.9����.�Z�\��:�F����U��0�n���No�X3F�@�3K;��TuZ�0Ⱥ�Mj�4�I���$���~��d0������i�#��������-��Ϸ9"+���������g�ǋ9[��{>�g0^1��ơ��_�g;2�)���$��m�`k���rv_n�*���i���{`��O9r��b��Orl���/����m>�qɺN��Dn�$Fc=M��%�M�ώA���}3PO8�v`�O���9�I�F�&4?'�>~{u�&�ܴ���Nb��,>���\���/kX���Ŝq$���!���R�@y>��)H}�F5�ruqq�D5������ï�[젚�0&%I@p�7���� =���o�wpE=�/p��"��y>g$�����.X)ңR`������s�{��]�*� /p�Tn��S;�A�8"���1�d���ݨ�!���iA牆�]h�u�)Ң��qh�k����6��"�d
�b綼U��B���2X{>�]u�.�{�dݾ �k`�\ ��&�>��� P��� u���k.J�!3�űK�/z�Њ�I�,IU��������"� SFc�z���Uodޣ�4~	߃ч��|�Z��ٔ�S!������^ʣh�G
���CdM~z|�Q����	���Ĵ�wt����2��;����}or�cpTUevu�S�(��ÿ徕ƎR,yo�wE�"%��b�">��@ⷫ� ��������a]�ChW����p��������uX=�I�c�a���2��>��qb����E����볓L�b��@
�m���-�i��[P�)�ZqR���+�	�#&@��5[������ع�O�WW�'�h{):�1&�T+~������_�\���.1��6��\�d#�xӶ���΅�"���%��� �k�(�X`]��� 4�'n2d�&��;�#3����@S�cZjZ�P ����i	���Ć�h�����}o0M]�,�`�#�6�T�H���G�L����ʃ� �eo��.�����MՒ,$�z���^��٪|_����{�����q��[����$�!2] _��������><F�p̫��1'��C����W�1�X*~xv�\Θ�ߑ�5I���^�}!ce�]��:����iiH�N�^OG�h^h##���S7ʐb5�Tu���#�N�˝J�J�Y~9��&����·��EcǷ$L5&��l�!C�i"���XE������/k�r�8L"]�3c �]G_7��=0T,�ܚ1��8�-;J�T����������"�!�t�Z�#2��W��&������$E���'��5�=R%�����۸	妌��q��AU7 ��H��:h�&7�i̖� 4S�0i���8S$���0	8�?O����v��?�}�s�>��&9��o7V�`��Y~�N��K*`}�fyl���1�tq{q|ʡyL��ӒIF%�K� ��q>����@sG�z���9%7 �
h���Ш9��������_{wQ��^�!�_��	w����&�(��`c����F3P��h�a��ҍ ȶ~{b�rSdz�V�#������$�E�&�ɠif ���{�(5�X����=�>x����r��o���\���&�Kx�}C����U�`1s&�Us9D�b�W�]p<&-$F#X�E�ڑO��ux5`��\ �8,Z����F-��J��h$����|c9	ڂ�|���+�5�ث�|Z��f����gG�`�&��+b
7k �pcִ��� �G�I��Ȅ�D����"�<ܹ�MO��h:�tI��������T�V�I�����)zU���y)��X�!Y��V�>)=YwQ�4�ke}tux--=T:
3�~A>	\�8���� L��^��Ȣ��%����������Q�m�"�Znp�W�6�ç�^j=�4��,��X}u��0.���~���.��dHE�ԯ��r}�ϰ��}F��*UQ�T
�z���%�7�\.���`��T�>f�PxI<��zj��Ƴ�#���dԷ+EQOA�1s�9��T㠅�ˇ�p+�\2�q�&�~��dV�����F{���1,��ϓ�j��(�ݼ�85Z%����/�`"��U9���Γ�}0R�X|�m���V��n���ġLݺ�#�,ʈd}���`َ9�ۘ�գ�f��PC��>j�Ra&X޾<pG��ۙm1��%(��vv@�\���
�Y�M��4&G���)b���'E@���'vW�7��<��� ����w\�Z|�	<�{ 1u<mGJ���ݰ0Z;�\?�o=�Û���5.�)�E[c�����?��?�?m���      �   ;  x�uWMs�8=ÿ�9�%��:z�co��D�٪��@$L�� -?;fj�rعo�47��}���)WR�e��ݯ_�n�l����,d�o�����:�,Z��bᙠ����L������/���F�쒅�L$8��;�J�~m�=�0�?�I���h��#�9��Y�_�ޚ:��O��k%;k4<��s\���'�vL�D�Βo������[����g�DD��@�)�j�)w?��N��j�W�޷J�,��Ώ�� cq��n�F�v�>��4��i52�Wt��+B�l�����Ep�x\g9��m��lm����
u���" �����n����(~����.$��łW��e��r�>?�C+q2�W��+��;
鯿<�σ�,�i%U+�Q�kwm $	~���b<}+M�U��7��ˮ����E�,�	����>g�\�Z� b|M@�1{���=�� 9�ID�1���^)�@��^�FxƊ��yz��Sv/��,� �s��6aĉG�U\�ht���Ѓo0��k���G�s������5�AW
Pg�:��� (�)�%{P��;�W[[�F� ��A���vE�Z�r�K�X��-�dK�^��[��d#K����~����h�}���حk�w
�pO>GD�Υ`WC��G�]��עV���V�%�v%8%� щ�V{�9���LNh��p>ÓD�~���ߺ^�	������]H�"�b*�a%��p�������W��)�G���s\5��(ɘe�UGuՀ���$2;M?���[1����Fa���"c�bk�Js����$'�#�=�q,Y��]����� 9�֭z�6��t
�Vc�I J�S� ���GUTۮGO����s�)K��{�����!:+;�!@���]6�O��*��:)�.���$ȗ�a\�gЖ+�V�|A��A5�X�6En&>M�;�Vv�l��"
�Ѷ���w���0%yE��[J�T����aH��o��Zv�d_l�E�j��9�s6	[�J5���-�=���ϛ��id�٨���f~���{!�qz`Fs�Y���/�"�wSJ$J���8��A4J�F#_�0vF��⨂"��loI���[5t�?��m3�W|�x[�u:	( �(C�0�6��EI��ń�S�0�����8d�E��S��O�1%_5rG���T���d
:z/�4a�<E��k0Q�-���u�1.�$�U�pL��O��;$�؇���}|��C��	d|�Pᴮ��ǷP�����O0�B-�ܘ�ŇO�R�J���$��~,Q��(�O�l�W�:���,K���+q��)���U5Ԉ��o��s��M�0M�$��
4�A�P �n�]C��Fb�@��IΏ�s�H����_dS[Ms��FJov��G��fw�L|HB�1Oz7��=�b�w<��JA�OX�Dcg9[�.u3.}1��t.��>��cL�� ��-)�;Hi��7A>+_B�������V�}Jw���/�C������buӝ?��q-�� -I�O0S�-`�K͍5Fr�`A�S}��'7>G�2�I>�&b��Tc߱
��{�9��D��}�)V�2��:w��n�Jg=J��������`TB���gO�}�i��4=�@��ܩ�۞�k�v<&sM[;������F잗?~��@v0��q�8Y�D�t=�J���d��,Zg�5F7/���s�_T��y�w��Vo
-u3կ�4��4��?�n�e�W��>4����MZ:��:c9,�m�X<p����5�2��/`��$����0�Cd�7�_L�E��Et�z��#�w����������i�n�P����NO�el�I��1��������XSm�?m�s�����͡����z�u�l�yd�v"T4n4� ��q�7� �)�q���tB6�J����j�����WS�'`3l��٪r����x(��C:�x��hg+�5:T�'�>t��KA�#���|�~T�=z���  �؏3�8��hk�:���v��bbBc$�F�t�=���u-]�o�&���,��I6u}��������4�#��������"���:>��)5�_�����r�      �   ,   x�3�tM,.I-��2�O���9��J2@L���R3F��� _�!      �   C  x�U�ˎ�0E��W�
�l��&�Z4m0`P��Vad1���ӯ/e��.���%o�w7�=&^1�%����Y)��a:���B�-�p�);X�q��pt1
V����[H�$l^��b?#�T/��@�4��S�F��SA��4��p�����S�T�6#c����Osg�w���Ꟙ> ��k�a�B��P��J5��Og*]@�����;�p>yK��NsY����L#���2�Z�|�4l��>
�pN���":��1\�=eT�dR��5�b-����hO�t�#Q��E˖ix�㹄+&��ox�ӿ��V����@]���b�|��,�0����{�.�M�%\�i%�
���^�P겛F*zx����HL���[j����������tHe���hc�8e���8����{{D�Z�rM.Җ�|�ҍ�
lv*�h���e�>�4������%J`XǺ�-&;`�;'���iW�Jt����h8�z�y,U�#K��F�@r��#�뭥�)�/q�S���S_Z��L���.j���[����l�,]�dX1�����-��F�ì9��yn�ח���A��      �   �   x�M��
�0F�{�"����j3
*���%��6XJH��-(��[�w8|b����J�K�)�D$]m5h���^4�{��W��Ρ����$�S��.��P�q�b�;�*�hY+%�1RU���m�j�����z��$�V��"~ �{+�      �   Z  x�E�ݎ�@���O�l�ǿK�3#��DY7{�=��'�8���[H#		�WEq�N���b���aԥ.n�̉�
Ri"-�)I�����ȉI����n��U�Si) M� T�ҬP�M	I��Z����a�+ve�c�Ԣ9��Z��P}����A�avFx�Ң`x�;^��GJ{	:�bI���2j8���
�gQ��GTUB*a�{<F$���(����J{4Ū�j��V\֗�t����c�.�܋�;��1�#~�Sw"�V1Y ^�=�.1cX^^�k�8�=�"/őI�Q}�4k�j�8�蘨1���%o;	�;WM0����u�5޵�sgH����H��h֝�fdG�o���p��_��l�l��{��k�oH^-u�4�?"WHb[ĻӃ�'$��#iZ�L+2�~i���Ȃ�����ao��
�GS���6��?]�x�T�H7V�o\Js��Y��oA�;�M�
>��ݧMd��m3�^��
�]���@�Î7nα������f�~���f%ޭ!�{��d����)������ΐ12Bkj-��ϑ�{�H���A��	�+i�G=c�M���C[���`�U�T�     