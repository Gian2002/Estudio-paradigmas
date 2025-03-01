-- Punto 1 - Usando las funciones habilidades y sirve, definir una función que dado
--           un problema permite saber qué personas tienen alguna habilidad que sirva
--           para el problema recibido

type Habilidad = String

data Persona = UnaPersona{
    nombre :: String,
    todasLasHabilidades :: [Habilidad]
} deriving(Show)

gian :: Persona
gian = UnaPersona "Gian" ["programar","entrenar"]

carlos :: Persona
carlos = UnaPersona "Carlos" ["Arquitecto", "programar"]

habilidades :: Persona -> [Habilidad]
habilidades persona = todasLasHabilidades persona

type Problema = String

sirve :: Problema -> Habilidad -> Bool
sirve "arreglar computadora" "programar" = True
sirve "arreglar computadora" _ = False

podrianAyudar :: Problema -> [Persona] -> [Persona]
podrianAyudar problema = filter (\persona -> any (sirve problema) (habilidades persona))
-- Elimine personas de ambos lados


-- Punto 2 - Indicar cuáles conceptos se están usando

-- Se usa orden superior (filter y any son funciones de orden superior porque reciben funciones como argumentos)

-- Se usa aplicación parcial (sirve es una funcion que le pasamos un problema y una habilidad y retorna
-- un booleano, pero en any (sirve problema) solo pasamos el problema y dsps la lista de habilidades)

-- No usa pattern matching (necesitariamos una funcion que decomponga valores con case o definiciones explícitas)

-- No usa composicion (no hay .)

-- Punto 3 - Si una persona tuviera una lista infinita de habilidades, ¿cómo se
-- comportaría podrianAyudar si dicha persona estuviera en la lista recibida?

-- La ejecución continuaría hasta que se encuentre una habilidad que sirva para solucionar el problema,
-- después se dejaría de analizar el resto de la lista por lazy evaluation.

-------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------

-- Punto 1

-- Es el mismo ejercicio que el anterior

-------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------

-- Se desea modelar en el paradigma funcional un sistema de admisión para competencias deportivas. Existen
-- atletas que desean participar en una competencia que tiene una serie de requisitos, de manera que no se
-- permite la inscripción de aquellos que incumplan alguno de ellos. Puede haber diversos requisitos, como
-- por ejemplo que solo se inscriban atletas de una cierta nacionalidad, que no se permita la inscripción
-- de quienes tengan menos de cierta edad, o que no puedan participar atletas con ciertos tipos de 
-- equipamiento no permitido. Puede haber competencias con más requisitos que otras, sin requisitos, o con
-- requisitos similares, como restringir la participación por nacionalidad, pero con diferentes criterios 
-- especificos. Por lo tanto, de los atletas se debe conocer la edad, la nacionalidad, y el equipamiento
-- que llevan consigo.

-- Punto 1 - Definir tipos de datos y funciones (explicitando el tipo de todas ellas) para cubrir las 
-- necesidades explicadas. 

-- Punto 2 - Mostrar cómo se representa una competencia de ejemplo que tenga tres requisitos como los 
-- mencionados.

data Atleta = UnAtleta{
    edad :: Int,
    nacionalidad :: String,
    equipamiento :: [String]
}

type Requisito = Atleta -> Bool

data Competencia = UnaCompetencia{
    nombreCompetencia :: String,
    requisitos :: [Requisito]
}

triatlon :: Competencia
triatlon = UnaCompetencia "Triatlon" [nacionalidadEs "Argentina", mayorDe 16, noPermite "Mochila"]

mayorDe :: Int -> Atleta -> Bool
mayorDe edadMin atleta = edad atleta > edadMin

nacionalidadEs :: String -> Atleta -> Bool
nacionalidadEs pais atleta = nacionalidad atleta == pais

noPermite :: String -> Atleta -> Bool
noPermite equipo atleta = notElem equipo (equipamiento atleta)

puedeInscribirse :: Competencia -> Atleta -> Bool
puedeInscribirse competencia atleta = verificaRequisitos (requisitos competencia) atleta

verificaRequisitos :: [Requisito]  -> Atleta -> Bool
verificaRequisitos [] _ = True
verificaRequisitos (x:xs) atleta = x atleta && verificaRequisitos xs atleta

-- Ambos puntos hechos al mismo tiempo


-- Punto 3 - Desarrollar la función controlDeInscripción, que permita saber qué atletas de una lista de 
-- espera cumplen los requisitos para participar en la competencia.

controlDeInscripcion :: Competencia -> [Atleta] -> [Atleta]
controlDeInscripcion competencia = filter (puedeInscribirse competencia) -- Saque atletas de ambos lados
                                                                         

-- Punto 4 - Indicar dónde y para que se usaron estos conceptos: Composición, Aplicación parcial, Orden
-- Superior.

-- Composición no se usó. Use aplicación parcial en los requisitos de las competencias para poder insertar
-- funciones dentro de una lista y que sea más intuitivo y fácil de agregar nuevos requisitos, tambien usé
-- aplicación parcial en el filter de controlDeInscripción, donde únicamente le pase como parámetro la
-- competencia y no los atletas. Orden superior usé en filter que recibió una función como argumento y
-- también en puedeInscribirse que opera con una lista de funciones de tipo [Atleta -> Bool].
