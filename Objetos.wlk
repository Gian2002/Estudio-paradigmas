/* class Pelicula{
    var personajes = []

    method protagonista () = personajes.first()
}

class PeliAventura inherits Pelicula{
    method rompeEstereotipos () {
        return self.protagonista().sosActuado() and self.protagonista().genero() != "varon" 
        and self.protagonista ().esRescatado().negate() }
}

class PeliTerror inherits Pelicula {
    method rompeEstereotipos (){
        return self.protagonista().sosActuado () and self.protagonista().genero() != "varon" 
        and personajes.all({p => p.esRescatado()}) }
}

class PeliComedia inherits Pelicula {
    method rompeEstereotipos (){
        return self.protagonista().sosActuado () and self.protagonista().genero() != "varon"
        and personajes.size() == 1 }
}

class PersonajeAnimado {
    method sosActuado() = false
    method esRescatado() = false
}

class PersonajeActuado {
    var genero
    var esRescatado

    method sosActuado () = true
    method genero() = genero
    method esRescatado() = esRescatado
}

En nuestro sistema, para que una película rompa estereotipos, en principio su 
protagonista no debe ser varon. Además se debe cumplir: en el caso de las películas de
aventura, que ese protagonista no sea rescatado; en el caso de las películas de terror,
que todos los personajes sean rescatados; y en el caso de las de comedia, que sólo 
tengan un personaje. Se sabe que los personajes animados no tienen género definido y 
nunca son rescatados, y los personajes actuados pueden tener distintos géneros y ser 
o no rescatados en la película. 

*/

//  Punto 1
// a) Escribiendo el método elProtagonistaNoEsVaron en la superclase y usándolo en las subclases se elimina 
// toda repetición de lógica.

// FALSO. Si bien se elimina parte de la repetición de lógica, todavía se repite lógica en la sentencia que
// se usa para ver si el protagonista es actuado o no.

// b) Se está rompiendo el encapsulamiento de los personajes.

// VERDADERO. Se esta testeando si el personaje es varon en otra clase externa.

//c) Como no hay ifs, se esta haciendo un buen uso del polimorfismo.

// FALSO. Se esta usando mal el polimorfismo en las peliculas, ya que hay repeticion de lógica en parte
// del método rompeEstereotipos. Ademas, se podrian mejorar los personajes para que sosActuado y esRescatado
// sean polimorficos con una clase padre.

// Punto 2 - Codificar una nueva solución arreglando lo que haga falta en base a las respuestas anteriores. Incluir un diagrama estático de la nueva solución.
class Pelicula {
    var personajes = #{} // Es un conjunto set (no tiene duplicados ni orden
    // method protagonista () = personajes.first() Se cambia porque un set no tiene first
    method protagonista() = personajes.find{p => p.esProtagonista()}
    
    method rompeEstereotipos(){
        return self.protagonista().esActuado() and self.protagonista().esVaron()
    }
}
class Personaje {
    var property esProtagonista

    method esVaron() = false
    method esActuado() = false
    method esRescatado() = false
}
class PersonajeAnimado inherits Personaje {
}
class PersonajeActuado inherits Personaje {
    const genero
    const esRescatado

    override method esActuado () = super().negate()
    override method esRescatado() = esRescatado
    override method esVaron() = genero == "masculino"
}
class PeliAventura inherits Pelicula {
    override method rompeEstereotipos () {
        return super() 
        and self.protagonista().esRescatado().negate() }     
}
class PeliTerror inherits Pelicula {
    override method rompeEstereotipos (){
        return super() 
        and personajes.all{p => p.esRescatado()} }
}
class PeliComedia inherits Pelicula {
    override method rompeEstereotipos (){
        return super()
        and personajes.size() == 1 }
}
//////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////

// Se desea saber cuáles son los jugadores buenos de un equipo. Puede haber distintos jugadores, y para
// saber cuándo un jugador es bueno depende de su posición. Se sabe que ser un buen mediocampista es
// difícil, porque todo buen mediocampista debe ser antes un buen defensor. El siguiente codigo resuelve
// el problema y funciona bien:

/*
class Equipo {
    var jugadores

    method jugadoresBuenos () {
        var buenos = []
        jugadores.forEach({ jug =>
            if (jug.esArquero () && jug.atajaPenales()) { buenos.add(jug) }
            if (jug.esDefensor () && jug.marcaMucho()) { buenos.add(jug) }
            if (jug.esMediocampista() && jug.marcaMucho () && jug.pasaBien ()) { buenos.add(jug) }
    })
    return buenos
}
}

class Jugador {
    var porcentajeBuenosPases 
    var penalesAtajados
    var cantMarcas
    var posicion

    method esArquero() = posicion == "Arquero"
    method esDefensor() = posicion == "Defensor"
    method esMediocampista() = posicion == "Mediocampista"
    method atajaPenales() = penalesAtajados > 2 
    method marcaMucho() = cantMarcas > 2
    method pasaBien() = porcentajeBuenosPases > 0.75
}
*/

//  Punto 1 

//  a) El método jugadoresBuenos() no produce fecto en el estado interno del Equipo luego de ejecutarse
//  VERDADERO. Ese método lo único que hace es recopilar los jugadores que son buenos de un equipo y
//  almacenarlos en una variable local del método llamada "buenos".

//  b) La solución tiene problemas de declaratividad.
//  VERDADERO. Mayormente en el método jugadores buenos, ya que utilizar ifs en un forEach no es casi
//  nunca lo óptimo existiendo conceptos como el isomorfismo. Además se rompe el encapsulamiento de los
//  jugadores ya que se testea si es bueno fuera de estos. También se podría mejorar la parte de que
//  para ser buen mediocapista debe ser antes un buen defensor.

//  c) Para agregar un nuevo tipo de jugador, sólo debo modificar la clase Jugador.
//  FALSO. Justo lo que dije en el anterior punto, si se agrega un nuevo tipo de jugador se debería
//  modificar también la clase equipo porque ahi es donde se testearía si es un buen delantero o no.

//  d) La responsabilidad de saber si un jugador es bueno está mal asignada.
//  VERDADERO. Esa responsabilidad debería recaer en la clase Jugador y no en la clase Equipo, ya que
//  se está rompiendo el encapsulamiento de los jugadores y además es más tedioso agregar otros tipos
//  de jugador.

//  Punto 2 - Codificar una solución superadora, sin repeticion de lógica, que permita que un jugador
//  cambie de posición en cualquier momento y agregando al delantero, que es bueno si hizo +10 goles.
class Equipo {
    var jugadores = []

    method jugadoresBuenos() = jugadores.filter{jug => jug.esBueno()}
}
class Jugador {
    var property porcentajeBuenosPases 
    var property penalesAtajados
    var property cantMarcas
    var posicion
    var property goles

    method cambiarPosicion(nuevaPosicion){
        posicion = nuevaPosicion
    }
    method esBueno() = posicion.esBuenoPara(self)
}
object arquero{
    method esBuenoPara(jugador) = jugador.penalesAtajados() > 2
}
object defensor{
    method esBuenoPara(jugador) = jugador.cantMarcas() > 2
}
object mediocampista{
    method esBuenoPara(jugador) = defensor.esBuenoPara(jugador) && jugador.porcentajeBuenosPases() > 0.75
}
object delantero{
    method esBuenoPara(jugador) = jugador.goles() > 10
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////

// Se sabe que en un parque de diversiones se cobra entrada a los visitantes. Los adultos y los niños tienen
// diferentes formas de calcular la tarifa (los adultos pagan una tarifa única de $100, mientras que los 
// niños pagan $50), y además hay visitantes que pagan con "Pase Rápido", otros con efectivo y otros con 
// tarjeta prepaga. Al efectuarse el cobro suceden dos cosas: el saldo del parque aumenta, y cada visitante
// efectúa el pago. Los que pagan con tarjeta prepaga disminuyen el saldo de su tarjeta en un 10% adicional
// como gasto de servicio (el 10% no va para el parque), y los que pagan con Pase Rápido disminuyen en 1 la
// cantidad de accesos disponibles. No necesitamos registrar nada adicional para los que pagan en efectivo.

// Se tiene el siguiente diagrama de la solución propuesta:


/*
class Parque {
    const property visitantes = []
    var property saldo = 0

    method cobrarEntrada(){
        visitantes.forEach{v => self.cobrarleA(v)}
    }
    method cobrarleA(visitante){
        saldo = saldo + visitante.tarifa()
        visitante.pagarEntrada()
    }
}
*/
// Punto 1 - Verdaero o falso

// a) Para que la solución propuesta funcione, es necesario que exista la clase Visitante, ya que de lo
// contrario no podrían incluirse los distintos visitantes en la lista del parque.

// FALSO. Si bien es más adecuado tener la clase padre Visitante para evitar repetir lógica con futuras
// nuevas clases que se quieran agregar, la solución podría funcioanar tranquilamente MIENTRAS hagamos que
// la clase Niño y la clase Adulto posean tanto tarifa() como pagarEntrada(), ya que de esta manera se
// volverían polimórficas y Parque no tendria ningún problema para mandar sus respectivos mensajes. 
// Reitero, funcionar de esta manera funciona, pero es más adecuado tener la clase Visitante.

// b) Hay buen uso de polimorfismo en la solución.

// VERDADERO. Me parece que esta bien usado el polimorfismo ya que se sobreescriben los métodos tarifa()
// y pagarEntrada() en las subclases que lo necesitan, tanto en Niño y Adulto como en las demás. La única
// observación que podría hacer es que en visitante se podría definir que tarifa() = 100. De esta manera
// no haría falta sobreescribirla en Adulto y únicamente se tendría que hacer en Niño.

// c) Por cómo se planteó el modelo, se va a repetir lógica en las implementaciones de pagarEntrada().

// VERDADERO. Se repite lógica en los tres métodos de pago de Niño con los tres métodos de pago de Adulto
// ya que los métodos hacen lo mismo independientemente si son Niños o Adultos.

// d) Si un adulto que paga con tarjeta prepaga decide pasarse al sistema de Paso Rápido, podrá hacerlo
// sin problemas con este modelo.

// FALSO. No tiene manera de hacer esto, ya que esas son dos clases distintas y es imposible para un objeto
// simplemente transferirse de clase, es un concepto imposible.

// e) Al cobrarle a un visitante que paga con Pase Rápido y este se queda sin accesos disponibles, se lanza
// un error, se frena la ejecución y el estado del sistema queda coherente.

// FALSO. No hay evidencia alguna que respalde esto, puede ser que este implementado pero al no tener
// el código de las clases es imposible saberlo.

// Punto 2 - Desarrollar una nueva solución que resuelva los problemas anteriores. Debe incluir tanto el 
// código como el diagrama.

class UserException inherits Exception { }

class Parque {
    const property visitantes = []
    var property saldo = 0

    method cobrarEntrada(){
        visitantes.forEach{v => self.cobrarleA(v)}
    }
    method cobrarleA(visitante){
        saldo = saldo + visitante.tarifa()
        visitante.pagarEntrada()
    }
}

class Visitante{
    var property metodoDePago

    method tarifa() = 100
    method pagarEntrada(){
        metodoDePago.pagar(self)
    }
    }

class Niño inherits Visitante{
    override method tarifa() = 50
}

class Adulto inherits Visitante{

}

class MetodoDePago{
    method pagar(visitante){}
}

class PagoConPrepaga inherits MetodoDePago{
    var property saldo

    override method pagar(visitante){
        if(saldo >= visitante.tarifa()){
            saldo = saldo - (visitante.tarifa() * 1.10)
        }else{
            throw new UserException(message = "Saldo insuficiente.")
        }
    }
}

class PagoConEfectivo inherits MetodoDePago{
   
}

class PagoConPaseRapido inherits MetodoDePago{
    var property accesosDisponibles

    override method pagar(visitante){
        if(accesosDisponibles > 0){
            accesosDisponibles = accesosDisponibles - 1
        }else{
            throw new UserException(message = "No quedan accesos disponibles.")
        }
    }
}


// Punto 3 - ¿Qué haría falta hacer en cada solución para poder contemplar otros tipos de visitantes,
// como personas mayores o adolescentes?

//  En la solución base se deberia no sólo agregar dos clases Mayor y Adolescente con sus respectivas
// tarifas, sino que también se deberían agregar 6 clases en total para representar cada uno de los métodos
// de pago tanto de Mayor como de Adolescente. 
//  Por otro lado en la solución que idee yo únicamente se deberían agregar 2 clases con sus respectivas
// tarifas: Mayor y Adolescente, ya que los métodos de pago ya estan representados en otras clases.