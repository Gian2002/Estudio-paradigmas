% Punto 1 - Completar el predicado todoLoQueTieneEsMasValioso, que tiene que permitir saber si todo lo que tiene la Persona1 es mas valioso que lo que tiene Persona2.

tiene(gian, teclado).
tiene(gian, mouse).
tiene(jessi, sueño).
tiene(jessi, anteojos).
tiene(jessi, glitter).

vale(teclado, 10).
vale(mouse, 20).
vale(sueño, 0).
vale(anteojos, 30).
vale(glitter, 15).

todoLoQueTieneEsMasValioso(Persona1, Persona2) :- forall((tiene(Persona1, CosaValiosa), tiene(Persona2, OtraCosa), vale(CosaValiosa, ValorCosaValiosa), vale(OtraCosa, OtroValor)), ValorCosaValiosa > OtroValor).
                                                    
% Punto 2

% No es posible usar esa función para consultar si nadie cumple con tener todas cosas más valiosas
% que una persona indicada, ya que el predicado no es inversible. Para lograr que sea inversible debemos
% generar a las personas: tiene(Persona1,_) y tiene(Persona2,_) ... resto de la funcion ...

% Punto 3
% not(todoLoQueTieneEsMasValioso(_, pedro)) Esto pregunta si alguien tiene cosas mas valiosas que Pedro, 
% y agregandole el not, si nadie.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Punto 1

% Se tiene este código

ingrediente(panqueque, huevo).
ingrediente(panqueque, harina).
ingrediente(flan, huevo).
ingrediente(flan, leche).
ingrediente(churrasco, carne).

come(jony, panqueque).
come(jony, flan).
come(moro, tortilla).
come(moro, churrasco).
come(ivo, flan).

% Recalquemos que el forall(x,y) funciona como: para todos los X se cumple Y.

% Se desea conocer que personas son quisquillosas, lo que ocurre cuando sólo comen comidas con un mismo
% ingrediente. En el ejemplo, jony es quisquilloso porque sólo come cosas con huevo e ivo sólo con leche.

% Se tienen estas soluciones, justificar porque cada una tiene problemas:

% a) quisquillosa(Persona) :-   come(Persona, _),
%                               forall( come(Persona, Comida), ingrediente(Comida, Ingrediente )).

% Esta solución tiene el problema de que Ingrediente queda libre en cada evaluación, entonces lo único
% que esta testeando el forall es si todas las comidas que come la persona tienen al menos un ingrediente.

% b) quisquillosa(Persona) :-   ingrediente(_, Ingrediente),
%                               forall( come(Persona, Comida), ingrediente(Comida, Ingrediente )).

% Esto tampoco esta bien porque se esta eligiendo un ingrediente arbitrariamente antes de iniciar el
% forall, entonces se termina testeando si todas las comidas que ingiere una Persona poseen ese ingrediente.

% c) quisquillosa(Persona) :-   come(_, Comida),
%                               forall( come(Persona, Comida), ingrediente(Comida, Ingrediente )).

% Esto es todavia peor, se elige una comida arbitrariamente antes del forall y se termina testeando para 
% las personas que comen esa comida, si poseen algún ingrediente. Nada que ver con lo pedido.

% Punto 2 - Codificar una solución correcta pero que en vez de usar forall, use not.

% Es un re kilombo mal. 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Se necesita implementar un sistema para que los atletas se inscriban a las 
% competencias de un torneo deportivo. Sabemos que un atleta puede inscribirse
% en una competencia cuando:

%  * Ha completado la inscripcion general al torneo

%  * No ha participado todavia en esa competencia

%  * Ha participado en todas las competencias requeridas como condición previa para
%   esa competencia, a menos que la inscripcion general al torneo se haya realizado
%   hace menos de un año, en cuyo caso las competencias previas no son requeridas.

% Se propuso esta solución

puedeInscribirse(Atleta, Competencia, Fecha) :- inscripcionGeneral(Atleta, FechaInscripcion),
                                                not(participo(Atleta, Competencia, _)),
                                                aniosCalendarioTranscurridos(FechaInscripcion, Fecha, 0).

puedeInscribirse(Atleta, Competencia, _) :- inscripcionGeneral(Atleta, _),
                                            not(participo(Atleta, Competencia, _)),
                                            competenciaRequerida(CompetenciaPrevia, Competencia),
                                            participo(Atleta, CompetenciaPrevia, _).

% Se sabe que existen estos predicados:

% * inscripcionGeneral/2: Relaciona un atleta y la fecha en la que completó su inscripción general al torneo. 
%   Es inversible.

% * participo/3: Relaciona un atleta, una competencia, y la fecha en la que participó. Es inversible. 

% * competenciaRequerida/2: Relaciona dos competencias tales que la primera es condición previa para la 
%   segunda. Es inversible.

% * añosCalendarioTranscurridos/3: Relaciona dos fechas cualesquiera con los años calendario que 
%   transcurrieron entre ambas. Solo es inversible para su tercer parámetro.

% Punto 1 - ¿La solución propuesta cumple con la lógica pedida? Justifique y plantee algún ejemplo que sirva
% para fundamentar esa respuesta.

% El problema que hay en esa solución es que en competenciaRequerida únicamente se testeará si el atleta 
% participó en alguna competenciaPrevia. Supongamos este ejemplo:

competencia(triatlon, natacion).
competencia(triatlon, ciclismo)

atleta(juan, ciclismo, 20/3/2002).
atleta(juan, paracaidismo, 21/4/2023).
atleta(juana, atletismo, 22/5/2024)

% Entonces imaginemos a Juan. En el predicado puedeInscribirse, juan es un atleta que tiene se inscribe
% un dia, y no participo de esa competencia (en nuestra base de conocimientos no figura). Imaginemos que
% juan se inscribio generalmente 2 años antes, por lo que aniosCalendarioTranscurridos, no pasa.
%   Pasemos a la otra opcion. Juan se inscribio, no participo de la competencia, y en competenciaRequerida
% se testea si Juan participó en alguna de las dos competenciasPrevias, natacion o ciclismo. Esto es
% verdadero, y Juan se puede inscribir. Esto no debería suceder, ya que Juan no participó en natacion.

% Punto 2 - Analice la inversibilidad de puedeInscribirse/3. En caso de que no sea inversible para uno o 
% más parámetros, explique qué sería necesario modificar o agregar para que lo sea.

% No es inversible para el parámetro Competencia (el not del participo requiere que Competencia sea
% instanciada con anterioridad). Para el parámetro Fecha tampoco es inversible ya que el predicado
% aniosCalendarioTranscurridos no es inversible para el parámetro Fecha.

puedeInscribirse(Atleta, Competencia, Fecha) :- inscripcionGeneral(Atleta, FechaInscripcion),
                                                aniosCalendarioTranscurridos(FechaInscripcion, Fecha, 0),
                                                findall(C, (competenciaRequerida(_, C)), TodasCompetencias),
                                                member(Competencia, TodasCompetencias),
                                                not(participo(Atleta, Competencia, _)).


% Punto 3 - Realice cualquier corrección que considere necesaria sobre puedeInscribirse/3, considerando las 
% respuestas anteriores y eliminando cualquier repetición de lógica existente.

puedeInscribirse(Atleta, Competencia, Fecha) :- inscripcionGeneral(Atleta, FechaInscripcion),
                                                generarFechaValida(FechaInscripcion, Fecha),
                                                competenciaDisponible(Competencia),
                                                not(participo(Atleta, Competencia, _)),
                                                cumpleRequisitos(Atleta, Competencia, FechaInscripcion).
