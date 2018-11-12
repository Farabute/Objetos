import Tp_objetos.*
import LibroYHechizos.*
import Personajes.*


class Artefacto{
	const property hoy = new Date()
	const property peso = 0
	const property diaDeCompra = hoy
	method diasDesdeCompra() = self.hoy() - self.diaDeCompra ()
	method factorDeCorreccion() = 1.min(self.diasDesdeCompra() / 1000)
	method pesoTotal() = 0.max(self.peso() - self.factorDeCorreccion())
	method precio() = 0
	method costo(personaje) = self.precio()
	method sosAdquirido(personaje) = personaje.agregarArtefacto(self)
}

class Arma inherits Artefacto{
	method unidadesDeLucha(duenio) = 3
	override method precio() = 5 * self.unidadesDeLucha(self)
}


class CollarDivino inherits Artefacto{
	var property perlas = 5
	
	method unidadesDeLucha(duenio) = self.perlas()
	
	override method precio() = 2 * self.perlas()
	
	override method pesoTotal() = super() + 0.5 * self.perlas()
}

class MascaraOscura inherits Artefacto{
	var property indiceDeOscuridad = 1
	var property valorMinimo = 4
	method unidadesDeLucha(duenio) = self.valorMinimo().max(fuerzaOscura.valorFuerzaOscura() * self.indiceDeOscuridad() / 2)
	method pesoExtra() = 0.max(self.unidadesDeLucha(self) - 3)
	override method pesoTotal() = super() + self.pesoExtra()
	override method precio() = 10 * self.indiceDeOscuridad()
}

object espejoFantastico{

	method unidadesDeLucha(duenio) = if(duenio.artefactos().size() == 1){
		return 0
	}
	else
	{
		return duenio.artefactoMasPoderoso().unidadesDeLucha(duenio)
	}
	
	method precio() = 90
	method costo(personaje) = self.precio()
}


class Armadura inherits Artefacto{
	const property unidadesBaseDeLucha = 3
	
	var property refuerzo = ninguno
	
	method unidadesDeLuchaDelRefuerzo(portador) = self.refuerzo().unidadesRefuerzo(portador)
		
	method unidadesDeLucha(portador) = self.unidadesBaseDeLucha() + self.unidadesDeLuchaDelRefuerzo(portador)
	
	override method precio() = self.refuerzo().precioRefuerzo(self)
	
	override method pesoTotal() = super() + self.refuerzo().pesoRefuerzo()
}


/* Refuerzos Armadura*/

class CotaDeMalla{	
	var unidadesRefuerzo
	method unidadesRefuerzo(luchador) = unidadesRefuerzo
	method precioRefuerzo(luchador) = self.unidadesRefuerzo(self) / 2
	method pesoRefuerzo() = 1
}


object bendicion{
	method unidadesRefuerzo(luchador) = luchador.nivelDeHechiceria()
	method precioRefuerzo(armadura) = armadura.unidadesBaseDeLucha()
	method pesoRefuerzo() = 0
}

object ninguno{
	method unidadesRefuerzo(luchador) = 0
	method precioRefuerzo(luchador) = 2
	method pesoRefuerzo() = 0
}
