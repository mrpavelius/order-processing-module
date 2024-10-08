PGDMP      ,            	    |            postgres    16.4    16.4     �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            �           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            �           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            �           1262    5    postgres    DATABASE     |   CREATE DATABASE postgres WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'Russian_Russia.1251';
    DROP DATABASE postgres;
                postgres    false            �           0    0    DATABASE postgres    COMMENT     N   COMMENT ON DATABASE postgres IS 'default administrative connection database';
                   postgres    false    4857                        3079    16384 	   adminpack 	   EXTENSION     A   CREATE EXTENSION IF NOT EXISTS adminpack WITH SCHEMA pg_catalog;
    DROP EXTENSION adminpack;
                   false            �           0    0    EXTENSION adminpack    COMMENT     M   COMMENT ON EXTENSION adminpack IS 'administrative functions for PostgreSQL';
                        false    2            �            1259    24576    orders    TABLE     �  CREATE TABLE public.orders (
    id integer NOT NULL,
    fio character varying(100) NOT NULL,
    car_number character varying(20) NOT NULL,
    cargo_name character varying(100) NOT NULL,
    volume numeric(10,2) NOT NULL,
    status character varying(20) DEFAULT 'Новый'::character varying NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);
    DROP TABLE public.orders;
       public         heap    postgres    false            �            1259    24582    Заказы_id_seq    SEQUENCE     �   CREATE SEQUENCE public."Заказы_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ,   DROP SEQUENCE public."Заказы_id_seq";
       public          postgres    false    216            �           0    0    Заказы_id_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE public."Заказы_id_seq" OWNED BY public.orders.id;
          public          postgres    false    217            �            1259    24583 %   Обработанные_заявки    TABLE     �   CREATE TABLE public."Обработанные_заявки" (
    id integer NOT NULL,
    order_id integer,
    processed_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    status character varying(20) NOT NULL
);
 ;   DROP TABLE public."Обработанные_заявки";
       public         heap    postgres    false            �            1259    24587 ,   Обработанные_заявки_id_seq    SEQUENCE     �   CREATE SEQUENCE public."Обработанные_заявки_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 E   DROP SEQUENCE public."Обработанные_заявки_id_seq";
       public          postgres    false    218            �           0    0 ,   Обработанные_заявки_id_seq    SEQUENCE OWNED BY     �   ALTER SEQUENCE public."Обработанные_заявки_id_seq" OWNED BY public."Обработанные_заявки".id;
          public          postgres    false    219            V           2604    24588 	   orders id    DEFAULT     n   ALTER TABLE ONLY public.orders ALTER COLUMN id SET DEFAULT nextval('public."Заказы_id_seq"'::regclass);
 8   ALTER TABLE public.orders ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    217    216            Z           2604    24589 (   Обработанные_заявки id    DEFAULT     �   ALTER TABLE ONLY public."Обработанные_заявки" ALTER COLUMN id SET DEFAULT nextval('public."Обработанные_заявки_id_seq"'::regclass);
 Y   ALTER TABLE public."Обработанные_заявки" ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    219    218            �          0    24576    orders 
   TABLE DATA           i   COPY public.orders (id, fio, car_number, cargo_name, volume, status, created_at, updated_at) FROM stdin;
    public          postgres    false    216   v       �          0    24583 %   Обработанные_заявки 
   TABLE DATA           e   COPY public."Обработанные_заявки" (id, order_id, processed_at, status) FROM stdin;
    public          postgres    false    218   $       �           0    0    Заказы_id_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('public."Заказы_id_seq"', 87, true);
          public          postgres    false    217            �           0    0 ,   Обработанные_заявки_id_seq    SEQUENCE SET     \   SELECT pg_catalog.setval('public."Обработанные_заявки_id_seq"', 7, true);
          public          postgres    false    219            ]           2606    24591    orders Заказы_pkey 
   CONSTRAINT     X   ALTER TABLE ONLY public.orders
    ADD CONSTRAINT "Заказы_pkey" PRIMARY KEY (id);
 D   ALTER TABLE ONLY public.orders DROP CONSTRAINT "Заказы_pkey";
       public            postgres    false    216            _           2606    24593 P   Обработанные_заявки Обработанные_заявки_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."Обработанные_заявки"
    ADD CONSTRAINT "Обработанные_заявки_pkey" PRIMARY KEY (id);
 ~   ALTER TABLE ONLY public."Обработанные_заявки" DROP CONSTRAINT "Обработанные_заявки_pkey";
       public            postgres    false    218            `           2606    24594 /   Обработанные_заявки orders_id    FK CONSTRAINT     �   ALTER TABLE ONLY public."Обработанные_заявки"
    ADD CONSTRAINT orders_id FOREIGN KEY (order_id) REFERENCES public.orders(id);
 [   ALTER TABLE ONLY public."Обработанные_заявки" DROP CONSTRAINT orders_id;
       public          postgres    false    4701    216    218            �   �  x����jTA��}���2M����|	&&](A��w1q�d��꼑�g0&3ah�������S���d<ҥ.t��B/�J���M�����B��ӯ)�~�3�t��K9;�h�ǣ�Do�����f r�ڠ�kz��t@sua�Ǧ�G���������7�_[t�����v7f��Zۺ�hB�Q�XQXs*y�J�܄�TvG�?�j<�9=S<w��Pu���Q������	��\@�*�Mb�R$�I5H�o�Hؿ�yR�n:K��[�����=#U�P�� �Pʤݽ��zG��<x��Ј%�Ļ�=
YU-�qEC�,z�����gfvO)r1��H�v�t(�ZkțiFb����P����ޙ��%J�j|�ڝ;0d�I�U��/�&X�      �   A   x�3�44�4202�5��52U0��21�21�334�4�60�0��/6\l�����{�b���� ���     