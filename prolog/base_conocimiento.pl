% ===========================================================================
%  base_conocimiento.pl
%  Base de conocimiento del Asistente Profesional Inteligente
%  Proyecto: Sistema inteligente integrador para la gestion y preparacion
%            del proceso de busqueda laboral mediante un modelo SaaS
%
%  Motor: SWI-Prolog
%  Uso:   swipl base_conocimiento.pl
%         ?- demo.
% ===========================================================================

:- discontiguous tiene_habilidad/3.


% ===========================================================================
% SECCION 1. HECHOS
% ===========================================================================

% ---------------------------------------------------------------------------
% 1.1 Usuarios registrados
% usuario(Id, NombreCompleto, Plan).
% ---------------------------------------------------------------------------
usuario(juan,  'Juan Perez Ramos',   premium).
usuario(maria, 'Maria Quispe Loayza', gratuito).


% ---------------------------------------------------------------------------
% 1.2 Catalogo de habilidades
% habilidad(Id, Categoria).
% ---------------------------------------------------------------------------
habilidad(html,       frontend).
habilidad(css,        frontend).
habilidad(javascript, frontend).
habilidad(react,      frontend).
habilidad(git,        herramienta).
habilidad(mysql,      base_datos).
habilidad(python,     backend).
habilidad(sql,        base_datos).
habilidad(excel,      ofimatica).
habilidad(node,       backend).


% ---------------------------------------------------------------------------
% 1.3 Habilidades declaradas por el usuario en su perfil
% tiene_habilidad(Usuario, Habilidad, Nivel).
% Nivel: 1 = mencionada, 2 = basica, 3 = intermedia, 4 = solida, 5 = avanzada
% Estos hechos se generan a partir de la tabla perfil_habilidad de la
% base de datos del sistema.
% ---------------------------------------------------------------------------
tiene_habilidad(juan, html,       4).
tiene_habilidad(juan, css,        4).
tiene_habilidad(juan, javascript, 3).
tiene_habilidad(juan, react,      1).
tiene_habilidad(juan, mysql,      3).

tiene_habilidad(maria, python, 4).
tiene_habilidad(maria, sql,    4).
tiene_habilidad(maria, excel,  5).


% ---------------------------------------------------------------------------
% 1.4 Empresas y ofertas laborales
% empresa(Id, RazonSocial).
% oferta(Id, Empresa, Puesto).
% ---------------------------------------------------------------------------
empresa(innova,   'Innova Peru').
empresa(andes,    'Grupo Andes').
empresa(softlima, 'SoftLima').
empresa(netcom,   'Netcom').
empresa(datasur,  'DataSur').

oferta(frontend_junior, innova,   'Desarrollador Frontend Junior').
oferta(analista_sis,    andes,    'Analista de Sistemas').
oferta(practicante_web, softlima, 'Practicante de Desarrollo Web').
oferta(full_stack,      netcom,   'Desarrollador Full Stack').
oferta(datos_junior,    datasur,  'Ingeniero de Datos Junior').


% ---------------------------------------------------------------------------
% 1.5 Requisitos de cada oferta
% requiere(Oferta, Habilidad, Caracter).
% Caracter: obligatorio | deseable
% Estos hechos se generan a partir de la tabla requisito_oferta.
% ---------------------------------------------------------------------------
requiere(frontend_junior, html,       obligatorio).
requiere(frontend_junior, css,        obligatorio).
requiere(frontend_junior, javascript, obligatorio).
requiere(frontend_junior, react,      obligatorio).
requiere(frontend_junior, git,        deseable).

requiere(analista_sis, sql,   obligatorio).
requiere(analista_sis, mysql, obligatorio).
requiere(analista_sis, excel, deseable).

requiere(practicante_web, html,       obligatorio).
requiere(practicante_web, css,        obligatorio).
requiere(practicante_web, javascript, deseable).

requiere(full_stack, javascript, obligatorio).
requiere(full_stack, react,      obligatorio).
requiere(full_stack, node,       obligatorio).
requiere(full_stack, mysql,      obligatorio).
requiere(full_stack, git,        deseable).

requiere(datos_junior, python, obligatorio).
requiere(datos_junior, sql,    obligatorio).
requiere(datos_junior, mysql,  obligatorio).
requiere(datos_junior, excel,  deseable).


% ---------------------------------------------------------------------------
% 1.6 Postulaciones y entrevistas simuladas
% postulacion(Id, Usuario, Oferta, Fecha, Estado).
% entrevista(Id, Postulacion, PuntajeGlobal).
% ---------------------------------------------------------------------------
postulacion(p001, juan,  frontend_junior, '2026-09-08', en_revision).
postulacion(p002, juan,  analista_sis,    '2026-09-05', entrevista).
postulacion(p003, maria, analista_sis,    '2026-09-06', en_revision).

entrevista(e001, p002, 8.0).
entrevista(e002, p002, 7.5).


% ===========================================================================
% SECCION 2. REGLAS DE EVIDENCIA
% ===========================================================================

% nivel_evidencia(+Usuario, +Habilidad, -Evidencia)
% Clasifica cuanto evidencia el perfil del usuario una habilidad concreta.
% Corresponde a las tres categorias que muestra la interfaz del sistema.
nivel_evidencia(Usuario, Habilidad, evidenciado) :-
    tiene_habilidad(Usuario, Habilidad, Nivel),
    Nivel >= 3.

nivel_evidencia(Usuario, Habilidad, poco_evidenciado) :-
    tiene_habilidad(Usuario, Habilidad, Nivel),
    Nivel < 3.

nivel_evidencia(Usuario, Habilidad, no_evidenciado) :-
    \+ tiene_habilidad(Usuario, Habilidad, _).


% ===========================================================================
% SECCION 3. REGLAS DE COINCIDENCIA CV - OFERTA
% ===========================================================================

% cumple_requisito(+Usuario, +Oferta, ?Habilidad)
% Verdadero cuando la oferta exige esa habilidad y el perfil la evidencia.
cumple_requisito(Usuario, Oferta, Habilidad) :-
    requiere(Oferta, Habilidad, _),
    nivel_evidencia(Usuario, Habilidad, evidenciado).

% falta_requisito(+Usuario, +Oferta, ?Habilidad)
% Requisito de la oferta que el perfil no llega a evidenciar.
falta_requisito(Usuario, Oferta, Habilidad) :-
    requiere(Oferta, Habilidad, _),
    \+ nivel_evidencia(Usuario, Habilidad, evidenciado).

% brecha_critica(+Usuario, +Oferta, ?Habilidad)
% Requisito obligatorio que el perfil no evidencia. Es la brecha que el
% asistente debe senalar primero.
brecha_critica(Usuario, Oferta, Habilidad) :-
    requiere(Oferta, Habilidad, obligatorio),
    \+ nivel_evidencia(Usuario, Habilidad, evidenciado).

% Listados
requisitos(Oferta, Lista) :-
    findall(H, requiere(Oferta, H, _), Lista).

coincidencias(Usuario, Oferta, Lista) :-
    findall(H, cumple_requisito(Usuario, Oferta, H), Lista).

faltantes(Usuario, Oferta, Lista) :-
    findall(H, falta_requisito(Usuario, Oferta, H), Lista).


% ===========================================================================
% SECCION 4. CALCULO DE COMPATIBILIDAD
% ===========================================================================

% compatibilidad(+Usuario, +Oferta, -Porcentaje)
% Proporcion simple de requisitos evidenciados sobre el total.
compatibilidad(Usuario, Oferta, Porcentaje) :-
    requisitos(Oferta, Requisitos),
    length(Requisitos, Total),
    Total > 0,
    coincidencias(Usuario, Oferta, Cumplidos),
    length(Cumplidos, N),
    Porcentaje is round(N * 100 / Total).

% peso(+Caracter, -Peso)
% Un requisito obligatorio pesa el doble que uno deseable.
peso(obligatorio, 2).
peso(deseable,    1).

% puntaje_habilidad(+Usuario, +Oferta, +Habilidad, -Puntos)
% Puntos obtenidos segun el nivel de evidencia: completo, mitad o cero.
puntaje_habilidad(Usuario, Oferta, Habilidad, Puntos) :-
    requiere(Oferta, Habilidad, Caracter),
    peso(Caracter, Peso),
    nivel_evidencia(Usuario, Habilidad, Evidencia),
    factor(Evidencia, Factor),
    Puntos is Peso * Factor.

factor(evidenciado,      1.0).
factor(poco_evidenciado, 0.5).
factor(no_evidenciado,   0.0).

% compatibilidad_ponderada(+Usuario, +Oferta, -Porcentaje)
% Version que distingue requisitos obligatorios de deseables y reconoce
% parcialmente las habilidades poco evidenciadas.
compatibilidad_ponderada(Usuario, Oferta, Porcentaje) :-
    findall(P, puntaje_habilidad(Usuario, Oferta, _, P), Puntos),
    sum_list(Puntos, Obtenido),
    findall(W, (requiere(Oferta, _, C), peso(C, W)), Pesos),
    sum_list(Pesos, Maximo),
    Maximo > 0,
    Porcentaje is round(Obtenido * 100 / Maximo).

% apto_para(+Usuario, ?Oferta)
% El sistema considera adecuada una oferta con 70 % o mas y sin brechas
% criticas pendientes.
apto_para(Usuario, Oferta) :-
    oferta(Oferta, _, _),
    compatibilidad_ponderada(Usuario, Oferta, Porcentaje),
    Porcentaje >= 70,
    \+ brecha_critica(Usuario, Oferta, _).

% ofertas_ordenadas(+Usuario, -Lista)
% Lista de pares Porcentaje-Oferta ordenada de mayor a menor. Es lo que
% alimenta el listado de ofertas de la interfaz.
ofertas_ordenadas(Usuario, Lista) :-
    findall(Porcentaje-Oferta,
            ( oferta(Oferta, _, _),
              compatibilidad_ponderada(Usuario, Oferta, Porcentaje) ),
            Pares),
    sort(0, @>=, Pares, Lista).


% ===========================================================================
% SECCION 5. GENERACION DE RECOMENDACIONES
% ===========================================================================

% recomendacion(+Usuario, +Oferta, -Texto)
% Produce el texto base que el modelo de lenguaje luego redacta de forma
% natural. Prolog decide QUE recomendar; el modelo generativo decide COMO.
recomendacion(Usuario, Oferta, Texto) :-
    brecha_critica(Usuario, Oferta, Habilidad),
    nivel_evidencia(Usuario, Habilidad, no_evidenciado),
    format(atom(Texto),
           'El requisito obligatorio ~w no aparece en el CV. Agregalo si lo has usado en algun proyecto.',
           [Habilidad]).

recomendacion(Usuario, Oferta, Texto) :-
    brecha_critica(Usuario, Oferta, Habilidad),
    nivel_evidencia(Usuario, Habilidad, poco_evidenciado),
    format(atom(Texto),
           'El requisito obligatorio ~w esta poco evidenciado. Detalla el proyecto y tu rol concreto.',
           [Habilidad]).

recomendacion(Usuario, Oferta, Texto) :-
    requiere(Oferta, Habilidad, deseable),
    nivel_evidencia(Usuario, Habilidad, no_evidenciado),
    format(atom(Texto),
           'La oferta valora ~w como habilidad deseable y el CV no la menciona.',
           [Habilidad]).

recomendacion(Usuario, Oferta, 'El perfil cubre todos los requisitos de la oferta. Conviene postular.') :-
    \+ falta_requisito(Usuario, Oferta, _).

% recomendaciones(+Usuario, +Oferta, -Lista)
recomendaciones(Usuario, Oferta, Lista) :-
    findall(T, recomendacion(Usuario, Oferta, T), Lista).


% ===========================================================================
% SECCION 6. INFORME PARA LA INTERFAZ
% ===========================================================================

% informe(+Usuario, +Oferta)
% Imprime el analisis completo, equivalente a la pantalla de compatibilidad.
informe(Usuario, Oferta) :-
    usuario(Usuario, Nombre, _),
    oferta(Oferta, Empresa, Puesto),
    empresa(Empresa, RazonSocial),
    compatibilidad(Usuario, Oferta, Simple),
    compatibilidad_ponderada(Usuario, Oferta, Ponderada),
    format('~n=============================================================~n'),
    format(' ANALISIS DE COMPATIBILIDAD~n'),
    format('=============================================================~n'),
    format(' Postulante : ~w~n', [Nombre]),
    format(' Oferta     : ~w  (~w)~n', [Puesto, RazonSocial]),
    format(' Simple     : ~w %~n', [Simple]),
    format(' Ponderada  : ~w %~n', [Ponderada]),
    format('-------------------------------------------------------------~n'),
    format(' REQUISITOS~n'),
    forall(requiere(Oferta, H, C),
           ( nivel_evidencia(Usuario, H, E),
             format('   ~w~t~16| ~w~t~30| ~w~n', [H, C, E]) )),
    format('-------------------------------------------------------------~n'),
    format(' RECOMENDACIONES~n'),
    recomendaciones(Usuario, Oferta, Rs),
    forall(member(R, Rs), format('   - ~w~n', [R])),
    format('=============================================================~n').


% ===========================================================================
% SECCION 7. DEMOSTRACION
% ===========================================================================

demo :-
    informe(juan, frontend_junior),
    informe(juan, analista_sis),
    informe(maria, analista_sis),
    format('~n RANKING DE OFERTAS PARA JUAN~n'),
    ofertas_ordenadas(juan, Ranking),
    forall(member(P-O, Ranking),
           ( oferta(O, _, Puesto),
             format('   ~w %~t~10| ~w~n', [P, Puesto]) )),
    format('~n OFERTAS EN LAS QUE EL SISTEMA CONSIDERA APTO A JUAN~n'),
    (  apto_para(juan, _)
    -> forall(apto_para(juan, O2),
              ( oferta(O2, _, P2), format('   - ~w~n', [P2]) ))
    ;  format('   (ninguna por ahora)~n')
    ),
    nl.


% ===========================================================================
% CONSULTAS DE EJEMPLO
% ===========================================================================
%
% ?- nivel_evidencia(juan, react, E).
%    E = poco_evidenciado.
%
% ?- coincidencias(juan, frontend_junior, L).
%    L = [html, css, javascript].
%
% ?- faltantes(juan, frontend_junior, L).
%    L = [react, git].
%
% ?- brecha_critica(juan, frontend_junior, H).
%    H = react.
%
% ?- compatibilidad(juan, frontend_junior, P).
%    P = 60.
%
% ?- compatibilidad_ponderada(juan, frontend_junior, P).
%
% ?- recomendaciones(juan, frontend_junior, L).
%
% ?- ofertas_ordenadas(juan, L).
%
% ?- apto_para(juan, O).
%
% ?- informe(juan, frontend_junior).
%
% ?- demo.
%
% ===========================================================================
